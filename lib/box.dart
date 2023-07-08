import 'package:hive/hive.dart';

import 'notes model.dart';

class Boxes{


static Box<NotesModel> getData()=> Hive.box<NotesModel>("notes");

}