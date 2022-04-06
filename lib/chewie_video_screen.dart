import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ChewieVideoScreen extends StatefulWidget {
  const ChewieVideoScreen({Key? key, required this.videoFile})
      : super(key: key);
  final Future<File?> videoFile;

  @override
  State<ChewieVideoScreen> createState() => _ChewieVideoScreenState();
}

class _ChewieVideoScreenState extends State<ChewieVideoScreen> {
  bool initialized = false;
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  @override
  void initState() {
    Future(() async {
      await _initVideo();
      _initChewie();
    });
    super.initState();
  }

  _initVideo() async {
    final video = await widget.videoFile;
    _videoPlayerController = VideoPlayerController.file(video!);
    setState(() {
      initialized = true;
    });

    // Play the video again when it ends
    // ..setLooping(true)
    // // initialize the controller and notify UI when done
    // ..initialize().then((_) => setState(() => initialized = true));
  }

  _initChewie() {
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      aspectRatio: 3 / 2,
      autoPlay: false,
      looping: false,
      // Try playing around with some of these other options:

      //showControls: false,
      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.red,
        handleColor: Colors.blue,
        backgroundColor: Colors.grey,
        bufferedColor: Colors.lightGreen,
      ),
      placeholder: Container(
        color: Colors.grey,
      ),
      autoInitialize: true,
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return initialized
        ? Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Center(
                      child: Chewie(
                        controller: _chewieController,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : const Center(child: CircularProgressIndicator());
  }
}
