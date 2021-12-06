import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HiveSample extends StatefulWidget {
  const HiveSample({Key? key}) : super(key: key);

  @override
  _HiveSampleState createState() => _HiveSampleState();
}

class _HiveSampleState extends State<HiveSample> {
  final controller = TextEditingController();

  // 初期化が完了したかどうかをはかる
  bool IsInittlized = false;

  // final memoBox = Hive.box('memo');

  Future<void> init() async {
    //ボックスをひらく
    await Hive.openBox('memo');
    IsInittlized = true;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();

    setState(() {});
  }

  Future<void> addMemo() async {
    // final memoBox = Hive.box('memo');
    final text = controller.text;
    if (text.isEmpty) {
      return;
    }

    await Hive.box('memo').add(text);

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
        child: IsInittlized
            ? Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextFormField(
                      onChanged: (_) {
                        setState(() {});
                      },
                      controller: controller,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: controller.text.trim().isEmpty ? null : addMemo,
                    child: const Text('追加'),
                  ),
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
