part of 'video_bloc.dart';

class VideoState extends Equatable {
  const VideoState({
    this.videos = const [],
    this.action = BlocAction.unknown,
    this.editVideoId = -1,
  });
  final List<VideoModel> videos;
  final BlocAction? action;
  final int? editVideoId;
  VideoState copyWith({
    List<VideoModel>? videos,
    BlocAction? action,
    int? editVideoId,
  }) =>
      VideoState(
        videos: videos ?? this.videos,
        action: action ?? this.action,
        editVideoId: editVideoId ?? this.editVideoId,
      );

  @override
  List<Object?> get props => [action];
}
