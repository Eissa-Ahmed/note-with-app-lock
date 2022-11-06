import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:note_app_2022/data/localData.dart';
import 'package:note_app_2022/helpers/cachHelper.dart';
import 'package:note_app_2022/helpers/stringsManager.dart';
import 'package:note_app_2022/model/addNoteModel.dart';
import 'package:note_app_2022/model/tasksModel.dart';
import 'package:note_app_2022/presentation/notesScreen/notesScreen.dart';
import 'package:note_app_2022/presentation/tasksScreen/tasksScreen.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
part 'add_note_state.dart';

class AddNoteCubit extends Cubit<AddNoteState> {
  AddNoteCubit() : super(AddNoteInitial());

  static AddNoteCubit get(context) => BlocProvider.of<AddNoteCubit>(context);

  //Variables
  int currentWidget = 0;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<FormState> formKeyTask = GlobalKey<FormState>();
  DateTime dateNow = DateTime.now();
  DateTime dateNotesView = DateTime.now();
  int selected = 0;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  TextEditingController title = TextEditingController();
  TextEditingController note = TextEditingController();
  TextEditingController titleU = TextEditingController();
  TextEditingController noteU = TextEditingController();
  TextEditingController task = TextEditingController();
  bool isLoaded = false;
  bool isLoaded2 = false;
  bool isLoaded3 = false;
  bool isLoaded4 = false;
  bool isLoaded5 = false;
  String? imageUrl;
  File? image;
  final storageRef = FirebaseStorage.instance.ref();

  ThemeMode mode = CachHelper.sharedPreferences.get("mode") == null
      ? ThemeMode.system
      : CachHelper.sharedPreferences.get("mode") == true
          ? ThemeMode.light
          : ThemeMode.dark;

  String? id;
  AddNoteModel? model;
  int isDoneTask = 0;
  List modelList = [];

  // Lists
  List<AddNoteModel> notes = [];

  List<Widget> widgetsScreen = [
    const NotesScreen(),
    const TasksScreen(),
  ];

  List<Color> colorSelected = [
    const Color(0xFF00BFA6),
    const Color(0xFFF9A826),
    const Color(0xFFF50057),
  ];
  List<TasksModel> tasksList = [];
  //Funcations
  equalDate(DateTime date) {
    dateNotesView = date;
    emit(EqualState());
  }

  void changeCurrentWidget(int index) {
    currentWidget = index;
    emit(ChangeCurrentWidgetState());
  }

  changeSelectedColor(int index) {
    selected = index;
    emit(ChangeSelecedColorState());
  }

  Future saveNote(BuildContext context) async {
    isLoaded2 = true;
    emit(AddNoteLoadedState());
    int random = Random().nextInt(1000000000);
    if (image != null) {
      await uploadImageToFirebase("$random");
    }
    AddNoteModel model = AddNoteModel(
      date: formatDate(dateNow, [yyyy, '-', mm, '-', dd]),
      image: imageUrl ?? "",
      note: note.text,
      title: title.text,
      color: colorSelected[selected].value,
      id: random,
    );
    await firestore
        .collection(FirebaseAuth.instance.currentUser!.uid)
        .add(model.toJson())
        .then((value) {
      Navigator.of(context).pop();
      isLoaded2 = false;
      imageUrl = null;
      title.text = "";
      note.text = "";
      image = null;
      emit(AddNoteSuccessState());
    }).catchError((error) {
      print("===============");
      print(error.toString());
      emit(AddNoteErrorState());
    });
  }

  getImageFromDevice() async {
    final ImagePicker picker = ImagePicker();
    final XFile? img = await picker.pickImage(source: ImageSource.gallery);
    if (img != null) {
      image = File(img.path);
      emit(GetImageFromDeviceState());
    }
  }

  deleteIamgeFromUi() {
    image = null;
    emit(DeleteImageFromUiState());
  }

  uploadImageToFirebase(String random) async {
    try {
      await storageRef
          .child("${FirebaseAuth.instance.currentUser!.uid}/$random")
          .putFile(image!);
      imageUrl = await storageRef
          .child("${FirebaseAuth.instance.currentUser!.uid}/$random")
          .getDownloadURL();
      emit(UploadedIamgeSuccessState());
    } on FirebaseException catch (e) {
      print("=============");
      print(e.toString());
      emit(UploadedIamgeErrorState());
    }
  }

  deleteImage(String random) async {
    await storageRef
        .child("${FirebaseAuth.instance.currentUser!.uid}/$random")
        .delete();
    emit(DeleteImageFromFirebaseState());
  }

