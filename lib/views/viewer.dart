import 'package:archive/archive.dart';
import 'package:file_cache/file_cache.dart';
import 'package:avis_manga/models/manga.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ViewerPage extends StatefulWidget {
  final MangaMetadata manga;

  ViewerPage(this.manga);

  @override
  State<StatefulWidget> createState() {
    return ViewerPageState();
  }
}

class ViewerPageState extends State<ViewerPage> {
  static Future<FileCache> cache = FileCache.fromDefault();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var decoder = new ZipDecoder();
    var ref = FirebaseStorage.instance
        .ref()
        .child(this.widget.manga.chapters.first.key);
    var downloadURL = ref.getDownloadURL();
    Future<Archive> chapter = downloadURL.then((url) => cache
            .then((cache) => cache.getBytes(url).then((bytes) {
                  print(url);
                  return decoder.decodeBytes(bytes);
                }))
            .catchError((err) {
          print(err);
        }));
    return Scaffold(
      appBar: AppBar(
        title: Text(this.widget.manga.title),
      ),
      body: FutureBuilder(future: chapter.then((archive) {
        return archive.first.rawContent;
      }), builder: (BuildContext ctx, AsyncSnapshot<InputStream> snap) {
        if (snap.hasData) {
          print("image loaded");
          return Image.memory(snap.data.toUint8List());
        } else {
          return Container();
        }
      }),
    );
  }
}
