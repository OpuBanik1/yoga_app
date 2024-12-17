import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:yoga_app/model.dart';
import 'package:yoga_app/third_page.dart';

// ignore: must_be_immutable
class SecondPage extends StatefulWidget {
  SecondPage({super.key, required this.exerciseModel});
  ExerciseModel exerciseModel;

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  int second = 5;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CachedNetworkImage(
            width: double.infinity,
            fit: BoxFit.cover,
            imageUrl: "${widget.exerciseModel.thumbnail}",
            placeholder: (context, url) =>
                Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          Positioned(
              bottom: 20,
              left: 20,
              right: 25,
              child: SleekCircularSlider(
                min: 5,
                max: 20,
                initialValue: second.toDouble(),
                onChange: (double value) {
                  // callback providing a value while its being changed (with a pan gesture)
                  setState(() {
                    second = value.toInt();
                  });
                },
                // onChangeStart: (double startValue) {
                //   // callback providing a starting value (when a pan gesture starts)
                // },
                // onChangeEnd: (double endValue) {
                //   // ucallback providing an ending value (when a pan gesture ends)
                // },
                innerWidget: (double value) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        ("$second"),
                        style: TextStyle(fontSize: 20, color: Colors.purple),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ThirdPage(
                                    exerciseModel: widget.exerciseModel,
                                    second: second,
                                  )));
                        },
                        child: Text("START"),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange),
                      )
                    ],
                  );
                  // use your custom widget inside the slider (gets a slider value from the callback)
                },
              ))
        ],
      ),
    );
  }
}
