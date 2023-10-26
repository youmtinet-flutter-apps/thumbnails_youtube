import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:thumbnail_youtube/lib.dart';

class HistoricBuilder extends StatelessWidget {
  const HistoricBuilder({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting();
    List<VideoThumbnailMetataData> historic = context.watch<AppProvider>().firebaseHistory;
    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: historic.length,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 300,
        // crossAxisCount: 3,
        crossAxisSpacing: 5.0,
        mainAxisSpacing: .0,
      ),
      itemBuilder: (context, index) {
        VideoThumbnailMetataData vid = historic[(historic.length - (index + 1)) % historic.length];
        var lastuse = DateTime.fromMillisecondsSinceEpoch(vid.lastuse.millisecondsSinceEpoch);
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: InkWell(
            onTap: () async {
              await firestoreStatistics(Incremente.views, vid.videoId, context);
              await addToHistoric(vid.videoId);
              context.read<AppProvider>().addFromLocal(vid);
              context.read<AppProvider>().addView(vid);
              context.read<AppProvider>().setvideoId(vid.videoId);
            },
            child: PhysicalModel(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(20),
              elevation: 12,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                      child: Image(
                        image: NetworkImage(
                          "https://i.ytimg.com/vi/${vid.videoId}/mqdefault.jpg",
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
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          Icon(vid.isLocal ? Icons.folder : Icons.cloud),
                          //
                          const Expanded(child: SizedBox()),
                          //
                          const Icon(CupertinoIcons.cloud_download_fill),
                          Text(
                            vid.downloads.toString(),
                          ),
                          const SizedBox(width: 8),

                          //
                          const Icon(Icons.remove_red_eye),
                          Text(
                            vid.views.toString(),
                          ),
                          const SizedBox(width: 8),
                          //
                          InkWell(
                            onTap: () async {
                              await firestoreStatistics(Incremente.likes, vid.videoId, context);
                              context.read<AppProvider>().addLike(vid);
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(CupertinoIcons.heart_solid),
                                Text(
                                  vid.likes.toString(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        DateFormat.MMMMEEEEd().format(lastuse).toString(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class HistoricIcon extends StatelessWidget {
  const HistoricIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Get.to(() => const HistoricBuilder());
      },
      child: Container(
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(Icons.history_toggle_off),
        ),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey,
        ),
      ),
    );
  }
}
