import 'package:flutter/material.dart';
import 'package:flutter_application_photo_tag/serect_photo/serect_photo.dart';
import 'package:flutter_application_photo_tag/tag_feature/tag.dart';
import 'package:flutter_application_photo_tag/tag_library/library_page.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'home/photo_home.dart';

import 'search/search_view.dart';

Future<void> main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TagAdapter());
  await Hive.openBox<Tag>('tags');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Media Picker Example',
      theme: ThemeData(
        // This is the theme of your application.
        primarySwatch: Colors.red,
      ),
      // home: HiveSample(),
      // home: Select(),
      home: const MyHomePage(title: 'Media Picker Example App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _navIndex = 0;

  final _navWiget = [
    const PhotoHome(),
    const TagLibraryView(),
    // PhotoLibraryView(),
    const SearchView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Command.tagAdd(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (
                    context,
                  ) =>
                          const SerectPotho()));
            },
          ),
        ],
      ),
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
      body: _navWiget.elementAt(_navIndex),
    );
  }
}

// class HomeBottomNavigationBar extends StatefulWidget {
//   const HomeBottomNavigationBar({Key? key}) : super(key: key);

//   @override
//   _HomeBottomNavigationBarState createState() =>
//       _HomeBottomNavigationBarState();
// }

// class _HomeBottomNavigationBarState extends State<HomeBottomNavigationBar> {
//   var _navIndex = 0;
//   var _label = '';
//   var _titles = ['insert_photo', 'photo_library', 'search'];

//   var navWiget = [
//     PhotoHome(),
//     PhotoLibraryView(),
//     SearchView(),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return BottomNavigationBar(
//       items: [
//         BottomNavigationBarItem(
//           icon: Icon(Icons.insert_photo),
//           title: Text('insert_photo'),
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(
//             Icons.photo_library,
//           ),
//           title: Text('photo_library'),
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.search),
//           title: Text('search'),
//         ),
//       ],
//       onTap: (int index) {
//         setState(
//           () {
//             _navIndex = index;
//             _label = _titles[index];
//           },
//         );
//       },
//       currentIndex: _navIndex,
//     );
//   }
// }
