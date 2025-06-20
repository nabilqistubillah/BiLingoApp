import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';


class SentenceScreen extends StatefulWidget {
  const SentenceScreen({super.key});

  @override
  State<SentenceScreen> createState() => _SentenceScreenState();
  
}

class _SentenceScreenState extends State<SentenceScreen> {
    int lives = 3; 
  DateTime? lastHeartLossTime; 
  Duration timeUntilRefill = Duration.zero; 
  Timer? refillTimer; 
  final String englishSentence = 'I am eating an apple';
  final List<String> correctOrder = ['Saya', 'sedang', 'makan', 'sebuah', 'apel'];

  List<String> choices = [];
  List<String> userAnswer = [];

  @override
  void initState() {
    super.initState();
    choices = List.from(correctOrder)..shuffle(Random());
  }

  void checkAnswer() {
    if (userAnswer.join(' ') == correctOrder.join(' ')) {
      showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          title: Text('✅ Benar!'),
          content: Text('Kamu menyusun kalimat dengan benar!'),
        ),
      );
    } else {
    decreaseLife();

    String message = lives > 0
        ? 'Jawaban salah! Sisa hati: $lives'
        : 'Kamu kehabisan hati!\nTunggu ${getTimeUntilRefill()} untuk isi ulang.';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text( '❌ Salah'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }
  }

  void resetAnswer() {
    setState(() {
      userAnswer.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Susun Kalimat')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              '❤️ $lives',
              style: const TextStyle(fontSize: 20, color: Colors.red),
            ),
            const SizedBox(height: 10),

            //untuk kalimatn
            Text(
              'Kalimat: "$englishSentence"',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Jawaban yang sedang disusun
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: userAnswer.map((word) {
                return ElevatedButton(
                  onPressed: () {
                    setState(() {
                      choices.add(word);
                      userAnswer.remove(word);
                    });
                  },
                  child: Text(word),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            // Pilihan kata
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: choices.map((word) {
                return ElevatedButton(
                  onPressed: () {
                    setState(() {
                      userAnswer.add(word);
                      choices.remove(word);
                    });
                  },
                  child: Text(word),
                );
              }).toList(),
            ),

            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: userAnswer.isNotEmpty && isHeartAvailable() ? checkAnswer : null,
              child: const Text("Cek Jawaban"),
            ),
            TextButton(
              onPressed: resetAnswer,
              child: const Text("🔁 Ulangi"),
            )
          ],
        ),
      ),
    );
  }


  void decreaseLife() {
    setState(() {
      lives--;
      if (lives == 0) {
        lastHeartLossTime = DateTime.now();
      }
    });
  }

  bool isHeartAvailable() {
    if (lives > 0) return true;
    if (lastHeartLossTime == null) return false;

    final now = DateTime.now();
    final diff = now.difference(lastHeartLossTime!);
    if (diff.inHours >= 4) {
      lives = 3;
      return true;
    }
    return false;
  }

  String getTimeUntilRefill() {
    if (lastHeartLossTime == null) return '';
    final now = DateTime.now();
    final diff = now.difference(lastHeartLossTime!);
    final remaining = Duration(hours: 4) - diff;
    return '${remaining.inHours} jam ${remaining.inMinutes % 60} menit';
  }

  

}
