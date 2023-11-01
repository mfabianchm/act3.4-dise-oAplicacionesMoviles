import 'package:hive_flutter/hive_flutter.dart';

class MoviesDatabase {
  List movieList = [];

  final _myBox = Hive.box('mybox');

  void createInitialData() {
    movieList = [
      ["Star Wars", false],
      ["Harry Potter", false]
    ];
  }

  void loadData() {
    movieList = _myBox.get("MOVIELIST");
  }

  void updateDataBase() {
    _myBox.put("MOVIELIST", movieList);
  }
}
