import 'package:flutter/material.dart';
import 'package:infosurvey_example/callingFile.dart';
import 'package:infosurvey_example/tree_model.dart';

import 'intro.dart';
import 'load_questions.dart';
import 'survey_screen.dart';

void main() {
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'InfoSurvey Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
      //  home: const Introduction()
      home:  FutureBuilder<List<Question>>(
        future: loadQuestions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return SurveyPage(questions: snapshot.data!);
          }
        },
      ),
    );
  }
}
