import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:thumbnail_youtube/lib.dart';

class HistoricFeaturedAll extends StatefulWidget {
  HistoricFeaturedAll({Key? key, this.preview = false}) : super(key: key);
  final bool preview;

  @override
  State<HistoricFeaturedAll> createState() => _HistoricFeaturedAllState();
}

class _HistoricFeaturedAllState extends State<HistoricFeaturedAll> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> _sataStream;
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
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: _sataStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData) {
          return Center(child: Text('Loading...'));
        }
        return HistoricBuilder(
          preview: widget.preview,
          historic:
              snapshot.data?.docs.map((QueryDocumentSnapshot<Map<String, dynamic>> e) {
                Map<String, dynamic> data = e.data();
                return VideoThumbnailMetataData.fromJson(data);
              }).toList() ??
              <VideoThumbnailMetataData>[],
        );
      },
    );
  }
}

class HistoricBuilder extends StatefulWidget {
  HistoricBuilder({Key? key, required this.historic, this.preview = false}) : super(key: key);
  final bool preview;
  final List<VideoThumbnailMetataData> historic;

  @override
  State<HistoricBuilder> createState() => _HistoricBuilderState();
}

class _HistoricBuilderState extends State<HistoricBuilder> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await initializeDateFormatting();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> listWidgets = List<Widget>.generate(widget.preview ? 5 : widget.historic.length, (int index) => _gridChildrenBuilder(index, widget.preview));
    List<Widget> listCouples = listWidgets.mapFoldedGeneralized((int index, List<Widget> items) => Row(children: items.map((Widget e) => Expanded(child: e)).toList()), 2, 0).toList();

    //  = context.watch<AppProvider>().firebaseHistory;
    /* return Padding(
      padding: EdgeInsets.all(8.0),
      child: GridView.builder(
        physics: BouncingScrollPhysics(),
        shrinkWrap: preview,
        itemCount: preview ? 5 : historic.length,

        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 180,
          crossAxisSpacing: .0,
          mainAxisSpacing: .0,
          childAspectRatio: .88,
        ),
        itemBuilder: _gridChildrenBuilder,
        // childrenDelegate: SliverChildBuilderDelegate(_gridChildrenBuilder),
      ),
    ); */
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: ListView.separated(
        separatorBuilder: (BuildContext context, int index) {
          return index % 8 == 4 ? ReusableInlineBanner() : SizedBox();
        },
        physics: BouncingScrollPhysics(),
        shrinkWrap: widget.preview,
        itemBuilder: (BuildContext context, int index) => listCouples.elementAt(index),
        itemCount: listCouples.length,
        // childrenDelegate: SliverChildBuilderDelegate(_gridChildrenBuilder),
      ),
    );
  }

  Widget _gridChildrenBuilder(int index, bool preview) {
    int index2 = (widget.historic.length - (index + 1)) % widget.historic.length;
    VideoThumbnailMetataData vid = widget.historic[index2];
    DateTime lastuse = DateTime.fromMillisecondsSinceEpoch(vid.lastuse.millisecondsSinceEpoch);
    return Builder(
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () async {
              try {
                context.read<AppProvider>().setLoading(true);
                context.read<AppProvider>().setResolution(RsolutionEnum.mqdefault);
                List<ResStatusCode> resulutionsStatuses = await Future.wait(
                  //
                  RsolutionEnum.values.map((RsolutionEnum e) => resolutionStatus(e, vid.videoId)),
                );
                List<ResStatusCode> available = resulutionsStatuses.where((ResStatusCode e) => e.statusCode == 200).toList();
                context.read<AppProvider>().setAvailableChoices(available.map((ResStatusCode e) => e.resoluton).toList());
                bool isAdsTime = context.read<AppProvider>().isAdsTime;
                if (isAdsTime) {
                  final GlobalKey<ReusableInterstitialAdsState> _globalKey = GlobalKey<ReusableInterstitialAdsState>();
                  await Get.dialog(
                    AlertDialog(
                      title: Text('Publicité'),
                      content: Text("Une publicité va être affichée avant de charger la vidéo"),
                      backgroundColor: context.theme.colorScheme.surface,
                      actions: <Widget>[
                        TextButton(
                          onPressed: () async {
                            Get.back();
                          },
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                  await context.read<AppProvider>().updateAdsTime();
                  await _globalKey.currentState?.showInterstitialAdIfAvailable();
                }
                await addToHistoric(vid.videoId);
                context.read<AppProvider>().addFromLocal(vid);
                await context.read<AppProvider>().addView(vid, context);
                context.read<AppProvider>().setvideoId(vid.videoId);
                context.read<AppProvider>().setLoading(false);

                if (!preview) {
                  Get.back();
                }
              } catch (e) {
                context.read<AppProvider>().setLoading(false);
                appSnackbar(context, 'Error', "Une erreur s'est produite lors du chargement de la vidéo");
              }
            },
            child: PhysicalModel(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(20),
              elevation: 12,
              child: LimitedBox(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                        // decoration: BoxDecoration(borderRadius: BorderRadius.circular(28)),
                        child: Image(
                          image: NetworkImage(context.watch<AppProvider>().thumbnail(videoId: vid.videoId, mainView: false)),
                          errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                            return LimitedBox(child: Image.asset('assets/launcher.png', width: 50));
                          },
                          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child; // Display the image when loading is complete
                            } else {
                              return Center(child: CircularProgressIndicator(value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null));
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          children: <Widget>[
                            Icon(vid.isLocal ? Icons.folder : Icons.cloud, color: Colors.white, size: 16),
                            //
                            Expanded(child: SizedBox()),
                            //
                            Icon(CupertinoIcons.cloud_download_fill, color: Colors.white, size: 16),
                            Text(vid.downloads.toString(), style: TextStyle(color: Colors.white)),
                            SizedBox(width: 8),

                            //
                            Icon(Icons.remove_red_eye, color: Colors.white, size: 16),
                            Text(vid.views.toString(), style: TextStyle(color: Colors.white)),
                            SizedBox(width: 8),
                            //
                            InkWell(
                              onTap: () async {
                                try {
                                  context.read<AppProvider>().setLoading(true);
                                  await context.read<AppProvider>().addLike(vid, context);
                                  context.read<AppProvider>().setLoading(false);
                                } catch (e) {
                                  context.read<AppProvider>().setLoading(false);
                                  appSnackbar(context, 'Error', "Une erreur s'est produite lors du chargement de la vidéo");
                                }
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Icon(CupertinoIcons.heart_solid, color: Colors.white, size: 16),
                                  Text(vid.likes.toString(), style: TextStyle(color: Colors.white)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(DateFormat.yMMMMEEEEd().format(lastuse).toString(), style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class AllHistory extends StatelessWidget {
  const AllHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return StackLoading(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Historique complet'),
          centerTitle: true,
          elevation: 0,
          titleTextStyle: TextStyle(color: Theme.of(context).textTheme.titleLarge?.color),
        ),

        backgroundColor: Colors.transparent,
        body: HistoricFeaturedAll(),
      ),
    );
  }
}

class HistoricIcon extends StatelessWidget {
  HistoricIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        await Get.to(() => AllHistory());
      },
      child: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 18),
          child: Icon(Icons.history_toggle_off, color: Colors.white),
        ),
        width: Get.width,
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
      ),
    );
  }
}
