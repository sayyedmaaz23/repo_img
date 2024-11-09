import 'package:shared_preferences/shared_preferences.dart';

class Bookmarked {

  Future<List<String>> loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('bookmarked_images') ?? [];
  }

  Future<void> addToBookmark(String url) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> bookmarks = prefs.getStringList('bookmarked_images') ?? [];
    if (!bookmarks.contains(url)) {
      bookmarks.add(url);
      await prefs.setStringList('bookmarked_images', bookmarks);
    }
  }


  Future<void> removeFromBookmark(String url) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> bookmarks = prefs.getStringList('bookmarked_images') ?? [];
    bookmarks.remove(url);
    await prefs.setStringList('bookmarked_images', bookmarks);
  }
}




