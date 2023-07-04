import 'package:flutter/material.dart';
import 'package:offside/main.dart';
import '../MainPage/main_page.dart';
import './signup.dart';

// 로그인 화면
class LoginPage extends StatefulWidget {
  //StatefulWidget 로 설정
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MainPage()));
                        //if (_formKey.currentState!.validate()) {}
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
                      onPressed: () {},
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
                        '아이디 찾기',
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
                    Text('  |  '),
                    InkWell(
                      //InkWell을 사용 -- onTap이 가능한 이유임.
                      child: Text(
                        '비밀번호 찾기',
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
