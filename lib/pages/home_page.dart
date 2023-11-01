import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:utilizacion_de_widgets/data/database.dart';
import 'package:utilizacion_de_widgets/utils/dialog_box.dart';
import 'package:utilizacion_de_widgets/utils/movie_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _myBox = Hive.box('mybox');

  MoviesDatabase db = MoviesDatabase();

  @override
  void initState() {
    if (_myBox.get("MOVIELIST") == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }
  }

  final _controller = TextEditingController();

  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.movieList[index][1] = !db.movieList[index][1];
    });
    db.updateDataBase();
  }

  void saveNewMovie() {
    setState(() {
      db.movieList.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
  }

  void createNewTask() {
    showDialog(
        context: context,
        builder: (context) {
          return DialogBox(
            controller: _controller,
            onSave: saveNewMovie,
            onCancel: () => Navigator.of(context).pop(),
          );
        });
  }

  void deleteMovie(int index) {
    setState(() {
      db.movieList.removeAt(index);
    });
    db.updateDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 152, 207, 252),
      appBar: AppBar(title: Text('CREADOR DE PELÍCULAS')),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: db.movieList.length,
        itemBuilder: (context, index) {
          return MovieTile(
            movieName: db.movieList[index][0],
            taskCompleted: db.movieList[index][1],
            onChanged: (value) => checkBoxChanged(value, index),
            deleteFunction: (context) => deleteMovie(index),
          );
        },
      ),
    );
  }
}
