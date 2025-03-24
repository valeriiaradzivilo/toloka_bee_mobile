import 'package:flutter/material.dart';

import '../../gen/assets.gen.dart';

class AppIcon extends StatelessWidget {
  const AppIcon({super.key, this.size = 50});

  final double size;

  @override
  Widget build(final BuildContext context) => Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      clipBehavior: Clip.hardEdge,
      child: Assets.logo.logo.image(),
    );
}