  Future deleteNote(String doc, String random, String delete) async {
    isLoaded4 = true;
    isLoaded5 = true;
    emit(DeleteNoteLoadedFromFirebaseState());
    await firestore
        .collection(FirebaseAuth.instance.currentUser!.uid)
        .doc(doc)
        .delete();
    if (delete != "") {
      await deleteImage(random);
    }

    isLoaded4 = false;
    isLoaded5 = false;
    emit(DeleteNoteSuccessFromFirebaseState());
  }

  changeMode() async {
    emit(ChangeMode2State());
    if (CachHelper.sharedPreferences.get("mode") == true) {
      await CachHelper.saveLocalData("mode", false);
      mode = ThemeMode.dark;
    } else if (CachHelper.sharedPreferences.get("mode") == false) {
      await CachHelper.saveLocalData("mode", true);
      mode = ThemeMode.light;
    } else {
      await CachHelper.saveLocalData("mode", false);
      mode = ThemeMode.dark;
    }
    emit(ChangeModeState());
  }

  updateNote(BuildContext context) async {
    isLoaded3 = true;
    emit(UpdateLoaded());
    if (image != null) {
      if (model!.image != "") {
        await deleteImage("${model!.id}");
      }
      await uploadImageToFirebase("${model!.id}");
    }
    AddNoteModel addNoteModel = AddNoteModel(
      date: formatDate(dateNow, [yyyy, '-', mm, '-', dd]),
      image: imageUrl ?? model!.image,
      note: noteU.text,
      title: titleU.text,
      color: colorSelected[selected].value,
      id: model!.id,
    );

    firestore
        .collection(FirebaseAuth.instance.currentUser!.uid)
        .doc(id)
        .update(addNoteModel.toJson())
        .then((value) {
      isLoaded3 = false;
      image = null;
      imageUrl = null;
      Navigator.of(context).pushReplacementNamed(RoutesString.homeScreen);
      emit(UpdateSuccess());
    }).catchError((error) {
      emit(UpdateError());
    });
  }

  searchList() {
    notes = [];
    for (var i = 0; i < modelList.length; i++) {
      notes.add(AddNoteModel.fronJson(modelList[i].data()));
    }
    emit(CompleteSearchListState());
  }

  sharePhoto() async {
    isLoaded5 = true;
    emit(SharePhotoLoadedState());
    final uri = Uri.parse(model!.image);
    final response = await http.get(uri);
    final bytes = response.bodyBytes;

    final temp = await getTemporaryDirectory();
    final path = "${temp.path}/image.jpg";

    File(path).writeAsBytesSync(bytes);

    await Share.shareFiles([path]).then((value) {
      isLoaded5 = false;
      emit(SharePhotoSuccessState());
    }).catchError((error) {
      emit(SharePhotoErrorState());
    });
  }

  addTaskToData(BuildContext context) async {
    emit(AddTAsksLoadedState());
    await SqlDb()
        .insertData(
            "INSERT INTO tasks(task , done) VALUES('${task.text}' , '$isDoneTask')")
        .then((value) async {
      await getTasksFromData();
      task.text = "";
      Navigator.pop(context);
      emit(AddTAsksSuccessState());
    }).catchError((error) {
      print("====================");
      print(error.toString());
      emit(AddTAsksErrorState());
    });
  }

  getTasksFromData() async {
    emit(GetTAsksLoadedState());
    tasksList = [];
    await SqlDb().readData("SELECT * FROM tasks").then((value) {
      for (var i = 0; i < value.length; i++) {
        if (value[i]["done"] == 1) {
          tasksList.insert(
            0,
            TasksModel.fromJson(value[i]),
          );
        }
      }
      for (var i = 0; i < value.length; i++) {
        if (value[i]["done"] == 0) {
          tasksList.insert(
            0,
            TasksModel.fromJson(value[i]),
          );
        }
      }
      emit(GetTAsksSuccessState());
    }).catchError((error) {
      print("====================");
      print(error.toString());
      emit(GetTAsksErrorState());
    });
  }

  updateTaskFromData(String task, int done) async {
    emit(UpdateTAsksLoadedState());
    await SqlDb()
        .updateData("UPDATE tasks SET done = $done WHERE task = '$task'")
        .then((value) async {
      await getTasksFromData();
      emit(UpdateTAsksSuccessState());
    }).catchError((error) {
      print("====================");
      print(error.toString());
      emit(UpdateTAsksErrorState());
    });
  }

  deleteTaskFromData(String task) async {
    emit(DeleteTAsksLoadedState());
    await SqlDb()
        .deleteData("DELETE FROM tasks WHERE task = '$task'")
        .then((value) async {
      await getTasksFromData();
      emit(DeleteTAsksSuccessState());
    }).catchError((error) {
      print("====================");
      print(error.toString());
      emit(DeleteTAsksErrorState());
    });
  }

  ////////
  ////////
  ///
  ///
  ///
  ///
  ///

}
