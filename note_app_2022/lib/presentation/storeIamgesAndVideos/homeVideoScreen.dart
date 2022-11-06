import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:note_app_2022/controller/cubitStore/store_image_cubit.dart';
import 'package:note_app_2022/model/storeVideoModel.dart';
import 'package:note_app_2022/services/colorsManager.dart';
import 'package:video_player/video_player.dart';

class HomeVideoScreen extends StatelessWidget {
  const HomeVideoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var cubitStore = StoreImageCubit.get(context);

    //  VideoPlayerController controllerVideo;

    return BlocConsumer<StoreImageCubit, StoreImageState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              await cubitStore.getVideoFromDevice();
            },
            child: const Icon(FontAwesomeIcons.video),
          ),
          body: StreamBuilder<QuerySnapshot>(
            stream: cubitStore.streamVideo,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Lottie.asset(
                    "assets/images/error.json",
                    width: 150,
                  ),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Lottie.asset(
                    "assets/images/loaded.json",
                    width: 150,
                  ),
                );
              }

              if (snapshot.hasData) {
                if (snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: SvgPicture.asset(
                      "assets/images/addImage.svg",
                      width: 200,
                    ),
                  );
                } else {
                  List model = snapshot.data!.docs;
                  return ModalProgressHUD(
                    inAsyncCall: cubitStore.loaded3,
                    progressIndicator: Center(
                      child: Lottie.asset(
                        "assets/images/loaded.json",
                        width: 150,
                      ),
                    ),
                    child: SafeArea(
                      child: Column(
                        children: [
                          cubitStore.controllerVideo == null
                              ? Container()
                              : Expanded(
                                  flex: 3,
                                  child: Stack(
                                    alignment: AlignmentDirectional.topStart,
                                    children: [
                                      cubitStore.controllerVideo!.value
                                              .isInitialized
                                          ? AspectRatio(
                                              aspectRatio: cubitStore
                                                  .controllerVideo!
                                                  .value
                                                  .aspectRatio,
                                              child: VideoPlayer(
                                                  cubitStore.controllerVideo!),
                                            )
                                          : Container(),
                                      IconButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        icon: const Icon(
                                          Icons.arrow_back_ios_new,
                                          color: ColorsManager.primaryColor,
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 10,
                                        left: 0,
                                        right: 0,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            IconButton(
                                              onPressed: () {},
                                              icon: const Icon(
                                                FontAwesomeIcons.backward,
                                                color:
                                                    ColorsManager.primaryColor,
                                                size: 28,
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                cubitStore.controllerVideo!
                                                        .value.isPlaying
                                                    ? cubitStore
                                                        .controllerVideo!
                                                        .pause()
                                                    : cubitStore
                                                        .controllerVideo!
                                                        .play();
                                              },
                                              icon: cubitStore.buttonPlay(),
                                            ),
                                            IconButton(
                                              onPressed: () {},
                                              icon: const Icon(
                                                FontAwesomeIcons.forward,
                                                color:
                                                    ColorsManager.primaryColor,
                                                size: 28,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                          Expanded(
                            flex: 2,
                            child: GridView.builder(
                              // controller: cubitStore.controller,
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 6),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                              itemBuilder: (context, i) {
                                return InkWell(
                                  onTap: () async {
                                    cubitStore.modelVideo =
                                        StoreVideoModel.fromJson(
                                            model[i].data());
                                    cubitStore.stopVideoWhenNavigator();
                                    await cubitStore.initVideoController();
                                  },
                                  onLongPress: () {
                                    cubitStore.id = model[i].id;
                                    cubitStore.modelVideo =
                                        StoreVideoModel.fromJson(
                                            model[i].data());

                                    customModalSheet(
                                        context, cubitStore, model[i].id);
                                  },
                                  child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    child: Stack(
                                      fit: StackFit.expand,
                                      alignment: AlignmentDirectional.center,
                                      children: [
                                        Image.network(
                                          model[i].data()["image"],
                                          fit: BoxFit.fill,
                                        ),
                                        const Icon(
                                          FontAwesomeIcons.circlePlay,
                                          size: 33,
                                          color: Colors.grey,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              itemCount: model.length,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              }

              return Center(
                child: Lottie.asset(
                  "assets/images/loaded.json",
                  width: 150,
                ),
              );
            },
          ),
        );
      },
    );
  }

  customModalSheet(
      BuildContext context, StoreImageCubit cubit, String doc) async {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.all(15),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12), topRight: Radius.circular(12)),
              color: Colors.white,
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () async {
                    await cubit.shareVideo();
                  },
                  icon: const Icon(
                    FontAwesomeIcons.shareNodes,
                    color: ColorsManager.primaryColor,
                  ),
                ),
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: Colors.red,
                      ),
                    ),
                    onPressed: () async {
                      await cubit.deleteVideoFromFireStore();
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "DELETE",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                    child: const Text("DOWNLOAD"),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
