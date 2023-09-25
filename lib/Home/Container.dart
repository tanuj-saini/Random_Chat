import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ContainerLeak extends ConsumerStatefulWidget {
  final Icon icon;
  final Color color;
  final String text;

  ContainerLeak(
      {required this.text, required this.color, required this.icon, super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _Container();
  }
}

class _Container extends ConsumerState<ContainerLeak> {
  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(side: BorderSide()),
        color: widget.color,
        child: ClipRRect(
            borderRadius:
                BorderRadius.circular(16.0), // Set the circular border
            child: Container(
                width: 200, // Set the width of the card
                height: 100, // Set the height of the card
                color: Color.fromARGB(
                    255, 240, 178, 240), // Set the background color of the card
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      widget.icon,
                      Text(
                        widget.text,
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ))));
  }
}
