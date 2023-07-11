
part of 'video_bloc.dart';

abstract class VideoEvent extends Equatable {
  const VideoEvent();
}

class VideoInitialLoad extends VideoEvent {
  const VideoInitialLoad();

  @override
  List<Object> get props => [];
}

class ClearAllDataEvent extends VideoEvent {
  const ClearAllDataEvent();

  @override
  List<Object> get props => [];
}

class VideoAddEvent extends VideoEvent {
  final VideoModel Video;

  const VideoAddEvent({required this.Video});

  @override
  List<Object> get props => [Video];
}

class ShowVideoAddDialogEvent extends VideoEvent {
  const ShowVideoAddDialogEvent();

  @override
  List<Object> get props => [];
}

class EditVideoShowTextField extends VideoEvent {
  final int VideoId;
  const EditVideoShowTextField({required this.VideoId});

  @override
  List<Object> get props => [];
}

class EditVideoEvent extends VideoEvent {
  final VideoModel Video;
  const EditVideoEvent({required this.Video});

  @override
  List<Object> get props => [Video];
}

class RemoveVideoEvent extends VideoEvent {
  final VideoModel Video;
  const RemoveVideoEvent({required this.Video});

  @override
  List<Object> get props => [Video.id!];
}

class LaunchCameraEvent extends VideoEvent {
  const LaunchCameraEvent();

  @override
  List<Object> get props => [];
}

class LaunchFileManagerEvent extends VideoEvent {
  const LaunchFileManagerEvent();

  @override
  List<Object> get props => [];
}
