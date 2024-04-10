import 'dart:collection';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:infosurvey/tree_node.dart';
import 'package:infosurvey/utils/imageparser.dart';
import 'package:infosurvey/widgets/drop_down.dart';
import 'package:infosurvey/widgets/search_item.dart';
import 'package:infosurvey/widgets/slider.dart';
import '../answers.dart';
import 'enum.dart';

class InfoSurvey extends StatefulWidget {
  InfoSurvey(
      {super.key,
      this.radioTextColor,
      this.dropDownColor,
      this.dropDownHeight,
      this.dropDownWidth,
      this.answerDescriptionStyle,
      this.dateTimeButton,
      this.activeCheckboxColor,
      this.sliderQuestionStyle,
      this.questionContentAlignment,
      this.radioQuestion,
      this.listTileQuestionStyle,
      this.checkBoxQuestionStyle,
      this.dateTimeQuestionStyle,
      this.customButton,
      this.customLastButton,
      required this.treeModel,
      this.optionRadioStyle,
      this.optionCheckBoxStyle,
      this.optionListTileStyle,
      this.activeColorSlider,
      this.inactiveColorSlider,
      this.activeRadioColor,
      // this.activeRadioTextColor,
      this.tileListColor,
      this.textFieldQuestionStyle,
      this.buttonTextStyle,
      // this.buttonText,
      //   this.buttonDecoration,
      this.submitSurveyPopup,
      this.surveyResult,
      required this.showScoreWidget,
      this.description,
      this.customSkipStyle,
      // this.imageContainer,
      //this.customSizedBox,
      this.onListTaleTapnavigation = true,
      this.optionTapNavigation = true,
      this.imagePlaceHolder,
      //   this.appBarTitleWidget,
      this.onPageChanged,
      this.onSurveyEnd,
      //  this.isAppBarVisible=true,
      // this.imagePlace,
      this.listTileShape,
      this.skipText,
      //    this.appBarBackgroundColor,
      //  this.appBarIconThemeData,

      this.dropDownDecoration,
      //    this.appBarBackgroundColor,
      //  this.appBarIconThemeData,
      this.dropDownQuestionStyle,
      this.optionImageHeight,
      this.optionImageWidth,
      this.customWidget,
      this.customWidgetReturn,
      this.searchTextFieldStyle,
      this.searchTextFieldWidth,
      this.searchItemQuestionStyle});

  Widget? dateTimeButton;
  double? dropDownHeight;
  double? dropDownWidth;
  TextStyle? answerDescriptionStyle;
  Color? radioTextColor;
  Color? dropDownColor;
  Color? activeCheckboxColor;
  TextStyle? sliderQuestionStyle;
  TextStyle? radioQuestion;
  TextStyle? listTileQuestionStyle;
  TextStyle? checkBoxQuestionStyle;
  TextStyle? dateTimeQuestionStyle;
  Widget? customButton;
  Widget? customLastButton;
  TreeModel treeModel;
  TextStyle? optionRadioStyle;
  TextStyle? optionListTileStyle;
  TextStyle? optionCheckBoxStyle;
  Color? activeColorSlider;
  bool optionTapNavigation;
  Color? inactiveColorSlider;
  Color? activeRadioColor;

  // Color? activeRadioTextColor;
  Color? tileListColor;

  CrossAxisAlignment? questionContentAlignment;
  TextStyle? textFieldQuestionStyle;
  TextStyle? buttonTextStyle;
  InputDecoration? textFieldDecoration;
  BoxDecoration? dropDownDecoration;
  TextStyle? dropDownQuestionStyle;
  TextStyle? searchItemQuestionStyle;
  double? optionImageHeight;
  double? optionImageWidth;
  Widget? customWidget;
  Function(int? questionId, String? question, List<String>? answer)?
      customWidgetReturn;

  // bool isAppBarVisible=true;
  Function(
    HashMap<String, dynamic> answersMap,
    TreeNode? questionsData,
    int pageIndex,
  )? onPageChanged;
  Function(int healthScore, HashMap<String, dynamic> answersMap)? onSurveyEnd;
  AlertDialog? submitSurveyPopup;
  Function(int healthScore, HashMap<String, dynamic> answersMap)? surveyResult;
  bool showScoreWidget;

  // Widget? appBarTitleWidget;
  String? imagePlaceHolder;

  TextStyle? description;
  TextStyle? customSkipStyle;

  // Container? imageContainer;
//  SizedBox? customSizedBox;
  // EdgeInsets? imagePlace;
  bool onListTaleTapnavigation;
  RoundedRectangleBorder? listTileShape;
  String? skipText;
  Function(String answer, String question, int score)? onCustomWidgetNextTapped;
  TextStyle? searchTextFieldStyle;
  double? searchTextFieldWidth;

//  Color? appBarBackgroundColor;
  //IconThemeData? appBarIconThemeData;

  @override
  State<InfoSurvey> createState() => InfoSurveyState();
}

class InfoSurveyState extends State<InfoSurvey> {
  // late AnimationController scaleController = AnimationController(
  //     duration: const Duration(milliseconds: 2000), vsync: this);
  // late Animation<double> scaleAnimation =
  //     CurvedAnimation(parent: scaleController, curve: Curves.elasticOut);
  // late AnimationController checkController = AnimationController(
  //     duration: const Duration(milliseconds: 1000), vsync: this);
  // late Animation<double> checkAnimation =
  //     CurvedAnimation(parent: checkController, curve: Curves.linear);
  int currentDataIndex = 0;
  int currentMainChildrenlistIndex = 0;
  bool isLast = false;
  Map<String, dynamic> scoreMap = {};
  int sumOfScores = 0;
  bool isLoad = false;
  TreeModel? pageviewTree;
  TreeNode? node;
  final GlobalKey _scafoldKey = GlobalKey<ScaffoldState>();
  Function(HashMap<String, dynamic>)? answerMap;
  HashMap<String, dynamic> answersMap = HashMap();
  Map<int, TextEditingController> textControllers = {};
  List<Map<String, dynamic>>? jsonResult;

  Map<String, dynamic>? listAnswer;

  void onCustomWidgetNextTapped(
      int questionId, dynamic answerdata, String question, int score) {
    addTheFollowUpQuestion(answerdata,
        isScrollTonextPage: true,
        question: question,
        isNestedchoice: true,
        answeValue: {
          'id': questionId,
          'question-type': 'custom_widget',
          'score': score ?? 0,
          'answer': answerdata
        });
  }

