import 'package:flutter/material.dart';
// import 'package:skeletons/skeletons.dart';

class Skeleton {
  static Widget cardLoading({required double height, required double width}) {
    return Container(
      height: height,
      width: width,
      // decoration: BorderBoxButtonDecorations.primaryBorderRadius,
    );
    // return SkeletonItem(
    //   child: SkeletonAvatar(
    //     style: SkeletonAvatarStyle(
    //       height: height,
    //       width: width,
    //       borderRadius: BorderBoxButtonDecorations.primaryBorderRadius,
    //     ),
    //   ),
    // );
  }
}
