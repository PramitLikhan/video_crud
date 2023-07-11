import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:video_crud/core/extensions/build_context_extension.dart';
import 'package:video_crud/features/video/presentation/widgets/flow_action_button.dart';

import '../../../../../core/helpers/blocHelper.dart';
import '../../domain/entities/video.dart';
import '../bloc/video_bloc.dart';
import '../widgets/cameraScreen.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({Key? key}) : super(key: key);

  // var bloc = VideoBloc();

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  TextEditingController VideoNameController = TextEditingController();
  TextEditingController searchBarController = TextEditingController();

  @override
  void initState() {
    context.read<VideoBloc>().add(const VideoInitialLoad());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var bloc = context.read<VideoBloc>();
    return Scaffold(
      appBar: AppBar(title:  Text('Video CRUD',style: context.textTheme.headlineMedium,),elevation: 0,backgroundColor: Colors.white),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: BlocBuilder<VideoBloc, VideoState>(
                builder: (context, state) {
                  return Row(
                    children: [
                      Expanded(
                        child: BlocBuilder<VideoBloc, VideoState>(
                          builder: (context, state) {
                            return Text(
                              state.videos.isNotEmpty ? 'Manage videos' : 'Add New Video..',
                              style: context.textTheme.labelLarge,
                            );
                          },
                        ),
                      ),
                      state.videos.isNotEmpty
                          ? Center(
                              child: IconButton(
                                onPressed: () => bloc.add(const ClearAllDataEvent()),
                                icon: const Icon(Icons.refresh),
                              ),
                            )
                          : Wrap(),
                    ],
                  );
                },
              ),
            ),
            BlocConsumer<VideoBloc, VideoState>(
              bloc: context.read<VideoBloc>(),
              listener: (context, VideoState state) {
                if (state.action == BlocAction.launchCamera) {
                  launchCamera(context);
                } else if (state.action == BlocAction.launchFileManager) {
                  launchFileManager();
                }
              },
              builder: (context, state) {
                return Expanded(
                  child: GridView.builder(
                    itemCount: state.videos.length,
                    itemBuilder: (context, index) => videoListItem(state.videos[index], context, index),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: const FlowMenu(),
    );
  }

  videoListItem(VideoModel Video, BuildContext context, index) {
    TextEditingController controller = TextEditingController();
    return BlocBuilder<VideoBloc, VideoState>(
      builder: (context, state) {
        // print('VideoPage.buildVideoList ${state.editIndex}');
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.file(Video.thumbnail!),
              ),
              Positioned(
                right: -5,
                top: -5,
                child: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => context.read<VideoBloc>().add(RemoveVideoEvent(Video: Video)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void launchCamera(BuildContext context) {
    var bloc = context.read<VideoBloc>();
    context.push(const CameraScreen()).then((value) async {
      debugPrint('starting method getting value $value');
      if (value != null) {
        debugPrint('value ${value}');
        File? file = File(value);
        final thumbnailFile = await VideoThumbnail.thumbnailFile(
          video: value,
          imageFormat: ImageFormat.JPEG,
          maxWidth: 128, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
          quality: 25,
        );
        bloc.add(VideoAddEvent(
            Video: VideoModel(
          file: file,
          id: bloc.state.videos.length,
          thumbnail: File(thumbnailFile!),
          description: '',
          title: '',
        )));

        // compressFile(File(value)).then((compressedImage) {
        //   debugPrint('original file ${File(value).lengthSync()}');
        //   debugPrint("${compressedImage!.lengthSync()}");
        //   image = compressedImage;
        //
        //   // isReadyForNew = true;
        //   // isAddNewChallanPressed = false;
        // });
      }
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
    });
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

  void launchFileManager() {}
}
