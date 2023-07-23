// import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_crud/core/services/pageService/AppPages.dart';
import 'package:video_crud/features/video/presentation/pages/video_page.dart';

import 'core/app/app_observer.dart';
import 'core/helpers/constants.dart';
import 'core/services/hive/category/videoHiveService.dart';
import 'core/services/hive/hive_service.dart';
import 'features/video/presentation/bloc/video_bloc.dart';

Future<void> main() async {
  Bloc.observer = AppObserver();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  await HiveService.hiveDbService.init();
  await VideoHiveService.db.initializeVideoService();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // try {
  //   cameras = await availableCameras();
  // } on CameraException catch (e) {
  //   debugPrint("$e");
  // }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VideoBloc(),
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        onGenerateRoute: (routeSettings) => AppPages.generateRoute(routeSettings),
        home: const VideoPage(),
      ),
    );
  }
}