  Future<void> modelJson() async {
    setState(() {
      isLoad = true;
    });
    try {
      // final String data = await rootBundle.loadString("assets/survey.json");
      // final List<Map<String, dynamic>> dataList = List<Map<String, dynamic>>.from(jsonDecode(data));
      //
      // widget.treeModel = TreeModel.fromJson(dataList);

      if (widget.treeModel != null) {
        pageviewTree = TreeModel(widget.treeModel!.nodes);
        pageviewTree!.nodes = [];
        pageviewTree!.nodes.add(widget.treeModel!.nodes[0]);
      }
    } catch (e) {
      print('Error loading JSON: $e');
    } finally {
      setState(() {
        isLoad = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    modelJson();
    // _controller = AnimationController(
    //     vsync: this,
    //     lowerBound: 0.5,
    //     duration: const Duration(seconds: 3),
    //     reverseDuration: const Duration(seconds: 3))
    //   ..repeat();
  }

  TextEditingController nameController = TextEditingController();
  List<String> answers = [];
  String? selectedValue;
  List<Map<String, dynamic>> followUpQuestions = [];
  PageController pageController = PageController();
  int currentQuestionIndex = 0;

  void resetOption() {
    if (pageController.page?.toInt() == 0) {
      answersMap.clear();
    }
  }

  void sumOfScoresData() {
    sumOfScores = 0;
    answersMap.forEach((key, value) {
      if (value['score'] != null && value['score'] is int) {
        sumOfScores += value['score'] as int;
      }
    });
    setState(() {});
  }

  @override
  void dispose() {
    // scaleController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // customWidgetReturnMain: (questionId, question, answers) {
    //   if (widget.customWidgetReturn != null) {
    //     widget.customWidgetReturn!(questionId, question, answers);
    //     print('----------checking whether custom widget working or not $answers');
    //   }
    // };
    ImagePosition refEnum = ImagePosition.top;
    return SafeArea(
      child: Theme(
        data: ThemeData(primaryColor: Colors.transparent),
        child: WillPopScope(
          onWillPop: () async {
            if (pageController.page?.toInt() == 0) {
              Navigator.pop(context);
            } else {
              answers = [];
              answerdata = '';
              answerDescription = '';
              pageController.previousPage(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.ease);
              if (pageviewTree != null) {
                isLast = false;
                if (pageController.page?.toInt() == 0) {
                } else {
                  removeTheNode();
                  setState(() {});
                }
              }
            }
            return false;
          },
          child: isLoad
              ? const Center(child: CircularProgressIndicator())
              : SizedBox(
                  //   width: MediaQuery.of(context).size.width,
                  // height: MediaQuery.of(context).size.height,
                  //  color: Colors.transparent,
                  child: PageView.builder(
                    onPageChanged: (page) {
                      if (widget.onPageChanged != null) {
                        Future.delayed(const Duration(milliseconds: 500), () {
                          widget.onPageChanged!(
                            answersMap,
                            pageviewTree?.nodes[pageController.page!.toInt()],
                            page,
                          );
                          print(
                              '-----------------------printing index with question data ${pageviewTree?.nodes[pageController.page!.toInt()].question}');
                        });
                      }
                    },
                    physics: const NeverScrollableScrollPhysics(),
                    controller: pageController,
                    itemCount: pageviewTree?.nodes.length ?? 0,
                    itemBuilder: (context, index) {
                      return buildQuestion(
                        pageviewTree!.nodes,
                        index,
                      );
                    },
                  ),
                ),
        ),
      ),
    );
  }

  Widget? buildQuestion(
    List<TreeNode> data,
    int pageIndex,
  ) {
    String questionType = data[pageIndex].questionType;
    switch (questionType) {
      case "radio":
        return buildRadioQuestion(data[pageIndex], pageIndex);
      case "slider":
        return CustomSlider(
          isLast: isLast,
          questionData: data[pageIndex],
          customButton: widget.customButton,
          questionContentAlignment: widget.questionContentAlignment,
          customLastButton: widget.customLastButton,
          callBack: (
            data,
            callingBackData,
            fromSkip,
          ) {
            print(
                '-----------------------------------building the drop down$data');
            if (callingBackData != null) {
              if (callingBackData.isMandatory == true) {
                if (data!.isEmpty) {
                  ScaffoldMessenger.maybeOf(context)!.showSnackBar(
                    const SnackBar(content: Text('Please provide an answer')),
                  );
                  return; // Exit the onTap function to prevent further action
                }
              }
              if (isLast) {
                answersMap[callingBackData.question] = {
                  'id': callingBackData.id,
                  'question-type': callingBackData.questionType,
                  'score': callingBackData.score,
                  'answer': data
                };

                sumOfScoresData();

                ScaffoldMessenger.maybeOf(context)!.showSnackBar(
                    SnackBar(content: Text('Your Score Is $sumOfScores')));

                if (widget.onSurveyEnd != null) {
                  widget.onSurveyEnd!(sumOfScores, answersMap);
                } else {
                  _showSubmitDialog();
                }

                //show Popup Dialog here
              } else {
                addTheFollowUpQuestion(
                    data!.isEmpty || data == null ? '' : data,
                    isNestedchoice: true,
                    question: callingBackData.question,
                    answeValue: {
                      'id': callingBackData.id,
                      'question-type': callingBackData.questionType,
                      'score': callingBackData.answerChoices == null
                          ? 0
                          : callingBackData.score,
                      'answer': data.isEmpty || data == null ? '' : data,
                    });
                pageController.nextPage(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              }
            }
          },
        );
      case "multipleChoices":
        return buildMultipleChoicesQuestion(data[pageIndex]);
      case "datetime":
        return buildDateTimeQuestion(data[pageIndex]);
      case "list":
        return buildLIstQuestioins(data[pageIndex]);
      case "text-field":
        return buildTextQuestion(data[pageIndex], pageIndex);
      case "custom_widget":
        return widget.customWidget;
      case "drop_down":
        return DropDown(
          dropDownQuestionStyle: widget.dropDownQuestionStyle,
          descriptionStyle: widget.description,
          answerMap: answersMap,
          skipText: widget.skipText,
          customSkipStyle: widget.customSkipStyle,
          dropDownDecoration: widget.dropDownDecoration,
          customButton: widget.customButton,
          questionContentAlignment: widget.questionContentAlignment,
          customLastButton: widget.customLastButton,
          dropDownColor: widget.dropDownColor,
          isLast: isLast,
          questionData: data[pageIndex],
          imagePlaceHolder: widget.imagePlaceHolder,
          dropDownHeight: widget.dropDownHeight,
          dropDownWidth: widget.dropDownWidth,
          callBack: (
            data,
            callingBackData,
            fromSkip,
          ) {
            print(
                '-----------------------------------building the drop down$data');
            if (callingBackData != null) {
              if (callingBackData.isMandatory == true) {
                if (data!.isEmpty) {
                  ScaffoldMessenger.maybeOf(context)!.showSnackBar(
                    const SnackBar(content: Text('Please provide an answer')),
                  );
                  return; // Exit the onTap function to prevent further action
                }
              }
              if (isLast) {
                answersMap[callingBackData.question] = {
                  'id': callingBackData.id,
                  'question-type': callingBackData.questionType,
                  'score': callingBackData.score,
                  'answer': data
                };

                sumOfScoresData();

                ScaffoldMessenger.maybeOf(context)!.showSnackBar(
                    SnackBar(content: Text('Your Score Is $sumOfScores')));

                if (widget.onSurveyEnd != null) {
                  widget.onSurveyEnd!(sumOfScores, answersMap);
                } else {
                  _showSubmitDialog();
                }

                //show Popup Dialog here
              } else {
                addTheFollowUpQuestion(
                    data!.isEmpty || data == null ? '' : data,
                    isNestedchoice: true,
                    question: callingBackData.question,
                    answeValue: {
                      'id': callingBackData.id,
                      'question-type': callingBackData.questionType,
                      'score': callingBackData.answerChoices == null
                          ? 0
                          : callingBackData.score,
                      'answer': data.isEmpty || data == null ? '' : data,
                    });
                pageController.nextPage(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              }
            }
          },
        );
      case "search_item":
        return SearchItem(
          imagePlaceHolder: widget.imagePlaceHolder,
          skipText: widget.skipText,
          questionContentAlignment: widget.questionContentAlignment,
          customSkipStyle: widget.customSkipStyle,
          customButton: widget.customButton,
          customLastButton: widget.customLastButton,
          description: widget.description,
          searchItemQuestionStyle: widget.searchItemQuestionStyle,
          textFieldStyle: widget.searchTextFieldStyle,
          isLast: isLast,
          questionData: data[pageIndex],
          searchTextFieldWidth: widget.searchTextFieldWidth,
          callBack: (data, callingBackData, fromSkip) {
            print(
                '-----------------------------------building the drop down$data');
            if (callingBackData != null) {
              if (callingBackData.isMandatory == true) {
                if (data!.isEmpty) {
                  ScaffoldMessenger.maybeOf(context)!.showSnackBar(
                    const SnackBar(content: Text('Please provide an answer')),
                  );
                  return;
                }
              }
              if (isLast) {
                answersMap[callingBackData.question] = {
                  'id': callingBackData.id,
                  'question-type': callingBackData.questionType,
                  'score': callingBackData.score,
                  'answer': data
                };

                sumOfScoresData();

                ScaffoldMessenger.maybeOf(context)!.showSnackBar(
                    SnackBar(content: Text('Your Score Is $sumOfScores')));

                if (widget.onSurveyEnd != null) {
                  widget.onSurveyEnd!(sumOfScores, answersMap);
                } else {
                  _showSubmitDialog();
                }

                //show Popup Dailog here
              } else {
                addTheFollowUpQuestion(
                    data.toString()!.isEmpty || data.toString() == null
                        ? ''
                        : data.toString()!,
                    isNestedchoice: true,
                    question: callingBackData.question,
                    answeValue: {
                      'id': callingBackData.id,
                      'question-type': callingBackData.questionType,
                      'score': callingBackData.answerChoices == null
                          ? 0
                          : callingBackData.score,
                      'answer': data!.isEmpty || data == null ? '' : data!,
                    });
                answers = [];

                pageController.nextPage(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              }
            }

            // if (answersMap.containsKey(callingBackData.question)) {
            //   if (answersMap[callingBackData.question]['answer'] != null && answersMap[callingBackData.question]['answer'].isNotEmpty) {
            //     answers = data!;
            //   }
            // }
          },
          answerMap: answersMap,
        );
      default:
        return buildTextQuestion(data[pageIndex], pageIndex);
    }
  }

  List<Map<String, dynamic>>? questions;

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  var jsonData;

  void parseAnswers() {
    jsonData = const JsonEncoder.withIndent('  ').convert(answersMap);
    print('printing the all answer-map values $jsonData');
  }

  void addTheFollowUpQuestion(String answer,
      {bool isNestedchoice = false,
      String? question,
      Map<String, dynamic>? answeValue,
      bool isRecrusive = false,
      haveDescription = false,
      bool? isScrollTonextPage = false}) async {
    TreeModel? model;
    TreeNode? node;
    resetOption();
    if (!isRecrusive) {
      answersMap[question!] = answeValue;
    }
    if (!haveDescription) {
      haveDescription = true;
    }

    if (isNestedchoice) {
      if (pageviewTree!
              .nodes[pageController.page!.toInt()].answerChoices[answer] ==
          null) {
        currentMainChildrenlistIndex = currentMainChildrenlistIndex + 1;
        if (currentMainChildrenlistIndex == widget.treeModel.nodes.length - 1) {
          isLast = true;
        }
        node = widget.treeModel.nodes[currentMainChildrenlistIndex];
      } else {
//    print('The answer choices where----'+pageviewTree!
        //   .nodes[pageController.page!.toInt() ].answerChoices[answer].toString());
        model = TreeModel.fromJson(pageviewTree!
            .nodes[pageController.page!.toInt()].answerChoices[answer]);
        node = model.nodes[0];
      }
    } else {
      // print('The answer choices where----'+pageviewTree!
      //     .nodes[pageController.page!.toInt() ].answerChoices[answer]);
      model = TreeModel.fromJson(
          widget.treeModel.nodes[currentQuestionIndex].answerChoices[answer]);
      node = model.nodes[0];
    }
    if (node.questionType != "") {
      pageviewTree!.nodes.add(node);
    } else {
      //Recursion Algorithm
      addTheFollowUpQuestion('', isNestedchoice: true, isRecrusive: true);
    }
    // answerValueJson = JsonEncoder.withIndent('  ').convert(answeValue);
    //
    // print('----------------------------------Having the data from json decode  $answerValueJson');
    parseAnswers();

    if (isScrollTonextPage ?? false) {
      pageController.nextPage(
          duration: const Duration(milliseconds: 500), curve: Curves.ease);
    }
    setState(() {});
  }

  var sum = 0;
  static const double _shadowHeight = 4;
  final double _height = 50 - _shadowHeight;
  double circleSize = 140;
  double iconSize = 108;

  void removeTheNode() async {
    bool shouldBreak = false;

    for (int j = 0; j < pageviewTree!.nodes.length; j++) {
      String question =
          pageviewTree!.nodes[pageController.page!.toInt()].question;

      for (int i = 0; i < widget.treeModel.nodes.length; i++) {
        if (question == widget.treeModel.nodes[i].question) {
          if (currentMainChildrenlistIndex > 0) {
            currentMainChildrenlistIndex = currentMainChildrenlistIndex - 1;
            shouldBreak = true;
            break;
          }
        }
      }

      if (shouldBreak) {
        break;
      }
    }

    pageviewTree!.nodes.removeAt(pageController.page!.toInt());
  }

  Widget buildRadioQuestion(TreeNode data, int pageIndex) {
    String? selectedValue;
    ImagePosition imagePosition = ImagePosition.top;
    if (data.imagePosition != null) {
      imagePosition = ImagePosition.values.firstWhere(
        (e) => e.toString().split('.').last == data.imagePosition!,
        orElse: () => ImagePosition.top,
      );
    }
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 12, right: 12),
        child: Column(
          crossAxisAlignment:
              widget.questionContentAlignment ?? CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 10,
            ),
            imagePosition == ImagePosition.top &&
                    data.image != null &&
                    data.image!.isNotEmpty
                ? ImageParser(
                    data: data,
                    imagePaceHolder: widget.imagePlaceHolder,
                  )
                // SizedBox(
                //   width: MediaQuery.of(context).size.width,
                //       child:
                //       Image.network(data.image!,
                //           height: data.imageHeight?.toDouble(),
                //           alignment: imagePlace == ImagePlace.left
                //               ? Alignment.topLeft
                //               : imagePlace == ImagePlace.right
                //                   ? Alignment.topRight
                //                   : Alignment.topCenter),
                //     )
                : Container(),

            // imagePosition == ImagePosition.top &&
            //         data.image != null &&
            //         data.image!.isNotEmpty
            //     ? widget.customSizedBox ??
            //         const SizedBox(
            //           height: 10,
            //         )
            //     : const SizedBox(),
            imagePosition == ImagePosition.top &&
                    data.image != null &&
                    data.image!.isNotEmpty
                ? SizedBox(height: MediaQuery.of(context).size.height * 0.01)
                : const SizedBox(height: 0),
            Text(
              data.question ?? "",
              style: widget.radioQuestion ??
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            imagePosition == ImagePosition.middle &&
                    data.image != null &&
                    data.image!.isNotEmpty
                ? ImageParser(
                    data: data,
                    imagePaceHolder: widget.imagePlaceHolder,
                  )
                : Container(),
            imagePosition == ImagePosition.middle &&
                    data.image != null &&
                    data.image!.isNotEmpty
                ? SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  )
                : const SizedBox(
                    height: 0,
                  ),

            // imagePosition == ImagePosition.middle &&
            //         data.image != null &&
            //         data.image!.isNotEmpty
            //     ? widget.customSizedBox ??
            //         const SizedBox(
            //           height: 10,
            //         )
            //     : const SizedBox(),
            data.description!.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      data.description.toString(),
                      style:
                          widget.description ?? const TextStyle(fontSize: 12),
                    ),
                  )
                : const SizedBox(
                    height: 0,
                  ),
            // widget.customSizedBox ??
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            imagePosition == ImagePosition.bottom &&
                    data.image != null &&
                    data.image!.isNotEmpty
                ? ImageParser(
                    data: data,
                    imagePaceHolder: widget.imagePlaceHolder,
                  )
                : Container(),
            imagePosition == ImagePosition.bottom &&
                    data.image != null &&
                    data.image!.isNotEmpty
                ? SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  )
                : const SizedBox(
                    height: 0,
                  ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Column(
              children: (data.answerChoices).keys.map<Widget>((answer) {
                if (data.answerChoices[answer] != null &&
                    data.answerChoices[answer] != '') {
                  if (answersMap.containsKey(data.question)) {
                    selectedValue = answersMap[data.question]['answer'];
                  }
                }
                //final bool isSelected = selectedValue == answer;
                //  final bool isSameAsPrevious = isSelected && selectedValue == previousAnswer;
                return RadioListTile(
                    title: Text(
                      answer,
                      style: widget.optionRadioStyle ??
                          TextStyle(
                              color: selectedValue == answer
                                  ? widget.radioTextColor ?? Colors.deepPurple
                                  : Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 16),
                    ),
                    value: answer,
                    activeColor: widget.activeRadioColor ?? Colors.deepPurple,
                    groupValue: selectedValue?.isNotEmpty ?? false
                        ? selectedValue
                        : null,
                    //  groupValue: selectedValue,
                    // groupValue: (answersMap.containsKey(data.question) && answersMap.containsKey(data.answerChoices)) ? null : selectedValue,
                    onChanged: (selectedAnswer) {
                      setState(() {
                        selectedValue = selectedAnswer;
                        answer = selectedAnswer!;
                      });
                      if (isLast) {
                        answersMap[data.question!] = {
                          'id': data.id,
                          'question-type': data.questionType,
                          'score': data.answerChoices == null
                              ? data.score
                              : data.answerChoices[selectedValue] != null
                                  ? data.answerChoices[selectedValue][0]
                                      ['score']
                                  : 0,
                          'answer': selectedAnswer
                        };
                        sumOfScoresData();

                        // ScaffoldMessenger.maybeOf(context)!.showSnackBar(
                        //     SnackBar(content: Text('Your Score Is $sumOfScores')));
                        if (widget.onSurveyEnd != null) {
                          widget.onSurveyEnd!(sumOfScores, answersMap);
                        } else {
                          _showSubmitDialog();
                        }
                      } else {
                        addTheFollowUpQuestion(answer,
                            isNestedchoice: true,
                            haveDescription:
                                data.description != null ? true : false,
                            question: data.question,
                            answeValue: {
                              'id': data.id,
                              'question-type': data.questionType,
                              'score':
                                  data.answerChoices[selectedAnswer] != null
                                      ? data.answerChoices[selectedAnswer][0]
                                          ['score']
                                      : 0,
                              'answer': answer
                            });

                        answersMap[data.question!] = {
                          'id': data.id,
                          'question-type': data.questionType,
                          'score': data.answerChoices == null
                              ? data.score
                              : data.answerChoices[selectedValue][0]['score'],
                          'answer': selectedAnswer
                        };

                        pageController.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.ease);
                      }
                    });
                // }
              }).toList(),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  data.isMandatory == false && isLast == false
                      ? GestureDetector(
                          onTap: () {
                            addTheFollowUpQuestion('',
                                isNestedchoice: true,
                                question: data.question,
                                answeValue: {'score': 0});
                            pageController.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                          },
                          /* child:
                    Container(
                      width: 120,
                      height:  40,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                             Colors.blueGrey,
                             Colors.blueGrey.shade200,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blueGrey.shade50,
                            offset: const Offset(5, 5),
                            blurRadius:  10,
                          )
                        ],
                      ),*/
                          child: Center(
                            child: Text(
                              widget.skipText ?? 'Skip',
                              style: widget.customSkipStyle ??
                                  const TextStyle(
                                      color: Colors.blue,
                                      fontSize: 16,
                                      decoration: TextDecoration.underline,
                                      decorationColor: Colors.blue,
                                      fontStyle: FontStyle.italic),
                            ),
                          ),
                        )
                      : const SizedBox(),
                  GestureDetector(
                    onTap: () {
                      if (isLast) {
                        if (answersMap.containsKey(data.question)) {
                          sumOfScoresData();

                          // ScaffoldMessenger.maybeOf(context)!.showSnackBar(
                          //     SnackBar(
                          //         content:
                          //             Text('Your Score Is $sumOfScores')));

                          if (widget.onSurveyEnd != null) {
                            widget.onSurveyEnd!(sumOfScores, answersMap);
                          } else {
                            _showSubmitDialog();
                          }
                        } else {
                          ScaffoldMessenger.maybeOf(context)!
                              .showSnackBar(const SnackBar(
                            content: Text('Please select at least one answer'),
                            behavior: SnackBarBehavior.floating,
                          ));
                        }
                      } else {
                        if (data.isMandatory == true) {
                          if (answers.isEmpty) {
                            ScaffoldMessenger.maybeOf(context)!
                                .showSnackBar(const SnackBar(
                              content:
                                  Text('Please select at least one answer'),
                              behavior: SnackBarBehavior.floating,
                            ));
                            return;
                          }
                          addTheFollowUpQuestion('',
                              isNestedchoice: true,
                              question: data.question,
                              answeValue: {
                                'id': data.id,
                                'question-type': data.questionType,
                                'score':
                                    data.answerChoices == null ? 0 : data.score,
                                'answer': selectedValue
                              });
                          pageController.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          addTheFollowUpQuestion('',
                              isNestedchoice: true,
                              question: data.question,
                              answeValue: {
                                'id': data.id,
                                'question-type': data.questionType,
                                'score':
                                    data.answerChoices == null ? 0 : data.score,
                                'answer': selectedValue
                              });
                          pageController.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        }
                      }
                    },
                    child: isLast
                        ? Container(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.5,
                              maxHeight:
                                  MediaQuery.of(context).size.height * 0.1,
                            ),
                            child: widget.customLastButton ??
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.32,
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.teal,
                                        Colors.teal.shade300,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black12,
                                        offset: Offset(5, 5),
                                        blurRadius: 10,
                                      )
                                    ],
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Submit',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                          )
                        : Container(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.5,
                              maxHeight:
                                  MediaQuery.of(context).size.height * 0.1,
                            ),
                            child: widget.customButton ??
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.32,
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.teal,
                                        Colors.teal.shade300
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black12,
                                        offset: Offset(5, 5),
                                        blurRadius: 10,
                                      )
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      isLast ? 'Submit Survey' : 'Next',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String answerDescription = '';
  String answerdata = '';

  Widget buildAnswerWidget(String answer, TreeNode questionData) {
    bool isSelected = answerdata == answer;

    String imageOption =
        questionData.answerChoices[answer][0]["imageOption"] ?? '';
    if (questionData.isMultiListSelects == false) {
      return Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          ListTile(
            title: Center(
                child: questionData.listGridType == true
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          imageOption.isNotEmpty
                              ? Image.network(
                                  imageOption,
                                  width:
                                      MediaQuery.of(context).size.width * 0.17,
                                  height:
                                      MediaQuery.of(context).size.width * 0.17,
                                )
                              : Container(),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.1),
                          Center(child: Text(answer)),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          imageOption.isNotEmpty
                              ? Image.network(
                                  imageOption,
                                  width:
                                      MediaQuery.of(context).size.width * 0.1,
                                  height:
                                      MediaQuery.of(context).size.width * 0.1,
                                )
                              : Container(),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.1),
                          Center(child: Text(answer)),
                        ],
                      )),
            // selectedTileColor: widget.tileListColor ?? Colors.green,
            tileColor: isSelected
                ? widget.tileListColor ?? Colors.blueGrey.shade300
                : Colors.blueGrey.shade50,
            selectedTileColor: widget.tileListColor ?? Colors.blueGrey.shade300,

            shape: isSelected
                ? widget.listTileShape ??
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(color: Colors.black),
                    )
                : RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Colors.blueGrey.shade200),
                  ),
            selected: isSelected,
            onTap: () {
              setState(() {
                if (answerdata != answer) {
                  answerdata = answer;
                  if (questionData.answerChoices[answer][0]
                          ['answerDescription'] !=
                      null) {
                    answerDescription = questionData.answerChoices[answer][0]
                        ['answerDescription'];
                  }
                } else {
                  //    answerdata = '';
                  //   answerDescription = '';
                }
              });

              // setState(() {
              //   if (!answers.contains(answer)) {
              //     answers.add(answer);
              //     answerDescription = answerDescription.isEmpty
              //         ? questionData
              //         .answerChoices[answer][0]['answerDescription'] ?? ''
              //         : '';
              //   } else {
              //     answers.remove(answer);
              //
              //     answerDescription = '';
              //   }
              // });

              if (widget.onListTaleTapnavigation) {
                addTheFollowUpQuestion(answer,
                    haveDescription:
                        questionData.description != null ? true : false,
                    isNestedchoice: true,
                    question: questionData.question,
                    answeValue: {
                      'id': questionData.id,
                      'question-type': questionData.questionType,
                      'score': questionData.answerChoices[answer][0]['score'],
                      'answer': answerdata,
                      'optionDescription': answerDescription
                    });
                Future.delayed(Duration(seconds: 1)).then((value) {
                  answerdata = '';
                  answerDescription = '';
                  setState(() {});
                });

                pageController.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.ease);
              }
            },
          ),
        ],
      );
    } else {
      if (questionData.answerChoices[answer] == null) {
        return ListTile(
          shape: isSelected
              ? widget.listTileShape ??
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: Colors.black),
                  )
              : RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Colors.blueGrey.shade200),
                ),
          title: Row(
            children: [
              imageOption.isNotEmpty ? Image.network(imageOption) : Container(),
              Text(answer),
            ],
          ),
          contentPadding: EdgeInsets.all(12),
          tileColor: isSelected
              ? widget.tileListColor ?? Colors.blueGrey.shade200
              : Colors.blueGrey.shade50,
          onTap: () {
            setState(() {
              if (answerdata == answer) {
                // answerDescription = answerDescription.isEmpty ? questionData
                //     .answerChoices[answer][0]['answerDescription'] : '';
              } else {
                answerDescription = questionData.answerChoices[answer][0]
                        ['answerDescription'] ??
                    '';
                answerdata = answer;
              }
            });
            if (widget.onListTaleTapnavigation) {
              addTheFollowUpQuestion('',
                  isNestedchoice: true,
                  question: questionData.question,
                  answeValue: {'score': 0});

              Future.delayed(Duration(seconds: 1)).then((value) {
                answerdata = '';
                answerDescription = '';
                setState(() {});
              });
              pageController.nextPage(
                duration: const Duration(milliseconds: 500),
                curve: Curves.ease,
              );
            }
          },
        );
      } else {
        return Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            SizedBox(
              height: questionData.listGridType == true ? 92 : 60,
              child: ListTile(
                title: Center(
                    child: questionData.listGridType == true
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              imageOption.isNotEmpty
                                  ? Image.network(
                                      imageOption,
                                      width: MediaQuery.of(context).size.width *
                                          0.16,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.16,
                                    )
                                  : Container(),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.01,
                              ),
                              Center(child: Text(answer)),
                            ],
                          )
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              imageOption.isNotEmpty
                                  ? Image.network(
                                      imageOption,
                                      width: MediaQuery.of(context).size.width *
                                          0.16,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.16,
                                    )
                                  : Container(),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.01),
                              Center(child: Text(answer)),
                            ],
                          )),
                // selectedTileColor: widget.tileListColor ?? Colors.green,
                tileColor: isSelected
                    ? widget.tileListColor ?? Colors.blueGrey.shade300
                    : Colors.blueGrey.shade50,
                selectedTileColor:
                    widget.tileListColor ?? Colors.blueGrey.shade300,

                shape: isSelected
                    ? widget.listTileShape ??
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(color: Colors.black),
                        )
                    : RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Colors.blueGrey.shade200),
                      ),
                selected: answers.contains(answer),
                onTap: () {
                  setState(() {
                    if (!answers.contains(answer)) {
                      answers.add(answer);
                      // answerDescription = answerDescription.isEmpty ? questionData.answerChoices[answer][0]['answerDescription'] ?? ''
                      //     : '';
                    } else {
                      answers.remove(answer);

                      answerDescription = '';
                    }
                  });

                  if (widget.onListTaleTapnavigation) {
                    addTheFollowUpQuestion(answer,
                        haveDescription:
                            questionData.description != null ? true : false,
                        isNestedchoice: true,
                        question: questionData.question,
                        answeValue: {
                          'id': questionData.id,
                          'question-type': questionData.questionType,
                          'score': questionData.answerChoices[answer][0]
                              ['score'],
                          'answer': answer,
                          'optionDescription': answerDescription
                        });
                    Future.delayed(Duration(seconds: 1)).then((value) {
                      answerdata = '';
                      answerDescription = '';
                      setState(() {});
                    });

                    pageController.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.ease);
                  }
                },
              ),
            ),
          ],
        );
      }
    }
  }

  Widget buildLIstQuestioins(TreeNode questionData) {
    Set<String> selectedAnswers = {};

    if (answersMap.containsKey(questionData.question)) {
      if (answersMap[questionData.question]['answer'] != null &&
          answersMap[questionData.question]['answer'].isNotEmpty) {
        if (questionData.isMultiListSelects == true) {
          answers = answersMap[questionData.question]['answer'] ?? '';
        } else {
          if (answerdata == '') {
            answerdata = answersMap[questionData.question]['answer'] ?? '';
          }
        }
      }
    }

    if (answersMap.containsKey(questionData.question)) {
      if (answersMap[questionData.question]['optionDescription'] != null &&
          answersMap[questionData.question]['optionDescription'] != '') {
        if (answerDescription == '') {
          answerDescription =
              answersMap[questionData.question]['optionDescription'] ?? '';
        }
      }
    }

    ImagePosition imagePosition = ImagePosition.top;
    if (questionData.imagePosition != null) {
      imagePosition = ImagePosition.values.firstWhere(
        (e) => e.toString().split('.').last == questionData.imagePosition!,
        orElse: () => ImagePosition.top,
      );
    }

    return Card(
      elevation: 0,
      color: Colors.transparent,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
          child: Column(
            crossAxisAlignment:
                widget.questionContentAlignment ?? CrossAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              imagePosition == ImagePosition.top &&
                      questionData.image != null &&
                      questionData.image!.isNotEmpty
                  ? ImageParser(
                      data: questionData,
                      imagePaceHolder: widget.imagePlaceHolder,
                    )
                  : Container(),
              imagePosition == ImagePosition.top &&
                      questionData.image != null &&
                      questionData.image!.isNotEmpty
                  ? SizedBox(height: MediaQuery.of(context).size.height * 0.01)
                  : SizedBox(
                      height: 0,
                    ),
              Text(
                questionData.question ?? "",
                style: widget.listTileQuestionStyle ??
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              imagePosition == ImagePosition.middle &&
                      questionData.image != null &&
                      questionData.image!.isNotEmpty
                  ? ImageParser(
                      data: questionData,
                      imagePaceHolder: widget.imagePlaceHolder,
                    )
                  : Container(),
              imagePosition == ImagePosition.middle &&
                      questionData.image != null &&
                      questionData.image!.isNotEmpty
                  ? SizedBox(height: MediaQuery.of(context).size.height * 0.01)
                  : const SizedBox(height: 0),
              questionData.description!.isNotEmpty
                  ? Text(
                      questionData.description.toString(),
                      style:
                          widget.description ?? const TextStyle(fontSize: 12),
                    )
                  : const SizedBox(
                      height: 0,
                    ),
              imagePosition == ImagePosition.bottom &&
                      questionData.image != null &&
                      questionData.image!.isNotEmpty
                  ? ImageParser(
                      data: questionData,
                      imagePaceHolder: widget.imagePlaceHolder,
                    )
                  : Container(),
              imagePosition == ImagePosition.bottom &&
                      questionData.image != null &&
                      questionData.image!.isNotEmpty
                  ? SizedBox(
                      height: MediaQuery.of(context).size.height * 0.001,
                    )
                  : const SizedBox(
                      height: 0,
                    ),
              //  SizedBox(height: MediaQuery.of(context).size.height*0.01),

              questionData.listGridType == true
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 11,
                        childAspectRatio: 3 / 2.2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          for (var answer in (questionData.answerChoices).keys)
                            buildAnswerWidget(answer, questionData)
                        ],
                      ),
                    )
                  : Column(
                      children: (questionData.answerChoices)
                          .keys
                          .map<Widget>((answer) {
                        return buildAnswerWidget(answer, questionData);
                      }).toList(),
                    ),

              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),

              answerDescription.isNotEmpty
                  ? Text(
                      answerDescription,
                      style: widget.answerDescriptionStyle ?? const TextStyle(),
                    )
                  : Container(),

              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    questionData.isMandatory == false && isLast == false
                        ? GestureDetector(
                            onTap: () {
                              addTheFollowUpQuestion('',
                                  isNestedchoice: true,
                                  question: questionData.question,
                                  answeValue: {'score': 0});
                              pageController.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.ease,
                              );
                              Future.delayed(Duration(seconds: 1))
                                  .then((value) {
                                answerdata = '';
                                answerDescription = '';
                                setState(() {});
                              });
                            },
                            child: Center(
                              child: Text(
                                widget.skipText ?? 'Skip',
                                style: widget.customSkipStyle ??
                                    const TextStyle(
                                        color: Colors.blue,
                                        fontSize: 16,
                                        decoration: TextDecoration.underline,
                                        decorationColor: Colors.blue,
                                        fontStyle: FontStyle.italic),
                              ),
                            ),
                          )
                        : const SizedBox(),
                    GestureDetector(
                        onTap: () {
                          if (isLast) {
                            //  if (answersMap.containsKey(questionData.question)) {

                            answersMap[questionData.question] = {
                              'id': questionData.id,
                              'question-type': questionData.questionType,
                              'score': questionData.answerChoices == null
                                  ? 0
                                  : questionData.score,
                              'answer': questionData.isMultiListSelects == true
                                  ? answers
                                  : answerdata,
                              'optionDescription': answerDescription
                            };
                            sumOfScoresData();

                            //addTheFollowUpQuestion(answerdata,
                            //     isNestedchoice: true,
                            //     question: questionData.question,
                            //     answeValue: {
                            //       'id': questionData.id,
                            //       'question-type': questionData.questionType,
                            //       'score': questionData.answerChoices == null
                            //           ? 0
                            //           : questionData.score,
                            //       'answer': answerdata,
                            //       'optionDescription': answerDescription
                            //     });
                            // ScaffoldMessenger.maybeOf(context)!.showSnackBar(
                            //     SnackBar(
                            //         content:
                            //             Text('Your Score Is $sumOfScores')));

                            if (widget.onSurveyEnd != null) {
                              widget.onSurveyEnd!(sumOfScores, answersMap);
                            } else {
                              _showSubmitDialog();
                            }
                            //    }
                            /* else {
                                ScaffoldMessenger.maybeOf(context)!
                                    .showSnackBar(const SnackBar(
                                  content:
                                      Text('Please select at least one answer'),
                                  behavior: SnackBarBehavior.floating,
                                ));
                              }*/
                          } else {
                            if (questionData.isMandatory == true) {
                              if (questionData.isMultiListSelects == false
                                  ? answerdata.isEmpty
                                  : answers.isEmpty) {
                                ScaffoldMessenger.maybeOf(context)!
                                    .showSnackBar(const SnackBar(
                                  content:
                                      Text('Please select at least one answer'),
                                  behavior: SnackBarBehavior.floating,
                                ));
                                return;
                              }
                              addTheFollowUpQuestion(
                                  questionData.isMultiListSelects == false
                                      ? answerdata
                                      : answers.length == 1
                                          ? answers[0]
                                          : answers.toString(),
                                  isNestedchoice: true,
                                  question: questionData.question,
                                  answeValue: {
                                    'id': questionData.id,
                                    'question-type': questionData.questionType,
                                    'score': questionData.answerChoices == null
                                        ? 0
                                        : questionData.score,
                                    //  'answer':answers,
                                    'answer':
                                        questionData.isMultiListSelects == true
                                            ? answers
                                            : answerdata,
                                    'optionDescription': answerDescription
                                  });
                              //  answers=[];

                              Future.delayed(const Duration(seconds: 1))
                                  .then((value) {
                                //  answerdata = '';
                                // answerDescription = '';
                                setState(() {});
                              });
                              pageController.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                              );
                              Future.delayed(const Duration(milliseconds: 800))
                                  .then((value) {
                                answers = [];
                                answerdata = '';
                                answerDescription = '';
                                setState(() {});
                              });
                            } else {
                              addTheFollowUpQuestion(
                                  questionData.isMultiListSelects == false
                                      ? answerdata
                                      : answers.length == 1
                                          ? answers[0]
                                          : answers.toString(),
                                  isNestedchoice: true,
                                  question: questionData.question,
                                  answeValue: {
                                    'id': questionData.id,
                                    'question-type': questionData.questionType,
                                    'score': questionData.answerChoices == null
                                        ? 0
                                        : questionData.score,
                                    //   'answer':answers,
                                    'answer':
                                        questionData.isMultiListSelects == true
                                            ? answers ?? ''
                                            : answerdata ?? '',
                                    'optionDescription': answerDescription
                                  });
                              // answers=[];
                              //
                              //   Future.delayed(Duration(seconds: 1))
                              //     .then((value) {
                              //   answerdata = '';
                              //   answerDescription = '';
                              //   setState(() {});
                              // });

                              pageController.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                              );
                              Future.delayed(const Duration(milliseconds: 800))
                                  .then((value) {
                                answers = [];
                                answerDescription = '';
                                answerdata = '';
                                setState(() {});
                              });
                            }
                          }
                        },
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.5,
                            maxHeight: MediaQuery.of(context).size.height * 0.1,
                          ),
                          child: isLast
                              ? widget.customLastButton ??
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.32,
                                    height: MediaQuery.of(context).size.height *
                                        0.05,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.teal,
                                          Colors.teal.shade300,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black12,
                                          offset: Offset(5, 5),
                                          blurRadius: 10,
                                        )
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        isLast ? 'Submit Survey' : 'Next',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  )
                              : Container(
                                  constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width * 0.5,
                                    maxHeight:
                                        MediaQuery.of(context).size.height *
                                            0.1,
                                  ),
                                  child: widget.customButton ??
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.32,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.teal,
                                              Colors.teal.shade300,
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Colors.black12,
                                              offset: Offset(5, 5),
                                              blurRadius: 10,
                                            )
                                          ],
                                        ),
                                        child: const Center(
                                          child: Text(
                                            'Next',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      )),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

