import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:thumbnail_youtube/utils/firebase_options.dart';
import 'package:flutter/material.dart';

class AnimatedOrientationExample extends StatefulWidget {
  AnimatedOrientationExample({super.key});

  @override
  _AnimatedOrientationExampleState createState() => _AnimatedOrientationExampleState();
}

class _AnimatedOrientationExampleState extends State<AnimatedOrientationExample> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);

    // Listen to orientation changes
    if (!mounted) return;
    MediaQuery.of(context).orientation;

    // Add listener to animation to trigger state update on each frame
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get the current orientation
    var orientation = MediaQuery.of(context).orientation;

    // Update the animation based on the orientation
    if (orientation == Orientation.portrait) {
      _controller.reverse();
    } else {
      _controller.forward();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Animated Orientation Example'),
      ),
      body: Center(
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Transform.rotate(
              angle: _animation.value * (orientation == Orientation.portrait ? 0 : 1) * 3.14,
              child: Container(
                width: 200,
                height: 200,
                color: Colors.blue,
                child: Center(
                  child: Text(
                    'Rotate Me!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

final Future<FirebaseApp> firebaseInitialization = Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
