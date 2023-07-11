import 'package:hive/hive.dart';
import '../../../../features/video/domain/entities/video.dart';
import '../hive_service.dart';

class VideoHiveService {
  static VideoHiveService? _VideoDB;
  VideoHiveService._();
  static VideoHiveService get db => _VideoDB ?? VideoHiveService._();

  static const hiveBoxName = "VideoBox";
  final videoKey = "Video";

  initializeVideoService() async {
    Hive.registerAdapter(VideoModelAdapter());
    await HiveService.hiveDbService.createBox(hiveBoxName);
  }

  List<VideoModel> getVideo() {
    var temp = HiveService.hiveDbService.readAll(hiveBoxName);
    print('VideoHiveService.getVideo ${temp.length}');
    List<VideoModel> VideoList = [];
    VideoList = temp.map((e) {
      VideoModel cat =
          VideoModel(id: e.id, title: e.title, description: e.description, file: e.file, thumbnail: e.thumbnail);
      return cat;
    }).toList();
    return VideoList;
  }

  addVideo(VideoModel video) => HiveService.hiveDbService.addWithKey(video.id, video, hiveBoxName);

  editVideo(VideoModel video) async => await HiveService.hiveDbService.updateByKey(video.id!, video, hiveBoxName);

  deleteVideo(VideoModel video) async => await HiveService.hiveDbService.deleteByKey(video.id, hiveBoxName);

  removeData() => HiveService.hiveDbService.clear(hiveBoxName);

  // bool get isEmpty => sl<HiveService>().getByKey(VideoKey, hiveBoxName) != null ? false : true;

  getBox() => HiveService.hiveDbService.getBox(hiveBoxName);
}
