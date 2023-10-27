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
    this.preview = false,
  }) : super(key: key);
  final bool preview;

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting();
    List<VideoThumbnailMetataData> historic = context.watch<AppProvider>().firebaseHistory;
    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: preview,
      itemCount: preview ? 5 : historic.length,
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
              await addToHistoric(vid.videoId);
              context.read<AppProvider>().addFromLocal(vid);
              await context.read<AppProvider>().addView(vid, context);
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
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          Icon(vid.isLocal ? Icons.folder : Icons.cloud, color: Colors.white),
                          //
                          const Expanded(child: SizedBox()),
                          //
                          const Icon(CupertinoIcons.cloud_download_fill, color: Colors.white),
                          Text(
                            vid.downloads.toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                          const SizedBox(width: 8),

                          //
                          const Icon(Icons.remove_red_eye, color: Colors.white),
                          Text(
                            vid.views.toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                          const SizedBox(width: 8),
                          //
                          InkWell(
                            onTap: () async {
                              await context.read<AppProvider>().addLike(vid, context);
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(CupertinoIcons.heart_solid, color: Colors.white),
                                Text(
                                  vid.likes.toString(),
                                  style: const TextStyle(color: Colors.white),
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
                        style: const TextStyle(color: Colors.white),
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
        Get.to(
          () => const Scaffold(
            body: HistoricBuilder(),
          ),
        );
      },
      child: Container(
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 18),
          child: Icon(
            Icons.history_toggle_off,
            color: Colors.white,
          ),
        ),
        width: Get.width,
        decoration: BoxDecoration(
          color: Get.theme.primaryColor,
        ),
      ),
    );
  }
}
