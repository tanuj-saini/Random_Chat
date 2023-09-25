import 'dart:typed_data';

import 'package:amazon/AuthContoller/authContoller.dart';
import 'package:amazon/UserModel/UserModel.dart';
import 'package:amazon/call/callPickScreen.dart';
import 'package:amazon/chat/messageEnum.dart';
import 'package:amazon/chat/pickAllFile.dart';
import 'package:amazon/constants/LoderScreen.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dart:io';

import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class bottomMessagebox extends ConsumerStatefulWidget {
  final String reciverUserId;
  final UserModel RuserModel;
  final String currEmail;
  final String CurrName;
  final String currId;

  bottomMessagebox(
      {required this.CurrName,
      required this.RuserModel,
      required this.currEmail,
      required this.currId,
      super.key,
      required this.reciverUserId});
  @override
  ConsumerState<bottomMessagebox> createState() {
    return _bottomMessagebox();
  }
}

class _bottomMessagebox extends ConsumerState<bottomMessagebox> {
  bool _isSend = false;
  bool _showEmoji = false;
  FocusNode focusNode = FocusNode();
  bool isRecoderinit = false;
  FlutterSoundRecorder? _flutterSoundRecorder;
  bool isRecodering = false;
  //bool

  void sendPhotoMessage({
    required File image,
    required String cuuUId,
    required String currUserName,
    required String ReciverUserName,
    required String reciverUserId,
  }) async {
    ref.watch(authContioller.notifier).sendTofirebasePhotoMessage(
        cuuUId: cuuUId,
        currUserName: currUserName,
        ReciverUserName: ReciverUserName,
        reciverUserId: reciverUserId,
        image: image,
        context: context,
        type: "photo");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _flutterSoundRecorder = FlutterSoundRecorder();
    OpenAudio();
  }

