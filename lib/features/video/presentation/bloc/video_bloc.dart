import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:video_crud/core/helpers/ioHelper.dart';

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
    on<ShowDeleteDialogEvent>((event, emit) => showDeleteDialog(event, emit));
    on<ShowDeleteAllDialogEvent>((event, emit) => showDeleteAllDialog(event, emit));
    on<VideoAddEvent>((event, emit) => addVideo(event, emit));
    on<RemoveVideoEvent>((event, emit) => removeVideo(event, emit));
    on<CaptureVideoEvent>((event, emit) => captureVideo(event, emit));
    on<ProcessCapturedVideoEvent>((event, emit) => processCapturedVideoEvent(event, emit));
    on<LaunchFileManagerEvent>((event, emit) => launchFileManager(event, emit));
    on<StartDetailsTitleEditEvent>((event, emit) => startDetailsTitleEditEvent(event, emit));
    on<EndDetailsTitleEditEvent>((event, emit) => endDetailsTitleEditEvent(event, emit));
    on<StartDetailsDescriptionEditEvent>((event, emit) => startDetailsDescriptionEditEvent(event, emit));
    on<EndDetailsDescriptionEditEvent>((event, emit) => endDetailsDescriptionEditEvent(event, emit));
    on<ResetStateEvent>((event, emit) => resetStateEvent(event, emit));

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
    emit(state.copyWith(action: BlocAction.unknown));
  }

  // editVideoEvent(EditVideoEvent event, Emitter<VideoState> emit) {
  //   state.videos[state.videos.indexWhere((element) => element.id == event.Video.id)] = event.Video;
  //   VideoHiveService.db.editVideo(event.Video);
  //   var action = state.action;
  //   emit(state.copyWith(videos: state.videos, action: BlocAction.unknown, editVideoId: -1));
  //   emit(state.copyWith(action: action));
  // }

  removeVideo(RemoveVideoEvent event, Emitter<VideoState> emit) async {
    await VideoHiveService.db.deleteVideo(event.Video);
    List<VideoModel> list = List.from(state.videos)..removeAt(state.videos.indexOf(event.Video));
    // var action = state.action;
    emit(state.copyWith(videos: list, action: BlocAction.removeItem));
    emit(state.copyWith(action: BlocAction.unknown));
  }

  clearAllData(ClearAllDataEvent event, Emitter<VideoState> emit) {
    VideoHiveService.db.removeData();
    emit(state.copyWith(videos: [], action: BlocAction.removeItem));
    emit(state.copyWith(action: BlocAction.unknown));
  }

  endDetailsTitleEditEvent(EndDetailsTitleEditEvent event, Emitter<VideoState> emit) {
    state.videos[state.videos.indexWhere((element) => element.id == event.video.id)] = event.video;
    VideoHiveService.db.editVideo(event.video);
    emit(state.copyWith(videos: state.videos, detailsState: VideoDetails.unknown));
  }

  endDetailsDescriptionEditEvent(EndDetailsDescriptionEditEvent event, Emitter<VideoState> emit) {
    state.videos[state.videos.indexWhere((element) => element.id == event.video.id)] = event.video;
    VideoHiveService.db.editVideo(event.video);
    emit(state.copyWith(videos: state.videos, detailsState: VideoDetails.unknown));
  }

  ///-------------------------------------------------------------------------------------------------------------------------------------------------------------------

  ///UI related operations ==============================================================================================================================================

  Future<void> showDeleteDialog(ShowDeleteDialogEvent event, Emitter<VideoState> emit) async =>
      emit(state.copyWith(videos: state.videos, action: BlocAction.showDeleteDialog, deleteIndex: event.deleteIndex));

  showDeleteAllDialog(ShowDeleteAllDialogEvent event, Emitter<VideoState> emit) => emit(state.copyWith(action: BlocAction.showDeleteAllDialog));

  launchFileManager(LaunchFileManagerEvent event, Emitter<VideoState> emit) => emit(state.copyWith(action: BlocAction.launchFileManager));

  captureVideo(CaptureVideoEvent event, Emitter<VideoState> emit) => emit(state.copyWith(action: BlocAction.launchCamera));

  startDetailsTitleEditEvent(StartDetailsTitleEditEvent event, Emitter<VideoState> emit) => emit(state.copyWith(detailsState: VideoDetails.editTitle));

  startDetailsDescriptionEditEvent(StartDetailsDescriptionEditEvent event, Emitter<VideoState> emit) => emit(state.copyWith(detailsState: VideoDetails.editDescription));

  resetStateEvent(ResetStateEvent event, Emitter<VideoState> emit) => emit(state.copyWith(action: BlocAction.unknown, detailsState: VideoDetails.unknown, deleteIndex: -1));

  processCapturedVideoEvent(ProcessCapturedVideoEvent event, Emitter<VideoState> emit) {
    IOHelper.io.createThumbnailFile(path: event.capturedVideoFile ?? '').then((value) => value != null
        ? add(VideoAddEvent(Video: VideoModel(file: event.capturedVideoFile, id: state.videos.length, thumbnail: value, description: '', title: '')))
        : add(const ResetStateEvent()));
  }

  ///-------------------------------------------------------------------------------------------------------------------------------------------------------------------
}
