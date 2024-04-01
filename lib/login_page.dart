// ignore_for_file: always_use_package_imports, use_super_parameters, avoid_redundant_argument_values, unawaited_futures, lines_longer_than_80_chars, eol_at_end_of_file, inference_failure_on_function_invocation, unnecessary_lambdas, omit_local_variable_types
import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_innovations/designs/_designs.dart';
import 'package:qr_innovations/login_service.dart';
import 'package:qr_innovations/riverpod/forgot_password_state.dart';
import 'package:qr_innovations/riverpod/signup_state.dart';

// Project imports:

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final _userIDTextCtrl = TextEditingController();
  final _password = TextEditingController();

  // final _userIDTextCtrl = TextEditingController(text: 'user_id');
  final _passwordVisible = ValueNotifier<bool>(false);
  TextEditingController email = TextEditingController();

  @override
  void initState() {
    super.initState();
    initializeNotifications();
  }

  void initializeNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: IOSInitializationSettings(),
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id', // Change this to a unique channel ID
      'Your Channel Name',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0, // Change this to a unique ID for each notification
      title,
      body,
      platformChannelSpecifics,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 174, 242, 243),
      body: SingleChildScrollView(
        child: Column(
          children: [
            logo(),
            SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              child: Container(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 174, 242, 243),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      userIDEditor(),
                      const SizedBox(height: 10),
                      passwordEditor(),
                      const SizedBox(height: 25),
                      signInButton(),
                      const SizedBox(height: 20),
                      // line1(),
                      forgotpassword(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget logo() {
    return Center(
      child: Image.asset(
        'assets/QRcode4you.png',
        height: MediaQuery.of(context).size.height / 2,
        width: MediaQuery.of(context).size.width,
      ),
    );
  }

  Widget line() {
    return const Center(
      child: Text(
        'Innovation',
        style: TextStyle(
          fontSize: 30,
          color: Colors.blue,
          fontWeight: FontWeight.w700,
          fontFamily: 'Montserrat',
        ),
      ),
    );
  }

  Widget userIDEditor() {
    return TextFormField(
      controller: _userIDTextCtrl,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Phone Number *',
        prefixIcon: const Icon(Icons.person),
        filled: true,
        fillColor: AppColors.whiteColor,
        contentPadding: const EdgeInsets.all(8),
        focusedBorder: UnderlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.white,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            width: 3,
            color: AppColors.textfieldColor,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget passwordEditor() {
    return ValueListenableBuilder<bool>(
      valueListenable: _passwordVisible,
      builder: (context, isPasswordVisible, _) {
        return TextFormField(
          controller: _password,
          decoration: InputDecoration(
            labelText: 'Password *',
            prefixIcon: const Icon(Icons.lock),
            filled: true,
            fillColor: AppColors.whiteColor,
            contentPadding: const EdgeInsets.all(8),
            focusedBorder: UnderlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.white,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                width: 3,
                color: AppColors.textfieldColor,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      },
    );
  }

  Widget signInButton() {
    final provider = ref.watch(loginProvider);
    final readProvider = ref.read(loginProvider);
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2 + 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor, // Background color
        ),
        onPressed: () {
          log('login onPressed event :1}');
          login(
            userID: _userIDTextCtrl.text,
            userName: 'user_${_userIDTextCtrl.text}',
          ).then((value) {
            FocusScope.of(context).unfocus();
            if (!provider.loading) {
              log('login onPressed event :2}');
              readProvider.login(
                context: context,
                userID: _userIDTextCtrl.text,
                password: _password.text,
              );
              onUserLogin();
            }
          });
        },
        // onPressed: _userIDTextCtrl.text.isEmpty
        //     ? null
        //     : () async {
        //         login(
        //           userID: _userIDTextCtrl.text,
        //           userName: 'user_${_userIDTextCtrl.text}',
        //         ).then((value) {
        //           onUserLogin();
        //
        //           Navigator.push(context, RouteDesign(route: HomePage()));
        //         });
        //       },
        child: provider.loading
            ? CircularProgressIndicators.secondaryColorProgressIndication
            : const Center(
                child: Text(
                  'Submit',
                  style: TextStyle(
                    fontSize: 15,
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
      ),
    );
  }

  Widget line1() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Don't have an account?",
            style: TextStyle(
              color: Color.fromARGB(255, 1, 15, 26),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          GestureDetector(
            // onTap: () {
            //   Navigator.pushNamed(
            //     context,
            //     PageRouteNames.signup,
            //   );
            // },
            child: const Text(
              '  SignUp',
              style: TextStyle(
                color: Colors.orange,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget forgotpassword() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => _forgetPasswordAlert(),
            child: const Text(
              'Forgot Password..?',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _forgetPasswordAlert() {
    final AlertDialog alert = AlertDialog(
      shape: BorderBoxButtonDecorations.extraBorderRadius,
      backgroundColor: AppColors.whiteColor,
      title: const Text(
        'Enter Email',
        style: TextStyle(
          color: Colors.blue,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: email,
            keyboardType: TextInputType.emailAddress,
            // style: commonTextFieldFontStyle,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.textfieldfillcolor,
              contentPadding: const EdgeInsets.all(8),
              focusedBorder: UnderlineInputBorder(
                borderSide: const BorderSide(
                  color: Color.fromARGB(174, 180, 180, 180),
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Color.fromARGB(174, 180, 180, 180),
                ),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('CANCEL'),
        ),
        TextButton(
          onPressed: () {
            FocusScope.of(context).unfocus();
            ref.read(resetPasswordProvider).getEmailOtp(
                  context: context,
                  email: email.text,
                );
          },
          child: const Text(
            'SUBMIT',
          ),
        ),
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: alert,
        );
      },
    );
  }
}
