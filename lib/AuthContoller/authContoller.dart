import 'dart:io';

import 'package:amazon/AuthContoller/testt.dart';
import 'package:amazon/Home/HomeScreen.dart';
import 'package:amazon/Profile/test.dart';
import 'package:amazon/UserModel/UserModel.dart';
import 'package:amazon/UserModel/UserSignModel.dart';
import 'package:amazon/authRepositry/authRepo.dart';
import 'package:amazon/call/callModule.dart';
import 'package:amazon/cart/StorageMethod.dart';
import 'package:amazon/chat/chatModuel.dart';
import 'package:amazon/constants/utils.dart';
import 'package:amazon/login/LoginScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enough_giphy_flutter/enough_giphy_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final authContioller = StateNotifierProvider<AuthContoller, bool>((ref) {
  final authRepo = ref.watch(authRepositry);
  final Storage = ref.watch(StorageMethodProvider);
  return AuthContoller(
      authRepositry: authRepo, ref: ref, storageMethod: Storage);
});
final getAlllDetails = StreamProvider.family((ref, uid) {
  final authRepo = ref.watch(authRepositry);
  return authRepo.getAllDetails();
});
final getAllmessagesDetails = StreamProvider.family((ref, String reciverUId) {
  final authRepo = ref.watch(authRepositry);
  return authRepo.getChatAllModule(ReciverUid: reciverUId);
});
final USerDetailsFormain = FutureProvider((ref) {
  final authRepo = ref.watch(authRepositry);
  return authRepo.getUserDetails();
});

class AuthContoller extends StateNotifier<bool> {
  final AuthRepositry authRepositry;
  final StorageMethod storageMethod;
  final Ref ref;

  AuthContoller(
      {required this.storageMethod,
      required this.ref,
      required this.authRepositry})
      : super(false);

  void sendDetailsToFirebase(
      {required String email,
      required String Password,
      required String Latitiude,
      required String longitude,
      required BuildContext context,
      required String name}) async {
    state = true;
    // UserModel user = UserModel(
    //     name: name,
    //     Latitiude: Latitiude,
    //     longitude: longitude,
    //     Email: email,
    //     UserUId: authRepositry.firebaseAuth.currentUser!.uid);
    authRepositry.sendDetailsToFirebase(
        name: name, Password: Password, Email: email, context: context);
    sentDetails(
        name: name,
        Latitiude: Latitiude,
        longitude: longitude,
        Email: email,
        context: context);
    // getUsername(name);
    state = false;
  }

  Stream<UserModel> getUserDetails({required String uid}) {
    return authRepositry.userDetails(uid: uid);
  }

  void sentDetails({
    required String name,
    required String Latitiude,
    required String longitude,
    required String Email,
    required BuildContext context,
  }) async {
    state = true;
    UserModel userModel = UserModel(
        name: name,
        Latitiude: Latitiude,
        longitude: longitude,
        Email: Email,
        UserUId: authRepositry.firebaseAuth.currentUser!.uid);
    authRepositry.SetUserDetailsTofirebase(
        context: context, userModel: userModel);
    state = false;
  }

