import 'dart:convert';
import 'dart:html' as html;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:yoga_app/model.dart';
import 'package:yoga_app/second_page.dart';
import 'package:yoga_app/toastmessage.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    fetchData();
    // TODO: implement initState
    super.initState();
  }

  String link =
      'https://raw.githubusercontent.com/codeifitech/fitness-app/master/exercises.json?fbclid=IwAR2gsu4SRvRRFkHK8JPTWHZXmaNP0dtp0G6h7ep4zQp7WaamX5S1UaSrc3A';
  List<ExerciseModel> allData = [];
  late ExerciseModel exerciseModel;
  bool isLoading = false;
  fetchData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var response = await http.get(Uri.parse(link));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        for (var i in data["exercises"]) {
          exerciseModel = ExerciseModel(
              id: i["id"],
              thumbnail: i["thumbnail"],
              gif: i["gif"],
              title: i["title"],
              seconds: i["seconds"]);
          setState(() {
            allData.add(exerciseModel);
          });
        }
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e);
      showToast("Something wrong $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading == true,
      blur: 0.5,
      opacity: 0.5,
      progressIndicator: CircularProgressIndicator(),
      child: Scaffold(
        body: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: allData.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          SecondPage(exerciseModel: allData[index])));
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  height: 100,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          width: double.infinity,
                          fit: BoxFit.cover,
                          imageUrl: "${allData[index].thumbnail}",
                          placeholder: (context, url) =>
                              Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      ),
                      Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 60,
                            alignment: Alignment.bottomLeft,
                            padding: EdgeInsets.symmetric(
                                horizontal: 166, vertical: 16),
                            child: Text(
                              "${allData[index].title}",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [
                                  Colors.black,
                                  Colors.black54,
                                  Colors.transparent
                                ],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter)),
                          ))
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
