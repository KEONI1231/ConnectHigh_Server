import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:per_pro/component/alert_dialog.dart';
import 'package:per_pro/component/circular_progress_indicator_dialog.dart';
import 'package:per_pro/component/custom_add_repl_textfiled.dart';
import 'package:per_pro/component/unFocus.dart';
import 'package:per_pro/firebase_database_model/user.dart';
import '../../../component/report_anonymessage/Custom_report_messeage_dialog.dart';
import '../../../constant/color.dart';

class BoardDetail extends StatefulWidget {
  final String postID;
  final String title;
  final String content;
  final String postTime;
  final String school;
  final String writerID;
  final int replCount;
  final int heartCount;
  final int scrapCount;
  final loginUser user;
  final String postValue;
  final String boardTitle;
  const BoardDetail({
    required this.boardTitle,
    required this.writerID,
    required this.postValue,
    required this.postID,
    required this.user,
    required this.school,
    required this.title,
    required this.content,
    required this.postTime,
    required this.replCount,
    required this.scrapCount,
    required this.heartCount,
    Key? key,
  }) : super(key: key);

  @override
  State<BoardDetail> createState() => _BoardDetailState();
}

class _BoardDetailState extends State<BoardDetail> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool? _isChecked = false;
  final TextEditingController replContent = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey();
  final titleStyle = const TextStyle(
      color: Colors.black, fontSize: 24, fontWeight: FontWeight.w700);
  final contentStyle = const TextStyle(
      color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500);
  final defaultTs = const TextStyle(color: Colors.black, fontSize: 16);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: unFocused,
        child: SafeArea(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ReplView(
              boardTitle: widget.boardTitle,
              postValue: widget.postValue,
              user: widget.user,
              postTime: widget.postTime,
              replCount: widget.replCount,
              heartCount: widget.heartCount,
              content: widget.content,
              title: widget.title,
              school: widget.school,
              scrapCount: widget.scrapCount,
              postID: widget.postID,
              writerID: widget.writerID,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 16),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '익명',
                          style: defaultTs,
                        ),
                        Checkbox(
                          value: _isChecked,
                          checkColor: BRIGHT_COLOR,
                          activeColor: PRIMARY_COLOR,
                          onChanged: (value) {
                            setState(() {
                              _isChecked = value;
                            });
                          },
                        ),
                        const SizedBox(width: 16),
                        GestureDetector(
                          onTap: addRepl,
                          child: const Icon(
                            Icons.done,
                            color: PRIMARY_COLOR,
                            size: 40,
                          ),
                        )
                      ],
                    ),
                    CustomAddReplTextField(
                        Controller: replContent, label: '댓글 작성')
                  ],
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }

  void addRepl() async {
    DocumentSnapshot postData =
        await firestore.collection(widget.postValue).doc(widget.postID).get();
    final List replIdList = List<String>.from(postData['repl id collector'] ?? []);
    if (formKey.currentState == null) {
      return;
    }
    if (formKey.currentState!.validate()) {
      widget.user.replCount++;
      CustomCircular(context, '댓글 다는중...');
      await firestore
          .collection('users')
          .doc(widget.user.ID)
          .update({'repl count': widget.user.postCount});
      await firestore
          .collection(widget.postValue)
          .doc(widget.postID)
          .update({'repl count': FieldValue.increment(1)});
      await firestore
          .collection(widget.postValue)
          .doc(widget.postID)
          .collection('repl')
          .doc(widget.user.ID + widget.user.replCount.toString() + '!@#')
          .set({
        'repl content': replContent.text,
        'repl id': widget.user.ID + widget.user.replCount.toString() + '!@#',
        'repl heart': 0,
        'repl writer id': widget.user.ID,
        'repled time': DateTime.now().toString(),
        'repl heartuser': [''],
        'is reported': false,
        'report content': ''
      });
      replIdList.add(widget.user.ID + widget.user.replCount.toString() + '!@#');
      await firestore.collection(widget.postValue).doc(widget.postID).update({
        'repl id collector': replIdList,
      });
      Navigator.pop(context);
      DialogShow(context, '댓글을 작성했습니다!');
    }
  }
}

class ReplView extends StatefulWidget {
  final int heartCount;
  final int scrapCount;
  final int replCount;
  final String school;
  final String postTime;
  final String title;
  final String content;
  final loginUser user;
  final String postID;
  final String postValue;
  final String writerID;
  final String boardTitle;
  const ReplView({
    required this.boardTitle,
    required this.writerID,
    required this.postID,
    required this.postValue,
    required this.user,
    required this.heartCount,
    required this.scrapCount,
    required this.school,
    required this.replCount,
    required this.postTime,
    required this.title,
    required this.content,
    Key? key,
  }) : super(key: key);