  void logOutUser(BuildContext context) async {
    authRepositry.logoutUser(context);
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => LoginScreen()));
  }

  Stream<List<UserModel>> getDetailsAll() {
    return authRepositry.getAllDetails();
  }

  void sendTofirebasePhotoMessage(
      {required String cuuUId,
      required String currUserName,
      required String ReciverUserName,
      required String reciverUserId,
      required File? image,
      required BuildContext context,
      required String type}) async {
    try {
      if (image != null) {
        state = true;
        String photoUrl = await storageMethod.uploadFile(
            uid: cuuUId,
            context: context,
            childname: "Photo/$cuuUId/message",
            file: image);
        String me = cuuUId == authRepositry.firebaseAuth.currentUser!.uid
            ? "me"
            : "$ReciverUserName";

        ChatModule chatModule = ChatModule(
            isMe: me,
            createdAt: DateTime.now(),
            currUserName: currUserName,
            ReciverUserName: ReciverUserName,
            cuuUId: cuuUId,
            reciverUserId: reciverUserId,
            MessageText: photoUrl,
            type: type);
        authRepositry.sendMessageToFirebase(chatModule: chatModule);
        state = false;
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
  }

  void sendTofirebaseTextMessage(
      {required String cuuUId,
      required String currUserName,
      required String ReciverUserName,
      required String reciverUserId,
      required String Text,
      required BuildContext context,
      required String type}) async {
    try {
      state = true;

      String me = cuuUId != authRepositry.firebaseAuth.currentUser!.uid
          ? "$ReciverUserName"
          : "me";

      ChatModule chatModule = ChatModule(
          createdAt: DateTime.now(),
          isMe: me,
          currUserName: currUserName,
          ReciverUserName: ReciverUserName,
          cuuUId: cuuUId,
          reciverUserId: reciverUserId,
          MessageText: Text,
          type: type);
      authRepositry.sendMessageToFirebase(chatModule: chatModule);
      state = false;
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
  }

  void sendTofirebaseGIFMessage(
      {required String cuuUId,
      required String currUserName,
      required String ReciverUserName,
      required String reciverUserId,
      required String GifUrl,
      required BuildContext context,
      required String type}) async {
    try {
      state = true;
      int gifUrlPartIndex = GifUrl.lastIndexOf('-') + 1;
      String gifUrlPart = GifUrl.substring(gifUrlPartIndex);
      String newgifUrl = 'https://i.giphy.com/media/$gifUrlPart/200.gif';
      String me = cuuUId == authRepositry.firebaseAuth.currentUser!.uid
          ? "me"
          : "$ReciverUserName";

      ChatModule chatModule = ChatModule(
          createdAt: DateTime.now(),
          isMe: me,
          currUserName: currUserName,
          ReciverUserName: ReciverUserName,
          cuuUId: cuuUId,
          reciverUserId: reciverUserId,
          MessageText: newgifUrl,
          type: type);
      authRepositry.sendMessageToFirebase(chatModule: chatModule);
      state = false;
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
  }

  Stream<List<ChatModule>> getDetails({required String reciverUserId}) {
    return authRepositry.getChatAllModule(ReciverUid: reciverUserId);
  }

  Stream<DocumentSnapshot> get CallStream => authRepositry.CallStream;

  void endCall(
      {required String CallId,
      required BuildContext context,
      required String reciverUserId}) async {
    authRepositry.endCall(
        CallerId: CallId, context: context, reciverUserId: reciverUserId);
  }

  void makeCall(
      {required BuildContext context,
      required String reciverUserId,
      required String reciverName,
      required String sendername,
      required String senderId}) async {
    String callId = Uuid().v1();
    CallModule senderCalldata = CallModule(
        callerId: authRepositry.firebaseAuth.currentUser!.uid,
        callerName: sendername,
        reciverUserId: reciverUserId,
        reciverName: reciverName,
        callId: callId,
        haDialled: true);

    CallModule reciverCalldata = CallModule(
        callerId: authRepositry.firebaseAuth.currentUser!.uid,
        callerName: sendername,
        reciverUserId: reciverUserId,
        reciverName: reciverName,
        callId: callId,
        haDialled: false);

    authRepositry.makeCall(
        senderCalldata: senderCalldata,
        context: context,
        reciverCallData: reciverCalldata);
  }

  void UpdateUserLocation({
    required BuildContext context,
    required UserModel userModel,
    required String Latitiude,
    required String longitude,
  }) async {
    try {
      state = true;

      if (Latitiude.isNotEmpty && longitude.isNotEmpty) {
        print(Latitiude);
        print(longitude);
        userModel = userModel.copyWith(Latitiude: Latitiude);
        await authRepositry.updateLocationfUser(userModel: userModel);
        state = false;
        // Navigator.of(context).push(MaterialPageRoute(
        //     builder: (ctx) => TestScreen(
        //         currEmail: userModel.Email,
        //         currName: userModel.name,
        //         cuuId: userModel.UserUId,
        //         currLatitude: Latitiude,
        //         currLogititude: longitude)));
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
  }

  void SignIn(
      {required String Password,
      required String Email,
      required String name,
      required BuildContext context}) async {
    try {
      state = true;
      UserSignModel userSignModel =
          UserSignModel(Password: Password, Email: Email);
      authRepositry.signIn(
          name: name, context: context, userSignModel: userSignModel);
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
    state = false;
  }
}
