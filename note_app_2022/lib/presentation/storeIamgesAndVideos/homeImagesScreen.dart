import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:note_app_2022/controller/cubitStore/store_image_cubit.dart';
import 'package:note_app_2022/model/storeImageModel.dart';
import 'package:note_app_2022/services/colorsManager.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class HomeStoreImagesScreen extends StatelessWidget {
  const HomeStoreImagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var cubitStore = StoreImageCubit.get(context);

    return BlocConsumer<StoreImageCubit, StoreImageState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              await cubitStore.getImageFromDevice();
              cubitStore.showImages();
            },
            child: const Icon(FontAwesomeIcons.image),
          ),
          body: StreamBuilder<QuerySnapshot>(
            stream: cubitStore.streamUser,
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
                    inAsyncCall: cubitStore.loaded1,
                    progressIndicator: Center(
                      child: Lottie.asset(
                        "assets/images/loaded.json",
                        width: 150,
                      ),
                    ),
                    child: SafeArea(
                      child: Column(
                        children: [
                          AnimatedContainer(
                            curve: Curves.linear,
                            duration: const Duration(milliseconds: 500),
                            height: cubitStore.hideHeight ??
                                MediaQuery.of(context).size.height * 0.6,
                            child: Stack(
                              alignment: AlignmentDirectional.topStart,
                              children: [
                                PhotoViewGallery.builder(
                                  scrollPhysics: const BouncingScrollPhysics(),
                                  builder: (BuildContext context, int i) {
                                    return PhotoViewGalleryPageOptions(
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Text("data"),
                                      imageProvider: NetworkImage(
                                          model[i].data()["image"]),
                                      initialScale:
                                          PhotoViewComputedScale.contained * 1,
                                      heroAttributes: PhotoViewHeroAttributes(
                                        tag: model[i].data()["id"],
                                      ),
                                    );
                                  },
                                  itemCount: model.length,
                                  loadingBuilder: (context, event) => Center(
                                    child: Lottie.asset(
                                      "assets/images/loaded.json",
                                      width: 150,
                                    ),
                                  ),
                                  pageController: cubitStore.pageController,
                                  backgroundDecoration: const BoxDecoration(
                                    color: Colors.transparent,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(
                                    Icons.arrow_back_ios_new,
                                    color: ColorsManager.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: GridView.builder(
                              controller: cubitStore.controller,
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
                                  onLongPress: () {
                                    cubitStore.model = StoreImageModel.fromJson(
                                        model[i].data());
                                    cubitStore.goToAnotherPhoto(i);
                                    cubitStore.showImages();
                                    customModalSheet(
                                        context, cubitStore, model[i].id);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: InstaImageViewer(
                                      disposeLevel: DisposeLevel.high,
                                      child: Image(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.3,
                                        fit: BoxFit.fitWidth,
                                        image: Image.network(
                                          model[i].data()["image"],
                                        ).image,
                                      ),
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
                    await cubit.sharePhoto();
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
                      await cubit.deletePhotoFromAll(doc);
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
                      await cubit.downloadImageToDevice();
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
