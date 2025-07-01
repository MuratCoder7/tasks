import "package:flutter/material.dart";

import "completed_tasks_page.dart";
import "home_page.dart";


class StarterPage extends StatefulWidget {
  const StarterPage({super.key});

  @override
  State<StarterPage> createState() => _StarterPageState();
}

class _StarterPageState extends State<StarterPage> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    HomePage(),
    CompletedTasksPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      body:_pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        onTap: (int index){
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Icon(
                Icons.home,
                size:28,
                color: Color(0xFF0D4673),
              ),
            ),
            label: "Home",

          ),
          BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Icon(
                    Icons.task_alt_outlined,
                    size:28,
                    color:Color(0xFF4CB050)
                ),
              ),
              label: "Completed Tasks"
          ),
        ],
      ),
    );
  }
}
