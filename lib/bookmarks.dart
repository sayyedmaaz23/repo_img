import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookmarksPage extends StatefulWidget {
  @override
  _BookmarksPageState createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  List<String> bookmarkedUrls = [];

  @override
  void initState() {
    super.initState();
    loadBookmarks();
  }


  Future<void> loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final storedUrls = prefs.getStringList('bookmarked_images');
    setState(() {
      bookmarkedUrls = storedUrls ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bookmarks'),
          backgroundColor:  Color(0xFFA56FF6)),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1,
        ),
        itemCount: bookmarkedUrls.length,
        itemBuilder: (context, index) {
          return Card(
            clipBehavior: Clip.antiAlias,
            child: Image.network(
              bookmarkedUrls[index],
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(child: CircularProgressIndicator());
              },
              errorBuilder: (context, error, stackTrace) {
                return Center(child: Text('Image load failed'));
              },
            ),
          );
        },
      ),
    );
  }
}
