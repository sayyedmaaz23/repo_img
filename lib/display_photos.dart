import 'package:flutter/material.dart';
import 'package:repo_img/view_img.dart';

import 'getphoto.dart';

class Displayphotos extends StatefulWidget {
  @override
  _DisplayphotosPageState createState() => _DisplayphotosPageState();
}

class _DisplayphotosPageState extends State<Displayphotos> {
  final Unsplash _unsplashService = Unsplash();
  List<String> _imageUrls = [];

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    try {
      final images = await _unsplashService.fetchImages('random');
      setState(() {
        _imageUrls = images;
      });
    } catch (e) {
      print('Error fetching images: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Unsplash Images'),
          backgroundColor:  Color(0xFFA56FF6),
      ),
      body: _imageUrls.isEmpty
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: _imageUrls.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> View_image(img_url: _imageUrls[index])));
            },
            child: Card(

              child: Image.network(_imageUrls[index], fit: BoxFit.cover),

            ),
          );
        },
      ),
    );
  }
}
