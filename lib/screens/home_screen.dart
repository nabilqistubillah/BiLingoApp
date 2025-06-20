import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final String name = "Kml Bilqist";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Selamat datang")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.purple,
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Welcome,", style: TextStyle(color: Colors.white)),
                Text(name, style: TextStyle(color: Colors.white, fontSize: 24)),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    hintText: "search",
                    filled: true,
                    suffixIcon: Icon(Icons.search),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 20),
          Text("Kategori Pembelajaran", style: TextStyle(fontSize: 18)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildCategory("Quiz", Icons.quiz),
                _buildCategory("Match", Icons.sync),
                _buildCategory("Lagu", Icons.music_note),
                _buildCategory("Kosakata", Icons.book),
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.emoji_events), label: "XP"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  Widget _buildCategory(String title, IconData icon) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          child: Icon(icon, size: 30),
        ),
        SizedBox(height: 5),
        Text(title),
      ],
    );
  }
}
