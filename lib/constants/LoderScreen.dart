import 'package:flutter/material.dart';

class LoderScreen extends StatefulWidget {
  const LoderScreen({super.key});
  @override
  State<LoderScreen> createState() {
    return _LoderScreen();
  }
}

class _LoderScreen extends State<LoderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
