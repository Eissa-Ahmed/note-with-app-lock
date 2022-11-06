import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:note_app_2022/controller/cubitStore/store_image_cubit.dart';
import 'package:note_app_2022/helpers/stringsManager.dart';

class HomeItemImagesAndVideo extends StatelessWidget {
  const HomeItemImagesAndVideo({super.key});

  @override
  Widget build(BuildContext context) {
    var cubitStore = StoreImageCubit.get(context);
    return BlocConsumer<StoreImageCubit, StoreImageState>(
      listener: (context, state) {},
      builder: (context, state) {
        return ModalProgressHUD(
          inAsyncCall: cubitStore.loaded2,
          progressIndicator: Center(
            child: Lottie.asset(
              "assets/images/loaded.json",
              width: 150,
            ),
          ),
          child: Scaffold(
            floatingActionButton: cubitStore.circularMenu(context),
            // appBar: AppBar(),
            body: SafeArea(
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed(RoutesString.homeStoreImagesScreen);
                    },
                    child: Card(
                      margin:
                          const EdgeInsets.only(left: 10, right: 10, top: 15),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: const [
                            Text(
                              "Photo",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                            Icon(
                              FontAwesomeIcons.image,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed(RoutesString.homeStoreVideosScreen);
                    },
                    child: Card(
                      margin:
                          const EdgeInsets.only(left: 10, right: 10, top: 15),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: const [
                            Text(
                              "Video",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                            Icon(
                              FontAwesomeIcons.video,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      // Navigator.of(context).pushNamed(RoutesString.homeStoreVideosScreen);
                    },
                    child: Card(
                      margin:
                          const EdgeInsets.only(left: 10, right: 10, top: 15),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: const [
                            Text(
                              "Audio",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                            Icon(
                              FontAwesomeIcons.music,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
