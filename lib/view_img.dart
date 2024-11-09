import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:repo_img/bookmark_list.dart';

class View_image extends StatefulWidget {
  final String img_url;
  const View_image({required this.img_url});

  @override
  _View_imageState createState() => _View_imageState();
}

class _View_imageState extends State<View_image> {
  bool isBookmarked = false;

  @override
  void initState() {
    super.initState();
    checkBookmarkStatus();
  }


  Future<void> checkBookmarkStatus() async {
    List<String> bookmarks = await Bookmarked().loadBookmarks();
    setState(() {
      isBookmarked = bookmarks.contains(widget.img_url);
    });
  }


  Future<void> toggleBookmark() async {
    setState(() {
      isBookmarked = !isBookmarked;
    });
    if (isBookmarked) {
      await Bookmarked().addToBookmark(widget.img_url);
    } else {
      await Bookmarked().removeFromBookmark(widget.img_url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PhotoView(imageProvider: NetworkImage(widget.img_url)),
          Positioned(
            top: 170,
            right: 5,
            child: FloatingActionButton(
              onPressed: toggleBookmark,
              child: Icon(
                isBookmarked ? Icons.bookmark_sharp : Icons.bookmark_border_sharp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}








