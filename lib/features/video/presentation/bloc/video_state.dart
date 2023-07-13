part of 'video_bloc.dart';

class VideoState extends Equatable {
  const VideoState({
    this.videos = const [],
    this.action = BlocAction.unknown,
    this.detailsState = VideoDetails.unknown,
    this.deleteIndex = -1,
  });
  final List<VideoModel> videos;
  final BlocAction? action;
  final VideoDetails? detailsState;
  final int? deleteIndex;
  VideoState copyWith({List<VideoModel>? videos, BlocAction? action, VideoDetails? detailsState, int? deleteIndex}) => VideoState(
        videos: videos ?? this.videos,
        action: action ?? this.action,
        deleteIndex: deleteIndex ?? this.deleteIndex,
        detailsState: detailsState ?? this.detailsState,
      );

  @override
  List<Object?> get props => [action, detailsState];
}