  @override
  State<ReplView> createState() => _ReplViewState();
}

class _ReplViewState extends State<ReplView> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var replContent;
  var repledTime;
  var forPrintRepledTime;
  var replID;
  var replHeart;
  var isReported;
  var replWriterID;

  @override
  Widget build(BuildContext context) {
    var boardTitle = widget.boardTitle;
    final titleStyle = TextStyle(color: Colors.black, fontSize: 20);
    final contentStyle = TextStyle(color: Colors.grey[600], fontSize: 14);
    return StreamBuilder<QuerySnapshot>(
      stream: firestore
          .collection(widget.postValue)
          .doc(widget.postID)
          .collection('repl')
          .where('repled time', isNotEqualTo: "0")
          .orderBy('repled time')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(color: PRIMARY_COLOR);
        }
        return Expanded(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                centerTitle: true,
                backgroundColor: PRIMARY_COLOR,
                title: Text(widget.boardTitle),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  childCount: 1,
                  (BuildContext context, int index) {
                    return Column(
                      //본문
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.account_circle,
                                    size: 48,
                                    color: PRIMARY_COLOR,
                                  ),
                                  const SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(widget.postTime.substring(0, 16)),
                                      Text(widget.school),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 32),
                              Text(widget.title, style: titleStyle),
                              Text(
                                '\n\n' + widget.content,
                                style: contentStyle,
                              ),
                              const SizedBox(height: 32),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: onHeartClick,
                                        child: Icon(Icons.favorite_border),
                                      ),
                                      Text(': ${widget.heartCount}개'),
                                      const SizedBox(width: 8),
                                      const Icon(Icons.messenger_outline),
                                      Text(': ${widget.replCount}개'),
                                      const SizedBox(width: 8),
                                      const Icon(Icons.star_outline),
                                      Text(': ${widget.scrapCount}개'),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      GestureDetector(
                                          onTap: () {
                                            ReportMessage(
                                                context,
                                                true,
                                                widget.postValue,
                                                widget.postID,
                                                '',
                                                widget.writerID,
                                                widget.user.ID);
                                            //post id, reported content 보내기
                                            //댓글은 어떻게 처리하지
                                            //댓글 신고인지 게시글 신고인지
                                          },
                                          child: Icon(Icons.more_vert)),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        const Liner(),
                        const SizedBox(height: 16),
                      ],
                    );
                  },
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                    childCount: snapshot.data!.docs.length,
                    (BuildContext context, int index) {
                  if (snapshot.data!.docs.length != 0) {
                    replContent = (snapshot.data?.docs[index]['repl content']);
                    repledTime = snapshot.data?.docs[index]['repled time'];
                    replID = (snapshot.data?.docs[index]['repl id']);
                    replHeart = (snapshot.data?.docs[index]['repl heart']);
                    isReported = (snapshot.data?.docs[index]['is reported']);
                    forPrintRepledTime = repledTime.substring(0, 16);
                    replWriterID =
                        (snapshot.data?.docs[index]['repl writer id']);
                  }
                  return EachRepl(
                      postValue: widget.postValue,
                      postID: widget.postID,
                      contentStyle: contentStyle,
                      titleStyle: titleStyle,
                      forPrintRepledTime: forPrintRepledTime,
                      isReported: isReported,
                      replContent: replContent,
                      repledTime: repledTime,
                      replHeart: replHeart,
                      replID: replID,
                      user: widget.user,
                      replWriterID: replWriterID);
                }),
              ),
            ],
          ),
        );
      },
    );
  }

  void onHeartClick() async {
    //좋아요 함수
    DocumentSnapshot postData =
        await firestore.collection(widget.postValue).doc(widget.postID).get();
    final List heartUserList = List<String>.from(postData['heart user'] ?? []);
    if (heartUserList.contains(widget.user.ID) == false) {
      //좋아요를 달지 않은 상태일때
      heartUserList.add(widget.user.ID);
      CustomCircular(context, '좋아요 등록중...');
      await firestore.collection(widget.postValue).doc(widget.postID).update({
        'heart user': heartUserList,
        'heart count': heartUserList.length - 1,
      });
      Navigator.pop(context);
      DialogShow(context, '좋아요를 달았습니다');
    } else if (heartUserList.contains(widget.user.ID) == true) {
      //좋아요를 달았을때와 좋아요 수가 0개 일때
      heartUserList.remove(widget.user.ID);
      CustomCircular(context, '좋아요 지우는 중...');
      await firestore.collection(widget.postValue).doc(widget.postID).update({
        'heart user': heartUserList,
        'heart count': heartUserList.length - 1,
      });
      Navigator.pop(context);
      DialogShow(context, '좋아요를 지웠습니다');
    }
    //print(heartUserList);
    //print(widget.user.ID);
  }
}

