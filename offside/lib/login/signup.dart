import 'package:flutter/material.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offside/MainPage/main_page.dart';
import 'package:offside/data/view/user_view_model.dart';

/// 회원가입 화면
class SignUpPage extends ConsumerStatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  TextStyle style = TextStyle(fontFamily: 'NanumSquare', fontSize: 18.0);
  late TextEditingController _name;
  late TextEditingController _id;
  late TextEditingController _password;
  late TextEditingController _password2;
  late TextEditingController _email;
  FocusNode searchFocusNode = FocusNode();
  FocusNode textFieldFocusNode = FocusNode();
  late SingleValueDropDownController _cnt;
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: "");
    _id = TextEditingController(text: "");
    _password = TextEditingController(text: "");
    _password2 = TextEditingController(text: "");
    _email = TextEditingController(text: "");
    _cnt = SingleValueDropDownController();
  }

  @override
  void dispose() {
    _name.dispose();
    _id.dispose();
    _email.dispose();
    _password.dispose();
    _password2.dispose();
    _cnt.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userViewModelProvider);
    return Scaffold(
      key: _key,
      appBar: AppBar(),
      body: Form(
        key: _formKey,
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text('회원가입',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: 30),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30),
                child: TextFormField(
                  controller: _email,
                  validator: (value) =>
                      (value!.isEmpty) ? "이메일을 입력 해 주세요" : null,
                  style: style,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    labelText: "이메일",
                    filled: true,
                    fillColor: Color(0xffF6F6F6),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30),
                child: TextFormField(
                  controller: _id,
                  validator: (value) =>
                      (value!.isEmpty) ? "닉네임 입력 해 주세요" : null,
                  style: style,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    labelText: "닉네임",
                    filled: true,
                    fillColor: Color(0xffF6F6F6),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30),
                child: TextFormField(
                  obscureText: true,
                  controller: _password,
                  validator: (value) =>
                      (value!.isEmpty) ? "패스워드를 입력 해 주세요" : null,
                  style: style,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    labelText: "Password",
                    filled: true,
                    fillColor: Color(0xffF6F6F6),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30),
                child: TextFormField(
                  obscureText: true,
                  controller: _password2,
                  validator: (value) =>
                      (value != _password.text) ? "패스워드가 다릅니다" : null,
                  style: style,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    labelText: "Password 확인",
                    filled: true,
                    fillColor: Color(0xffF6F6F6),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30),
                child: DropDownTextField(
                    validator: (value) =>
                        (_cnt.dropDownValue == null) ? "응원하는 팀을 선택해주세요" : null,
                    clearOption: false,
                    textFieldFocusNode: textFieldFocusNode,
                    searchFocusNode: searchFocusNode,
                    // searchAutofocus: true,
                    dropDownItemCount: 25,
                    searchShowCursor: false,
                    enableSearch: true,
                    searchKeyboardType: TextInputType.number,
                    textFieldDecoration: InputDecoration(
                        prefixIcon: Icon(Icons.favorite),
                        labelText: "응원하는 팀",
                        filled: true,
                        fillColor: Color(0xffF6F6F6),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        )),
                    dropDownList: const [
                      DropDownValueModel(name: '강원 FC', value: "value1"),
                      DropDownValueModel(name: '경남 FC', value: "value2"),
                      DropDownValueModel(name: '김천 상무 FC', value: "value3"),
                      DropDownValueModel(name: '김포 FC', value: "value4"),
                      DropDownValueModel(name: '광주 FC', value: "value5"),
                      DropDownValueModel(name: '대구 FC', value: "value6"),
                      DropDownValueModel(name: '대전 하나 시티즌', value: "value7"),
                      DropDownValueModel(name: '부산 아이파크', value: "value8"),
                      DropDownValueModel(name: '부천 FC 1995', value: "value9"),
                      DropDownValueModel(name: 'FC 서울', value: "value10"),
                      DropDownValueModel(name: '서울 이랜드 FC', value: "value11"),
                      DropDownValueModel(name: '성남 FC', value: "value12"),
                      DropDownValueModel(name: '수원 삼성 블루윙즈', value: "value13"),
                      DropDownValueModel(name: '수원 FC', value: "value14"),
                      DropDownValueModel(name: '안산 그리너스 FC', value: "value15"),
                      DropDownValueModel(name: 'FC 안양', value: "value16"),
                      DropDownValueModel(name: '울산 현대', value: "value17"),
                      DropDownValueModel(name: '인천 유나이티드 FC', value: "value18"),
                      DropDownValueModel(name: '전남 드래곤즈', value: "value19"),
                      DropDownValueModel(name: '전북 현대 모터스', value: "value20"),
                      DropDownValueModel(name: '재주 유나이티드 FC', value: "value21"),
                      DropDownValueModel(name: '천안 시티 FC', value: "value22"),
                      DropDownValueModel(name: '충남 아산 FC', value: "value23"),
                      DropDownValueModel(name: '충북 청주 FC', value: "value24"),
                      DropDownValueModel(name: '포항 스틸러스', value: "value25"),
                      DropDownValueModel(name: '없음', value: "value26"),
                    ],
                    controller: _cnt),
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 180.0),
                child: Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(5.0), //둥근효과
                  color: Color(0xff0E2057),
                  child: MaterialButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          await user.emailSignUp(
                              email: _email.value.text,
                              password: _password.value.text,
                              nickname: _id.value.text,
                              team: _cnt.dropDownValue!.name);
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MainPage()),
                              (route) => false);
                        } catch (e) {
                          print("$e 이메일 회원가입 실패");
                        }
                      }
                    },
                    height: 65,
                    child: Text(
                      "회원가입",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
