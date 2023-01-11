import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:per_pro/component/appbar.dart';
import 'package:per_pro/component/custom_send_mail.dart';
import '../../../constant/color.dart';
import '../../../firebase_database_model/user.dart';

class certified_screen extends StatefulWidget {
  final loginUser user;
  final BoxDecoration ContainerDecoration;

  const certified_screen(
      {required this.user, required this.ContainerDecoration, Key? key})
      : super(key: key);

  @override
  State<certified_screen> createState() => _certified_screenState();
}

class _certified_screenState extends State<certified_screen> {
  XFile? certifiedImage;

  @override
  Widget build(BuildContext context) {
    final ts = TextStyle(
        fontWeight: FontWeight.w900, color: PRIMARY_COLOR, fontSize: 20);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(titleText: '학교인증'),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'asset/img/logo_blue.png',
                  width: 200,
                  height: 200,
                ), //고등어 이미지.
                Text(
                  '학교 인증을 진행합니다.',
                  style: ts,
                ),
                Text(
                  '학생증, 나이스, 학적기록부 등 학생임을 인증할 수 있는 이미지 자료를 업로드 해주세요.',
                  style: ts.copyWith(fontSize: 11),
                ),
                const SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                  onPressed: uploadImage,
                  child: Text('첨부파일 업로드'),
                  style: ElevatedButton.styleFrom(
                      primary: PRIMARY_COLOR,
                      minimumSize: const Size(196, 40),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15))),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void uploadImage() async {
    var picker = ImagePicker();
    var image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        certifiedImage = image;
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (BuildContext context) {
          return SendMail(
              certifiedImage: certifiedImage,
              appBarText: '학교인증',
              user: widget.user,
              ContainerDecoration: widget.ContainerDecoration);
        }));
      });
    }
  }
}
