import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:note_app_2022/controller/cubitNote/add_note_cubit.dart';
import 'package:note_app_2022/helpers/cachHelper.dart';
import 'package:note_app_2022/helpers/stringsManager.dart';
import 'package:note_app_2022/model/addNoteModel.dart';
import 'package:note_app_2022/services/colorsManager.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var cubitNote = AddNoteCubit.get(context);

    return BlocConsumer<AddNoteCubit, AddNoteState>(
      listener: (context, state) {
        if (state is LoadNoteToDayLoadedState) {
          cubitNote.isLoaded = true;
        }
        if (state is! LoadNoteToDayLoadedState) {
          cubitNote.isLoaded = false;
        }
      },
      builder: (context, state) {
        final Stream<QuerySnapshot> usersStream = FirebaseFirestore.instance
            .collection(FirebaseAuth.instance.currentUser!.uid)
            .orderBy("date")
            // .where("date",
            //     isGreaterThanOrEqualTo: formatDate(
            //         cubitNote.dateNotesView, [yyyy, '-', mm, '-', dd]))
            .snapshots();
        return ModalProgressHUD(
          inAsyncCall: cubitNote.isLoaded4,
          progressIndicator: Lottie.asset(
            "assets/images/loaded.json",
            width: 150,
          ),
          child: Column(
            children: [
              customDateLine(cubitNote, context),
              FirebaseAuth.instance.currentUser == null
                  ? Center(
                      child: Lottie.asset(
                        "assets/images/loaded.json",
                        width: 150,
                      ),
                    )
                  : StreamBuilder<QuerySnapshot>(
                      stream: usersStream,
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Expanded(
                            child: Center(
                              child: Lottie.asset(
                                "assets/images/error.json",
                                width: 150,
                              ),
                            ),
                          );
                        }

                        if (snapshot.hasData) {
                          // cubitNote.searchList(snapshot.data!.docs);

                          cubitNote.modelList = snapshot.data!.docs;

                          if (cubitNote.modelList.isEmpty) {
                            return customNoNotes(cubitNote, context);
                          } else {
                            return customItem(cubitNote.modelList, cubitNote);
                          }
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Expanded(
                            child: Center(
                              child: Lottie.asset(
                                "assets/images/loaded.json",
                                width: 150,
                              ),
                            ),
                          );
                        }
                        return Container();
                      },
                    ),
            ],
          ),
        );
      },
    );
  }

  Expanded customNoNotes(AddNoteCubit cubitNote, BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "assets/images/addNote.svg",
            width: 150,
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            "No Notes In Day ${cubitNote.dateNotesView.day}",
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Expanded customItem(List<dynamic> model, AddNoteCubit cubit) {
    return Expanded(
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1 / 1.75,
        ),
        itemBuilder: (context, i) {
          return InkWell(
            onTap: () {
              cubit.id = model[i].id;
              cubit.model = AddNoteModel.fronJson(model[i].data());
              Navigator.of(context).pushNamed(RoutesString.singleNoteScreen);
            },
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Stack(
                alignment: AlignmentDirectional.topStart,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.45,
                    decoration: BoxDecoration(
                      color: Color(model[i].data()["color"]),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        model[i].data()["image"] == ""
                            ? Container()
                            : ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: model[i].data()["image"],
                                  width: double.infinity,
                                  height: 150,
                                  fit: BoxFit.cover,
                                  errorWidget: (context, url, error) =>
                                      const Center(
                                          child: Icon(FontAwesomeIcons
                                              .circleExclamation)),
                                  progressIndicatorBuilder:
                                      (context, url, progress) => Center(
                                    child: Lottie.asset(
                                      "assets/images/loaded.json",
                                      width: 150,
                                    ),
                                  ),
                                ),
                              ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  model[i].data()["title"],
                                  textDirection: TextDirection.rtl,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  model[i].data()["note"],
                                  overflow: TextOverflow.ellipsis,
                                  textDirection: TextDirection.rtl,
                                  softWrap: false,
                                  maxLines: 5,
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
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      await customModalSheet(context, cubit, model, i);
                    },
                    icon: const Icon(
                      FontAwesomeIcons.ellipsisVertical,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        itemCount: model.length,
      ),
    );
  }

  customModalSheet(BuildContext context, AddNoteCubit cubit,
      List<dynamic> model, int i) async {
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
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: Colors.red,
                      ),
                    ),
                    onPressed: () async {
                      await cubit
                          .deleteNote(model[i].id, "${model[i].data()["id"]}",
                              model[i].data()["image"])
                          .then((value) {
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
                      cubit.id = model[i].id;
                      cubit.titleU.text = model[i].data()["title"];
                      cubit.noteU.text = model[i].data()["note"];
                      cubit.model = AddNoteModel.fronJson(model[i].data());
                      // print(cubit.model!.title);
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

  Padding customDateLine(AddNoteCubit cubit, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: DatePicker(
        DateTime.parse(CachHelper.sharedPreferences.get("myDate").toString()),
        initialSelectedDate: DateTime.now(),
        selectionColor: ColorsManager.primaryColor,
        selectedTextColor: Colors.white,
        dayTextStyle: Theme.of(context).textTheme.displayMedium!,
        monthTextStyle: Theme.of(context).textTheme.displayMedium!,
        dateTextStyle: Theme.of(context).textTheme.displayLarge!,
        onDateChange: (date) {
          cubit.equalDate(date);
          // cubit.loadNotesToday(formatDate(date, [yyyy, '-', mm, '-', dd]));
        },
      ),
    );
  }
}
