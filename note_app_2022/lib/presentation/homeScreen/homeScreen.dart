import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:note_app_2022/controller/cubitNote/add_note_cubit.dart';
import 'package:note_app_2022/services/colorsManager.dart';
import 'package:note_app_2022/services/search.dart';

import '../../helpers/stringsManager.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddNoteCubit, AddNoteState>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubitAddNotes = AddNoteCubit.get(context);

        return Scaffold(
          bottomNavigationBar: customButtomAppBar(cubitAddNotes),
          floatingActionButton:
              customFloationActionButtom(context, cubitAddNotes),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          appBar: AppBar(
            title: InkWell(
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(RoutesString.loginScreen);
              },
              child: Text(
                "Notes",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  cubitAddNotes.changeMode();
                },
                icon: const Icon(
                  FontAwesomeIcons.solidMoon,
                  size: 25,
                ),
              ),
              IconButton(
                onPressed: () async {
                  await cubitAddNotes.searchList();
                  showSearch(context: context, delegate: Search());
                },
                icon: const Icon(
                  FontAwesomeIcons.magnifyingGlass,
                  size: 22,
                ),
              ),
            ],
          ),
          body: cubitAddNotes.widgetsScreen[cubitAddNotes.currentWidget],
        );
      },
    );
  }

  FloatingActionButton customFloationActionButtom(
      BuildContext context, AddNoteCubit cubit) {
    return FloatingActionButton(
      onPressed: () {
        if (cubit.currentWidget == 0) {
          Navigator.of(context).pushNamed(RoutesString.addNoteScreen);
        } else {
          showModalBottomSheet(
            context: context,
            builder: (context) => SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: Form(
                key: cubit.formKeyTask,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: cubit.task,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                        autofocus: true,
                        maxLength: 50,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "No Can Add Empty Task , You Are Carzy ?";
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          suffixIcon: const Icon(FontAwesomeIcons.listCheck),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  color: ColorsManager.primaryColor)),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 55),
                        ),
                        onPressed: () async {
                          if (cubit.formKeyTask.currentState!.validate()) {
                            await cubit.addTaskToData(context);
                          }
                        },
                        child: const Text("Add Task"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      },
      child: const Icon(FontAwesomeIcons.plus),
    );
  }

  BottomAppBar customButtomAppBar(AddNoteCubit cubit) {
    return BottomAppBar(
      elevation: 10.0,
      shape: const CircularNotchedRectangle(),
      color: ColorsManager.primaryColor,
      child: SizedBox(
        height: 55,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
              onPressed: () {
                cubit.changeCurrentWidget(0);
              },
              child: const Text(
                "Notes",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                cubit.changeCurrentWidget(1);
              },
              child: const Text(
                "Tasks",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
