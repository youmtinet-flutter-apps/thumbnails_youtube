import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:thumbnail_youtube/l10n/app_localizations.dart';
import 'package:thumbnail_youtube/lib.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(const ThumbHubApp());

class ThumbHubApp extends StatelessWidget {
  const ThumbHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (BuildContext context) => context.l10n.thumbHubTitle,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        //
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(brightness: Brightness.dark, primarySwatch: Colors.deepPurple, scaffoldBackgroundColor: const Color(0xFF0F0F1A), cardColor: const Color(0xFF1E1E2C)),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _urlController = TextEditingController();

  // Mock data for the Hub
  final List<Map<String, String>> _hubThumbnails = List<Map<String, String>>.generate(
    10,
    (int index) => <String, String>{
      'id': 'dQw4w9WgXcQ', // Classic Rick Roll
      'title': 'Viral Video Thumbnail ${index + 1}',
      'views': '${(index + 1) * 12}K',
      'likes': '${index * 5}0',
    },
  );

  Future<void> _fetchFromClipboard() async {
    ClipboardData? data = await Clipboard.getData('text/plain');
    if (data != null && data.text!.contains('youtube.com')) {
      setState(() {
        _urlController.text = data.text!;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.l10n.youtubeUrlDetected)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.thumbHubAppBarTitle, style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: <Widget>[
            // URL Input Section
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(15)),
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _urlController,
                    decoration: InputDecoration(
                      hintText: context.l10n.pasteUrlHereHint,
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.link, color: Colors.blueAccent),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _fetchFromClipboard,
                          icon: const Icon(Icons.assignment_returned),
                          label: Text(context.l10n.pasteFromClipboard),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[800]),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Logic to extract ID and navigate
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                          child: Text(context.l10n.fetchThumb),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Hub Header
            Row(
              children: <Widget>[
                Icon(Icons.whatshot, color: Colors.orange),
                const SizedBox(width: 8),
                Text(context.l10n.communityHub, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            // Grid of Thumbnails
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  // Grid with max cross axis extent, spacing, and aspect ratio for thumbnails
                  maxCrossAxisExtent: 200,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.2, // 16:9 aspect ratio for YouTube thumbnails
                ),
                itemCount: _hubThumbnails.length,
                itemBuilder: (BuildContext context, int index) {
                  final Map<String, String> thumb = _hubThumbnails[index];
                  return GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute<void>(builder: (BuildContext context) => DetailScreen(id: thumb['id']!))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network('https://img.youtube.com/vi/${thumb['id']}/mqdefault.jpg', fit: BoxFit.cover),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(context.l10n.viewsLabel(thumb['views'] ?? ''), style: const TextStyle(fontSize: 12, color: Colors.grey)),
                            const Icon(Icons.favorite_border, size: 14, color: Colors.grey),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final String id;
  const DetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.maxResPreview)),
      body: Column(
        children: <Widget>[
          Expanded(
            child: InteractiveViewer(
              child: Image.network(
                'https://img.youtube.com/vi/$id/maxresdefault.jpg',
                loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? progress) {
                  if (progress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(context.l10n.selectQuality, style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <String>[context.l10n.qualityHd, context.l10n.qualitySd, context.l10n.qualityNormal].map((String q) => ActionChip(label: Text(q), onPressed: () {})).toList(),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () => launchUrl(Uri.parse('https://www.youtube.com/watch?v=$id')),
                    icon: const Icon(Icons.play_circle_fill),
                    label: Text(context.l10n.launchVideoInYoutube),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.download), label: Text(context.l10n.saveToGallery)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
