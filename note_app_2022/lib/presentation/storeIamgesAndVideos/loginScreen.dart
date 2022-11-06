import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:note_app_2022/controller/cubitStore/store_image_cubit.dart';
import 'package:note_app_2022/services/colorsManager.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var cubitStore = StoreImageCubit.get(context);
    return BlocConsumer<StoreImageCubit, StoreImageState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: Form(
              key: cubitStore.formKeyLogin,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          obscureText: false,
                          readOnly: true,
                          controller: cubitStore.login,
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 16,
                          ),
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Please Enter Passowrd !";
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            helperText: cubitStore.helperText,
                            helperStyle: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 14,
                            ),
                            prefixIcon: const Icon(
                              FontAwesomeIcons.rightToBracket,
                              color: ColorsManager.primaryColor,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: ColorsManager.primaryColor,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: ColorsManager.primaryColor,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Colors.red,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: ColorsManager.primaryColor,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          cubitStore.isPass,
                          textDirection: TextDirection.ltr,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    customKeyBoard(cubitStore, context),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Padding customKeyBoard(StoreImageCubit cubit, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: cubit.rowNumber.map((e) {
              return InkWell(
                onTap: () {
                  cubit.password.add(e);
                  cubit.login.text = cubit.password.join("");
                  cubit.getHelperText();
                },
                child: Container(
                  alignment: Alignment.center,
                  width: 30,
                  height: 35,
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.grey.shade300,
                  ),
                  child: Text(
                    e.toString(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: cubit.row1.map((e) {
              return InkWell(
                onTap: () {
                  cubit.password.add(e);
                  cubit.login.text = cubit.password.join("");
                  cubit.getHelperText();
                },
                child: Container(
                  alignment: Alignment.center,
                  width: 30,
                  height: 35,
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.grey.shade300,
                  ),
                  child: Text(
                    e.toString(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: cubit.row2.map((e) {
              return InkWell(
                onTap: () {
                  cubit.password.add(e);
                  cubit.login.text = cubit.password.join("");
                },
                child: Container(
                  alignment: Alignment.center,
                  width: 30,
                  height: 35,
                  padding: const EdgeInsets.all(6),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.grey.shade300,
                  ),
                  child: Text(
                    e.toString(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: cubit.row3.map((e) {
              return InkWell(
                onTap: () {
                  cubit.password.add(e);
                  cubit.login.text = cubit.password.join("");
                },
                child: Container(
                  alignment: Alignment.center,
                  width: 30,
                  height: 35,
                  padding: const EdgeInsets.all(6),
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.grey.shade300,
                  ),
                  child: Text(
                    e.toString(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: cubit.row4.map((e) {
              return InkWell(
                onTap: () {
                  if (e == "SUBMIT") {
                    cubit.checkUserLogin(context);
                  } else {
                    cubit.password.removeLast();
                    cubit.login.text = cubit.password.join("");
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  width: 90,
                  height: 35,
                  padding: const EdgeInsets.all(6),
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.grey.shade300,
                  ),
                  child: Text(
                    e.toString(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
