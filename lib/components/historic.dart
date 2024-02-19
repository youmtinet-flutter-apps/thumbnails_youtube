import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:thumbnail_youtube/lib.dart';

class HistoricFeaturedAll extends StatefulWidget {
  HistoricFeaturedAll({
    super.key,
    this.preview = false,
  });
  final bool preview;

  @override
  State<HistoricFeaturedAll> createState() => _HistoricFeaturedAllState();
}

class _HistoricFeaturedAllState extends State<HistoricFeaturedAll> {
  late Stream<QuerySnapshot> _sataStream;
  //
  @override
  void initState() {
    CollectionReference<Map<String, dynamic>> collection = FirebaseFirestore.instance.collection('statistics');
    if (widget.preview) {
      _sataStream = collection.orderBy('views', descending: true).limit(5).snapshots();
    } else {
      _sataStream = collection.orderBy('views', descending: false).snapshots();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _sataStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData) {
          return Center(child: Text('Loading...'));
        }
        return HistoricBuilder(
          preview: widget.preview,
          historic: snapshot.data?.docs.map(
                (e) {
                  var data = e.data() as Map<String, dynamic>;
                  return VideoThumbnailMetataData.fromJson(
                    data,
                  );
                },
              ).toList() ??
              [],
        );
      },
    );
  }
}

class HistoricBuilder extends StatelessWidget {
  HistoricBuilder({
    Key? key,
    required this.historic,
    this.preview = false,
  }) : super(key: key);
  final bool preview;
  final List<VideoThumbnailMetataData> historic;

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting();
    //  = context.watch<AppProvider>().firebaseHistory;
    return Padding(
      padding: EdgeInsets.all(18.0),
      child: GridView.builder(
        physics: BouncingScrollPhysics(),
        shrinkWrap: preview,
        itemCount: preview ? 5 : historic.length,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 300,
          crossAxisSpacing: 5.0,
          mainAxisSpacing: .0,
        ),
        itemBuilder: (context, index) {
          VideoThumbnailMetataData vid = historic[(historic.length - (index + 1)) % historic.length];
          var lastuse = DateTime.fromMillisecondsSinceEpoch(vid.lastuse.millisecondsSinceEpoch);
          return Padding(
            padding: EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () async {
                await addToHistoric(vid.videoId);
                context.read<AppProvider>().addFromLocal(vid);
                await context.read<AppProvider>().addView(vid, context);
                context.read<AppProvider>().setvideoId(vid.videoId);
              },
              child: PhysicalModel(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(20),
                elevation: 12,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                        child: Image(
                          image: NetworkImage(
                            context.watch<AppProvider>().thumbnail(videoId: vid.videoId, mainView: false),
                          ),
                          errorBuilder: (context, error, stackTrace) {
                            return LimitedBox(
                                child: Image.asset(
                              'assets/launcher.png',
                              width: 50,
                            ));
                          },
                          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child; // Display the image when loading is complete
                            } else {
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            Icon(vid.isLocal ? Icons.folder : Icons.cloud, color: Colors.white),
                            //
                            Expanded(child: SizedBox()),
                            //
                            Icon(CupertinoIcons.cloud_download_fill, color: Colors.white),
                            Text(
                              vid.downloads.toString(),
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(width: 8),

                            //
                            Icon(Icons.remove_red_eye, color: Colors.white),
                            Text(
                              vid.views.toString(),
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(width: 8),
                            //
                            InkWell(
                              onTap: () async {
                                await context.read<AppProvider>().addLike(vid, context);
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(CupertinoIcons.heart_solid, color: Colors.white),
                                  Text(
                                    vid.likes.toString(),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          DateFormat.yMMMMEEEEd().format(lastuse).toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class HistoricIcon extends StatelessWidget {
  HistoricIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        await Get.to(
          () => Scaffold(
            body: HistoricFeaturedAll(),
          ),
        );
      },
      child: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 18),
          child: Icon(
            Icons.history_toggle_off,
            color: Colors.white,
          ),
        ),
        width: Get.width,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
