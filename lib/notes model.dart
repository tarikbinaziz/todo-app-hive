
import 'package:hive_flutter/hive_flutter.dart';

part 'notes model.g.dart';

@HiveType(typeId: 0)
class NotesModel extends HiveObject{
  @HiveField(0)
  String? title;
  @HiveField(1)
  String? desc;

  NotesModel({this.title, this.desc});
}