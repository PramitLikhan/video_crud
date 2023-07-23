import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_crud/features/video/presentation/bloc/video_bloc.dart';

final double buttonSize = 60;

class FlowMenu extends StatefulWidget {
  const FlowMenu({super.key});

  @override
  State<FlowMenu> createState() => _FlowMenuState();
}

class _FlowMenuState extends State<FlowMenu> with SingleTickerProviderStateMixin {
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

  @override
  void dispose() {
    menuAnimation.dispose();
  }

  Widget flowMenuItem(IconData icon, VideoBloc bloc) {
    // final double buttonSize = MediaQuery.of(context).size.height / menuItems.length / 4;
    return FloatingActionButton(
      elevation: 0,
      // fillColor: Colors.blue,
      splashColor: Colors.amber[100],
      // shape: const CircleBorder(),
      // constraints: BoxConstraints.tight(Size(buttonSize, buttonSize)),
      onPressed: () {
        _updateMenu(icon);
        if (icon == Icons.camera_alt) {
          bloc.add(const CaptureVideoEvent());
        } else if (icon == Icons.image) {
          bloc.add(const LaunchFileManagerEvent());
        }
        menuAnimation.status == AnimationStatus.completed ? menuAnimation.reverse() : menuAnimation.forward();
      },
      child: Icon(
        icon,
        color: Colors.white,
        size: 45.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var bloc = context.read<VideoBloc>();
    return Flow(
      delegate: FlowMenuDelegate(menuAnimation: menuAnimation),
      children: menuItems.map<Widget>((IconData icon) => flowMenuItem(icon, bloc)).toList(),
    );
  }
}

class FlowMenuDelegate extends FlowDelegate {
  FlowMenuDelegate({required this.menuAnimation}) : super(repaint: menuAnimation);

  final Animation<double> menuAnimation;

  @override
  bool shouldRepaint(FlowMenuDelegate oldDelegate) {
    return menuAnimation != oldDelegate.menuAnimation;
  }

  @override
  void paintChildren(FlowPaintingContext context) {
    final size = context.size;
    final xStart = size.width - buttonSize;
    final yStart = size.height - buttonSize;
    final n = context.childCount;
    for (int i = 0; i < n; i++) {
      final radius = 70 * menuAnimation.value;
      final isLastItem = i == context.childCount - 1;
      setValue(value) => isLastItem ? 0.0 : value;
      final theta = (i * pi * 0.5) / (n - 2);
      double x = xStart - setValue(radius * cos(theta));
      double y = yStart - setValue(radius * sin(theta));

      context.paintChild(i,
          transform: Matrix4.identity()
            ..translate(x, y, 0)
            ..translate(buttonSize / 2, buttonSize / 2)
            ..rotateZ(isLastItem ? 0.7 * menuAnimation.value : 180 * (1 - menuAnimation.value) * pi / 180)
            ..scale(isLastItem ? 1.0 : max(menuAnimation.value, 0.5))
            ..translate(-buttonSize / 2, -buttonSize / 2));
    }
  }
}
