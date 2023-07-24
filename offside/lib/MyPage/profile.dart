import 'package:flutter/material.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:offside/main.dart';
import 'package:offside/user_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Edit extends ConsumerStatefulWidget {
  @override
  _EditState createState() => _EditState();
}

class _EditState extends ConsumerState<Edit> {
  TextStyle style = TextStyle(fontFamily: 'NanumSquare', fontSize: 18.0);
  late TextEditingController _name;
  late TextEditingController _password;
  late TextEditingController _new_password;
  late TextEditingController _confirm_new_password;
  late TextEditingController _email;
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();

  FocusNode searchFocusNode = FocusNode();
  FocusNode textFieldFocusNode = FocusNode();

  late SingleValueDropDownController _cnt;

  @override
  void initState() {
    super.initState();
    final read_user = ref.read(userViewModelProvider);
    _name = TextEditingController(text: read_user.user!.nickname);

    _password = TextEditingController(text: "");
    _new_password = TextEditingController(text: "");
    _confirm_new_password = TextEditingController(text: "");
    _email = TextEditingController(
        text: read_user.user?.nickname != null ? read_user.user?.email : "");
    _cnt = SingleValueDropDownController(
        data: DropDownValueModel(
            name: read_user.user!.team!, value: "initvalue"));
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _new_password.dispose();
    _confirm_new_password.dispose();
    _cnt.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var size = MediaQuery.of(context).size;
    void onPressed() {}
    final user = ref.watch(userViewModelProvider);
    return Scaffold(
        key: _key,
        appBar: AppBar(),
        body: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text('회원정보 수정',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: 10),
              user.user!.email != null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 30),
                      child: TextFormField(
                        controller: _email,
                        validator: (value) =>
                            (value!.isEmpty) ? "이메일을 입력 해 주세요" : null,
                        style: style,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email),
                          labelText: "이메일 변경",
                          filled: true,
                          fillColor: Color(0xffF6F6F6),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    )
                  : SizedBox(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30),
                child: TextFormField(
                  controller: _name,
                  validator: (value) =>
                      (value!.isEmpty) ? "닉네임 입력 해 주세요" : null,
                  style: style,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    labelText: "닉네임 변경",
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
                  controller: _cnt,
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
                      labelText: "응원 팀 변경",
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
                  ],
                  onChanged: (val) {},
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: Text(
                  "비밀번호 변경을 원하시면 새로운 비밀번호를 입력하세요.",
                  style: TextStyle(
                      color: Color.fromRGBO(18, 32, 84, 1),
                      fontSize: 13,
                      fontWeight: FontWeight.bold),
                ),
              ),
              // Padding(
              //   padding:
              //       const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30),
              //   child: TextFormField(
              //     obscureText: true,
              //     controller: _new_password,
              //     validator: (value) => (value!.isEmpty || value == _password)
              //         ? "패스워드를 확인해 주세요"
              //         : null,
              //     style: style,
              //     decoration: InputDecoration(
              //       prefixIcon: Icon(Icons.lock),
              //       labelText: "신규 비밀번호",
              //       filled: true,
              //       fillColor: Color(0xffF6F6F6),
              //       border: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(8),
              //         borderSide: BorderSide.none,
              //       ),
              //     ),
              //   ),
              // ),
              // Padding(
              //   padding:
              //       const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30),
              //   child: TextFormField(
              //     obscureText: true,
              //     controller: _confirm_new_password,
              //     validator: (value) =>
              //         (value != _new_password) ? "패스워드가 올바르지 않습니다." : null,
              //     style: style,
              //     decoration: InputDecoration(
              //       prefixIcon: Icon(Icons.lock),
              //       labelText: "신규 비밀번호 확인",
              //       filled: true,
              //       fillColor: Color(0xffF6F6F6),
              //       border: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(8),
              //         borderSide: BorderSide.none,
              //       ),
              //     ),
              //   ),
              // ),
              Container(
                padding: EdgeInsets.fromLTRB(40, 20, 40, 0),
                child: ElevatedButton(
                  onPressed: () {
                    user.updateUserInfo(
                        uid: user.user!.uid!,
                        email: _email.value.text,
                        nickname: _name.value.text,
                        team: _cnt.dropDownValue!.name);
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          const Color.fromRGBO(33, 58, 135, 1))),
                  child: const Text(
                    "DONE",
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
