import 'package:flutter/material.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:offside/data/view/team_info_view_model.dart';
import 'package:offside/data/view/user_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Edit extends ConsumerStatefulWidget {
  @override
  _EditState createState() => _EditState();
}

class _EditState extends ConsumerState<Edit> {
  TextStyle style = const TextStyle(fontSize: 18.0);
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
    List teamInfo = ref.read(teamInfoViewModelProvider).teamInfoList;
    _name = TextEditingController(text: read_user.user!.nickname);

    _password = TextEditingController(text: "");
    _new_password = TextEditingController(text: "");
    _confirm_new_password = TextEditingController(text: "");
    _email = TextEditingController(
        text: read_user.user?.nickname != null ? read_user.user?.email : "");
    _cnt = SingleValueDropDownController(
        data: DropDownValueModel(
            name: teamInfo[read_user.user!.team!].fullName,
            value: read_user.user!.team!));
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
    final user = ref.watch(userViewModelProvider);
    List teamInfoList = ref.read(teamInfoViewModelProvider).teamInfoList;
    List<DropDownValueModel> dropDownValueList = [];
    for (var i = 1; i < teamInfoList.length; i++) {
      dropDownValueList
          .add(DropDownValueModel(name: teamInfoList[i].fullName, value: i));
    }
    return Scaffold(
        key: _key,
        appBar: AppBar(),
        body: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text('회원정보 수정',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 10),
              user.user!.email == null || user.user?.email == ""
                  ? const SizedBox()
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 30),
                      child: TextFormField(
                        controller: _email,
                        validator: (value) =>
                            (value!.isEmpty) ? "이메일을 입력 해 주세요" : null,
                        style: style,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.email),
                          labelText: "이메일 변경",
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
                  controller: _name,
                  validator: (value) =>
                      (value!.isEmpty) ? "닉네임 입력 해 주세요" : null,
                  style: style,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person),
                    labelText: "닉네임 변경",
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
                    listPadding: ListPadding(top: 1, bottom: 1),
                    controller: _cnt,
                    clearOption: false,
                    textFieldFocusNode: textFieldFocusNode,
                    searchFocusNode: searchFocusNode,
                    dropDownItemCount: 25,
                    searchShowCursor: false,
                    enableSearch: true,
                    searchKeyboardType: TextInputType.text,
                    textFieldDecoration: InputDecoration(
                        prefixIcon: const Icon(Icons.favorite),
                        labelText: "응원 팀 변경",
                        filled: true,
                        fillColor: const Color(0xffF6F6F6),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        )),
                    dropDownList: dropDownValueList),
              ),
              const SizedBox(
                height: 10,
              ),
              const Center(
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
                padding: const EdgeInsets.fromLTRB(40, 20, 40, 0),
                child: ElevatedButton(
                  onPressed: () {
                    user.updateUserInfo(
                        uid: user.user!.uid!,
                        email: _email.value.text,
                        nickname: _name.value.text,
                        team: _cnt.dropDownValue!.value);
                    showDialog(
                      context: context,
                      barrierDismissible: true, //바깥 영역 터치시 닫을지 여부 결정
                      builder: ((context) {
                        return AlertDialog(
                          title: const Text("회원정보 수정"),
                          content: const Text("회원 정보가 수정되었습니다."),
                          actions: <Widget>[
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop(); //창 닫기
                              },
                              child: const Text("X"),
                            )
                          ],
                        );
                      }),
                    );
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
