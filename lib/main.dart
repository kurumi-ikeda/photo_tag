import 'package:flutter/material.dart';
import 'package:flutter_application_photo_tag/photo_home/infinity_image_grid.dart';
import 'package:flutter_application_photo_tag/tag_library/library_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'model/deleted_tag_photo_id/deleted_photo_id.dart';
import 'model/tag/tag.dart';
import 'search/search_page.dart';
import 'tag_library/tag_page/result_selection_provider.dart';

Future<void> main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TagAdapter());
  await Hive.openBox<Tag>('tags');
  Hive.registerAdapter(DeletedPhotoIdAdapter());
  await Hive.openBox<DeletedPhotoId>('deletedPhotoIds');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ResultSelectionProvider>(
          create: (_) => ResultSelectionProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photo Tag',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _navIndex = 0;

  final _navWidget = [
    const InfinityImageScrollPage(),
    const TagLibraryPage(),
    const SearchPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.insert_photo),
            label: 'insert_photo',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.photo_library,
            ),
            label: 'photo_library',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'search',
          ),
        ],
        onTap: (int index) {
          setState(
            () {
              _navIndex = index;
            },
          );
        },
        currentIndex: _navIndex,
      ),
      body: _navWidget.elementAt(_navIndex),
    );
  }
}
