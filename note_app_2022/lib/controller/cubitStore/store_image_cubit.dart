import 'dart:io';
import 'dart:math';

import 'package:circular_menu/circular_menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:image_picker/image_picker.dart';
import 'package:note_app_2022/helpers/cachHelper.dart';
import 'package:note_app_2022/helpers/stringsManager.dart';
import 'package:note_app_2022/model/storeImageModel.dart';
import 'package:http/http.dart' as http;
import 'package:note_app_2022/model/storeVideoModel.dart';
import 'package:note_app_2022/services/colorsManager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

part 'store_image_state.dart';

class StoreImageCubit extends Cubit<StoreImageState> {
  StoreImageCubit() : super(StoreImageInitial());

  static StoreImageCubit get(context) => BlocProvider.of(context);

  //Variables
  TextEditingController login = TextEditingController();
  GlobalKey<FormState> formKeyLogin = GlobalKey<FormState>();
  String? helperText;
  String isPass = "";
  File? image;
  File? video;
  String? imageUrl;
  String? videoUrl;
  final storageRef = FirebaseStorage.instance.ref();
  final Stream<QuerySnapshot> streamUser = FirebaseFirestore.instance
      .collection(FirebaseAuth.instance.currentUser!.uid)
      .doc("${FirebaseAuth.instance.currentUser!.uid}123")
      .collection("images")
      .snapshots();
  final Stream<QuerySnapshot> streamVideo = FirebaseFirestore.instance
      .collection(FirebaseAuth.instance.currentUser!.uid)
      .doc("${FirebaseAuth.instance.currentUser!.uid}333")
      .collection("videos")
      .snapshots();
  bool loaded1 = false;
  bool loaded2 = false;
  bool loaded3 = false;
  StoreImageModel? model;
  StoreVideoModel? modelVideo;
  PageController pageController = PageController();
  ScrollController controller = ScrollController();
  double? hideHeight;
  GlobalKey<CircularMenuState> circularMenuKey = GlobalKey<CircularMenuState>();
  VideoPlayerController? controllerVideo;
  String? photoFromVido;
  String? id;

//Lists
  List rowNumber = "1234567890".split("");
  List row1 = "QWERTYUIOP".split("");
  List row2 = "ASDFGHJKL".split("");
  List row3 = ["Z", "X", "C", "V", "B", "N", "M"];
  List row4 = ["DELETE", "SUBMIT"];
  List<String> password = [];

  //Funcations
  initVideoController() {
    loaded3 = true;
    emit(PlayVideoLoadedState());
    controllerVideo = VideoPlayerController.network(modelVideo!.video)
      ..initialize().then((_) {
        loaded3 = false;
        controllerVideo!.play();
        emit(PlayVideoSuccessState());
      });
  }

  stopVideoWhenNavigator() {
    if (controllerVideo != null) {
      controllerVideo!.pause();
      emit(PuaseVideoNavigatorState());
    }
  }

  checkUserLogin(BuildContext context) {
    emit(LogInUserLoadedSate());
    if (CachHelper.sharedPreferences.get("login") == null) {
      if (formKeyLogin.currentState!.validate()) {
        CachHelper.saveLocalData("login", login.text);
        Navigator.of(context)
            .pushReplacementNamed(RoutesString.homeImagesAndVideoScreen);
        login.text = "";
      }
    } else {
      if (formKeyLogin.currentState!.validate()) {
        if (CachHelper.sharedPreferences.get("login") == login.text) {
          Navigator.of(context)
              .pushReplacementNamed(RoutesString.homeImagesAndVideoScreen);
          login.text = "";
        } else {
          isPass = "This Password Is Wrong !";
        }
      }
    }
    emit(LogInUserSuccessSate());
  }

  getHelperText() {
    if (CachHelper.sharedPreferences.get("login") == null) {
      helperText = "Please Create Password !!";
      if (password.length > 6) {
        helperText = "✔ Done";
      }
    }
    emit(HlperTextState());
  }

  getImageFromDevice() async {
    final ImagePicker picker = ImagePicker();
    final XFile? img = await picker.pickImage(source: ImageSource.gallery);
    if (img != null) {
      image = File(img.path);
      await saveIamgeToFireBase();
      emit(ImageFromDeviceState());
    }
  }

///////////////////////////
  ///
  ///
  ///
/////////////////////////

  screenFromVideo(String url) async {
    photoFromVido = null;
    photoFromVido = await VideoThumbnail.thumbnailFile(
      video: url,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.JPEG,
      maxHeight: 150,
      quality: 100,
    );
    emit(ScreenFromVideoState());
  }

