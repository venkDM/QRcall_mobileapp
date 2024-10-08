// Flutter imports:
// ignore_for_file: unnecessary_import, unused_local_variable, always_use_package_imports, lines_longer_than_80_chars, use_super_parameters, use_string_buffers, unnecessary_new, unnecessary_lambdas, use_build_context_synchronously
import 'package:faker/faker.dart' as Faker;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_svg/svg.dart';
import 'package:launch_review/launch_review.dart';
import 'package:qr_innovations/api_token_services/api_tokens.dart';
import 'package:qr_innovations/app_checker_version/app_checker_versions.dart';
import 'package:qr_innovations/designs/_designs.dart';
import 'package:qr_innovations/designs/border_box_button_decorations.dart';
import 'package:qr_innovations/designs/circular_progress_indicators.dart';
import 'package:qr_innovations/designs/colors.dart';
import 'package:qr_innovations/designs/font_styles.dart';
import 'package:qr_innovations/login_page.dart';
import 'package:qr_innovations/login_service.dart';
import 'package:qr_innovations/riverpod/profile_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
// Package imports:
import 'package:zego_uikit/zego_uikit.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

// Project imports:

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final _checker = AppVersionChecker();
  final TextEditingController singleInviteeUserIDTextCtrl =
      TextEditingController();
  final TextEditingController groupInviteeUserIDsTextCtrl =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _initialProcess();
    _checkVersion();
  }

  Future<void> _initialProcess() async {
    try {
      await ref.read(profileProvider).getProfile(context: context);
    } catch (e) {
      final sharedPreferences = await SharedPreferences.getInstance();
      await sharedPreferences.remove('token');
      await Navigator.pushAndRemoveUntil(
        context,
        RouteDesign(route: const LoginPage()),
        (route) => false,
      );
    }
  }

  Future<void> _checkVersion() async {
    await _checker.checkUpdate().then((value) {
      if (value.newVersion != null &&
          value.newVersion != value.currentVersion) {
        final alert = AlertDialog(
          shape: BorderBoxButtonDecorations.defaultCardBorderRadius,
          title: Column(
            children: <Widget>[
              Image.asset(
                'assets/images/successful_icon.png',
                height: 100,
                width: 100,
              ),
              const SizedBox(height: 10),
              const Text(
                'New version available. Please update and continue.',
                style: TextStyles.alertContentStyle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextButton(
                      child: const Text(
                        'Skip',
                        style: TextStyles.alertButtonStyle,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      child: const Text(
                        'Update',
                        style: TextStyles.alertButtonStyle,
                      ),
                      onPressed: () {
                        LaunchReview.launch(
                          androidAppId: AppIdVersion.androidId,
                          iOSAppId: AppIdVersion.iosId,
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
            ],
          ),
        );
        showDialog<dynamic>(
          context: context,
          builder: (BuildContext context) {
            return alert;
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(profileProvider);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.blue,
        title: const Text(
          'Profile',
          style: TextStyles.appbarStyle,
        ),
        centerTitle: true,
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(
                Icons.menu,
                color: Colors.white,
                size: 25,
              ),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            ),
          ),
        ],
      ),
      backgroundColor: AppColors.secondaryColor,
      body: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: ref.watch(profileProvider).loading
              ? const Center(
                  child:
                      CircularProgressIndicators.primaryColorProgressIndication,
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              'Your Phone Number: ${provider.userDetails?.userMobNo}',
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: SvgPicture.asset(
                              'assets/Profile.svg',
                              height: 100,
                              width: 100,
                            ),
                          ),
                          const Text(
                            'Name',
                            style: TextStyles.titleFontStyle,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '${provider.userDetails?.userName}',
                            style: TextStyles.noColorNoSizeFontStyle,
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Mobile Number',
                            style: TextStyles.titleFontStyle,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '${provider.userDetails?.userMobNo}',
                            style: TextStyles.noColorNoSizeFontStyle,
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Email ID',
                            style: TextStyles.titleFontStyle,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '${provider.userDetails?.userEmail}',
                            style: TextStyles.noColorNoSizeFontStyle,
                          ),
                        ],
                      ),
                    ),

                    // SizedBox(
                    //   height: MediaQuery.of(context).size.height / 3 + 60,
                    // ),
                  ],
                ),
        ),
      ),
      endDrawer: SizedBox(
        width: MediaQuery.of(context).size.width * 0.70,
        child: Drawer(
          width: MediaQuery.of(context).size.width / 2 + 10,
          child: ListView(
            // padding: const EdgeInsets.all(0),
            children: [
              // const SizedBox(
              //   height: 50,
              // ),
              //DrawerHeader
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Privacy'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.book),
                title: const Text(' Setting '),
                onTap: () {
                  Navigator.pop(context);
                },
              ),

              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('LogOut'),
                onTap: () {
                  logout().then((value) {
                    onUserLogout();
                    ref.read(profileProvider).logout(context: context);
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget logoutButton() {
    return Ink(
      width: 35,
      height: 35,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.redAccent,
      ),
      child: IconButton(
        icon: const Icon(Icons.exit_to_app_sharp),
        iconSize: 20,
        color: Colors.white,
        onPressed: () {
          // logout().then((value) {
          //   onUserLogout();

          //   Navigator.pushNamed(
          //     context,
          //     PageRouteNames.login,
          //   );
          // });
        },
      ),
    );
  }

  Widget userListView() {
    final random = Faker.RandomGenerator();
    final faker = Faker.Faker();

    return Center(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 1,
        itemBuilder: (context, index) {
          late TextEditingController inviteeUsersIDTextCtrl;
          late List<Widget> userInfo;
          if (0 == index) {
            inviteeUsersIDTextCtrl = singleInviteeUserIDTextCtrl;
            userInfo = [
              const Text('invitee name ('),
              inviteeIDFormField(
                textCtrl: inviteeUsersIDTextCtrl,
                formatters: [
                  FilteringTextInputFormatter.allow(RegExp('[0-9,]')),
                ],
                labelText: 'invitee ID',
                hintText: ' enter invitee ID',
              ),
              const Text(')'),
            ];
          }
          // else if (1 == index) {
          //   inviteeUsersIDTextCtrl = groupInviteeUserIDsTextCtrl;
          //   userInfo = [
          //     const Text('group name ('),
          //     inviteeIDFormField(
          //       textCtrl: inviteeUsersIDTextCtrl,
          //       formatters: [
          //         FilteringTextInputFormatter.allow(RegExp('[0-9,]')),
          //       ],
          //       labelText: 'invitees ID',
          //       hintText: "separate IDs by ','",
          //     ),
          //     const Text(')'),
          //   ];
          // }
          else {
            inviteeUsersIDTextCtrl = TextEditingController();
            userInfo = [
              // Text(
              //   '${faker.person.firstName()}(${random.fromPattern([
              //         '######'
              //       ])})',
              //   style: textStyle,
              // )
            ];
          }

          return Column(
            children: [
              Row(
                children: [
                  const SizedBox(width: 20),
                  ...userInfo,
                  Expanded(child: Container()),
                  sendCallButton(
                    isVideoCall: false,
                    inviteeUsersIDTextCtrl: inviteeUsersIDTextCtrl,
                    onCallFinished: onSendCallInvitationFinished,
                  ),
                  sendCallButton(
                    isVideoCall: true,
                    inviteeUsersIDTextCtrl: inviteeUsersIDTextCtrl,
                    onCallFinished: onSendCallInvitationFinished,
                  ),
                  const SizedBox(width: 20),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                // child: Divider(height: 1.0, color: Colors.grey),
              ),
            ],
          );
        },
      ),
    );
  }

  void onSendCallInvitationFinished(
    String code,
    String message,
    List<String> errorInvitees,
  ) {
    if (errorInvitees.isNotEmpty) {
      var userIDs = '';
      for (var index = 0; index < errorInvitees.length; index++) {
        if (index >= 5) {
          userIDs += '... ';
          break;
        }

        final userID = errorInvitees.elementAt(index);
        userIDs += '$userID ';
      }
      if (userIDs.isNotEmpty) {
        userIDs = userIDs.substring(0, userIDs.length - 1);
      }

      var message = "User doesn't exist or is offline: $userIDs";
      if (code.isNotEmpty) {
        message += ', code: $code, message:$message';
      }
      showToast(
        message,
        position: StyledToastPosition.top,
        context: context,
      );
    } else if (code.isNotEmpty) {
      showToast(
        'code: $code, message:$message',
        position: StyledToastPosition.top,
        context: context,
      );
    }
  }
}

Widget inviteeIDFormField({
  required TextEditingController textCtrl,
  List<TextInputFormatter>? formatters,
  String hintText = '',
  String labelText = '',
}) {
  const textStyle = TextStyle(fontSize: 12);
  return Expanded(
    flex: 100,
    child: SizedBox(
      height: 30,
      child: TextFormField(
        style: textStyle,
        controller: textCtrl,
        inputFormatters: formatters,
        decoration: InputDecoration(
          isDense: true,
          hintText: hintText,
          hintStyle: textStyle,
          labelText: labelText,
          labelStyle: textStyle,
          border: const OutlineInputBorder(),
        ),
      ),
    ),
  );
}

Widget sendCallButton({
  required bool isVideoCall,
  required TextEditingController inviteeUsersIDTextCtrl,
  void Function(String code, String message, List<String>)? onCallFinished,
}) {
  return ValueListenableBuilder<TextEditingValue>(
    valueListenable: inviteeUsersIDTextCtrl,
    builder: (context, inviteeUserID, _) {
      final invitees =
          getInvitesFromTextCtrl(inviteeUsersIDTextCtrl.text.trim());

      return ZegoSendCallInvitationButton(
        isVideoCall: isVideoCall,
        invitees: invitees,
        resourceID: 'zego_data',
        iconSize: const Size(40, 40),
        buttonSize: const Size(50, 50),
        onPressed: onCallFinished,
      );
    },
  );
}

List<ZegoUIKitUser> getInvitesFromTextCtrl(String textCtrlText) {
  final invitees = <ZegoUIKitUser>[];

  final inviteeIDs = textCtrlText.trim().replaceAll('，', '');
  inviteeIDs.split(',').forEach((inviteeUserID) {
    if (inviteeUserID.isEmpty) {
      return;
    }

    invitees.add(
      ZegoUIKitUser(
        id: inviteeUserID,
        name: 'user_$inviteeUserID',
      ),
    );
  });

  return invitees;
}

//  Text('Your Phone Number: ${currentUser.id}'),
// userListView(),

//     WillPopScope(
// onWillPop: () async {
//   return false;
// },
