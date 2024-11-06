import 'dart:convert';
import 'package:flutter/services.dart';

import 'tree_model.dart';


Future<List<Question>> loadQuestions() async {
  final String response = await rootBundle.loadString('assets/json/tree_model.json');
  final List<dynamic> data = json.decode(response);
  return data.map((json) => Question.fromJson(json)).toList();
}
