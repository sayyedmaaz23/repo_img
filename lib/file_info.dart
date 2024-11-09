import 'package:flutter/material.dart';
import 'package:repo_img/repo_list.dart';


class file_info extends StatelessWidget{
  final List<GistFile>files;
  const file_info({required this.files});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Files'),
          backgroundColor:  Color(0xFFA56FF6),
      ),
      body:
      Container(
        child:
        ListView.builder(
            itemCount: files.length,
            itemBuilder: (context, index){
              final file= files[index];
              return Card(
                child: ListTile(
                  title: Text(file.filename),
                  subtitle: Text("Language: ${file.language} \n URL: ${file.rawUrl} \n Size: ${file.size}"),
                ),
              );
            }),
      ),
    );
  }
}