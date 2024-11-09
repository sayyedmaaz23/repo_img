
import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:repo_img/file_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GistPage extends StatefulWidget {
  @override
  _GistPageState createState() => _GistPageState();
}

class _GistPageState extends State<GistPage> {
  late Future<List<Gist>> gists;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    gists = fetchAndCacheGists('https://api.github.com/gists/public');
    _startPeriodicUpdates();
  }
  void _startPeriodicUpdates() {
    _timer = Timer.periodic(Duration(minutes: 5), (timer) {
      setState(() {
        gists = fetchAndCacheGists('https://api.github.com/gists/public');
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Public Repositories'),
          backgroundColor:  Color(0xFFA56FF6)),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            gists = fetchAndCacheGists('https://api.github.com/gists/public', forceRefresh: true);
          });
          await gists;
        },
        child: FutureBuilder<List<Gist>>(
          future: gists,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              var gistsData = snapshot.data!;

              return ListView.builder(
                itemCount: gistsData.length,
                itemBuilder: (context, index) {
                  return Card(
                    clipBehavior: Clip.hardEdge,
                    child: InkWell(
                      splashColor: Colors.blue.withAlpha(30),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            title: Text(gistsData[index].description.isEmpty ? "No Description" : gistsData[index].description),
                          ),
                          Row(
                            children: [
                              Text("Created at " + (gistsData[index].created_d).substring(0, 10).split('-').reversed.join('-')),
                              Expanded(child: SizedBox()),
                              Text("Updated at " + (gistsData[index].updated_d).substring(0, 10).split('-').reversed.join('-'))
                            ],
                          ),
                          SizedBox(height: 25),
                          Text("Comments " + gistsData[index].comment_c.toString()),
                        ],
                      ),
                      onLongPress: () {
                        showDialog(context: context, builder: (context) {
                          return AlertDialog(
                            title: Text('Owner Information'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(gistsData[index].owner.avatar_url),
                                  radius: 40,
                                ),
                                SizedBox(height: 16),
                                Text('Name: ${gistsData[index].owner.name}'),
                                Text('ID: ${gistsData[index].owner.id.toString()}'),
                                Text('Node ID: ${gistsData[index].owner.node_id}'),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text('Ok'),
                              ),
                            ],
                          );
                        });
                      },
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => file_info(files: gistsData[index].files)),
                        );
                      },
                    ),
                  );
                },
              );
            } else {
              return Center(child: Text('No data available'));
            }
          },
        ),
      ),
    );
  }


}


class Gist {
  final String id;
  final String description;
  final List<GistFile> files;
  final String created_d;
  final String updated_d;
  final int comment_c;
  final GistOwner owner;

  Gist({required this.id, required this.description, required this.files, required this.created_d, required this.updated_d, required this.comment_c, required this.owner});

  factory Gist.fromJson(Map<String, dynamic> json) {
    var filesList = (json['files'] as Map<String, dynamic>).values.map((fileJson) {
      return GistFile.fromJson(fileJson);
    }).toList();

    var owner_info = GistOwner.fromJson(json['owner']);


    return Gist(
      id: json['id'],
      description: json['description'] ?? 'No description',
      files: filesList,
      owner: owner_info,
      created_d: json['created_at'],
      updated_d: json['updated_at'],
      comment_c: json['comments'],
    );
  }
}


class GistFile {
  final String filename;
  final String rawUrl;
  final int size;
  final String? language;

  GistFile({required this.filename, required this.rawUrl, required this.size, required this.language});

  factory GistFile.fromJson(Map<String, dynamic> json) {
    return GistFile(
      filename: json['filename'],
      rawUrl: json['raw_url'],
      size: json['size'],
      language: json['language'],
    );
  }
}

class GistOwner {
  final String name;
  final int id;
  final String node_id ;
  final String avatar_url;

  GistOwner({required this.name,required this.id,  required this.node_id, required this.avatar_url});

  factory GistOwner.fromJson(Map<String, dynamic> json) {
    return GistOwner(
      name: json['login'],
      id: json['id'],
      node_id: json['node_id'],
      avatar_url: json['avatar_url']
    );
  }
}

Future<List<Gist>> fetchAndCacheGists(String url, {bool forceRefresh = false}) async {
  final prefs = await SharedPreferences.getInstance();
  final cacheKey = 'gists_cache_key';

  if (!forceRefresh) {

    final cachedData = prefs.getString(cacheKey);
    if (cachedData != null) {
      List jsonData = json.decode(cachedData);
      print('Data loaded from cache');
      return jsonData.map((data) => Gist.fromJson(data)).toList();
    }
  }


  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    List jsonData = json.decode(response.body);


    await prefs.setString(cacheKey, json.encode(jsonData));

    print('Data fetched from API and cached');
    return jsonData.map((data) => Gist.fromJson(data)).toList();
  } else {
    throw Exception('Failed to load gists');
  }
}





// https://api.github.com/gists/public

// https://unsplash.com/developers
