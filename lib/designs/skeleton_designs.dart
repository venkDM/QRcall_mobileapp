
import 'package:flutter/material.dart';
import 'package:qr_innovations/designs/border_box_button_decorations.dart';
import 'package:skeletons/skeletons.dart';

class Skeleton {
  static Widget cardLoading({required double height, required double width}) {
    return SkeletonItem(
      child: SkeletonAvatar(
        style: SkeletonAvatarStyle(
          height: height,
          width: width,
          borderRadius: BorderBoxButtonDecorations.primaryBorderRadius,
        ),
      ),
    );
  }
}
