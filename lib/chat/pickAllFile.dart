import 'dart:io';

import 'package:amazon/constants/utils.dart';
import 'package:enough_giphy_flutter/enough_giphy_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<File?> pickimage(ImageSource source, BuildContext context) async {
  File? image;
  try {
    final imagePick = await ImagePicker().pickImage(source: source);
    if (imagePick != null) {
      image = File(imagePick.path);
    }
  } catch (e) {
    showSnackBar(context, e.toString());
  }
  return image;
}

Future<File?> pickVideo(BuildContext context, ImageSource source) async {
  File? Video;
  try {
    final pickerVideo = await ImagePicker().pickVideo(source: source);
    if (pickerVideo != null) {
      Video = File(pickerVideo.path);
    }
  } catch (e) {
    showSnackBar(context, e.toString());
  }
  return Video;
}

Future<GiphyGif?> pickGIF(BuildContext context) async {
  GiphyGif? gif;
  try {
    gif = await Giphy.getGif(
        context: context, apiKey: '6EPNCQ2mxOEughOIvsjdd1JuVpgnqwbc');
  } catch (e) {
    showSnackBar(context, e.toString());
  }
  return gif;
}
