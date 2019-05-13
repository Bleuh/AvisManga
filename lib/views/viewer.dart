import 'package:archive/archive.dart';
import 'package:file_cache/file_cache.dart';
import 'package:avis_manga/models/manga.dart';
import 'package:avis_manga/data/db.dart';
import 'package:avis_manga/auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  bool currentlyDisplay = true;

  void displayAppBar() {
    if (currentlyDisplay) {
      SystemChrome.setEnabledSystemUIOverlays([]);
    } else {
      SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    }
    setState(() {
      currentlyDisplay = !currentlyDisplay;
    });
  }

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

    return WillPopScope(
      onWillPop: (){
        SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
        setState(() {
          currentlyDisplay = true;
        });
        return Auth.instance.then((auth){
          auth.currentUser.lastTimeRead = DateTime.now();
          return Database.instance.updateUser(auth.currentUser).then((_) => Future.value(true));
        });
      },
      child: Scaffold(
        appBar: currentlyDisplay ? AppBar(
          title: Text("${this.widget.manga.title} - chapitre ${this.widget.chapter + 1}"),
        ) : null,
        body: GestureDetector(
          onTap: displayAppBar,
          child: FutureBuilder(
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
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
