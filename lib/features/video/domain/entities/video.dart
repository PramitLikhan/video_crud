import 'package:hive/hive.dart';

part 'video.g.dart';

/// id : 1
/// title : "november rain"
/// description : "this time of the year the rain is amaizing"
/// file : ""
/// thumbnail : ""
@HiveType(typeId: 1)
class VideoModel {
  @HiveField(0)
  int? _id;
  @HiveField(1)
  String? _title;
  @HiveField(2)
  String? _description;
  @HiveField(3)
  String? _file;
  @HiveField(4)
  String? _thumbnail;
  VideoModel({
    int? id,
    String? title,
    String? description,
    String? file,
    String? thumbnail,
  }) {
    _id = id;
    _title = title;
    _description = description;
    _file = file;
    _thumbnail = thumbnail;
  }

  VideoModel.fromJson(dynamic json) {
    _id = json['id'];
    _title = json['title'];
    _description = json['description'];
    _file = json['file'];
    _thumbnail = json['thumbnail'];
  }

  VideoModel copyWith({
    int? id,
    String? title,
    String? description,
    String? file,
    String? thumbnail,
  }) =>
      VideoModel(
        id: id ?? _id,
        title: title ?? _title,
        description: description ?? _description,
        file: file ?? _file,
        thumbnail: thumbnail ?? _thumbnail,
      );
  int? get id => _id;
  String? get title => _title;
  String? get description => _description;
  String? get file => _file;
  String? get thumbnail => _thumbnail;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['title'] = _title;
    map['description'] = _description;
    map['file'] = _file;
    map['thumbnail'] = _thumbnail;
    return map;
  }
}
