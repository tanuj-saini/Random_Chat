import 'package:agora_uikit/agora_uikit.dart';
import 'package:amazon/AuthContoller/authContoller.dart';
import 'package:amazon/agora/config_agora.dart';
import 'package:amazon/call/callModule.dart';
import 'package:amazon/constants/LoderScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CallScreen extends ConsumerStatefulWidget {
  final String ChannelId;
  final CallModule callModule;

  CallScreen({required this.ChannelId, required this.callModule, super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _CallScreen();
  }
}

class _CallScreen extends ConsumerState<CallScreen> {
  AgoraClient? client;
  String baseUrl = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    client = AgoraClient(
        agoraConnectionData: AgoraConnectionData(
            appId: AgoraConfig.appId,
            channelName: widget.ChannelId,
            tokenUrl: baseUrl));
    initAgora();
  }

  void initAgora() async {
    await client!.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: client == null
            ? LoderScreen()
            : Scaffold(
                body: SafeArea(
                  child: Stack(
                    children: [
                      AgoraVideoViewer(client: client!),
                      AgoraVideoButtons(
                        client: client!,
                        disconnectButtonChild: IconButton(
                            onPressed: () async {
                              await client!.engine.leaveChannel();
                              ref.read(authContioller.notifier).endCall(
                                  CallId: widget.callModule.callerId,
                                  context: context,
                                  reciverUserId:
                                      widget.callModule.reciverUserId);
                              Navigator.of(context).pop();
                            },
                            icon: Icon(Icons.call_end)),
                      ),
                    ],
                  ),
                ),
              ));
  }
}
