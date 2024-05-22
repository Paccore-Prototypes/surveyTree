import 'dart:collection';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';

class Answers extends StatefulWidget {
  Answers({Key? key, required this.answersMap, required this.scores}) : super(key: key);

  final HashMap<String, dynamic> answersMap;
  final int scores;

  @override
  State<Answers> createState() => _AnswersState();
}

class _AnswersState extends State<Answers> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  var jsonData;

  void parseAnswers() {
    jsonData = JsonEncoder.withIndent('  ').convert(widget.answersMap);
    print('---------------------------------getting all data from answersMap'+jsonData.toString());
  }

  @override
  Widget build(BuildContext context) {
    parseAnswers();

    List<String> questionKeys = widget.answersMap.keys.toList();

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "Survey App",
          style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontFamily: "Roboto"),
        ),
        backgroundColor: Colors.blue.shade800,
        elevation: 3,
        shadowColor: Colors.blueGrey,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20,),
             Center(
              child: Text(
                'Your Survey Score:',
                style: TextStyle(fontSize: 20, color: Colors.green.shade800, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10,),
            Center(child: AnimatedCheck(scores: widget.scores)),
            const SizedBox(height: 20,),
            SizedBox(
              width:MediaQuery.of(context).size.width,
              height: 50,
              child: const Text(
                'Survey Responses',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20,),
            SizedBox(
              height: 450,
              child: ListView.builder(
                itemCount: questionKeys.length,
                itemBuilder: (context, index) {
                  String question = questionKeys[index];
                  dynamic answer = widget.answersMap[question];
                  String answerJson = const JsonEncoder.withIndent('  ').convert(answer);
                  return Card(
                    margin: EdgeInsets.all(10),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${index+1} . $question',
                            style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            answerJson,
                            style: const TextStyle(fontSize: 14),
                          ),
                          // const Divider(), // Add a divider between questions
                        ],
                      ),
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

class AnimatedCheck extends StatefulWidget {
  AnimatedCheck({Key? key, required this.scores}) : super(key: key);

  final int scores;

  @override
  _AnimatedCheckState createState() => _AnimatedCheckState();
}

class _AnimatedCheckState extends State<AnimatedCheck> with TickerProviderStateMixin {
  late AnimationController scaleController = AnimationController(
      duration: const Duration(milliseconds: 2000), vsync: this);
  late Animation<double> scaleAnimation = CurvedAnimation(
      parent: scaleController, curve: Curves.elasticOut);
  late AnimationController checkController = AnimationController(
      duration: const Duration(milliseconds: 1000), vsync: this);
  late Animation<double> checkAnimation = CurvedAnimation(
      parent: checkController, curve: Curves.linear);
  bool showScore = false;

  @override
  void initState() {
    super.initState();
    scaleController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(Duration(seconds: 1), () {
          setState(() {
            showScore = true;
          });
        });
        checkController.forward();
      }
    });
    scaleController.forward();
  }

  @override
  void dispose() {
    scaleController.dispose();
    checkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double circleSize = 100;
    double iconSize = 85;

    return ScaleTransition(
      scale: scaleAnimation,
      child: AnimatedBuilder(
          animation: checkController,
          builder: (context, child) {
            double flip = checkAnimation.value * 180.0;
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY((flip / 180) * pi),
              child: Container(
                height: circleSize,
                width: circleSize,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: SizeTransition(
                  sizeFactor: checkAnimation,
                  axis: Axis.horizontal,
                  axisAlignment: -1,
                  child: AnimatedBuilder(
                    animation: checkController,
                    builder: (context, child) {
                      double flip = checkAnimation.value * 180.0;
                      return Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY((flip / 180) * pi),
                        child: child,
                      );
                    },
                    child: Center(
                      child: showScore ? Text(
                        '${widget.scores}',
                        style: TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold),
                      ) : Icon(
                          Icons.check, color: Colors.white, size: iconSize),
                    ),
                  ),
                ),
              ),
            );
          }
      ),
    );
  }
}
