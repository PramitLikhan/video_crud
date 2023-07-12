import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_crud/features/video/presentation/bloc/video_bloc.dart';
import 'package:video_crud/features/video/presentation/pages/video_page.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    print('AppPages.generateRoute for ${routeSettings.name}');
    switch (routeSettings.name) {
      case _Paths.VIDEO_PAGE:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => VideoBloc(),
            child: VideoPage(),
          ),
          settings: routeSettings,
        );

      default:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => VideoBloc(),
            child: VideoPage(),
          ),
          settings: routeSettings,
        );
    }
  }
}
