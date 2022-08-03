import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import '../utils/clamp.dart';
import '../utils/viewport_painter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:latlng/latlng.dart';
import 'package:map/map.dart';

void consoleLog({required text, int color = 37}) {
  if (kDebugMode) {
    print('\x1B[${color}m $text\x1B[0m');
  }
}

class RasterMapPage extends StatefulWidget {
  const RasterMapPage({Key? key}) : super(key: key);

  @override
  RasterMapPageState createState() => RasterMapPageState();
}

class RasterMapPageState extends State<RasterMapPage> {
  final controller = MapController(
    location: const LatLng(35.68, 51.41),
    zoom: 6,
  );
  bool _darkMode = false;
  Offset? _dragStart;
  double _scaleStart = 1.0;

  void _gotoDefault() {
    controller.center = const LatLng(35.68, 51.41);
    controller.zoom = 14;
    setState(() {});
  }

  void _onDoubleTap(MapTransformer transformer, Offset position) {
    consoleLog(text: position);
    const delta = 0.5;
    final zoom = clamp(controller.zoom + delta, 2, 18);

    transformer.setZoomInPlace(zoom, position);
    setState(() {});
  }

  void _onScaleStart(ScaleStartDetails details) {
    _dragStart = details.focalPoint;
    _scaleStart = 1.0;
  }

