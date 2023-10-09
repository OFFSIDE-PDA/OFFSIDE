import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 회원가입 화면
class ResetPasswordPage extends ConsumerStatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends ConsumerState<ResetPasswordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const ResetPassword(),
    );
  }
}

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final firebaseAuth = FirebaseAuth.instance;
  TextStyle style = const TextStyle(fontSize: 18.0);
  late TextEditingController _email;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _email = TextEditingController(text: "");
  }

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text('비밀번호 재설정',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 5),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30),
              child: TextFormField(
                  controller: _email,
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '이메일을 입력해주세요';
                    }
                    return null;
                  },
                  style: style,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.email),
                      labelText: "이메일",
                      filled: true,
                      fillColor: const Color(0xffF6F6F6),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ))),
            ),
            const SizedBox(height: 5),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30),
              child: OutlinedButton(
                onPressed: () async {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_formKey.currentState!.validate()) {
                    await firebaseAuth
                        .sendPasswordResetEmail(email: _email.text)
                        .then((value) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('비밀번호 재설정 메일을 전송합니다')),
                      );
                    });
                  }
                },
                child: const Text('비밀번호 재설정하기'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
