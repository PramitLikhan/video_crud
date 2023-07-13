import 'dart:io';
import 'dart:math';

import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:video_crud/core/extensions/build_context_extension.dart';
import 'package:video_crud/features/video/presentation/pages/video_details_page.dart';
import 'package:video_crud/features/video/presentation/widgets/flow_action_button.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../../../../core/helpers/blocHelper.dart';
import '../../domain/entities/video.dart';
import '../bloc/video_bloc.dart';
import '../widgets/cameraScreen.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({Key? key}) : super(key: key);

  // var bloc = VideoBloc();

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  @override
  void initState() {
    context.read<VideoBloc>().add(const VideoInitialLoad());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var bloc = context.read<VideoBloc>();
    return Scaffold(
      appBar: AppBar(
          title: Text(
            'Video CRUD',
            style: context.textTheme.headlineMedium,
          ),
          elevation: 0,
          backgroundColor: Colors.white),
      body: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
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
                              state.videos.isNotEmpty ? 'Manage videos ...' : 'Add New Video ...',
                              style: context.textTheme.headlineSmall,
                            );
                          },
                        ),
                      ),
                      state.videos.isNotEmpty
                          ? Center(
                              child: TextButton(
                                onPressed: () => bloc.add(const ShowDeleteAllDialogEvent()),
                                child: Text(
                                  'Delete All',
                                  style: context.textTheme.headlineSmall!.copyWith(color: Colors.red),
                                ),
                              ),
                            )
                          : const Wrap(),
                    ],
                  );
                },
              ),
            ),
            BlocBuilder<VideoBloc, VideoState>(
                builder: (context, state) => Container(
                      child: state.videos.isEmpty ? Center(child: LottieBuilder.asset('assets/animation.json')) : Container(),
                    )),
            BlocConsumer<VideoBloc, VideoState>(
              bloc: context.read<VideoBloc>(),
              listener: (context, VideoState state) {
                if (state.action == BlocAction.launchCamera) {
                  launchCamera(context);
                } else if (state.action == BlocAction.launchFileManager) {
                  launchFileManager(context);
                } else if (state.action == BlocAction.showDeleteAllDialog) {
                  deleteDialog(
                      context: context,
                      deleteFunction: () {
                        bloc.add(const ClearAllDataEvent());
                        context.pop();
                      },
                      message: 'Are you sure ? you can\'t undo this');
                }
              },
              builder: (context, state) {
                return Expanded(
                  child: GridView.builder(
                    itemCount: state.videos.length,
                    itemBuilder: (context, index) => videoListItem(state.videos[index], context, index),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                    clipBehavior: Clip.none,
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

  videoListItem(VideoModel video, BuildContext context, index) {
    var bloc = context.read<VideoBloc>();
    return BlocConsumer<VideoBloc, VideoState>(
      listener: (context, state) {
        if (state.action == BlocAction.showDeleteDialog && state.deleteIndex == state.videos.indexOf(video)) {
          deleteDialog(
              context: context,
              deleteFunction: () {
                bloc.add(RemoveVideoEvent(Video: video));
                context.pop();
                bloc.add(const ResetStateEvent());
              },
              message: 'Are you sure you want to delete this video? you can\'t undo this');
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: badges.Badge(
              onTap: () => context.read<VideoBloc>().add(ShowDeleteDialogEvent(deleteIndex: state.videos.indexOf(video))),
              stackFit: StackFit.expand,
              badgeContent: const Icon(Icons.clear, size: 30),
              badgeAnimation: const badges.BadgeAnimation.rotation(
                animationDuration: Duration(seconds: 1),
                colorChangeAnimationDuration: Duration(seconds: 1),
                loopAnimation: false,
                curve: Curves.fastOutSlowIn,
                colorChangeAnimationCurve: Curves.easeInCubic,
              ),
              badgeStyle: const badges.BadgeStyle(shape: badges.BadgeShape.circle),
              position: badges.BadgePosition.topEnd(end: 8, top: 10),
              child: InkWell(
                onTap: () => context.push(VideoDetailsPage(index: index)),
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.file(
                          File(video.thumbnail!),
                          fit: BoxFit.fitWidth,
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.black45, Colors.transparent],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                video.title!,
                                style: context.textTheme.headlineSmall!.copyWith(color: Colors.white, overflow: TextOverflow.ellipsis),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )),
        );
      },
    );
  }

  void deleteDialog({required BuildContext context, required Function deleteFunction, required String message}) {
    var bloc = context.read<VideoBloc>();
    Dialogs.materialDialog(msg: message, title: "Delete", color: Colors.white, context: context, actions: [
      IconsOutlineButton(
        onPressed: () {
          context.pop();
          bloc.add(const ResetStateEvent());
        },
        text: 'Cancel',
        iconData: Icons.cancel_outlined,
        textStyle: const TextStyle(color: Colors.grey),
        iconColor: Colors.grey,
      ),
      IconsButton(
        onPressed: deleteFunction,
        text: 'Delete',
        iconData: Icons.delete,
        color: Colors.red,
        textStyle: const TextStyle(color: Colors.white),
        iconColor: Colors.white,
      ),
    ]);
  }

  void launchCamera(BuildContext context) {
    var bloc = context.read<VideoBloc>();
    context.push(const CameraScreen()).then((value) async {
      debugPrint('starting method getting value $value');
      if (value != null) {
        debugPrint('value ${value}');
        final thumbnailFile = await VideoThumbnail.thumbnailFile(
          video: value,
          imageFormat: ImageFormat.PNG,
          maxWidth: 128, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
          quality: 25,
        );
        bloc.add(VideoAddEvent(
            Video: VideoModel(
          file: value,
          id: bloc.state.videos.length,
          thumbnail: thumbnailFile!,
          description: '',
          title: '',
        )));
      } else {
        bloc.add(const ResetStateEvent());
      }
      print('_VideoPageState.launchFileManager ${bloc.state.action} ${bloc.state.detailsState}');
      bloc.add(const ResetStateEvent());
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
