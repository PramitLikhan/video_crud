import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../features/video/domain/entities/video.dart';
import '../../features/video/presentation/bloc/video_bloc.dart';

class IOHelper {
  static IOHelper? _instance;
  static IOHelper get io => _instance ?? IOHelper();

  init() {
    _instance = IOHelper();
  }

  Future<String?> captureVideo() async {
    try {
      final value = await ImagePicker().pickVideo(source: ImageSource.camera);
      print('_VideoPageState.pickImage ${value.runtimeType}');
      if (value == null) return null;
      final imageTemporary = value.path;
      return imageTemporary;
    } on PlatformException catch (e) {
      debugPrint('object: $e');
    }
    return null;
  }

  Future<String?> createThumbnailFile({required String path}) async {
    final thumbnailFile = await VideoThumbnail.thumbnailFile(
      video: path,
      imageFormat: ImageFormat.PNG,
      maxWidth: 128, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
      quality: 100,
    );
    return thumbnailFile;
  }

  Future<File?> compressFile(File file) async {
    Random random = Random();
    int randomNumber = random.nextInt(100);
    final dir = Directory.systemTemp;
    final targetPath = '${dir.absolute.path}/$randomNumber.jpg';
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      minWidth: 1200,
      minHeight: 940,
      quality: 50,
    );
    return result;
  }

  Future<void> launchFileManager(BuildContext context) async {
    var bloc = context.read<VideoBloc>();
    await pickVideo(ImageSource.gallery).then((value) async {
      if (value != null) {
        debugPrint('value add korbo ${value.runtimeType}');

        final thumbnailFile = await VideoThumbnail.thumbnailFile(
          video: value.path,
          imageFormat: ImageFormat.JPEG,
          maxWidth: 128, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
          quality: 25,
        );
        bloc.add(VideoAddEvent(
            Video: VideoModel(
          file: value.path,
          id: bloc.state.videos.length,
          thumbnail: thumbnailFile!,
          description: '',
          title: '',
        )));
      } else {
        bloc.add(const ResetStateEvent());
      }
    });
    print('_VideoPageState.launchFileManager ${bloc.state.action} ${bloc.state.detailsState}');
    bloc.add(const ResetStateEvent());
  }

  Future pickVideo(ImageSource source) async {
    try {
      final image = await ImagePicker().pickVideo(source: source);
      print('_VideoPageState.pickImage ${image.runtimeType}');
      if (image == null) return;

      final imageTemporary = File(image.path);
      // setState(() => widget.image = imageTemporary);
      return imageTemporary;
    } on PlatformException catch (e) {
      debugPrint('object: $e');
    }
  }
}
