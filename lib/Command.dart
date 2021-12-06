//何か使用変更が入っても、main画面は何も変更を加えないようにする

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_photo_tag/Tag_Add.dart';
import 'Tag_Add.dart';

class Command {
  //tagaddへのアクセス
  static tagAdd(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => TagAdd()));
  }
}
