import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TagAdd extends StatefulWidget {
  const TagAdd({Key? key}) : super(key: key);

  @override
  _TagAddState createState() => _TagAddState();
}

class _TagAddState extends State<TagAdd> {
  //ここがphotoのlistになる

  final list = [
    '写真1',
    '写真2',
    '写真3',
    '写真4',
    '写真5',
  ];
  //選択したもののlistがこれ
  final selectedList = <String>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('widget.title)'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index) {
          final text = list[index];
          return InkWell(
              onTap: () {
                if (selectedList.contains(text)) {
                  selectedList.remove(text);
                } else {
                  selectedList.add(text);
                }

                setState(() {});
              },
              child: Stack(
                children: [
                  Container(
                    // color: selectedList.contains(text) ? Colors.blue : null,
                    alignment: Alignment.center,
                    child: Text(text),
                  ),
                  if (selectedList.contains(text))
                    const Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: EdgeInsets.all(4),
                        child: Icon(
                          Icons.check_circle,
                          color: Colors.lightBlue,
                        ),
                      ),
                    )
                ],
              ));
        },
      ),
    );
  }
}
