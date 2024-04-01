// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_innovations/riverpod/forgot_password_state.dart';

class CreatePasswordPage extends ConsumerStatefulWidget {
  const CreatePasswordPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreatePasswordPageState();
}

class _CreatePasswordPageState extends ConsumerState<CreatePasswordPage> {
  bool _newPasswordVisible = true;

  TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final readProvider = ref.read(resetPasswordProvider);
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.velocity.pixelsPerSecond.dx > 0) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Create Password *',
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(right: 10, left: 10),
                      child: TextField(
                        controller: _password,
                        obscureText: _newPasswordVisible,
                        decoration: InputDecoration(
                          labelText: 'New Password *',
                          // errorText: provider.passwordError != ""
                          //     ? provider.passwordError
                          //     : null,
                          errorMaxLines: 2,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _newPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _newPasswordVisible = !_newPasswordVisible;
                              });
                            },
                          ),
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
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            readProvider.createNewPassword(
                              context: context,
                              password: _password.text,
                            );
                          },
                          child: const Text(
                            'Submit',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
