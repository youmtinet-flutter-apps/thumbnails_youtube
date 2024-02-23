import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:saver_gallery/saver_gallery.dart';

const List<String> videoFormats = ['.mp4', '.mov', '.avi', '.wmv', '.3gp', '.3gpp', '.mkv', '.flv'];
const List<String> imageFormats = ['.jpeg', '.png', '.jpg', '.gif', '.webp', '.tif', '.heic'];
const httpkey = 'http';

bool isLocalFilePath(String path) {
  Uri uri = Uri.parse(path);
  return !uri.scheme.contains(httpkey);
}

bool isVideo(String path) {
  bool output = false;
  for (var videoFormat in videoFormats) {
    if (path.toLowerCase().contains(videoFormat)) output = true;
  }
  return output;
}

bool isImage(String path) {
  bool output = false;
  for (var imageFormat in imageFormats) {
    if (path.toLowerCase().contains(imageFormat)) output = true;
  }
  return output;
}

class GallerySaver {
  static const String pleaseProvidePath = 'Please provide valid file path.';
  static const String fileIsNotVideo = 'File on path is not a video.';
  static const String fileIsNotImage = 'File on path is not an image.';

  ///saves video from provided temp path and optional album name in gallery
  static Future<bool?> saveVideo(
    String path, {
    String? albumName,
    bool toDcim = false,
    Map<String, String>? headers,
  }) async {
    File? tempFile;
    if (path.isEmpty) {
      throw ArgumentError(pleaseProvidePath);
    }
    if (!isVideo(path)) {
      throw ArgumentError(fileIsNotVideo);
    }
    if (!isLocalFilePath(path)) {
      tempFile = await _downloadFile(path, headers: headers);
      path = tempFile.path;
    }
    var result = await SaverGallery.saveFile(
      file: path,
      name: p.basename(path),
      androidRelativePath: 'DCIM/$albumName/Saved',
      androidExistNotSave: false,
    );
    if (tempFile != null) {
      tempFile.delete();
    }
    return result.isSuccess;
  }

  ///saves image from provided temp path and optional album name in gallery
  static Future<bool?> saveImage(
    String path, {
    String? albumName,
    bool toDcim = false,
    Map<String, String>? headers,
  }) async {
    File? tempFile;
    if (path.isEmpty) {
      throw ArgumentError(pleaseProvidePath);
    }
    if (!isImage(path)) {
      throw ArgumentError(fileIsNotImage);
    }
    if (!isLocalFilePath(path)) {
      tempFile = await _downloadFile(path, headers: headers);
      path = tempFile.path;
    }

    var result = await SaverGallery.saveFile(
      file: path,
      name: p.basename(path),
      androidRelativePath: 'DCIM/$albumName/Saved',
      androidExistNotSave: false,
    );
    if (tempFile != null) {
      tempFile.delete();
    }

    return result.isSuccess;
  }

  static Future<File> _downloadFile(String url, {Map<String, String>? headers}) async {
    log(url);
    log('$headers');
    http.Client cclient = http.Client();
    var req = await cclient.get(Uri.parse(url), headers: headers);
    if (req.statusCode >= 400) {
      throw HttpException(req.statusCode.toString());
    }
    var bytes = req.bodyBytes;
    String dir = (await getTemporaryDirectory()).path;
    File file = File('$dir/${p.basename(url)}');
    await file.writeAsBytes(bytes);
    log('File size:${await file.length()}');
    log(file.path);
    return file;
  }
}

class PhotoGallerySaver {
  static String channelName = 'gallery_saver';
  static String methodSaveImage = 'saveImage';
  static String methodSaveVideo = 'saveVideo';

  static String pleaseProvidePath = 'Please provide valid file path.';
  static String fileIsNotVideo = 'File on path is not a video.';
  static String fileIsNotImage = 'File on path is not an image.';
  static MethodChannel _channel = MethodChannel(channelName);

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
