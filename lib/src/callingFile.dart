import 'dart:convert';

import 'package:custom_scale/src/info_survey.dart';
import 'package:custom_scale/src/tree_node.dart';
import 'package:flutter/material.dart';

class ImportingProperties extends StatefulWidget {
  const ImportingProperties({Key? key});

  @override
  State<ImportingProperties> createState() => _ImportingPropertiesState();
}

class _ImportingPropertiesState extends State<ImportingProperties>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  TreeModel? model;
  bool isLoad = false;

  @override
  void initState() {
    super.initState();
    modelJson().then((treeModel) {
      setState(() {
        model = treeModel;
        isLoad = false;
      });
    });
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<TreeModel> modelJson() async {
    setState(() {
      isLoad = true;
    });
    String data = await DefaultAssetBundle.of(context).loadString("assets/survey.json");
    List<Map<String, dynamic>> dataList = List<Map<String, dynamic>>.from(jsonDecode(data));
    TreeModel treeModel = TreeModel.fromJson(dataList);
    return treeModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoad
          ? const CircularProgressIndicator()
          : model != null
          ? InfoSurvey(
        treeModel: model!,
        tileListColor: Colors.blueGrey.shade200,
        showScoreWidget: true,
        surveyResult: (healthScore, answersMap) {
          print('Health Score: $healthScore');
          print('Answers Map: $answersMap');
        },
      )
          : Container(),
    );
  }
}