//   Widget buildSliderQuestion(TreeNode questionData) {
//
//     ValueNotifier<double> sliderValue = ValueNotifier<double>(25);
//
//     if(answersMap.containsKey(questionData.question)){
//      sliderValue = ValueNotifier(double.parse(answersMap[questionData.question]['answer']??'25'));
//     }
//
//     double sliderScore = 0;
//
//     ImagePosition imagePosition = ImagePosition.top;
//     if (questionData.imagePosition != null) {
//       imagePosition = ImagePosition.values.firstWhere(
//         (e) => e.toString().split('.').last == questionData.imagePosition!,
//         orElse: () => ImagePosition.top,
//       );
//     }
//
//     return Padding(
//       padding: const EdgeInsets.only(left: 12,right: 12),
//       child: Column(
//         crossAxisAlignment:   widget.questionContentAlignment ?? CrossAxisAlignment.end,
//         children: [
//            SizedBox(
//             height: MediaQuery.of(context).size.height*0.01,
//           ),
//           imagePosition == ImagePosition.top &&
//                   questionData.image != null &&
//                   questionData.image!.isNotEmpty
//               ? ImageParser(data:questionData,
//                             imagePaceHolder: widget.imagePlaceHolder,
//
//               )
//               : Container(),
//           imagePosition == ImagePosition.top &&
//               questionData.image != null &&
//               questionData.image!.isNotEmpty ?  SizedBox(height: MediaQuery.of(context).size.height*0.01):const SizedBox(height: 0,),
//           Text(
//             questionData.question ?? "",
//             style: widget.sliderQuestionStyle ??
//                 const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//            SizedBox(
//             height: MediaQuery.of(context).size.height*0.01,
//           ),
//           imagePosition == ImagePosition.middle &&
//                   questionData.image != null &&
//                   questionData.image!.isNotEmpty
//               ? ImageParser(data:questionData,
//                             imagePaceHolder: widget.imagePlaceHolder,
//
//               )
//               : Container(),
//           imagePosition == ImagePosition.middle &&
//               questionData.image != null &&
//               questionData.image!.isNotEmpty ?  SizedBox(height: MediaQuery.of(context).size.height*0.01):const SizedBox(height: 0),
//
//           questionData.description!.isNotEmpty
//               ? Text(
//                   questionData.description.toString(),
//                   style: widget.description ?? const TextStyle(fontSize: 12),
//                 )
//               : const SizedBox(
//                   height: 0,
//                 ),
//            SizedBox(
//             height: MediaQuery.of(context).size.height*0.01,
//           ),
//           imagePosition == ImagePosition.bottom &&
//                   questionData.image != null &&
//                   questionData.image!.isNotEmpty
//               ? ImageParser(data:questionData,
//                             imagePaceHolder: widget.imagePlaceHolder,
//
//               )
//               : Container(),
//           imagePosition == ImagePosition.bottom &&
//               questionData.image != null &&
//               questionData.image!.isNotEmpty ? SizedBox(height: MediaQuery.of(context).size.height*0.01,):const SizedBox(height: 0,),
//           ValueListenableBuilder<double>(
//             valueListenable: sliderValue,
//             builder: (context, value, child) {
//               return Column(
//                 children: [
//   SliderTheme(
//                 data: const SliderThemeData(
//                     showValueIndicator: ShowValueIndicator.always),
//                 child:
//   Slider(
//                     value: sliderValue.value,
//                     divisions: 100,
//                     onChanged: (double newValue) {
//                         sliderValue.value = newValue;
//                     },
//                     max: 100,
//                     inactiveColor:
//                         widget.inactiveColorSlider ?? Colors.blueGrey.shade300,
//                     activeColor: widget.activeColorSlider ?? Colors.blueGrey,
//                     label: sliderValue.value.toStringAsFixed(0),
//                   )),
//                   // Text(
//                   //   "Saved Value: ${sliderValue.value.toStringAsFixed(0)}",
//                   //   style: TextStyle(
//                   //       fontSize: 16,
//                   //       fontWeight: FontWeight.bold,
//                   //       color: Colors.deepPurple.shade400),
//                   // ),
//                 ],
//               );
//             },
//           ),
//            SizedBox(
//             height: MediaQuery.of(context).size.height*0.01,
//           ),
//           Padding(
//             padding: const EdgeInsets.only(left: 15, right: 15),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 questionData.isMandatory == false && isLast == false
//                     ? GestureDetector(
//                           onTap: () {
//                             addTheFollowUpQuestion('',
//                                 isNestedchoice: true,
//                                 question: questionData.question,
//                                 answeValue: {'score': 0});
//                             pageController.nextPage(
//                               duration: const Duration(milliseconds: 500),
//                               curve: Curves.easeInOut,
//                             );
//                           },
//                           /* child:
//                     Container(
//                       width: 120,
//                       height:  40,
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           colors: [
//                              Colors.blueGrey,
//                              Colors.blueGrey.shade200,
//                           ],
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                         ),
//                         borderRadius: BorderRadius.circular(20),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.blueGrey.shade50,
//                             offset: const Offset(5, 5),
//                             blurRadius:  10,
//                           )
//                         ],
//                       ),*/
//                           child: Center(
//                             child: Text(
//                              widget.skipText ?? 'Skip',
//                               style: widget.customSkipStyle ?? const  TextStyle(
//                                   color: Colors.blue,
//                                   fontSize: 16,
//                                   decoration: TextDecoration.underline,
//                                   decorationColor: Colors.blue,
//                                   fontStyle: FontStyle.italic),
//                             ),
//                           ),
//                         )
//                     : const SizedBox(),
//                     GestureDetector(
//                       onTap: () {
//                         String? ageGroup;
//                         double valueSlider = sliderValue.value;
//                         if (valueSlider < 10) {
//                           ageGroup = 'under_10';
//                         } else if (valueSlider >= 10 && valueSlider <= 20) {
//                           ageGroup = '10_to_20';
//                         } else if (valueSlider > 20 && valueSlider <= 30) {
//                           ageGroup = '20_to_30';
//                         } else if (valueSlider >= 10 && valueSlider <= 20) {
//                           ageGroup = '30_to_40';
//                         } else if (valueSlider > 20 && valueSlider <= 30) {
//                           ageGroup = '40_to_50';
//                         } else if (valueSlider >= 10 && valueSlider <= 20) {
//                           ageGroup = '50_to_60';
//                         } else if (valueSlider > 20 && valueSlider <= 30) {
//                           ageGroup = '60_to_70';
//                         } else if (valueSlider >= 10 && valueSlider <= 20) {
//                           ageGroup = '70_to_80';
//                         } else if (valueSlider > 20 && valueSlider <= 30) {
//                           ageGroup = '80_to_90';
//                         } else if (valueSlider >= 10 && valueSlider <= 20) {
//                           ageGroup = '90_to_100';
//                         } else {}
//
//                         switch (ageGroup) {
//                           case 'under_10':
//                             sliderScore = 1;
//                             break;
//                           case '10_to_20':
//                             sliderScore = 2;
//                             break;
//                           case '20_to_30':
//                             sliderScore = 3;
//                             break;
//                           case '30_to_40':
//                             sliderScore = 4;
//                             break;
//                           case '40_to_50':
//                             sliderScore = 5;
//                             break;
//                           case '50_to_60':
//                             sliderScore = 6;
//                             break;
//                           case '60_to_70':
//                             sliderScore = 7;
//                             break;
//                           case '70_to_80':
//                             sliderScore = 8;
//                             break;
//                           case '80_to_90':
//                             sliderScore = 9;
//                             break;
//                           case '90_to_100':
//                             sliderScore = 10;
//                             break;
//                           default:
//                             sliderScore = questionData.score!.toDouble();
//                             break;
//                         }
//
//                         if (isLast) {
//                           answersMap[questionData.question!] = {
//                             'id': questionData.id,
//                             'score': questionData.answerChoices == null
//                                 ? 0
//                                 : questionData.score,
//                             //  'score': sliderScore,
//                             'question-type': questionData.questionType,
//                             'answer': sliderValue.value.toStringAsFixed(0)
//                           };
// if(widget.onSurveyEnd!=null){
// widget.onSurveyEnd!(sumOfScores, answersMap);
// }else{
//                                                 _showSubmitDialog();
//
// }
//                         } else {
//                           addTheFollowUpQuestion('',
//                               isNestedchoice: true,
//                               question: questionData.question,
//                               answeValue: {
//                                 'id': questionData.id,
//                                 'question-type': questionData.questionType,
//                                 //  'score': sliderScore,
//                                 'score': questionData.answerChoices == null
//                                     ? 0
//                                     : questionData.score,
//                                 'answer': sliderValue.value.toStringAsFixed(0)
//                               });
//                           pageController.nextPage(
//                             duration: const Duration(milliseconds: 500),
//                             curve: Curves.easeInOut,
//                           );
//                         }
//                       },
//           child:Container(
//       constraints: BoxConstraints(
//       maxWidth: MediaQuery.of(context).size.width*0.5,
//       maxHeight: MediaQuery.of(context).size.height*0.1,
//       ),
//                       child:isLast ? widget.customLastButton ?? Container(
//                             width: MediaQuery.of(context).size.width*0.32,
//                             height: MediaQuery.of(context).size.height*0.05,
//                             decoration: BoxDecoration(
//                               gradient: LinearGradient(
//                                 colors: [
//                                   Colors.teal,
//                                   Colors.teal.shade300,
//                                 ],
//                                 begin: Alignment.topLeft,
//                                 end: Alignment.bottomRight,
//
//                               ),
//                               borderRadius: BorderRadius.circular(20),
//                               boxShadow: const [
//                                 BoxShadow(
//                                   color: Colors.black12,
//                                   offset: Offset(5, 5),
//                                   blurRadius: 10,
//                                 )
//                               ],
//                             ),
//                             child: const Center(
//                               child: Text(
//                                 'Next',
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                             ),
//                           )
//                                     :Container(
//       constraints: BoxConstraints(
//       maxWidth: MediaQuery.of(context).size.width*0.5,
//       maxHeight: MediaQuery.of(context).size.height*0.1,
//       ),
//                       child: widget.customButton ?? Container(
//                         width: MediaQuery.of(context).size.width*0.32,
//                         height: MediaQuery.of(context).size.height*0.05,
//                         decoration:
//                             BoxDecoration(
//                               gradient: LinearGradient(
//                                 colors: [
//                                   Colors.teal,
//                                   Colors.teal.shade300,
//                                 ],
//                                 begin: Alignment.topLeft,
//                                 end: Alignment.bottomRight,
//                               ),
//                               borderRadius: BorderRadius.circular(20),
//                               boxShadow: const [
//                                 BoxShadow(
//                                   color: Colors.black12,
//                                   offset: Offset(5, 5),
//                                   blurRadius: 10,
//                                 )
//                               ],
//                             ),
//                         child: const Center(
//                           child: Text(
//                            'Next',
//                             style:
//                                 TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     )),],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

  Widget buildTextQuestion(TreeNode questionData, int index) {
    textControllers.putIfAbsent(index, () => TextEditingController(text: ''));

    ImagePosition imagePosition = ImagePosition.top;
    if (questionData.imagePosition != null) {
      imagePosition = ImagePosition.values.firstWhere(
        (e) => e.toString().split('.').last == questionData.imagePosition!,
        orElse: () => ImagePosition.top,
      );
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 12, right: 12),
        child: Column(
          crossAxisAlignment:
              widget.questionContentAlignment ?? CrossAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            imagePosition == ImagePosition.top &&
                    questionData.image != null &&
                    questionData.image!.isNotEmpty
                ? ImageParser(
                    data: questionData,
                    imagePaceHolder: widget.imagePlaceHolder,
                  )
                : Container(),
            imagePosition == ImagePosition.top &&
                    questionData.image != null &&
                    questionData.image!.isNotEmpty
                ? SizedBox(height: MediaQuery.of(context).size.height * 0.01)
                : const SizedBox(
                    height: 0,
                  ),

            Text(
              questionData.question ?? "",
              style: widget.textFieldQuestionStyle ??
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            imagePosition == ImagePosition.middle &&
                    questionData.image != null &&
                    questionData.image!.isNotEmpty
                ? ImageParser(
                    data: questionData,
                    imagePaceHolder: widget.imagePlaceHolder,
                  )
                : Container(),
            imagePosition == ImagePosition.middle &&
                    questionData.image != null &&
                    questionData.image!.isNotEmpty
                ? SizedBox(height: MediaQuery.of(context).size.height * 0.01)
                : const SizedBox(
                    height: 0,
                  ),

            questionData.description!.isNotEmpty
                ? Text(
                    questionData.description.toString(),
                    style: widget.description ?? const TextStyle(fontSize: 12),
                  )
                : const SizedBox(
                    height: 0,
                  ),

            imagePosition == ImagePosition.bottom &&
                    questionData.image != null &&
                    questionData.image!.isNotEmpty
                ? ImageParser(
                    data: questionData,
                    imagePaceHolder: widget.imagePlaceHolder,
                  )
                : Container(),
            imagePosition == ImagePosition.bottom &&
                    questionData.image != null &&
                    questionData.image!.isNotEmpty
                ? SizedBox(height: MediaQuery.of(context).size.height * 0.01)
                : const SizedBox(
                    height: 0,
                  ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            TextField(
              keyboardType: questionData.inputType == 'number'
                  ? TextInputType.number
                  : TextInputType.text,
              decoration: widget.textFieldDecoration ??
                  const InputDecoration(
                    labelText: 'Your Answer',
                  ),
              controller: textControllers[index],
              onChanged: (text) {
                text = nameController.text.trim();
                //int score = int.parse(text);
                //radioSelectedValues?.add(score);
              },
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            // currentQuestionIndex == surveyData.length-1
            //    widget.isLastButton ??
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  questionData.isMandatory == false && isLast == false
                      ? GestureDetector(
                          onTap: () {
                            setState(() {
                              FocusScope.of(context).unfocus();
                            });
                            addTheFollowUpQuestion('',
                                isNestedchoice: true,
                                question: questionData.question,
                                answeValue: {'score': 0});
                            pageController.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                          },
                          /* child:
                    Container(
                      width: 120,
                      height:  40,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                             Colors.blueGrey,
                             Colors.blueGrey.shade200,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blueGrey.shade50,
                            offset: const Offset(5, 5),
                            blurRadius:  10,
                          )
                        ],
                      ),*/
                          child: Center(
                            child: Text(
                              widget.skipText ?? 'Skip',
                              style: widget.customSkipStyle ??
                                  const TextStyle(
                                      color: Colors.blue,
                                      fontSize: 16,
                                      decoration: TextDecoration.underline,
                                      decorationColor: Colors.blue,
                                      fontStyle: FontStyle.italic),
                            ),
                          ),
                        )
                      : const SizedBox(),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        FocusScope.of(context).unfocus();
                      });
                      if (questionData.isMandatory == true) {
                        String textAnswer = textControllers[index]?.text ?? '';
                        if (textAnswer.isEmpty) {
                          ScaffoldMessenger.maybeOf(context)!.showSnackBar(
                            const SnackBar(
                                content: Text('Please provide an answer')),
                          );
                          return; // Exit the onTap function to prevent further action
                        }
                      }
                      String textAnswer = textControllers[index]?.text ?? '';

                      if (isLast) {
                        textControllers[index]?.text;

                        answersMap[questionData.question] = {
                          'id': questionData.id,
                          'question-type': questionData.questionType,
                          'score': questionData.score,
                          'answer': textAnswer
                        };

                        sumOfScoresData();

                        // ScaffoldMessenger.maybeOf(context)!.showSnackBar(
                        //     SnackBar(
                        //         content: Text('Your Score Is $sumOfScores')));

                        if (widget.onSurveyEnd != null) {
                          widget.onSurveyEnd!(sumOfScores, answersMap);
                        } else {
                          _showSubmitDialog();
                        }

                        //show Popup Dailog here
                      } else {
                        addTheFollowUpQuestion(textAnswer,
                            isNestedchoice: true,
                            question: questionData.question,
                            answeValue: {
                              'id': questionData.id,
                              'question-type': questionData.questionType,
                              'score': questionData.score,
                              'answer': textAnswer
                            });
                        pageController.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut);
                      }
                    },
                    child: isLast
                        ? widget.customLastButton ??
                            Container(
                              width: isLast ? 150 : 120,
                              height: isLast ? 50 : 40,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.teal,
                                    Colors.teal.shade300,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    offset: Offset(5, 5),
                                    blurRadius: 10,
                                  )
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  isLast ? 'Submit Survey' : 'Next',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            )
                        : Container(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.5,
                              maxHeight:
                                  MediaQuery.of(context).size.height * 0.1,
                            ),
                            child: widget.customButton ??
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.32,
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.teal,
                                        Colors.teal.shade300,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black12,
                                        offset: Offset(5, 5),
                                        blurRadius: 10,
                                      )
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      isLast ? 'Submit Survey' : 'Next',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                          ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildMultipleChoicesQuestion(
    TreeNode questionData,
  ) {
    //  List<String> answers = [];

    ImagePosition imagePosition = ImagePosition.top;
    if (questionData.imagePosition != null) {
      imagePosition = ImagePosition.values.firstWhere(
        (e) => e.toString().split('.').last == questionData.imagePosition!,
        orElse: () => ImagePosition.top,
      );
    }

    if (answersMap.containsKey(questionData.question)) {
      if (answersMap[questionData.question]['answer'] != null &&
          answersMap[questionData.question]['answer'].isNotEmpty) {
        answers = answersMap[questionData.question]['answer'] ?? '';
      }
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 12, right: 12),
        child: Column(
          crossAxisAlignment:
              widget.questionContentAlignment ?? CrossAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            imagePosition == ImagePosition.top &&
                    questionData.image != null &&
                    questionData.image!.isNotEmpty
                ? ImageParser(
                    data: questionData,
                    imagePaceHolder: widget.imagePlaceHolder,
                  )
                : Container(),
            imagePosition == ImagePosition.top &&
                    questionData.image != null &&
                    questionData.image!.isNotEmpty
                ? SizedBox(height: MediaQuery.of(context).size.height * 0.01)
                : const SizedBox(
                    height: 0,
                  ),
            Text(
              questionData.question ?? "",
              style: widget.checkBoxQuestionStyle ??
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            imagePosition == ImagePosition.middle &&
                    questionData.image != null &&
                    questionData.image!.isNotEmpty
                ? ImageParser(
                    data: questionData,
                    imagePaceHolder: widget.imagePlaceHolder,
                  )
                : Container(),
            imagePosition == ImagePosition.middle &&
                    questionData.image != null &&
                    questionData.image!.isNotEmpty
                ? SizedBox(height: MediaQuery.of(context).size.height * 0.01)
                : const SizedBox(
                    height: 0,
                  ),
            questionData.description!.isNotEmpty
                ? Text(
                    questionData.description.toString(),
                    style: widget.description ?? const TextStyle(fontSize: 12),
                  )
                : const SizedBox(
                    height: 0,
                  ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            imagePosition == ImagePosition.bottom &&
                    questionData.image != null &&
                    questionData.image!.isNotEmpty
                ? ImageParser(
                    data: questionData,
                    imagePaceHolder: widget.imagePlaceHolder,
                  )
                : Container(),
            imagePosition == ImagePosition.top &&
                    questionData.image != null &&
                    questionData.image!.isNotEmpty
                ? SizedBox(height: MediaQuery.of(context).size.height * 0.01)
                : const SizedBox(
                    height: 0,
                  ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Column(
              children: (questionData.answerChoices).keys.map<Widget>((answer) {
                return CheckboxListTile(
                    title: Text(
                      answer,
                      style: widget.optionCheckBoxStyle ??
                          const TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 16),
                    ),
                    activeColor: widget.activeCheckboxColor ?? Colors.indigo,
                    value: answers.contains(answer),
                    onChanged: (bool? selected) {
                      setState(() {
                        if (selected ?? false) {
                          if (!answers.contains(answer)) {
                            answers.add(answer);
                          }
                        } else {
                          answers.remove(answer);
                        }
                      });
                    });
              }).toList(),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  questionData.isMandatory == false && isLast == false
                      ? GestureDetector(
                          onTap: () {
                            addTheFollowUpQuestion('',
                                isNestedchoice: true,
                                question: questionData.question,
                                answeValue: {'score': 0});
                            pageController.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                          },
                          /* child:
                    Container(
                      width: 120,
                      height:  40,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.blueGrey,
                            Colors.blueGrey.shade200,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            offset: Offset(5, 5),
                            blurRadius: 10,
                          )
                        ],
                      ),*/
                          child: Center(
                            child: Text(
                              widget.skipText ?? 'Skip',
                              style: widget.customSkipStyle ??
                                  const TextStyle(
                                      color: Colors.blue,
                                      fontSize: 16,
                                      decoration: TextDecoration.underline,
                                      decorationColor: Colors.blue,
                                      fontStyle: FontStyle.italic),
                            ),
                          ),
                        )
                      : const SizedBox(),
                  GestureDetector(
                      onTap: () {
                        int score = 0;
                        if (questionData.isMandatory == true) {
                          if (answers.isEmpty) {
                            ScaffoldMessenger.maybeOf(context)!.showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Please select at least one option')));
                            return;
                          }
                          // for (int i = 0; i < answers.length; i++) {
                          //   if (questionData.answerChoices != null) {
                          //     score = score +
                          //         questionData.answerChoices[answers[i]][0]
                          //             ['score'] as int;
                          //   }
                          // }
                          if (isLast) {
                            answersMap[questionData.question] = {
                              'id': questionData.id,
                              'question-type': questionData.questionType,
                              'score': score,
                              'answer': answers
                            };
                            sumOfScoresData();
                            // ScaffoldMessenger.maybeOf(context)!.showSnackBar(
                            //     SnackBar(
                            //         content:
                            //             Text('Your Score Is $sumOfScores')));
                            if (widget.onSurveyEnd != null) {
                              widget.onSurveyEnd!(sumOfScores, answersMap);
                            } else {
                              _showSubmitDialog();
                            }
                          } else {
                            setState(() {
                              addTheFollowUpQuestion(answers.toString(),
                                  isNestedchoice: true,
                                  question: questionData.question,
                                  answeValue: {
                                    'id': questionData.id,
                                    'question-type': questionData.questionType,
                                    'score': score,
                                    'answer': answers
                                  });
                              answers = [];

                              pageController.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                              );
                            });
                          }
                        } else {
                          if (isLast) {
                            answersMap[questionData.question] = {
                              'id': questionData.id,
                              'question-type': questionData.questionType,
                              'score': score,
                              'answer': answers
                            };
                            sumOfScoresData();
                            // ScaffoldMessenger.maybeOf(context)!.showSnackBar(
                            //     SnackBar(
                            //         content:
                            //             Text('Your Score Is $sumOfScores')));
                            if (widget.onSurveyEnd != null) {
                              widget.onSurveyEnd!(sumOfScores, answersMap);
                            } else {
                              _showSubmitDialog();
                            }
                          } else {
                            setState(() {
                              addTheFollowUpQuestion(answers.toString(),
                                  isNestedchoice: true,
                                  question: questionData.question,
                                  answeValue: {
                                    'id': questionData.id,
                                    'question-type': questionData.questionType,
                                    'score': score,
                                    'answer': answers
                                  });
                              answers = [];

                              pageController.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                              );
                            });
                          }
                        }
                        Future.delayed(Duration(milliseconds: 800))
                            .then((value) {
                          answers = [];
                          setState(() {});
                        });
                      },
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.5,
                          maxHeight: MediaQuery.of(context).size.height * 0.1,
                        ),
                        child: isLast
                            ? widget.customLastButton ??
                                Container(
                                  width: isLast ? 150 : 120,
                                  height: isLast ? 50 : 40,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.teal,
                                        Colors.teal.shade300,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black12,
                                        offset: Offset(5, 5),
                                        blurRadius: 10,
                                      )
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      isLast ? 'Submit Survey' : 'Next',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                )
                            : Container(
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.5,
                                  maxHeight:
                                      MediaQuery.of(context).size.height * 0.1,
                                ),
                                child: widget.customButton ??
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.32,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.teal,
                                            Colors.teal.shade300,
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.black12,
                                            offset: Offset(5, 5),
                                            blurRadius: 10,
                                          )
                                        ],
                                      ),
                                      child: Center(
                                        child: Text(
                                          isLast ? 'Submit Survey' : 'Next',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                              ),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDateTimeQuestion(TreeNode questionData) {
    ImagePosition imagePosition = ImagePosition.top;
    if (questionData.imagePosition != null) {
      imagePosition = ImagePosition.values.firstWhere(
        (e) => e.toString().split('.').last == questionData.imagePosition!,
        orElse: () => ImagePosition.top,
      );
    }

    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12),
      child: Column(
        crossAxisAlignment:
            widget.questionContentAlignment ?? CrossAxisAlignment.center,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          imagePosition == ImagePosition.top &&
                  questionData.image != null &&
                  questionData.image!.isNotEmpty
              ? ImageParser(
                  data: questionData,
                  imagePaceHolder: widget.imagePlaceHolder,
                )
              : Container(),
          imagePosition == ImagePosition.top &&
                  questionData.image != null &&
                  questionData.image!.isNotEmpty
              ? SizedBox(height: MediaQuery.of(context).size.height * 0.01)
              : const SizedBox(
                  height: 0,
                ),
          Text(
            questionData.question ?? "",
            style: widget.dateTimeQuestionStyle ??
                const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          imagePosition == ImagePosition.middle &&
                  questionData.image != null &&
                  questionData.image!.isNotEmpty
              ? ImageParser(
                  data: questionData,
                  imagePaceHolder: widget.imagePlaceHolder,
                )
              : Container(),
          imagePosition == ImagePosition.middle &&
                  questionData.image != null &&
                  questionData.image!.isNotEmpty
              ? SizedBox(height: MediaQuery.of(context).size.height * 0.01)
              : const SizedBox(
                  height: 0,
                ),
          questionData.description!.isNotEmpty
              ? Text(
                  questionData.description.toString(),
                  style: widget.description ?? const TextStyle(fontSize: 12),
                )
              : const SizedBox(
                  height: 0,
                ),

          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          imagePosition == ImagePosition.bottom &&
                  questionData.image != null &&
                  questionData.image!.isNotEmpty
              ? ImageParser(
                  data: questionData,
                  imagePaceHolder: widget.imagePlaceHolder,
                )
              : Container(),
          imagePosition == ImagePosition.bottom &&
                  questionData.image != null &&
                  questionData.image!.isNotEmpty
              ? SizedBox(height: MediaQuery.of(context).size.height * 0.01)
              : const SizedBox(
                  height: 0,
                ),
          const SizedBox(height: 10),

          GestureDetector(
            onTap: () => _selectDate(context),
            child: widget.dateTimeButton ??
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: MediaQuery.of(context).size.height * 0.05,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.teal,
                        Colors.teal.shade300,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(5, 5),
                        blurRadius: 10,
                      )
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'Select Date/Time',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          Text(
            '$selectedDate',
            //  '00:00:00',
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple.shade400),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          //   widget.isLastButton ??
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                questionData.isMandatory == false && isLast == false
                    ? GestureDetector(
                        onTap: () {
                          addTheFollowUpQuestion('',
                              isNestedchoice: true,
                              question: questionData.question,
                              answeValue: {'score': 0});
                          pageController.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        },
                        /* child:
                  Container(
                    width: 120,
                    height:  40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                           Colors.blueGrey,
                           Colors.blueGrey.shade200,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueGrey.shade50,
                          offset: const Offset(5, 5),
                          blurRadius:  10,
                        )
                      ],
                    ),*/
                        child: Center(
                          child: Text(
                            widget.skipText ?? 'Skip',
                            style: widget.customSkipStyle ??
                                const TextStyle(
                                    color: Colors.blue,
                                    fontSize: 16,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.blue,
                                    fontStyle: FontStyle.italic),
                          ),
                        ),
                      )
                    : const SizedBox(),
                GestureDetector(
                  onTap: () {
                    if (isLast) {
                      answersMap[questionData.question] = {
                        'id': questionData.id,
                        'question-type': questionData.questionType,
                        'score': questionData.score,
                        'answer': selectedDate.toIso8601String()
                      };

                      sumOfScoresData();

                      ScaffoldMessenger.maybeOf(context)!.showSnackBar(SnackBar(
                          content: Text('Your Score Is $sumOfScores')));

                      if (widget.onSurveyEnd != null) {
                        widget.onSurveyEnd!(sumOfScores, answersMap);
                      } else {
                        _showSubmitDialog();
                      }
                    } else {
                      addTheFollowUpQuestion('',
                          isNestedchoice: true,
                          question: questionData.question,
                          answeValue: {
                            'id': questionData.id,
                            'question-type': questionData.questionType,
                            'score': questionData.answerChoices.isEmpty
                                ? 0
                                : questionData.score,
                            'answer': selectedDate.toIso8601String()
                          });
                      pageController.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.ease);
                    }
                  },
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.5,
                      maxHeight: MediaQuery.of(context).size.height * 0.1,
                    ),
                    child: isLast
                        ? widget.customLastButton ??
                            Container(
                              color: Colors.blue,
                              child: const Text(
                                'Submit',
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                        : widget.customButton ??
                            Container(
                              width: MediaQuery.of(context).size.width *
                                  (isLast ? 0.32 : 0.32),
                              height: MediaQuery.of(context).size.height *
                                  (isLast ? 0.05 : 0.05),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.teal,
                                    Colors.teal.shade300,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    offset: Offset(5, 5),
                                    blurRadius: 10,
                                  )
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  isLast ? 'Submit Survey' : 'Next',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> _showSubmitDialog() async {
    //  List intValues = radioSelectedValues?.map((value) =>  value).toList() ?? [];
    // int sum = intValues.fold(0, (previousValue, element) => (previousValue + element).toInt());

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return widget.submitSurveyPopup ??
            AlertDialog(
              elevation: 0,
              insetPadding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.25,
                bottom: MediaQuery.of(context).size.height * 0.23,
              ),
              title: const Text('Submit Survey?'),
              content: Column(
                children: [
                  const Text('Do you want to submit the survey?'),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  Container(
                    height: circleSize,
                    width: circleSize,
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Colors.green,
                            width: MediaQuery.of(context).size.width * 0.01)),
                    child: Center(
                        child: Icon(Icons.check,
                            color: Colors.green, size: iconSize)),
                  ),
                ],
              ),
              actions: <Widget>[
                ElevatedButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  child: const Text('Submit'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    widget.surveyResult!(sumOfScores, answersMap);
                    if (widget.showScoreWidget == true) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Answers(
                                    scores: sumOfScores,
                                    answersMap: answersMap,
                                  )));
                    } else {
                      showScore();
                    }
                  },
                ),
              ],
            );
      },
    );
  }

  bool show = false;

  Future<void> showScore() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding:
              const EdgeInsets.only(left: 20, right: 20, top: 150, bottom: 180),
          title: const Text('Your Survey Score is:',
              style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 20)),
          elevation: 0,
          content: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.3),
              //  _buildBody(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.3),
              Container(
                height: MediaQuery.of(context).size.height * 0.01,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Colors.red,
                      Colors.orange,
                      Colors.yellow,
                      Colors.greenAccent,
                      Colors.green
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: Colors.transparent,
                    inactiveTrackColor: Colors.transparent,
                    trackHeight: 0.1,
                    thumbColor: Colors.blue,
                  ),
                  child: Slider(
                    min: 0,
                    max: 200,
                    divisions: 10,
                    value: sumOfScores.toDouble(),
                    onChanged: (_) {},
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

// late AnimationController _controller;
}
