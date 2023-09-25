import 'package:amazon/AuthContoller/authContoller.dart';
import 'package:amazon/UserModel/UserModel.dart';
import 'package:amazon/call/callPickScreen.dart';
import 'package:amazon/chat/ChatBox.dart';
import 'package:amazon/chat/chatModuel.dart';
import 'package:amazon/constants/LoderScreen.dart';
import 'package:amazon/constants/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final UserModel RuserModel;
  final String currEmail;
  final String CurrName;
  final String currId;

  ChatScreen(
      {required this.currId,
      required this.CurrName,
      required this.RuserModel,
      required this.currEmail,
      super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _ChatScreen();
  }
}

class _ChatScreen extends ConsumerState<ChatScreen> {
  void makeCall() async {
    ref.watch(authContioller.notifier).makeCall(
        context: context,
        reciverUserId: widget.RuserModel.UserUId,
        reciverName: widget.RuserModel.name,
        sendername: widget.CurrName,
        senderId: widget.currId);
  }

  @override
  Widget build(BuildContext context) {
    //   var chat=ChatModule(currUserName:widget.CurrName,
    //  ReciverUserName: widget.RuserModel.name, cuuUId: widget.currId,
    //  reciverUserId: widget.RuserModel.UserUId, MessageText: , isMe: isMe, type: type);
    return CallPickUpScrenn(
        scaffold: Scaffold(
            appBar: AppBar(
              title: Text(widget.RuserModel.name),
              centerTitle: true,
              actions: [
                IconButton(
                    onPressed: () => makeCall(),
                    icon: Icon(Icons.video_camera_back_outlined)),
              ],
            ),
            body: Column(
              children: [
                ref
                    .watch(getAllmessagesDetails(widget.RuserModel.UserUId))
                    .when(
                      data: (data) {
                        return Expanded(
                          child: ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              var chat = data[index];
                              SizedBox(
                                height: 10,
                              );
                              if (chat.isMe == chat.cuuUId) {
                                return ListTile(
                                  leading: Text(
                                    widget.CurrName,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  title: chat.type == "text"
                                      ? Text(
                                          chat.MessageText,
                                        )
                                      : chat.type == "gif"
                                          ? CachedNetworkImage(
                                              imageUrl: chat.MessageText)
                                          : chat.type == "photo"
                                              ? CachedNetworkImage(
                                                  imageUrl: chat.MessageText)
                                              : SizedBox(),
                                );
                              } else {
                                return ListTile(
                                  leading: Text(
                                    chat.currUserName,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  title: chat.type == "text"
                                      ? Text(
                                          chat.MessageText,
                                        )
                                      : chat.type == "gif"
                                          ? CachedNetworkImage(
                                              imageUrl: chat.MessageText)
                                          : chat.type == "photo"
                                              ? CachedNetworkImage(
                                                  imageUrl: chat.MessageText)
                                              : SizedBox(),
                                );
                              }
                            },
                          ),
                        );
                      },
                      error: (err, trace) {
                        showSnackBar(context, err.toString());
                        return SizedBox();
                      },
                      loading: () => LoderScreen(),
                    ),
                bottomMessagebox(
                    CurrName: widget.CurrName,
                    RuserModel: widget.RuserModel,
                    currEmail: widget.currEmail,
                    currId: widget.currId,
                    reciverUserId: widget.RuserModel.UserUId)
              ],
            )));
  }
}
