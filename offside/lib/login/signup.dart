import 'package:flutter/material.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offside/MainPage/main_page.dart';
import 'package:offside/data/view/team_info_view_model.dart';
import 'package:offside/data/view/user_view_model.dart';

/// 회원가입 화면
class SignUpPage extends ConsumerStatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  TextStyle style = const TextStyle(fontSize: 18.0);
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
    final teamInfo = ref.read(teamInfoViewModelProvider).teamInfoList;
    List<DropDownValueModel> dropDownValueList = [];
    for (var i = 1; i < teamInfo.length; i++) {
      dropDownValueList
          .add(DropDownValueModel(name: teamInfo[i].fullName, value: i));
    }
    return Scaffold(
      key: _key,
      appBar: AppBar(),
      body: Form(
        key: _formKey,
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text('회원가입',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 30),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30),
                child: TextFormField(
                  controller: _email,
                  validator: (value) =>
                      (value!.isEmpty) ? "이메일을 입력 해 주세요" : null,
                  style: style,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.email),
                    labelText: "이메일",
                    filled: true,
                    fillColor: const Color(0xffF6F6F6),
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
                    prefixIcon: const Icon(Icons.person),
                    labelText: "닉네임",
                    filled: true,
                    fillColor: const Color(0xffF6F6F6),
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
                    prefixIcon: const Icon(Icons.lock),
                    labelText: "Password",
                    filled: true,
                    fillColor: const Color(0xffF6F6F6),
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
                    prefixIcon: const Icon(Icons.lock),
                    labelText: "Password 확인",
                    filled: true,
                    fillColor: const Color(0xffF6F6F6),
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
                    dropDownItemCount: 6,
                    searchShowCursor: false,
                    enableSearch: true,
                    searchKeyboardType: TextInputType.text,
                    textFieldDecoration: InputDecoration(
                        prefixIcon: const Icon(Icons.favorite),
                        labelText: "응원하는 팀",
                        filled: true,
                        fillColor: const Color(0xffF6F6F6),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        )),
                    dropDownList: dropDownValueList,
                    controller: _cnt),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(5.0), //둥근효과
                  color: const Color(0xff0E2057),
                  child: MaterialButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          await user.emailSignUp(
                              email: _email.value.text,
                              password: _password.value.text,
                              nickname: _id.value.text,
                              team: _cnt.dropDownValue!.value);
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MainPage()),
                              (route) => false);
                        } catch (e) {
                          print("$e 이메일 회원가입 실패");
                        }
                      }
                    },
                    height: 65,
                    child: const Text(
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
