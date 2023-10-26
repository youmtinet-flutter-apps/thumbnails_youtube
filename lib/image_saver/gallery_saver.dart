import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class PhotoGallerySaver {
  static const String channelName = 'gallery_saver';
  static const String methodSaveImage = 'saveImage';
  static const String methodSaveVideo = 'saveVideo';

  static const String pleaseProvidePath = 'Please provide valid file path.';
  static const String fileIsNotVideo = 'File on path is not a video.';
  static const String fileIsNotImage = 'File on path is not an image.';
  static const MethodChannel _channel = MethodChannel(channelName);

  ///saves video from provided temp path and optional album name in gallery

  ///saves image from provided temp path and optional album name in gallery
  static Future<bool?> saveImage(
    Uint8List imageData, {
    String? albumName,
    bool toDcim = false,
    Map<String, String>? headers,
  }) async {
    File? tempFile;
    if (imageData.isEmpty) {
      throw ArgumentError(pleaseProvidePath);
    }

    tempFile = await saveUint8ListToTempFile(imageData);

    bool? result = await _channel.invokeMethod(
      methodSaveImage,
      <String, dynamic>{'path': tempFile.path, 'albumName': albumName, 'toDcim': toDcim},
    );
    tempFile.delete();

    return result;
  }

  static Future<File> saveUint8ListToTempFile(Uint8List imageData) async {
    // Get the temporary directory
    final directory = await getTemporaryDirectory();

    // Generate a unique filename
    final fileName = DateTime.now().millisecondsSinceEpoch.toString() + '.jpg';

    // Create a file and write the image data to it
    final tempFile = File('${directory.path}/$fileName');
    tempFile.create();
    await tempFile.writeAsBytes(imageData);

    // print('Image saved to: ${tempFile.path}');
    return tempFile;
  }
}
