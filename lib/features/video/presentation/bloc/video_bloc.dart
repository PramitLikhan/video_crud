
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/helpers/blocHelper.dart';
import '../../../../core/services/hive/category/videoHiveService.dart';
import '../../domain/entities/video.dart';

part 'video_event.dart';
part 'video_state.dart';

class VideoBloc extends Bloc<VideoEvent, VideoState> {
  VideoBloc() : super(const VideoState()) {
    ///List of events and respective methods =============================================================================================================================
    on<VideoInitialLoad>((event, emit) => onInitialLoad(event, emit));
    on<ClearAllDataEvent>((event, emit) => clearAllData(event, emit));
    on<ShowVideoAddDialogEvent>((event, emit) => showVideoAddDialog(event, emit));
    on<VideoAddEvent>((event, emit) => addVideo(event, emit));
    on<EditVideoEvent>((event, emit) => editVideoEvent(event, emit));
    on<RemoveVideoEvent>((event, emit) => removeVideo(event, emit));
    on<LaunchCameraEvent>((event, emit) => launchCamera(event,emit));
    on<LaunchFileManagerEvent>((event, emit) => launchFileManager(event,emit));


    ///-------------------------------------------------------------------------------------------------------------------------------------------------------------------
  }

  ///hive related operations =============================================================================================================================================

  onInitialLoad(VideoInitialLoad event, Emitter<VideoState> emit) {
    List<VideoModel> videoList = VideoHiveService.db.getVideo();
    emit(state.copyWith(action: BlocAction.unknown, videos: videoList));
  }

  addVideo(VideoAddEvent event, Emitter<VideoState> emit) {
    VideoHiveService.db.addVideo(event.Video);
    emit(state.copyWith(videos: List.from(state.videos)..add(event.Video), action: BlocAction.addItem));
  }

  editVideoEvent(EditVideoEvent event, Emitter<VideoState> emit) {
    state.videos[state.videos.indexWhere((element) => element.id == event.Video.id)] = event.Video;
    VideoHiveService.db.editVideo(event.Video);
    var action = state.action;
    emit(state.copyWith(videos: state.videos, action: BlocAction.unknown, editVideoId: -1));
    emit(state.copyWith(action: action));
  }

  removeVideo(RemoveVideoEvent event, Emitter<VideoState> emit) async {
    await VideoHiveService.db.deleteVideo(event.Video);
    List<VideoModel> list = List.from(state.videos)..removeAt(state.videos.indexOf(event.Video));
    var action = state.action;
    emit(state.copyWith(videos: list, action: BlocAction.unknown));
    emit(state.copyWith(action: action));
  }

  clearAllData(ClearAllDataEvent event, Emitter<VideoState> emit) {
    VideoHiveService.db.removeData();
    emit(state.copyWith(videos: [], action: BlocAction.unknown));
  }

  ///-------------------------------------------------------------------------------------------------------------------------------------------------------------------

  ///UI related operations ==============================================================================================================================================

  Future<void> showVideoAddDialog(ShowVideoAddDialogEvent event, Emitter<VideoState> emit) async =>
      emit(state.copyWith(videos: state.videos, action: BlocAction.showDialog));

  launchFileManager(LaunchFileManagerEvent event, Emitter<VideoState> emit) {
    emit(state.copyWith(action: BlocAction.launchFileManager));
  }

  launchCamera(LaunchCameraEvent event, Emitter<VideoState> emit) {
    emit(state.copyWith(action: BlocAction.launchCamera));
  }
///-------------------------------------------------------------------------------------------------------------------------------------------------------------------
}
