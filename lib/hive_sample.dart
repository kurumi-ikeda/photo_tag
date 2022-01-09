import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HiveSample extends StatefulWidget {
  const HiveSample({Key? key}) : super(key: key);

  @override
  _HiveSampleState createState() => _HiveSampleState();
}

class _HiveSampleState extends State<HiveSample> {
  //textのデータを取得する
  final controller = TextEditingController();

  // 初期化が完了したかどうかをはかる
  //↑ボックスを開いたらtrueになる
  bool IsInittlized = false;

  // final memoBox = Hive.box('memo');

  Future<void> init() async {
    //ボックスをひらく
    await Hive.openBox('memo');
    await Hive.openBox('memo2');
    //開いたので trueになる
    IsInittlized = true;
    //再描画
    setState(() {});
  }

  //widgetが作成されたタイミングで処理をする(コンストラクタ的なもの)
  @override
  void initState() {
    super.initState();
    //initメソッドをよびだして、Boxを開く
    init();

    setState(() {});
  }

  Future<void> addMemo2() async {
    // final memoBox = Hive.box('memo');
    final text = controller.text;
    //文字が空か否かを把握する
    if (text.isEmpty) {
      //空文字なら 処理を返す
      return;
    }
    //Boxにtextを保存
    await Hive.box('memo2').add(text);

    // コントローラーを初期化
    controller.clear();

    setState(() {});
  }

  Future<void> addMemo() async {
    // final memoBox = Hive.box('memo');
    final text = controller.text;
    //文字が空か否かを把握する
    if (text.isEmpty) {
      //空文字なら 処理を返す
      return;
    }
    //Boxにtextを保存
    await Hive.box('memo').add(text);

    // コントローラーを初期化
    controller.clear();

    setState(() {});
  }

  // void getMemoList() {
  //   Hive.box(kye);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hiveサンプル'),
      ),
      body: SingleChildScrollView(
        //三項演算子でtureならColumnの内容を表示、falseならCenterの中身を表示させる
        child: IsInittlized
            ? Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextFormField(
                      //TextFormFieldの変更を通知
                      onChanged: (_) {
                        setState(() {});
                      },

                      controller: controller,
                    ),
                  ),
                  ElevatedButton(
                    //先端と末端の空白を消して、その文字が空文字かどうかを判定している
                    onPressed: controller.text.trim().isEmpty ? null : addMemo,
                    child: const Text('追加'),
                  ),
                  //ここでメモの内容を出力しているっぴ
                  ...Hive.box('memo')
                      .keys
                      .map((key) => Text(Hive.box('memo').get(key)))
                      .toList()
                ],
              )
            : const Center(child: CupertinoActivityIndicator()),
      ),
    );
  }
}
