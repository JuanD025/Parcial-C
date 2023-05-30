import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  VideoPlayerWidget({required this.videoUrl});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _shouldClose = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl);
    _controller.initialize().then((_) {
      setState(() {
        _controller.setVolume(50);
        _controller.play();
        _checkClose();
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _checkClose() async {
    while (!_shouldClose) {
      await Future.delayed(Duration(milliseconds: 500));
      if (_controller.value.isInitialized &&
          _controller.value.position > Duration(seconds: 20)) {
        setState(() {
          _shouldClose = true;
        });
      }
    }
  }

  void _onCloseButtonPressed() {
    if (!_shouldClose) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Anuncio incompleto'),
          content: Text('¿Está seguro de que desea cerrar el anuncio?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Continuar viendo'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Cerrar anuncio'),
            ),
          ],
        ),
      ).then((value) {
        if (value == true) {
          _shouldClose = true;
          print("No ha acabdo el viedeo");
          Navigator.pop(context, false);
        }
      });
    } else {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Anuncio"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            _onCloseButtonPressed();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: _shouldClose
                ? () {
                    _controller.pause();
                    Navigator.of(context).pop(true);
                  }
                : null,
          ),
        ],
      ),
      body: Container(
        color: Colors.black,
        child: Center(
          child: AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          ),
        ),
      ),
    );
  }
}