  void _onScaleUpdate(ScaleUpdateDetails details, MapTransformer transformer) {
    final scaleDiff = details.scale - _scaleStart;
    _scaleStart = details.scale;

    if (scaleDiff > 0) {
      controller.zoom += 0.02;

      setState(() {});
    } else if (scaleDiff < 0) {
      controller.zoom -= 0.02;
      if (controller.zoom < 1) {
        controller.zoom = 1;
      }
      setState(() {});
    } else {
      final now = details.focalPoint;
      var diff = now - _dragStart!;
      _dragStart = now;
      final h = transformer.constraints.maxHeight;

      final vp = transformer.getViewport();
      if (diff.dy < 0 && vp.bottom - diff.dy < h) {
        diff = Offset(diff.dx, 0);
      }

      if (diff.dy > 0 && vp.top - diff.dy > 0) {
        diff = Offset(diff.dx, 0);
      }

      transformer.drag(diff.dx, diff.dy);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    const duration2 = Duration(milliseconds: 512);
    const String fontFamily2 = 'Surah Names';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Raster Map'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18.0),
            child: AnimatedSwitcher(
              duration: duration2,
              reverseDuration: duration2,
              transitionBuilder: (Widget child, Animation<double> animation) {
                return RotationTransition(
                  turns: animation,
                  child: FadeTransition(
                    opacity: animation,
                    child: ScaleTransition(
                      scale: animation,
                      child: child,
                    ),
                  ),
                );
              },

              /* switchInCurve: Curves.bounceIn,
              switchOutCurve: Curves.bounceOut, */
              child: IconButton(
                key: Key(_darkMode ? 'DarkModeIcon' : 'LightModeIcon'),
                tooltip: 'Toggle Dark Mode',
                onPressed: () {
                  _darkMode = !_darkMode;
                  setState(() {});
                },
                icon: Icon(_darkMode ? Icons.dark_mode : Icons.wb_sunny_outlined),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const Text(
            'لَا أُقْسِمُ بِيَوْمِ الْقِيَامَةِ  وَلَا أُقْسِمُ بِالنَّفْسِ اللَّوَّامَةِ (٢) أَيَحْسَبُالْإِنْسَانُ أَلَّنْ نَجْمَعَ عِظَامَهُ (٣) بَلَى قَادِرِينَ عَلَى أَنْ نُسَوِّيَ بَنَانَهُ (٤) بَلْيُرِيدُ الْإِنْسَانُ لِيَفْجُرَ أَمَامَهُ (٥) يَسْأَلُ أَيَّانَ يَوْمُ الْقِيَامَةِ'
                    '\n' +
                fontFamily2,
            style: TextStyle(
              fontFamily: fontFamily2,
            ),
          ),
          Expanded(
            child: MapLayoutBuilder(
              controller: controller,
              builder: (context, transformer) {
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onDoubleTapDown: (details) => _onDoubleTap(
                    transformer,
                    details.localPosition,
                  ),
                  onTap: () {
                    consoleLog(text: controller.zoom);
                  },
                  onScaleStart: _onScaleStart,
                  onScaleUpdate: (details) => _onScaleUpdate(details, transformer),
                  child: Listener(
                    behavior: HitTestBehavior.opaque,
                    onPointerSignal: (event) {
                      if (event is PointerScrollEvent) {
                        final delta = event.scrollDelta.dy / -1000.0;
                        final zoom = clamp(controller.zoom + delta, 2, 18);

                        transformer.setZoomInPlace(zoom, event.localPosition);
                        setState(() {});
                      }
                    },
                    child: Stack(
                      children: [
                        Map(
                          controller: controller,
                          builder: builder,
                        ),
                        CustomPaint(
                          painter: ViewportPainter(
                            transformer.getViewport(),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _gotoDefault,
        tooltip: 'My Location',
        child: const Icon(Icons.my_location),
      ),
    );
  }

  Widget builder(context, x, y, z) {
    final tilesInZoom = pow(2.0, z).floor();

    while (x < 0) {
      x += tilesInZoom;
    }
    while (y < 0) {
      y += tilesInZoom;
    }

    x %= tilesInZoom;
    y %= tilesInZoom;

    //Legal notice: This url is only used for demo and educational purposes. You need a license key for production use.

    //Google Maps
    var s = 'https://services.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/';
    var t = '${s}tile/$z/$y/$x';
    final google = 'http://mt0.google.com/vt/lyrs=m&x=$x&y=$y&z=$z';
    final light = 'https://cartodb-basemaps-b.global.ssl.fastly.net/light_all/$z/$x/$y.png';
    final url = 'https://cartodb-basemaps-b.global.ssl.fastly.net/dark_all/$z/$x/$y.png';

    final darkUrl = 'https://a.tile.openstreetmap.org/$z/$x/$y.png';
    //
    final url1 =
        'https://www.google.com/maps/vt/pb=!1m4!1m3!1i$z!2i$x!3i$y!2m3!1e0!2sm!3i420120488!3m7!2sen!5e1105!12m4!1e68!2m2!1sset!2sRoadmap!4e0!5m1!1e0!23i4111425';
    final String _darkUrl2 =
        'https://maps.googleapis.com/maps/vt?pb=!1m5!1m4!1i$z!2i$x!3i$y!4i256!2m3!1e0!2sm!3i556279080!3m17!2sen-US!3sUS!5e18!12m4!1e68!2m2!1sset!2sRoadmap!12m3!1e37!2m1!1ssmartmaps!12m4!1e26!2m2!1sstyles!2zcC52Om9uLHMuZTpsfHAudjpvZmZ8cC5zOi0xMDAscy5lOmwudC5mfHAuczozNnxwLmM6I2ZmMDAwMDAwfHAubDo0MHxwLnY6b2ZmLHMuZTpsLnQuc3xwLnY6b2ZmfHAuYzojZmYwMDAwMDB8cC5sOjE2LHMuZTpsLml8cC52Om9mZixzLnQ6MXxzLmU6Zy5mfHAuYzojZmYwMDAwMDB8cC5sOjIwLHMudDoxfHMuZTpnLnN8cC5jOiNmZjAwMDAwMHxwLmw6MTd8cC53OjEuMixzLnQ6NXxzLmU6Z3xwLmM6I2ZmMDAwMDAwfHAubDoyMCxzLnQ6NXxzLmU6Zy5mfHAuYzojZmY0ZDYwNTkscy50OjV8cy5lOmcuc3xwLmM6I2ZmNGQ2MDU5LHMudDo4MnxzLmU6Zy5mfHAuYzojZmY0ZDYwNTkscy50OjJ8cy5lOmd8cC5sOjIxLHMudDoyfHMuZTpnLmZ8cC5jOiNmZjRkNjA1OSxzLnQ6MnxzLmU6Zy5zfHAuYzojZmY0ZDYwNTkscy50OjN8cy5lOmd8cC52Om9ufHAuYzojZmY3ZjhkODkscy50OjN8cy5lOmcuZnxwLmM6I2ZmN2Y4ZDg5LHMudDo0OXxzLmU6Zy5mfHAuYzojZmY3ZjhkODl8cC5sOjE3LHMudDo0OXxzLmU6Zy5zfHAuYzojZmY3ZjhkODl8cC5sOjI5fHAudzowLjIscy50OjUwfHMuZTpnfHAuYzojZmYwMDAwMDB8cC5sOjE4LHMudDo1MHxzLmU6Zy5mfHAuYzojZmY3ZjhkODkscy50OjUwfHMuZTpnLnN8cC5jOiNmZjdmOGQ4OSxzLnQ6NTF8cy5lOmd8cC5jOiNmZjAwMDAwMHxwLmw6MTYscy50OjUxfHMuZTpnLmZ8cC5jOiNmZjdmOGQ4OSxzLnQ6NTF8cy5lOmcuc3xwLmM6I2ZmN2Y4ZDg5LHMudDo0fHMuZTpnfHAuYzojZmYwMDAwMDB8cC5sOjE5LHMudDo2fHAuYzojZmYyYjM2Mzh8cC52Om9uLHMudDo2fHMuZTpnfHAuYzojZmYyYjM2Mzh8cC5sOjE3LHMudDo2fHMuZTpnLmZ8cC5jOiNmZjI0MjgyYixzLnQ6NnxzLmU6Zy5zfHAuYzojZmYyNDI4MmIscy50OjZ8cy5lOmx8cC52Om9mZixzLnQ6NnxzLmU6bC50fHAudjpvZmYscy50OjZ8cy5lOmwudC5mfHAudjpvZmYscy50OjZ8cy5lOmwudC5zfHAudjpvZmYscy50OjZ8cy5lOmwuaXxwLnY6b2Zm!4e0';
    //Mapbox Streets
    // final url =
    //     'https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/$z/$x/$y?access_token=YOUR_MAPBOX_ACCESS_TOKEN';

    return CachedNetworkImage(
      imageUrl: _darkMode ? darkUrl : url,
      fit: BoxFit.cover,
    );
  }
}
