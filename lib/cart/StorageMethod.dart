import 'dart:io';
import 'dart:typed_data';

import 'package:amazon/constants/utils.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final StorageMethodProvider =
    Provider((ref) => StorageMethod(storage: FirebaseStorage.instance));

class StorageMethod {
  final FirebaseStorage storage;

  StorageMethod({required this.storage});

  Future<String> uploadFile(
      {required String uid,
      required BuildContext context,
      required String childname,
      required File? file}) async {
    try {
      final ref = await storage.ref().child(childname).child(uid);

      UploadTask uploadTask = ref.putFile(file!);
      final snapShot = await uploadTask;
      return await snapShot.ref.getDownloadURL();
    } on FirebaseException catch (e) {
      showSnackBar(context, e.message!);
    }
    return "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR2nrx0oKNIWcjDbq5RimIXN6eHzgl2T30BMw&usqp=CAU";
  }
}
