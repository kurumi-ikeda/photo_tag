import 'package:flutter/material.dart';

import 'select_photo/select_photo.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text("Photo Tag"),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (
                  context,
                ) =>
                        const SelectPhoto()));
          },
        ),
      ],
    );
  }
}
