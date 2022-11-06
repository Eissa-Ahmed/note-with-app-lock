import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:note_app_2022/controller/cubitNote/add_note_cubit.dart';
import 'package:note_app_2022/model/tasksModel.dart';
import 'package:note_app_2022/services/colorsManager.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var cubitTasks = AddNoteCubit.get(context);
    return BlocConsumer<AddNoteCubit, AddNoteState>(
      listener: (context, state) {},
      builder: (context, state) {
        return cubitTasks.tasksList.isEmpty
            ? Center(
                child: Lottie.asset(
                  "assets/images/task.json",
                  width: 250,
                ),
              )
            : ListView.separated(
                itemBuilder: (context, i) {
                  return customItemTask(cubitTasks.tasksList[i], cubitTasks);
                },
                separatorBuilder: (context, i) {
                  return const SizedBox(
                    height: 15,
                  );
                },
                itemCount: cubitTasks.tasksList.length,
              );
      },
    );
  }

  Card customItemTask(TasksModel model, AddNoteCubit cubit) {
    return Card(
      color: model.isDone == 1 ? Colors.grey[500] : Colors.white,
      elevation: model.isDone == 1 ? 0 : 10.0,
      child: ListTile(
        leading: model.isDone == 1
            ? IconButton(
                padding: EdgeInsets.zero,
                onPressed: () async {
                  await cubit.deleteTaskFromData(model.message);
                },
                icon: const Icon(
                  FontAwesomeIcons.trash,
                  color: Colors.red,
                ),
              )
            : const Padding(
                padding: EdgeInsets.only(left: 10),
                child: Icon(FontAwesomeIcons.listCheck,
                    color: ColorsManager.primaryColor),
              ),
        trailing: Checkbox(
            value: model.isDone == 1 ? true : false,
            onChanged: (val) async {
              if (val == true) {
                await cubit.updateTaskFromData(model.message, 1);
              } else {
                await cubit.updateTaskFromData(model.message, 0);
              }
            }),
        title: Text(
          model.message,
          maxLines: 2,
          textDirection: TextDirection.rtl,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            decoration: model.isDone == 0
                ? TextDecoration.none
                : TextDecoration.lineThrough,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
