import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:yoga_app/model.dart';

class ThirdPage extends StatefulWidget {
  ThirdPage({super.key, required this.exerciseModel, this.second});
  final ExerciseModel exerciseModel;
  final int? second;

  @override
  State<ThirdPage> createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> {
  late Timer timer;
  int startCount = 0;

  @override
  void initState() {
    // TODO: implement initState
    timer = Timer.periodic(Duration(seconds: 1), (callback) {
      if (timer.tick == widget.second) {
        timer.cancel();
        Future.delayed(Duration(seconds: 2), () {
          Navigator.of(context).pop();
        });
      }
      setState(() {
        startCount = timer.tick;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CachedNetworkImage(
            height: double.infinity,
            width: double.infinity,
            // fit: BoxFit.cover,
            imageUrl: "${widget.exerciseModel.gif}",
            placeholder: (context, url) =>
                Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          Positioned(child: Center(child: Text("${startCount}")))
        ],
      ),
    );
  }
}
