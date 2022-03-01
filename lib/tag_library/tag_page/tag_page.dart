import 'package:flutter/material.dart';

import 'package:flutter_application_photo_tag/tag_feature/tag.dart';

import 'package:flutter_application_photo_tag/tag_library/tag_page/tag_photo_grid_view.dart';

import 'package:provider/provider.dart';

import 'result_selection_provider.dart';
import 'select_photo_grid_view.dart';

/*
作るべきメソッド
tagNameの名前を替えられるメソッド(rename)
selectedListの中身を変更できるメソッド(rename)

*/

class TagPage extends StatefulWidget {
  final Tag tag;
  const TagPage({Key? key, required this.tag}) : super(key: key);

  @override
  _TagPageState createState() => _TagPageState();
}

class _TagPageState extends State<TagPage> {
  Widget bodyWidgetChange(bool isSelectionState) {
    if (isSelectionState) {
      return SelectPhotoGridView(tag: widget.tag);
    } else {
      return TagPhotoGridView(
        tag: widget.tag,
      );
    }
  }

  // Widget appBarWidgetChange() {
  //   if (isSelectionState) {
  //     return AppBar();
  //   } else {
  //     return AppBar(
  //       title: Text(widget.tag.tagName),
  //       actions: <Widget>[
  //         PopupMenuButton(
  //             itemBuilder: (context) => <PopupMenuEntry>[
  //                   PopupMenuItem(
  //                     child: const Text("写真編集"),
  //                     onTap: () {
  //                       isSelectionState = true;
  //                       setState(() {});
  //                     },
  //                   ),
  //                   PopupMenuItem(
  //                     child: const Text("名前変更"),
  //                     onTap: () async {
  //                       await Future.delayed(const Duration(seconds: 0));
  //                       final text = await showDialog<String>(
  //                         context: context,
  //                         builder: (context) {
  //                           return const EditDialog();
  //                         },
  //                       );
  //                       if (text?.isNotEmpty == true) {
  //                         widget.tag.tagName = text!;

  //                         await Boxes.updateTag(widget.tag);
  //                         setState(() {});
  //                       }
  //                     },
  //                   ),
  //                 ]),
  //       ],
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // context.
    return ChangeNotifierProvider(
      create: (BuildContext context) {
        ResultSelectionProvider();
      },
      child: bodyWidgetChange(
        context.watch<ResultSelectionProvider>().isSelectionState,
      ),
    );
  }
  // @override
  // Widget build(BuildContext context) {
  //   // context.
  //   return Consumer<ResultSelectionProvider>(builder: (context, model, _) {
  //     return Scaffold(
  //       appBar: AppBar(
  //         title: Text(widget.tag.tagName),
  //         actions: <Widget>[
  //           PopupMenuButton(
  //               itemBuilder: (context) => <PopupMenuEntry>[
  //                     PopupMenuItem(
  //                       child: const Text("写真編集"),
  //                       onTap: () {
  //                         model.changeIsSelectionState();
  //                         // isSelectionState = true;
  //                         setState(() {});
  //                       },
  //                     ),
  //                     PopupMenuItem(
  //                       child: const Text("名前変更"),
  //                       onTap: () async {
  //                         await Future.delayed(const Duration(seconds: 0));
  //                         final text = await showDialog<String>(
  //                           context: context,
  //                           builder: (context) {
  //                             return const EditDialog();
  //                           },
  //                         );
  //                         if (text?.isNotEmpty == true) {
  //                           widget.tag.tagName = text!;

  //                           await Boxes.updateTag(widget.tag);
  //                           setState(() {});
  //                         }
  //                       },
  //                     ),
  //                   ]),
  //         ],
  //       ),
  //       body: bodyWidgetChange(model.isSelectionState),
  //     );
  //   });
  // }
}

class EditDialog extends StatefulWidget {
  const EditDialog({Key? key}) : super(key: key);

  @override
  _EditDialogState createState() => _EditDialogState();
}

class _EditDialogState extends State<EditDialog> {
  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    return AlertDialog(
      title: const Text('名前変更'),
      content: TextFormField(
        controller: controller,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(controller.text);
          },
          child: const Text('完了'),
        )
      ],
    );
  }
}
