import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:thumbnail_youtube/utils/firebase_options.dart';

final Future<FirebaseApp> firebaseInitialization = Firebase.initializeApp(
  name: 'VideoThumbnailsViewer',
  options: DefaultFirebaseOptions.currentPlatform,
);
FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
