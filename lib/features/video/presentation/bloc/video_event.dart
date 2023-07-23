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

class ShowDeleteDialogEvent extends VideoEvent {
  const ShowDeleteDialogEvent({required this.deleteIndex});
  final int deleteIndex;

  @override
  List<Object> get props => [];
}

class ShowDeleteAllDialogEvent extends VideoEvent {
  const ShowDeleteAllDialogEvent();

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

class CaptureVideoEvent extends VideoEvent {
  const CaptureVideoEvent();

  @override
  List<Object> get props => [];
}

class ProcessCapturedVideoEvent extends VideoEvent {
  final String? capturedVideoFile;
  const ProcessCapturedVideoEvent({required this.capturedVideoFile});

  @override
  List<Object> get props => [];
}

class LaunchFileManagerEvent extends VideoEvent {
  const LaunchFileManagerEvent();

  @override
  List<Object> get props => [];
}

class StartDetailsTitleEditEvent extends VideoEvent {
  const StartDetailsTitleEditEvent();

  @override
  List<Object> get props => [];
}

class EndDetailsTitleEditEvent extends VideoEvent {
  final VideoModel video;
  const EndDetailsTitleEditEvent({required this.video});

  @override
  List<Object> get props => [];
}

class StartDetailsDescriptionEditEvent extends VideoEvent {
  const StartDetailsDescriptionEditEvent();

  @override
  List<Object> get props => [];
}

class EndDetailsDescriptionEditEvent extends VideoEvent {
  final VideoModel video;
  const EndDetailsDescriptionEditEvent({required this.video});

  @override
  List<Object> get props => [];
}

class ResetStateEvent extends VideoEvent {
  const ResetStateEvent();

  @override
  List<Object> get props => [];
}
