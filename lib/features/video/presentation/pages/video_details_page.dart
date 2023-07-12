import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_crud/core/extensions/build_context_extension.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/helpers/blocHelper.dart';
import '../bloc/video_bloc.dart';

class VideoDetailsPage extends StatefulWidget {
  const VideoDetailsPage({Key? key, required this.index}) : super(key: key);
  final int index;

  @override
  State<VideoDetailsPage> createState() => _VideoDetailsPageState();
}

class _VideoDetailsPageState extends State<VideoDetailsPage> {
  late VideoPlayerController _controller;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    var bloc = context.read<VideoBloc>();
    super.initState();
    _controller = VideoPlayerController.file(File(bloc.state.videos[widget.index].file!))
      ..setLooping(true)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    var bloc = context.read<VideoBloc>();
    return Scaffold(
      appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black45),
          title: Text(
            'Details',
            style: context.textTheme.headlineMedium,
          ),
          elevation: 0,
          backgroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            _controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: Stack(
                      children: [
                        InkWell(
                          child: VideoPlayer(_controller),
                          onTap: () async {
                            if (_controller.value.isPlaying) {
                              await _controller.pause();
                            } else {
                              await _controller.play();
                            }
                            setState(() {});
                          },
                        ),
                        Center(
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _controller.value.isPlaying ? Colors.transparent : Colors.white54,
                            ),
                            child: Icon(
                              _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                              color: _controller.value.isPlaying ? Colors.transparent : Colors.black,
                              size: 45,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(),
            BlocBuilder<VideoBloc, VideoState>(
              builder: (context, state) {
                return Row(
                  children: [
                    Expanded(
                      child: state.detailsState == VideoDetails.editTitle
                          ? TextField(
                              controller: titleController,
                            )
                          : Text(
                              bloc.state.videos[widget.index].title.toString() != '' && bloc.state.videos[widget.index].title != null
                                  ? bloc.state.videos[widget.index].title!
                                  : 'Title is empty',
                              style: context.textTheme.headlineMedium,
                            ),
                    ),
                    InkWell(
                        onTap: () {
                          if (state.detailsState == VideoDetails.unknown) {
                            bloc.add(const StartDetailsTitleEditEvent());
                          } else if (state.detailsState == VideoDetails.editTitle) {
                            var editedVideo = bloc.state.videos[widget.index].copyWith(title: titleController.text);
                            bloc.add(EndDetailsTitleEditEvent(video: editedVideo));
                            titleController.clear();
                          }
                        },
                        child: state.detailsState == VideoDetails.editTitle ? const Icon(Icons.clear) : const Icon(Icons.edit)),
                  ],
                );
              },
            ),
            const SizedBox(
              height: 15,
            ),
            BlocBuilder<VideoBloc, VideoState>(
              builder: (context, state) {
                return Row(
                  children: [
                    Expanded(
                      child: state.detailsState == VideoDetails.editDescription
                          ? TextField(
                              controller: descriptionController,
                            )
                          : Text(bloc.state.videos[widget.index].description.toString() != '' && bloc.state.videos[widget.index].description != null
                              ? bloc.state.videos[widget.index].description!
                              : 'Description is empty'),
                    ),
                    InkWell(
                        onTap: () {
                          if (state.detailsState == VideoDetails.unknown) {
                            bloc.add(const StartDetailsDescriptionEditEvent());
                          } else if (state.detailsState == VideoDetails.editDescription) {
                            var editedVideo = bloc.state.videos[widget.index].copyWith(description: descriptionController.text);
                            bloc.add(EndDetailsDescriptionEditEvent(video: editedVideo));
                            descriptionController.clear();
                          }
                        },
                        child: state.detailsState == VideoDetails.editDescription ? const Icon(Icons.clear) : const Icon(Icons.edit)),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
