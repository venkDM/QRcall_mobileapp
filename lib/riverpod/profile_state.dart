// ignore_for_file: avoid_positional_boolean_parameters, use_build_context_synchronously, lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_innovations/api_token_services/api_tokens.dart';
import 'package:qr_innovations/api_token_services/http_services.dart';
import 'package:qr_innovations/designs/alerts_design.dart';
import 'package:qr_innovations/designs/colors.dart';
import 'package:qr_innovations/designs/font_styles.dart';
import 'package:qr_innovations/designs/navigation_style.dart';
import 'package:qr_innovations/login_page.dart';
import 'package:qr_innovations/model/profile_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

final profileProvider = ChangeNotifierProvider<ProfileProvider>((ref) {
  return ProfileProvider();
});

class ProfileProvider extends ChangeNotifier {
  bool loading = false;
  UserDetails? userDetails;

  void setLoading(bool response) {
    loading = response;
    notifyListeners();
  }

  Future<void> getProfile({required BuildContext context}) async {
    await Token.getAuthToken();
    setLoading(true);
    final url = '${Api.apiUrl}/user_mobile_details';
    final response = await HttpService.getApi(url: url);
    if (response.$1 == 200) {
      final details = ProfileModel.fromJson(response.$2);
      userDetails = details.userDetails;
    } else {
      Alerts.errorAlert(context, '${response.$2['message']}');
    }
    setLoading(false);
    notifyListeners();
  }

  Future<void> logout({required BuildContext context}) async {
    setLoading(true);
    final url = '${Api.apiUrl}/user_mobile_logout';
    final sharedPreferences = await SharedPreferences.getInstance();
    final body = {'userId': ''};
    final response = await HttpService.postApi(url: url, body: body);
    if (response.$1 == 200) {
      await sharedPreferences.remove('token');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(
            child: Text(
              '${response.$2['message']}',
              style: TextStyles.TextfieldFontStyle,
            ),
          ),
          backgroundColor: AppColors.LinearGradient1,
          margin: const EdgeInsets.only(left: 70, right: 70, bottom: 10),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: AppColors.LinearGradient1),
            borderRadius: BorderRadius.circular(25),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
      await Navigator.pushAndRemoveUntil(
        context,
        RouteDesign(route: const LoginPage()),
        (route) => false,
      );
    } else {
      Alerts.errorAlert(context, '${response.$2['message']}');
    }
    setLoading(false);
    notifyListeners();
  }
}
