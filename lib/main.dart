import 'package:flutter/material.dart';
import 'package:flutter_application_photo_tag/serect_photo/serect_photo.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'hive_sample.dart';
import 'home/photo_home.dart';

import 'photo_library/photo_library_view.dart';
import 'search/ search_view.dart';

Future<void> main() async {
  await Hive.initFlutter();
  runApp(MyApp());
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
  // var _label = '';
  var _titles = ['insert_photo', 'photo_library', 'search'];

  var _navWiget = [
    PhotoHome(),
    PhotoLibraryView(),
    SearchView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
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
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.insert_photo),
            title: Text('insert_photo'),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.photo_library,
            ),
            title: Text('photo_library'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text('search'),
          ),
        ],
        onTap: (int index) {
          setState(
            () {
              _navIndex = index;
              // _label = _titles[index];
            },
          );
        },
        currentIndex: _navIndex,
      ),
      body: _navWiget.elementAt(_navIndex),

      // body: PhotoHome(),
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
