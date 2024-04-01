import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinput/pinput.dart';
import 'package:qr_innovations/riverpod/forgot_password_state.dart';

class OtpPage extends ConsumerStatefulWidget {
  const OtpPage({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OtpPageState();
}

class _OtpPageState extends ConsumerState<OtpPage> {
  TextEditingController pinController = TextEditingController();

  void onEnd() {}

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(resetPasswordProvider);
    final readProvider = ref.read(resetPasswordProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP'),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              const Text(
                'OTP Verification',
              ),
              const SizedBox(height: 15),
              Column(
                children: [
                  const Text('Enter the OTP sent to '),
                  const SizedBox(height: 5),
                  Text(
                    provider.storedEmail,
                  ),
                ],
              ),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Pinput(
                      controller: pinController,
                      onCompleted: (pin) {
                        readProvider.enterEmailOtp(
                          context: context,
                          otp: pin,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
