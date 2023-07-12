part of 'video_bloc.dart';

class VideoState extends Equatable {
  const VideoState({
    this.videos = const [],
    this.action = BlocAction.unknown,
    this.detailsState = VideoDetails.unknown,
    this.editVideoId = -1,
  });
  final List<VideoModel> videos;
  final BlocAction? action;
  final VideoDetails? detailsState;
  final int? editVideoId;
  VideoState copyWith({List<VideoModel>? videos, BlocAction? action, int? editVideoId, VideoDetails? detailsState}) => VideoState(
        videos: videos ?? this.videos,
        action: action ?? this.action,
        editVideoId: editVideoId ?? this.editVideoId,
        detailsState: detailsState ?? this.detailsState,
      );

  @override
  List<Object?> get props => [action, detailsState];
}
