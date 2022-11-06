import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app_2022/controller/cubitNote/add_note_cubit.dart';
import 'package:note_app_2022/controller/cubitStore/store_image_cubit.dart';
import 'package:note_app_2022/helpers/appRouter.dart';
import 'package:note_app_2022/helpers/cachHelper.dart';
import 'package:note_app_2022/services/signIn.dart';
import 'package:note_app_2022/services/theme.dart';
import 'firebase_options.dart';
import 'helpers/myBlocObserver.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CachHelper.init();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  Bloc.observer = MyBlocObserver();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await signIn();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AddNoteCubit()..getTasksFromData(),
        ),
        BlocProvider(
            create: (context) => StoreImageCubit()
              ..getHelperText()
              ..notiListener()),
      ],
      child: BlocConsumer<AddNoteCubit, AddNoteState>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            onGenerateRoute: AppRouter.onGenerateRoute,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: AddNoteCubit.get(context).mode,
          );
        },
      ),
    );
  }
}
