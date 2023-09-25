import 'package:amazon/Home/HomeScreen.dart';
import 'package:amazon/MainScreen/MainScreen.dart';
import 'package:amazon/UserModel/UserModel.dart';
import 'package:amazon/UserModel/UserSignModel.dart';
import 'package:amazon/call/CallScreen.dart';
import 'package:amazon/call/callModule.dart';
import 'package:amazon/chat/chatModuel.dart';
import 'package:amazon/constants/error_handling.dart';
import 'package:amazon/login/LoginScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final authRepositry = Provider((ref) => AuthRepositry(
      firebaseAuth: FirebaseAuth.instance,
      firebaseFirestore: FirebaseFirestore.instance,
    ));

class AuthRepositry {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;

  AuthRepositry({required this.firebaseAuth, required this.firebaseFirestore});

  void sendDetailsToFirebase(
      {required String Password,
      required String Email,
      required String name,
      required BuildContext context}) async {
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
          email: Email, password: Password);
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
  }

  void logoutUser(BuildContext context) async {
    try {
      await firebaseAuth.signOut();
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (ctx) => LoginScreen()));
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
  }

  void SetUserDetailsTofirebase(
      {required UserModel userModel, required BuildContext context}) async {
    await firebaseFirestore
        .collection("users")
        .doc(userModel.UserUId)
        .set(userModel.toMap());
    Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => HomeScreen(
            Email: userModel.Email,
            name: userModel.name,
            CurrentUserID: firebaseAuth.currentUser!.uid)));
  }

  Stream<UserModel> userDetails({required String uid}) {
    return firebaseFirestore
        .collection('users')
        .doc(uid)
        .snapshots()
        .asyncMap((event) => UserModel.fromMap(event.data()!));
  }

  Future<UserModel?> getUserDetails() async {
    var userData = await firebaseFirestore
        .collection('users')
        .doc(firebaseAuth.currentUser?.uid)
        .get();
    UserModel? user;
    if (userData.data() != null) {
      user = UserModel.fromMap(userData.data()!);
    }

    return user;
  }

  Stream<List<ChatModule>> getChatAllModule({
    required String ReciverUid,
  }) {
    return firebaseFirestore
        .collection("users")
        .doc(firebaseAuth.currentUser!.uid)
        .collection("Chats")
        .doc(ReciverUid)
        .collection('messages')
        .orderBy("createdAt")
        .snapshots()
        .map((event) {
      final List<ChatModule> chat = [];
      for (var document in event.docs) {
        chat.add(
          ChatModule.fromMap(document.data()),
        );
      }
      return chat;
    });
  }

  void sendMessageToFirebase({required ChatModule chatModule}) async {
    String uuid = Uuid().v1();
    await firebaseFirestore
        .collection("users")
        .doc(chatModule.reciverUserId)
        .collection("Chats")
        .doc(chatModule.cuuUId)
        .collection("messages")
        .doc(uuid)
        .set(chatModule.toMap());
    await firebaseFirestore
        .collection("users")
        .doc(chatModule.cuuUId)
        .collection("Chats")
        .doc(chatModule.reciverUserId)
        .collection("messages")
        .doc(uuid)
        .set(chatModule.toMap());
  }

  Stream<List<UserModel>> getAllDetails() {
    return firebaseFirestore.collection('users').snapshots().map((event) {
      final List<UserModel> list = [];
      for (var document in event.docs) {
        list.add(UserModel.fromMap(document.data()));
      }
      return list;
    });
  }

  Stream<DocumentSnapshot> get CallStream => firebaseFirestore
      .collection("call")
      .doc(firebaseAuth.currentUser!.uid)
      .snapshots();

  void makeCall(
      {required CallModule senderCalldata,
      required BuildContext context,
      required CallModule reciverCallData}) async {
    try {
      await firebaseFirestore
          .collection("call")
          .doc(senderCalldata.callerId)
          .set(senderCalldata.toMap());

      await firebaseFirestore
          .collection("call")
          .doc(senderCalldata.reciverUserId)
          .set(reciverCallData.toMap());
      Navigator.of(context).push(MaterialPageRoute(
          builder: (ctx) => CallScreen(
              ChannelId: senderCalldata.callId, callModule: senderCalldata)));
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
  }

  void endCall(
      {required String CallerId,
      required BuildContext context,
      required String reciverUserId}) async {
    try {
      await firebaseFirestore.collection("call").doc(CallerId).delete();

      await firebaseFirestore.collection("call").doc(reciverUserId).delete();
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
  }

  Future updateLocationfUser({required UserModel userModel}) async {
    await firebaseFirestore
        .collection('users')
        .doc(userModel.UserUId)
        .update(userModel.toMap());
  }

  void signIn(
      {required UserSignModel userSignModel,
      required String name,
      required BuildContext context}) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: userSignModel.Email, password: userSignModel.Password);
      Navigator.of(context).push(MaterialPageRoute(
          builder: (ctx) => HomeScreen(
              Email: userSignModel.Email,
              name: name,
              CurrentUserID: firebaseAuth.currentUser!.uid)));
    } on FirebaseException catch (e) {
      showSnackBar(context, e.toString());
    }
    ;
  }
}