  getVideoFromDevice() async {
    emit(VideoFromDeviceState());
    final ImagePicker picker = ImagePicker();
    final XFile? videoI = await picker.pickVideo(source: ImageSource.gallery);
    if (videoI != null) {
      video = File(videoI.path);
      await saveVideoToFireBase();
      emit(VideoFromDeviceState());
    }
  }

  uploadVideoToFirebase(String random) async {
    emit(UploadedVideoStoreLoadedState());
    try {
      await storageRef
          .child(
              "${FirebaseAuth.instance.currentUser!.uid}/privateVideo/$random")
          .putFile(video!);

      videoUrl = await storageRef
          .child(
              "${FirebaseAuth.instance.currentUser!.uid}/privateVideo/$random")
          .getDownloadURL();
      await screenFromVideo(videoUrl!);
      await uploadImageVideoToFirebase(random, photoFromVido!);
      emit(UploadedVideoStoreSuccessState());
    } on FirebaseException catch (e) {
      print("=============");
      print(e.toString());
      emit(UploadedVideoStoreErrorState());
    }
  }

  saveVideoToFireBase() async {
    loaded1 = true;
    loaded2 = true;
    loaded3 = true;
    emit(SaveVideoPrivateLoadedState());
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final int random = Random().nextInt(123456789);
    await uploadVideoToFirebase("$random");

    StoreVideoModel model =
        StoreVideoModel(id: random, video: videoUrl!, image: imageUrl!);

    await firestore
        .collection(FirebaseAuth.instance.currentUser!.uid)
        .doc("${FirebaseAuth.instance.currentUser!.uid}333")
        .collection("videos")
        .add({
      "id": model.id,
      "video": model.video,
      "image": model.image,
    }).then((value) {
      loaded1 = false;
      loaded2 = false;
      loaded3 = false;
      emit(SaveVideoPrivateSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SaveVideoPrivateErrorState());
    });
  }

  uploadImageVideoToFirebase(String random, String path) async {
    try {
      await storageRef
          .child(
              "${FirebaseAuth.instance.currentUser!.uid}/imagesVideo/$random")
          .putFile(File(path));
      imageUrl = await storageRef
          .child(
              "${FirebaseAuth.instance.currentUser!.uid}/imagesVideo/$random")
          .getDownloadURL();
      // emit(UploadedIamgeSuccessState());
    } on FirebaseException catch (e) {
      print("=============");
      print(e.toString());
      // emit(UploadedIamgeErrorState());
    }
  }

  deleteImageAndVideo() async {
    await storageRef
        .child(
            "${FirebaseAuth.instance.currentUser!.uid}/imagesVideo/${modelVideo!.id}")
        .delete();
    await storageRef
        .child(
            "${FirebaseAuth.instance.currentUser!.uid}/privateVideo/${modelVideo!.id}")
        .delete();
    emit(DeleteImageAndVideoFromFirebaseState());
  }

  deleteVideoFromFireStore() async {
    loaded3 = true;
    emit(DeleteVideoFromFireStoreLoaded());
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore
        .collection(FirebaseAuth.instance.currentUser!.uid)
        .doc("${FirebaseAuth.instance.currentUser!.uid}333")
        .collection("videos")
        .doc(id)
        .delete()
        .then((value) async {
      await deleteImageAndVideo();
      loaded3 = false;
      emit(DeleteVideoFromFireStoreSuccess());
    }).catchError((error) {
      emit(DeleteVideoFromFireStoreError());
    });
  }

///////////////////////////
  ///
  ///
  ///
/////////////////////////
  uploadImageToFirebase(String random) async {
    emit(UploadedIamgeStoreLoadedState());
    try {
      await storageRef
          .child("${FirebaseAuth.instance.currentUser!.uid}/private/$random")
          .putFile(image!);

      imageUrl = await storageRef
          .child("${FirebaseAuth.instance.currentUser!.uid}/private/$random")
          .getDownloadURL();
      emit(UploadedIamgeStoreSuccessState());
    } on FirebaseException catch (e) {
      print("=============");
      print(e.toString());
      emit(UploadedIamgeStoreErrorState());
    }
  }

  saveIamgeToFireBase() async {
    loaded1 = true;
    loaded2 = true;
    emit(SaveImagePrivateLoadedState());
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final int random = Random().nextInt(123456789);
    await uploadImageToFirebase("$random");

    StoreImageModel model = StoreImageModel(id: random, image: imageUrl!);

    await firestore
        .collection(FirebaseAuth.instance.currentUser!.uid)
        .doc("${FirebaseAuth.instance.currentUser!.uid}123")
        .collection("images")
        .add({
      "id": model.id,
      "image": model.image,
    }).then((value) {
      loaded1 = false;
      loaded2 = false;
      emit(SaveImagePrivateSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SaveImagePrivateErrorState());
    });
  }

