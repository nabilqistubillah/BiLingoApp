import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:bilingo/services/user_service.dart';
class Sentence {
  final String english;
  final List<String> translation;
  

  Sentence({required this.english, required this.translation});

  factory Sentence.fromJson(Map<String, dynamic> json) {
    return Sentence(
      english: json['english'],
      translation: List<String>.from(json['translation']),
    );
  }
}

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

  List<Sentence> allSentences = [];
  int currentSentenceIndex = 0;

  List<String> choices = [];
  List<String> userAnswer = [];

  @override
  void initState() {
    super.initState();
    loadSentences();

    if (lives == 0 && lastHeartLossTime != null) {
      startRefillCountdown();
    }
  }

  Future<void> loadSentences() async {
    final jsonString = await rootBundle.loadString('assets/data/sentences.json');
    final List<dynamic> data = json.decode(jsonString);
    setState(() {
      allSentences = data.map((item) => Sentence.fromJson(item)).toList();
      setupSentence();
    });
  }

  void setupSentence() {
    if (currentSentenceIndex >= allSentences.length) return;
    final current = allSentences[currentSentenceIndex];
    userAnswer = [];
    choices = List.from(current.translation)..shuffle();
  }

  void decreaseLife() {
    setState(() {
      lives--;
      if (lives == 0) {
        lastHeartLossTime = DateTime.now();
        startRefillCountdown();
      }
    });
  }

  void startRefillCountdown() {
    refillTimer?.cancel();

    refillTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      final elapsed = now.difference(lastHeartLossTime!);
      final refillDelay = const Duration(hours: 4);

      if (elapsed >= refillDelay) {
        setState(() {
          lives = 3;
          refillTimer?.cancel();
        });
      } else {
        setState(() {
          timeUntilRefill = refillDelay - elapsed;
        });
      }
    });
  }

  Future <void> checkAnswer() async{
   
    final correct = allSentences[currentSentenceIndex].translation;

    if (userAnswer.join(' ') == correct.join(' ')) {
       await UserService.addXp(10);
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('✅ Benar!'),
          content: const Text('Kamu menyusun kalimat dengan benar!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                nextSentence();
              },
              child: const Text("Lanjut"),
            )
          ],
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
          title: const Text('❌ Salah'),
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

  void nextSentence() {
    if (currentSentenceIndex + 1 < allSentences.length) {
      setState(() {
        currentSentenceIndex++;
        setupSentence();
      });
    } else {
      showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          title: Text('🎉 Selesai!'),
          content: Text('Kamu telah menyelesaikan semua kalimat!'),
        ),
      );
    }
  }

  void resetAnswer() {
    setState(() {
      userAnswer.clear();
      choices = List.from(allSentences[currentSentenceIndex].translation)..shuffle();
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

  @override
  Widget build(BuildContext context) {
    if (allSentences.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final current = allSentences[currentSentenceIndex];

    return Scaffold(
      appBar: AppBar(title: const Text('Susun Kalimat')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'Kalimat: "${current.english}"',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            lives > 0
                ? Text(
                    '❤️ $lives',
                    style: const TextStyle(fontSize: 20, color: Colors.red),
                  )
                : Text(
                    '❤️ 0 — Tunggu: ${timeUntilRefill.inHours}j ${timeUntilRefill.inMinutes % 60}m',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
            const SizedBox(height: 20),
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
}
