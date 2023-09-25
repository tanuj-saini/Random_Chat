import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ttest extends ConsumerStatefulWidget {

  ttest({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _TestScreen();
  }
}

class _TestScreen extends ConsumerState<ttest> {
  @override
  Widget build(BuildContext context) {
  return Scaffold(body: Center(child: Text('fklslka'),),);
  }}