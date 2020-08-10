import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';

class PhotoPicker {
  static const MethodChannel _channel =
      const MethodChannel('shenjian/photo_picker');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<File> pickPhoto() async{
    final path = await _channel.invokeMethod('pickPhoto');
    return File(path);
  }
}
