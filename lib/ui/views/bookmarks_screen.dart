import 'package:flutter/material.dart';

class BookMarksScreen extends StatefulWidget {
  const BookMarksScreen({super.key});

  @override
  State<BookMarksScreen> createState() => _BookMarksScreenState();
}

class _BookMarksScreenState extends State<BookMarksScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(height: 20),
          Text('Productos favoritos',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
