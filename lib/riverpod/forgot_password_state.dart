// ignore_for_file: avoid_positional_boolean_parameters, use_build_context_synchronously, lines_longer_than_80_chars

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_innovations/api_token_services/api_tokens.dart';
import 'package:qr_innovations/api_token_services/http_services.dart';
import 'package:qr_innovations/create_password_screen.dart';
import 'package:qr_innovations/designs/alerts_design.dart';
import 'package:qr_innovations/designs/navigation_style.dart';
import 'package:qr_innovations/login_page.dart';
import 'package:qr_innovations/otp_screen.dart';

final resetPasswordProvider =
    ChangeNotifierProvider<ResetPasswordProvider>((ref) {
  return ResetPasswordProvider();
});

class ResetPasswordProvider extends ChangeNotifier {
  bool loading = false;
  String storedEmail = '';
  String token = '';

  void setLoading(bool response) {
    loading = response;
    notifyListeners();
  }

  Future<void> getEmailOtp({
    required BuildContext context,
    required String email,
  }) async {
    storedEmail = email;
    setLoading(true);
    final url = '${Api.apiUrl}/mobileUser_forgot_password';
    final body = utf8.encode(
      json.encode({'user_email': email}),
    );
    final response = await HttpService.initialUTFPostApi(url: url, body: body);
    if (response.$1 == 200) {
      Alerts.successAlert(context, '${response.$2['message']}');
      await Navigator.push(context, RouteDesign(route: const OtpPage()));
    } else {
      Alerts.errorAlert(context, '${response.$2['message']}');
    }
    setLoading(false);
  }

  Future<void> enterEmailOtp({
    required BuildContext context,
    required String otp,
  }) async {
    setLoading(true);
    final url = '${Api.apiUrl}/mobileUser_verify_opt';
    final body = utf8.encode(
      json.encode({
        'user_email': storedEmail,
        'otp': otp,
      }),
    );
    final response = await HttpService.initialUTFPostApi(url: url, body: body);
    if (response.$1 == 200) {
      Alerts.successAlert(context, '${response.$2['message']}');
      await Navigator.push(
        context,
        RouteDesign(route: const CreatePasswordPage()),
      );
    } else {
      Alerts.errorAlert(context, '${response.$2["message"]}');
    }
    setLoading(false);
  }

  Future<void> createNewPassword({
    required BuildContext context,
    required String password,
  }) async {
    setLoading(true);
    final url = '${Api.apiUrl}/mobileUser_reset_password';

    final body = utf8.encode(
      json.encode({
        'user_email': storedEmail,
        'newPassword': password,
      }),
    );
    final response = await HttpService.initialUTFPostApi(url: url, body: body);

    log('response:$response');
    if (response.$1 == 200) {
      await Navigator.pushAndRemoveUntil(
        context,
        RouteDesign(route: const LoginPage()),
        (route) => false,
      );
    } else {
      Alerts.errorAlert(context, '${response.$2["message"]}');
    }
    setLoading(false);
  }
}
