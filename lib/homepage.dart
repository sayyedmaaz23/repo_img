import 'package:flutter/material.dart';
import 'package:repo_img/bookmarks.dart';
import 'package:repo_img/display_photos.dart';
import 'package:repo_img/repo_list.dart';

class Homepage extends StatefulWidget {
  @override
  State<Homepage> createState() {
    return _HomepageState();
  }
}

class _HomepageState extends State<Homepage> {
  final String apiUrl = 'https://api.github.com/gists/public';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('App', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xFFA56FF6),
        elevation: 10,
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Add action for settings if needed
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFA56FF6).withOpacity(0.7),
              Color(0xFFA56FF6),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => BookmarksPage()));
                  },
                  child: Row(
                    children: [
                      Icon(Icons.bookmark, size: 20),
                      SizedBox(width: 8),
                      Text('Bookmarks', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                    ],
                  ),
                  style: ButtonStyle(
                    padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 16, vertical: 10)),
                    minimumSize: WidgetStateProperty.all(Size(150, 50)),
                    backgroundColor: WidgetStateProperty.all(Color(0xFFA56FF6)),
                    textStyle: WidgetStateProperty.all(TextStyle(fontSize: 16)),
                    shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    elevation: WidgetStateProperty.all(5),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Center(
                child: Text(
                  'Welcome',
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => GistPage()),
                      );
                    },
                    child: Text(
                      'Repo List',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    style: ButtonStyle(
                      padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 25, vertical: 16)),
                      minimumSize: WidgetStateProperty.all(Size(150, 40)),
                      textStyle: WidgetStateProperty.all(TextStyle(fontSize: 20)),
                      backgroundColor: WidgetStateProperty.all(Color(0xFFA56FF6)),
                      shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      elevation: WidgetStateProperty.all(5),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Displayphotos()),
                      );
                    },
                    child: Text(
                      'Images',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    style: ButtonStyle(
                      padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 25, vertical: 16)),
                      minimumSize: WidgetStateProperty.all(Size(150, 40)),
                      textStyle: WidgetStateProperty.all(TextStyle(fontSize: 20)),
                      backgroundColor: WidgetStateProperty.all(Color(0xFFA56FF6)),
                      shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      elevation: WidgetStateProperty.all(5),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