  deleteImage(String random) async {
    await storageRef
        .child("${FirebaseAuth.instance.currentUser!.uid}/private/$random")
        .delete();
    emit(DeleteImageFromFireBaseState());
  }

  sharePhoto() async {
    loaded1 = true;
    emit(SharePhotoLoadedState());
    final uri = Uri.parse(model!.image);
    final response = await http.get(uri);
    final bytes = response.bodyBytes;

    final temp = await getTemporaryDirectory();
    final path = "${temp.path}/image.jpg";

    File(path).writeAsBytesSync(bytes);

    await Share.shareFiles([path]).then((value) {
      loaded1 = false;
      emit(SharePhotoSuccessState());
    }).catchError((error) {
      emit(SharePhotoErrorState());
    });
  }

  deletePhotoFromAll(String doc) async {
    loaded1 = true;
    emit(DeleteIamgeFromAllLoadedState());
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore
        .collection(FirebaseAuth.instance.currentUser!.uid)
        .doc("${FirebaseAuth.instance.currentUser!.uid}123")
        .collection("images")
        .doc(doc)
        .delete()
        .then((value) async {
      await deleteImage("${model!.id}");
      loaded1 = false;
      emit(DeleteIamgeFromAllSuccessState());
    }).catchError((error) {
      emit(DeleteIamgeFromAllErrorState());
    });
  }

  downloadImageToDevice() async {
    try {
      // Saved with this method.
      loaded1 = true;
      emit(DownloadImageToDeviceLoadedState());
      var imageId = await ImageDownloader.downloadImage(model!.image);
      if (imageId == null) {
        return;
      }

      // Below is a method of obtaining saved image information.
      var fileName = await ImageDownloader.findName(imageId);
      var path = await ImageDownloader.findPath(imageId);
      var size = await ImageDownloader.findByteSize(imageId);
      var mimeType = await ImageDownloader.findMimeType(imageId);
      loaded1 = false;
      emit(DownloadImageToDeviceSuccessState());
    } on PlatformException catch (error) {
      print(error);
      emit(DownloadImageToDeviceErrorState());
    }
  }

  goToAnotherPhoto(int i) {
    pageController.animateToPage(
      i,
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOut,
    );
    emit(GoToAnotherPhoto());
  }

  hideImages() {
    hideHeight = 0;
    emit(HideImagesState());
  }

  showImages() {
    hideHeight = null;
    emit(ShowImagesState());
  }

  notiListener() {
    controller.addListener(() {
      if (controller.position.userScrollDirection == ScrollDirection.forward) {
        showImages();
      } else if (controller.position.userScrollDirection ==
          ScrollDirection.reverse) {
        hideImages();
      }
    });
  }

  buttonPlay() {
    Widget? play;
    if (controllerVideo!.value.isPlaying) {
      play = const Icon(
        FontAwesomeIcons.pause,
        color: ColorsManager.primaryColor,
        size: 28,
      );
    } else {
      play = const Icon(
        FontAwesomeIcons.play,
        color: ColorsManager.primaryColor,
        size: 28,
      );
    }
    emit(ButtonPlayState());
    return play;
  }

  Widget circularMenu(BuildContext context) => CircularMenu(
        key: circularMenuKey,
        alignment: Alignment.bottomRight,
        toggleButtonIconColor: Colors.white,
        // backgroundWidget: const Icon(FontAwesomeIcons.plus),
        toggleButtonColor: Colors.deepOrangeAccent,
        items: [
          CircularMenuItem(
              padding: 15,
              icon: FontAwesomeIcons.image,
              color: ColorsManager.primaryColor,
              iconSize: 20,
              onTap: () async {
                await getImageFromDevice();
                // callback
              }),
          CircularMenuItem(
              icon: FontAwesomeIcons.video,
              color: ColorsManager.primaryColor,
              iconSize: 20,
              padding: 15,
              onTap: () async {
                await getVideoFromDevice();
                //callback
              }),
          CircularMenuItem(
              icon: FontAwesomeIcons.music,
              color: ColorsManager.primaryColor,
              padding: 15,
              iconSize: 20,
              onTap: () {
                //callback
              }),
        ],
      );

  ////
  ///
  ///
  ///
  ///
  ///

  shareVideo() async {
    loaded3 = true;
    emit(SharePhotoLoadedState());
    final uri = Uri.parse(modelVideo!.video);
    final response = await http.get(uri);
    final bytes = response.bodyBytes;

    final temp = await getTemporaryDirectory();
    final path = "${temp.path}/video.mp4";

    File(path).writeAsBytesSync(bytes);

    await Share.shareFiles([path]).then((value) {
      loaded3 = false;
      emit(SharePhotoSuccessState());
    }).catchError((error) {
      emit(SharePhotoErrorState());
    });
  }
}
