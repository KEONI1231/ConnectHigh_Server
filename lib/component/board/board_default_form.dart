import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:per_pro/component/add_post_screen.dart';
import 'package:per_pro/component/appbar.dart';
import 'package:per_pro/firebase_database_model/user.dart';
import '../../../constant/color.dart';
import 'board_detail.dart';


class BoardDefaultForm extends StatefulWidget {
  final String postValue;
  final loginUser user;

  const BoardDefaultForm({
    required this.postValue,
    required this.user,
    Key? key,
  }) : super(key: key);

  @override
  State<BoardDefaultForm> createState() => _BoardDefaultFormState();
}

class _BoardDefaultFormState extends State<BoardDefaultForm> {
  @override
  Widget build(BuildContext context) {
    var boardTitle = '';
    String title = '';
    String content = '';
    String postTime = '';
    String school = '';
    String postID = '';
    String writerID = '';
    bool isReported = false;
    int heartCount = 0;
    int replCount = 0;
    int scrapCount = 0;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    if(widget.postValue == 'post-free-board') {
      boardTitle = '자유게시판';
    }
    else if(widget.postValue == 'post-love-board') {
      boardTitle = '연애게시판';
    }
    else if(widget.postValue == 'post-meal-board') {
      boardTitle = '급식게시판';
    }
    else {
      boardTitle = 'null';
    }
    return Scaffold(
      backgroundColor: BRIGHT_COLOR,
      floatingActionButton: renderFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(titleText: boardTitle),
            SizedBox(height: 8),
            SizedBox(height: 8),
            StreamBuilder<QuerySnapshot>(
              stream: firestore
                  .collection(widget.postValue)
                  .orderBy('posted time', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(color: PRIMARY_COLOR);
                }
                return Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    //shrinkWrap: true,
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (context, index) {
                      title = snapshot.data?.docs[index]['title'];
                      content = snapshot.data?.docs[index]['content'];
                      postTime = snapshot.data?.docs[index]['posted time'];
                      school = snapshot.data?.docs[index]['school'];
                      heartCount = snapshot.data?.docs[index]['heart count'];
                      replCount = snapshot.data?.docs[index]['repl count'];
                      scrapCount = snapshot.data?.docs[index]['scrap count'];
                      postID = snapshot.data?.docs[index]['post id'];
                      writerID = snapshot.data?.docs[index]['writer id'];
                      isReported = snapshot.data?.docs[index]['is reported'];
                      return PostContents(
                        boardTitle: boardTitle,
                        isReported: isReported,
                        writerID: writerID,
                        postTime: postTime,
                        title: title,
                        content: content,
                        school: school,
                        replCount: replCount,
                        scrapCount: scrapCount,
                        heartCount: heartCount,
                        postID: postID,
                        user: widget.user,
                        postValue: widget.postValue,
                        //onTap: onBoardTap,
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  FloatingActionButton renderFloatingActionButton() {
    return FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return AddPost(postValue: widget.postValue, user: widget.user);
          }));
        },
        backgroundColor: PRIMARY_COLOR,
        icon: Icon(Icons.add_box_outlined),
        label: Text('글 쓰기'));
  }
}

class PostContents extends StatelessWidget {
  final String title;
  final String school;
  final String content;
  final String postTime;
  final String writerID;
  final int replCount;
  final int scrapCount;
  final int heartCount;
  final String postID;
  final String postValue;
  final bool isReported;
  final loginUser user;
  final String boardTitle;
  const PostContents({
    required this.boardTitle,
    required this.isReported,
    required this.writerID,
    required this.postValue,
    required this.user,
    required this.school,
    required this.title,
    required this.content,
    required this.postTime,
    required this.replCount,
    required this.scrapCount,
    required this.heartCount,
    required this.postID,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final titleStyle = TextStyle(color: Colors.black, fontSize: 21);
    final contentStyle = TextStyle(color: Colors.grey[600], fontSize: 18);
    return GestureDetector(
        onTap: () {
          if (isReported == false) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return BoardDetail(
                    boardTitle: boardTitle,
                    postValue: postValue,
                    //게시판의 종류
                    user: user,
                    postID: postID, //게시글의 id
                    heartCount: heartCount,
                    replCount: replCount,
                    scrapCount: scrapCount,
                    title: title,
                    content: content,
                    postTime: postTime,
                    school: school,
                    writerID: writerID,
                  );
                },
              ),
            );
          }
        },
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(8, 0, 8, 2),
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    isReported == false
                        ? Text(
                            title,
                            style: titleStyle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                        : Text(
                            '신고된 게시물 입니다',
                            style: titleStyle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                    const SizedBox(height: 8),
                    isReported == false
                        ? Text(
                            content,
                            style: contentStyle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                        : Text(
                            '신고된 게시물 입니다.',
                            style: contentStyle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(Icons.favorite_border),
                        Text(': $heartCount개'),
                        SizedBox(
                          width: 8,
                        ),
                        Icon(Icons.messenger_outline),
                        Text(': ${replCount}개'),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
