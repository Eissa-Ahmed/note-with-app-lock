import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:note_app_2022/controller/cubitNote/add_note_cubit.dart';
import 'package:note_app_2022/helpers/stringsManager.dart';
import 'package:note_app_2022/services/colorsManager.dart';
import 'package:share_plus/share_plus.dart';

class SingleNoteScreen extends StatelessWidget {
  const SingleNoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var cubitSingleNote = AddNoteCubit.get(context);
    return BlocConsumer<AddNoteCubit, AddNoteState>(
      listener: (context, state) {},
      builder: (context, state) {
        return ModalProgressHUD(
          inAsyncCall: cubitSingleNote.isLoaded5,
          progressIndicator: Lottie.asset(
            "assets/images/loaded.json",
            width: 150,
          ),
          child: Scaffold(
            backgroundColor: Color(cubitSingleNote.model!.color),
            body: SafeArea(
              child: Column(
                children: [
                  Stack(
                    alignment: AlignmentDirectional.topStart,
                    children: [
                      cubitSingleNote.model!.image == ""
                          ? Container()
                          : CachedNetworkImage(
                              imageUrl: cubitSingleNote.model!.image,
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * 0.5,
                              fit: BoxFit.fill,
                              errorWidget: (context, url, error) =>
                                  const Center(
                                      child: Icon(
                                          FontAwesomeIcons.circleExclamation)),
                              progressIndicatorBuilder:
                                  (context, url, progress) => Center(
                                child: Lottie.asset(
                                  "assets/images/loaded.json",
                                  width: 150,
                                ),
                              ),
                            ),
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                      ),
                      Positioned(
                        right: 5,
                        top: 5,
                        child: IconButton(
                          onPressed: () async {
                            await customModalSheet(
                              context,
                              cubitSingleNote,
                            );
                          },
                          icon: const Icon(
                            FontAwesomeIcons.ellipsisVertical,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      width: double.infinity,
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              cubitSingleNote.model!.title,
                              textDirection: TextDirection.rtl,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              cubitSingleNote.model!.note,
                              overflow: TextOverflow.ellipsis,
                              textDirection: TextDirection.rtl,
                              softWrap: false,
                              maxLines: 500,
                              style: const TextStyle(
                                height: 1,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Color.fromARGB(
                                  255,
                                  231,
                                  231,
                                  231,
                                ),
                              ),
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

  customModalSheet(
    BuildContext context,
    AddNoteCubit cubit,
  ) async {
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
                    AlertDialog alert = await customAlert(cubit, context);
                    showDialog(context: context, builder: (context) => alert);
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
                      await cubit
                          .deleteNote(
                        cubit.id!,
                        "${cubit.model!.id}",
                        cubit.model!.image,
                      )
                          .then((value) {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      });
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
                    onPressed: () {
                      cubit.titleU.text = cubit.model!.title;
                      cubit.noteU.text = cubit.model!.note;
                      Navigator.of(context).pushNamed(
                        RoutesString.updateScreen,
                      );
                    },
                    child: const Text("UPDATE"),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Future<AlertDialog> customAlert(
      AddNoteCubit cubit, BuildContext context) async {
    return AlertDialog(
      content: SizedBox(
        height: 110,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "What do you want to share ?",
              style: Theme.of(context).textTheme.displayLarge,
            ),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: ColorsManager.primaryColor,
                      ),
                    ),
                    onPressed: () async {
                      Navigator.pop(context);

                      await Share.share(
                          "${cubit.model!.title}\n${cubit.model!.note}");
                    },
                    child: const Text(
                      "TEXT",
                      style: TextStyle(color: ColorsManager.primaryColor),
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

                      await cubit.sharePhoto();
                    },
                    child: const Text("PHOTO"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
