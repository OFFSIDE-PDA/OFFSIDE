import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offside/login/kakao_signup.dart';
import 'package:offside/login/reset_password.dart';
import '../MainPage/main_page.dart';
import './signup.dart';
import 'package:offside/user_view_model.dart';

// 로그인 화면
class LoginPage extends ConsumerStatefulWidget {
  //StatefulWidget 로 설정
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  //LoginPage  --> _LoginPageState 로 이동
  TextStyle style = TextStyle(fontFamily: 'NanumSquare', fontSize: 18.0);
  late TextEditingController _email; //각각 변수들 지정
  late TextEditingController _password;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    //initState 초기화를 위해 필요한 저장공간.
    super.initState();
    _email = TextEditingController(text: ""); //변수를 여기서 초기화함.
    _password = TextEditingController(text: "");
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userViewModelProvider);
    //Widget 여기서 UI화면 작성
    return Scaffold(
      body: Padding(
        //body는 appbar아래 화면을 지정.
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Center(
            //가운데로 지정
            child: ListView(
              //ListView - children으로 여러개 padding설정
              shrinkWrap: true,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 30),
                  child: Text('로그인',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 30),
                  child: TextFormField(
                      //TextFormField
                      controller: _email, //_email이 TextEditingController
                      validator: (value) =>
                          (value!.isEmpty) ? "이메일을 입력해 주세요" : null, //hint 역할
                      style: style,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email_outlined),
                        labelText: "이메일", //hint
                        filled: true,
                        fillColor: Color(0xffF6F6F6),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ) //클릭시 legend 효과
                      ),
                ),
                Padding(
                  //두번째 padding <- LIstview에 속함.
                  padding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 30),
                  child: TextFormField(
                      obscureText: true,
                      controller: _password,
                      validator: (value) => (value!.isEmpty)
                          ? "패스워드를 입력해 주세요"
                          : null, //아무것도 누르지 않은 경우 이 글자 뜸.
                      style: style,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock_outline),
                          labelText: "비밀번호",
                          filled: true,
                          fillColor: Color(0xffF6F6F6),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ))),
                ),
                SizedBox(height: 40),
                Padding(
                  //세번째 padding
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 30),
                  child: Material(
                    elevation: 5.0, //그림자효과
                    borderRadius: BorderRadius.circular(5.0), //둥근효과
                    color: Color(0xff0E2057),
                    child: MaterialButton(
                      //child - 버튼을 생성
                      height: 70,
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            await user.emailSignIn(
                                email: _email.value.text,
                                password: _password.value.text);
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MainPage()));
                          } catch (e) {
                            print(e);
                            print("로그인 실패");
                          }
                        }
                      },
                      child: Text(
                        "로그인",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ),
                Padding(
                  //padding <- ListView
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 30),
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(5.0),
                    color: Color(0xffFDDC3F),
                    child: MaterialButton(
                      height: 70,
                      onPressed: () async {
                        try {
                          await user.kakaoSignIn();
                          print(user.user!.team);
                          if (user.user!.team == null) {
                            print("이거 왜 안되지");
                            // ignore: use_build_context_synchronously
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => KaKaoSignUpPage()));
                          } else {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MainPage()));
                          }
                        } catch (e) {
                          print(e);
                          print("로그인 실패");
                        }
                      },
                      child: Text(
                        "카카오톡으로 간편 로그인",
                        style:
                            TextStyle(color: Color(0xff3A2929), fontSize: 18),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  //Center <- Listview
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      //InkWell을 사용 -- onTap이 가능한 이유임.
                      child: Text(
                        '비밀번호 재설정',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => resetPasswordPage()),
                        );
                      },
                    ),
                    Text('  |  '),
                    InkWell(
                      //InkWell을 사용 -- onTap이 가능한 이유임.
                      child: Text(
                        '회원가입',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUpPage()),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