  void OpenAudio() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Mic Permission is Not allowed');
    }
    await _flutterSoundRecorder!.openRecorder();
    isRecoderinit = true;
  }

  void selectPhoto({
    required String cuuUId,
    required String currUserName,
    required String ReciverUserName,
    required String reciverUserId,
  }) async {
    File? image = await pickimage(ImageSource.gallery, context);
    if (image != null) {
      sendPhotoMessage(
          image: image,
          cuuUId: cuuUId,
          currUserName: currUserName,
          ReciverUserName: ReciverUserName,
          reciverUserId: reciverUserId);
    }
  }

  void selectVideo({
    required String cuuUId,
    required String currUserName,
    required String ReciverUserName,
    required String reciverUserId,
  }) async {
    File? video = await pickVideo(context, ImageSource.gallery);
    if (video != null) {
      sendPhotoMessage(
          image: video,
          cuuUId: cuuUId,
          currUserName: currUserName,
          ReciverUserName: ReciverUserName,
          reciverUserId: reciverUserId);
    }
  }

  void selectGif({
    required String cuuUId,
    required String currUserName,
    required String ReciverUserName,
    required String reciverUserId,
  }) async {
    final gif = await pickGIF(context);
    if (gif != null) {
      ref.watch(authContioller.notifier).sendTofirebaseGIFMessage(
          cuuUId: cuuUId,
          currUserName: currUserName,
          ReciverUserName: ReciverUserName,
          reciverUserId: reciverUserId,
          GifUrl: gif.url,
          context: context,
          type: 'gif');
    }
  }

  void showKeyboard() {
    focusNode.requestFocus();
  }

  void HideKeyboard() {
    focusNode.unfocus();
  }

  void HideEmojiContainer() {
    setState(() {
      _showEmoji = false;
    });
  }

  void ShowEmojiContainer() {
    setState(() {
      _showEmoji = true;
    });
  }

  void toggleKeyboardEmoji() {
    if (_showEmoji) {
      HideEmojiContainer();
      showKeyboard();
    } else {
      ShowEmojiContainer();
      HideKeyboard();
    }
  }

  void sendTextMessage({
    required String Text,
    required String cuuUId,
    required String currUserName,
    required String ReciverUserName,
    required String reciverUserId,
  }) async {
    if (_isSend) {
      ref.watch(authContioller.notifier).sendTofirebaseTextMessage(
          cuuUId: cuuUId,
          currUserName: currUserName,
          ReciverUserName: ReciverUserName,
          reciverUserId: reciverUserId,
          Text: Text,
          context: context,
          type: "text");
      setState(() {
        _isSend = !_isSend;
        messageContoller.text = "";
      });
    }
  }

  final TextEditingController messageContoller = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    messageContoller.dispose();
    _flutterSoundRecorder!.closeRecorder();
    isRecoderinit = false;
  }

  @override
  Widget build(BuildContext context) {
    final isLoding = ref.watch(authContioller);
    return Column(
      children: [
        isLoding
            ? LoderScreen()
            : Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      focusNode: focusNode,
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          setState(() {
                            _isSend = true;
                          });
                        } else {
                          setState(() {
                            _isSend = false;
                          });
                        }
                      },
                      //focusNode: focusNode,
                      controller: messageContoller,

                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.black38,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: SizedBox(
                            width: 100,
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: toggleKeyboardEmoji,
                                  icon: const Icon(
                                    Icons.emoji_emotions,
                                    color: Colors.grey,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => selectGif(
                                      cuuUId: widget.currId,
                                      currUserName: widget.CurrName,
                                      ReciverUserName: widget.RuserModel.name,
                                      reciverUserId: widget.RuserModel.UserUId),
                                  icon: const Icon(
                                    Icons.gif,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        suffixIcon: SizedBox(
                          width: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () => selectPhoto(
                                    cuuUId: widget.currId,
                                    currUserName: widget.CurrName,
                                    ReciverUserName: widget.RuserModel.name,
                                    reciverUserId: widget.RuserModel.UserUId),
                                icon: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.grey,
                                ),
                              ),
                              IconButton(
                                onPressed: () => selectVideo(
                                    cuuUId: widget.currId,
                                    currUserName: widget.CurrName,
                                    ReciverUserName: widget.RuserModel.name,
                                    reciverUserId: widget.RuserModel.UserUId),
                                icon: const Icon(
                                  Icons.attach_file,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        hintText: 'Type a message!',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: const BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                        contentPadding: const EdgeInsets.all(10),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 4,
                      right: 3,
                      left: 2,
                    ),
                    child: GestureDetector(
                        child: CircleAvatar(
                          backgroundColor: const Color(0xFF128C7E),
                          radius: 22,
                          child: Icon(
                            _isSend
                                ? Icons.send
                                : isRecodering
                                    ? Icons.close
                                    : Icons.mic,
                            color: Colors.white,
                          ),
                        ),
                        onTap: () => sendTextMessage(
                            Text: messageContoller.text,
                            cuuUId: widget.currId,
                            currUserName: widget.CurrName,
                            ReciverUserName: widget.RuserModel.name,
                            reciverUserId: widget.RuserModel.UserUId)),
                  ),
                ],
              ),
        _showEmoji
            ? SizedBox(
                height: 310,
                child: EmojiPicker(
                  onEmojiSelected: (category, emoji) {
                    setState(() {
                      messageContoller.text =
                          messageContoller.text + emoji.emoji;
                      _isSend = true;
                    });
                  },
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class ChatBox extends ConsumerStatefulWidget {
//   ChatBox({super.key});
//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() {
//     return _ChatBox();
//   }
// }

// class _ChatBox extends ConsumerState<ChatBox> {
//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//     messageContoller.dispose();
//   }

//   final TextEditingController messageContoller = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         TextField(
//           controller: messageContoller,
//           decoration: InputDecoration(
//             prefixIcon:
//                 IconButton(onPressed: () {}, icon: Icon(Icons.emoji_emotions)),
//             suffixIcon: Row(
//               children: [
//                 IconButton(onPressed: () {}, icon: Icon(Icons.gif)),
//                 IconButton(onPressed: () {}, icon: Icon(Icons.camera)),
//               ],
//             ),

//           ),

//         ),
//         CircleAvatar(radius: 10,child: IconButton(onPressed: (){}, icon: Icon(Icons.send)),),
//       ],
//     );

//   }
// }
