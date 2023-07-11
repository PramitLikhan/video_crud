import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_crud/features/video/presentation/bloc/video_bloc.dart';

class FlowMenu extends StatefulWidget {
  const FlowMenu({super.key});

  @override
  State<FlowMenu> createState() => _FlowMenuState();
}

class _FlowMenuState extends State<FlowMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController menuAnimation;
  IconData lastTapped = Icons.notifications;
  final List<IconData> menuItems = <IconData>[

    Icons.camera_alt,
    Icons.image,
    Icons.add,
  ];

  void _updateMenu(IconData icon) {
    if (icon != Icons.menu) {
      setState(() => lastTapped = icon);
    }
  }

  @override
  void initState() {
    super.initState();
    menuAnimation = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
  }

  Widget flowMenuItem(IconData icon, VideoBloc bloc) {
    final double buttonDiameter =
        MediaQuery.of(context).size.height / menuItems.length/4;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: RawMaterialButton(
        fillColor: Colors.blue,
        splashColor: Colors.amber[100],
        shape: const CircleBorder(),
        constraints: BoxConstraints.tight(Size(buttonDiameter, buttonDiameter)),
        onPressed: () {
          _updateMenu(icon);
          if(icon == Icons.camera_alt){
            bloc.add(const LaunchCameraEvent());
          }else if(icon ==Icons.image){
            bloc.add(const LaunchFileManagerEvent());
          }
          menuAnimation.status == AnimationStatus.completed
              ? menuAnimation.reverse()
              : menuAnimation.forward();
        },
        child: Icon(
          icon,
          color: Colors.white,
          size: 45.0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var bloc = context.read<VideoBloc>();
    return Flow(
      delegate: FlowMenuDelegate(menuAnimation: menuAnimation),
      children:
      menuItems.map<Widget>((IconData icon) => flowMenuItem(icon,bloc)).toList(),
    );
  }
}

class FlowMenuDelegate extends FlowDelegate {
  FlowMenuDelegate({required this.menuAnimation})
      : super(repaint: menuAnimation);

  final Animation<double> menuAnimation;

  @override
  bool shouldRepaint(FlowMenuDelegate oldDelegate) {
    return menuAnimation != oldDelegate.menuAnimation;
  }

  @override
  void paintChildren(FlowPaintingContext context) {
    double dx = 0.0;
    for (int i = 0; i < context.childCount; ++i) {
      dx = context.getChildSize(i)!.width * i;
      context.paintChild(
        i,
        transform: Matrix4.translationValues(
          context.size.width-70,
          context.size.height-100-(dx * menuAnimation.value),
          0,
        ),
      );
    }
  }
}