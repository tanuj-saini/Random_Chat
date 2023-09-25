import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Cart extends ConsumerStatefulWidget {
  Cart({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _Cart();
  }
}

class _Cart extends ConsumerState<Cart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "fdjdksj",
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
