import 'package:amazon/AuthContoller/authContoller.dart';
import 'package:amazon/call/CallScreen.dart';
import 'package:amazon/call/callModule.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CallPickUpScrenn extends ConsumerWidget {
  final Widget scaffold;
  CallPickUpScrenn({required this.scaffold, super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<DocumentSnapshot>(
      stream: ref.watch(authContioller.notifier).CallStream,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.data() != null) {
          CallModule callModule =
              CallModule.fromMap(snapshot.data!.data() as Map<String, dynamic>);
          if (!callModule.haDialled) {
            return Scaffold(
              body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 90,
                      ),
                      Text(
                        "Imcoming Call",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 40),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        callModule.callerName,
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(
                        height: 70,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.all(80.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (ctx) => CallScreen(
                                                ChannelId: callModule.callId,
                                                callModule: callModule)));
                                  },
                                  icon: Icon(
                                    Icons.phone,
                                    color: Colors.green,
                                    size: 30,
                                  )),
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.call_end,
                                    color:
                                        const Color.fromARGB(255, 255, 99, 88),
                                    size: 30,
                                  ))
                            ],
                          ),
                        ),
                      )
                    ]),
              ),
            );
          }
        }
        return scaffold;
      },
    );
  }
}
