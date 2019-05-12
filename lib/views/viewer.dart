import 'package:archive/archive.dart';
import 'package:file_cache/file_cache.dart';
import 'package:avis_manga/models/manga.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ViewerPage extends StatefulWidget {
  final MangaMetadata manga;
  final int chapter;

  ViewerPage(this.manga, this.chapter);

  @override
  State<StatefulWidget> createState() {
    return ViewerPageState();
  }
}

class ViewerPageState extends State<ViewerPage>
    with SingleTickerProviderStateMixin {
  static Future<FileCache> cache = FileCache.fromDefault();
  double itemWidth;

  Future<Archive> chapter;

  @override
  void initState() {
    super.initState();

    var decoder = new ZipDecoder();
    var ref = FirebaseStorage.instance
        .ref()
        .child(this.widget.manga.chapters[widget.chapter].key);
    var downloadURL = ref.getDownloadURL();
    chapter = downloadURL.then((url) => cache
            .then((cache) => cache.getBytes(url).then((bytes) {
                  print(url);
                  return decoder.decodeBytes(bytes);
                }))
            .catchError((err) {
          print(err);
        }));
  }

  @override
  Widget build(BuildContext context) {
    itemWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(this.widget.manga.title),
      ),
      body: FutureBuilder(
          future: chapter,
          builder: (BuildContext ctx, AsyncSnapshot<Archive> snap) {
            if (snap.hasData) {
              print("image loaded");
              return Container(
                padding: EdgeInsets.all(0),
                child: PageView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    var file = snap.data[index];
                    return Image.memory(file.rawContent.toUint8List());
                  },
                  scrollDirection: Axis.horizontal,
                ),
              );
            } else {
              return Container(
                child: Column(
                  children: <Widget>[
                    CircularProgressIndicator(),
                    new Container(
                      height: 8.0,
                    ),
                    Text("loading...")
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                ),
                alignment: Alignment.center,
              );
            }
          }),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