class Liner extends StatelessWidget {
  //본문과 댓글을 구분하기 위한 라인
  const Liner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.black,
            width: 0.5,
          ),
        ),
      ),
    );
  }
}

class EachRepl extends StatefulWidget {
  final titleStyle;
  final contentStyle;
  final replContent;
  final repledTime;
  final forPrintRepledTime;
  final replID;
  final replHeart;
  final isReported;
  final postID;
  final postValue;
  final loginUser user;
  final replWriterID;
  const EachRepl(
      {required this.replWriterID,
      required this.user,
      required this.postID,
      required this.postValue,
      required this.titleStyle,
      required this.contentStyle,
      required this.replContent,
      required this.replID,
      required this.repledTime,
      required this.forPrintRepledTime,
      required this.isReported,
      required this.replHeart,
      Key? key})
      : super(key: key);

  @override
  State<EachRepl> createState() => _EachReplState();
}

class _EachReplState extends State<EachRepl> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 2),
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.account_circle,
                          color: PRIMARY_COLOR,
                        ),
                        const SizedBox(width: 8),
                        widget.isReported == false
                            ? Text(
                                '익명',
                                style: widget.titleStyle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )
                            : Text(
                                '신고',
                                style: widget.titleStyle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                        const SizedBox(width: 8),
                        Text(
                          widget.forPrintRepledTime,
                          style: widget.contentStyle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        GestureDetector(
                            onTap: () {
                              widget.isReported != true
                                  ? ReportMessage(
                                      context,
                                      false,
                                      widget.postValue,
                                      widget.postID,
                                      widget.replID,
                                      widget.replWriterID,
                                      widget.user.ID)
                                  : () {}; //여기에 변수들을 넘겨서 처리해야함 .
                              // ex { post-value, post-id}
                            },
                            child: Icon(Icons.more_vert)),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 8),
                widget.isReported == false
                    ? Text(
                        widget.replContent,
                        style: widget.contentStyle,
                      )
                    : Text(
                        '신고된 댓글입니다.',
                        style: widget.contentStyle
                            .copyWith(color: Colors.red[400]),
                      ), //문제1) 어떤 댓글을 클릭하여 신고해도 마지막 댓글이 신고가 됨, 좋아요도 마찬가지 (모두 해결)
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                        onTap:
                            widget.isReported != true ? replHeartClick : () {},
                        child: Icon(Icons.favorite_border)),
                    Text(': ${widget.replHeart}개'),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Liner(),
      ],
    );
  }

  void replHeartClick() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot postData = await firestore
        .collection(widget.postValue)
        .doc(widget.postID)
        .collection('repl')
        .doc(widget.replID)
        .get();
    final List heartUserList =
        List<String>.from(postData['repl heartuser'] ?? []);
    if (heartUserList.contains(widget.user.ID) == false) {
      //좋아요를 달지 않은 상태일때
      heartUserList.add(widget.user.ID);
      CustomCircular(context, '좋아요 등록중...');
      await firestore
          .collection(widget.postValue)
          .doc(widget.postID)
          .collection('repl')
          .doc(widget.replID)
          .update({
        'repl heartuser': heartUserList,
        'repl heart': heartUserList.length - 1,
      });
      Navigator.pop(context);
      DialogShow(context, '좋아요를 달았습니다');
    } else if (heartUserList.contains(widget.user.ID) == true) {
      //좋아요를 달았을때와 좋아요 수가 0개 일때
      heartUserList.remove(widget.user.ID);
      CustomCircular(context, '좋아요 지우는 중...');
      await firestore
          .collection(widget.postValue)
          .doc(widget.postID)
          .collection('repl')
          .doc(widget.replID)
          .update({
        'repl heartuser': heartUserList,
        'repl heart': heartUserList.length - 1,
      });
      Navigator.pop(context);
      DialogShow(context, '좋아요를 지웠습니다');
    }
  }
}
