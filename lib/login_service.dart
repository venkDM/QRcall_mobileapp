// Package imports:
// ignore_for_file: always_use_package_imports, unawaited_futures, lines_longer_than_80_chars, cascade_invocations
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

// Project imports:
import 'common.dart';
import 'constants.dart';

ZegoUIKitPrebuiltCallController? callController;

/// local virtual login
Future<void> login({
  required String userID,
  required String userName,
}) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString(cacheUserIDKey, userID);

  currentUser.id = userID;
  currentUser.name = 'user_$userID';
}

/// local virtual logout
Future<void> logout() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.remove(cacheUserIDKey);
}

/// on user login
void onUserLogin() {
  callController ??= ZegoUIKitPrebuiltCallController();

  /// 4/5. initialized ZegoUIKitPrebuiltCallInvitationService when account is logged in or re-logged in
  ZegoUIKitPrebuiltCallInvitationService().init(
    appID: 519713699 /*input your AppID*/,
    appSign:
        '41ace79a303f6ec12ef291122c9231dc30ba01632842c9fa4cb432e61e5cd861' /*input your AppSign*/,
    userID: currentUser.id,
    userName: currentUser.name,
    plugins: [ZegoUIKitSignalingPlugin()],
    controller: callController,
    requireConfig: (ZegoCallInvitationData data) {
      final config = (data.invitees.length > 1)
          ? ZegoCallType.videoCall == data.type
              ? ZegoUIKitPrebuiltCallConfig.groupVideoCall()
              : ZegoUIKitPrebuiltCallConfig.groupVoiceCall()
          : ZegoCallType.videoCall == data.type
              ? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
              : ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall();

      config
        ..turnOnCameraWhenJoining = false
        ..turnOnMicrophoneWhenJoining = true
        ..useSpeakerWhenJoining = true;

      config.avatarBuilder = customAvatarBuilder;

      /// support minimizing, show minimizing button
      config.topMenuBarConfig.isVisible = true;

      config.topMenuBarConfig.buttons
          .insert(0, ZegoMenuBarButtonName.minimizingButton);

      return config;
    },
  );
}

/// on user logout
void onUserLogout() {
  callController = null;

  /// 5/5. de-initialization ZegoUIKitPrebuiltCallInvitationService when account is logged out
  ZegoUIKitPrebuiltCallInvitationService().uninit();
}
