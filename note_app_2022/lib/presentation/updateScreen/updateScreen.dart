import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:note_app_2022/controller/cubitNote/add_note_cubit.dart';
import 'package:note_app_2022/helpers/stringsManager.dart';
import 'package:note_app_2022/services/colorsManager.dart';

class UpdateScreen extends StatelessWidget {
  const UpdateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var cubitUpdate = AddNoteCubit.get(context);

    return BlocConsumer<AddNoteCubit, AddNoteState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: customAppBar(context),
          body: BlocConsumer<AddNoteCubit, AddNoteState>(
            listener: (context, state) {},
            builder: (context, state) {
              return ModalProgressHUD(
                inAsyncCall: cubitUpdate.isLoaded3,
                progressIndicator: Lottie.asset(
                  "assets/images/loaded.json",
                  width: 150,
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: cubitUpdate.formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          customTextFormField(context, cubitUpdate),
                          customButtom(cubitUpdate, context),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  AppBar customAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pushReplacementNamed(RoutesString.homeScreen);
        },
        icon: const Icon(
          Icons.arrow_back_ios,
        ),
      ),
      elevation: 0,
      title: Text(
        "Add Note",
        style: Theme.of(context).textTheme.titleLarge,
      ),
      centerTitle: true,
    );
  }

  Column customButtom(AddNoteCubit cubit, BuildContext context) {
    return Column(
      children: [
        cubit.image != null
            ? Stack(
                alignment: AlignmentDirectional.topEnd,
                children: [
                  Image.file(
                    cubit.image!,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  IconButton(
                    onPressed: () {
                      cubit.deleteIamgeFromUi();
                    },
                    icon: const Icon(
                      FontAwesomeIcons.x,
                      color: Colors.red,
                    ),
                  ),
                ],
              )
            : cubit.model!.image == ""
                ? Container()
                : Image.network(
                    cubit.model!.image,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
        SizedBox(
          height: 100,
          child: Row(
            children: [
              dateTime(context, cubit),
              Expanded(
                child: ListView.separated(
                  reverse: true,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: (context, i) {
                    return customCircleColor(i, cubit);
                  },
                  separatorBuilder: (context, i) {
                    return const SizedBox(
                      width: 10,
                    );
                  },
                  itemCount: cubit.colorSelected.length,
                ),
              ),
            ],
          ),
        ),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: ColorsManager.primaryColor),
          ),
          onPressed: () async {
            await cubit.getImageFromDevice();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("Add Photo"),
              SizedBox(
                width: 10,
              ),
              Icon(FontAwesomeIcons.image)
            ],
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
            await cubit.updateNote(context);
          },
          child: const Text("Update Note"),
        ),
      ],
    );
  }

  Expanded dateTime(BuildContext context, AddNoteCubit cubit) {
    return Expanded(
      child: DateTimePicker(
        style: TextStyle(color: Theme.of(context).primaryColor),
        type: DateTimePickerType.date,
        dateMask: 'yyyy-MM-dd',
        initialValue: DateTime.now.toString(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
        icon: Icon(
          Icons.event,
          color: Theme.of(context).primaryColorLight,
        ),
        dateLabelText: 'Date',
        onChanged: (val) {
          cubit.dateNow = DateTime.parse(val);
        },
        onSaved: (val) => print(val),
      ),
    );
  }

  InkWell customCircleColor(int index, AddNoteCubit cubit) {
    return InkWell(
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      onTap: () {
        cubit.changeSelectedColor(index);
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: cubit.colorSelected[index],
          shape: BoxShape.circle,
        ),
        child: cubit.selected == index
            ? const Icon(
                Icons.done,
                color: Colors.white,
              )
            : Container(),
      ),
    );
  }

  Column customTextFormField(BuildContext context, AddNoteCubit cubit) {
    return Column(
      children: [
        TextFormField(
          // initialValue: cubit.model!.title,
          validator: (val) {
            if (val!.isEmpty) {
              return "Title Required";
            } else {
              return null;
            }
          },
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
          controller: cubit.titleU,
          decoration: InputDecoration(
            hintText: "Title",
            hintStyle: Theme.of(context).textTheme.titleMedium,
            border: InputBorder.none,
          ),
        ),
        TextFormField(
          validator: (val) {
            if (val!.isEmpty) {
              return "note Required";
            } else {
              return null;
            }
          },
          style: TextStyle(
            color: Theme.of(context).primaryColorLight,
          ),
          controller: cubit.noteU,
          maxLines: 13,
          decoration: InputDecoration(
            hintStyle: Theme.of(context).textTheme.titleSmall,
            hintText: "Note",
            border: InputBorder.none,
          ),
        ),
      ],
    );
  }
}
