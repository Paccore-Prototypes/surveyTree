import 'dart:collection';
import 'dart:convert';
import 'package:custom_scale/src/tree_node.dart';
import 'package:flutter/material.dart';
import 'answers.dart';


class SurveyTree extends StatefulWidget {
  SurveyTree({super.key,
    this.sliderQuestionStyle,
    this.radioQuestion,
    this.listTileQuestionStyle,
    this.checkBoxQuestionStyle,
    this.dateTimeQuestionStyle,
    this.customButton,
    required this.treeModel,
    this.optionRadioStyle,
    this.optionCheckBoxStyle,
    this.optionListTileStyle,
    this.activeColorSlider,
    this.inactiveColorSlider,
    this.activeRadioColor,
    this.activeRadioTextColor,
    this.tileListColor,
    this.textFieldQuestionStyle,
    this.buttonTextStyle,
    this.buttonText,
    this.buttonDecoration,
    this.submitSurveyPopup,
    this.showResultant,
    required this.isNavigation
  });
  TextStyle? sliderQuestionStyle;
  TextStyle? radioQuestion;
  TextStyle? listTileQuestionStyle;
  TextStyle? checkBoxQuestionStyle;
  TextStyle? dateTimeQuestionStyle;
  ElevatedButton? customButton;
  TreeModel treeModel;
  TextStyle? optionRadioStyle;
  TextStyle? optionListTileStyle;
  TextStyle? optionCheckBoxStyle;
  Color? activeColorSlider;
  Color? inactiveColorSlider;
  Color? activeRadioColor;
  Color? activeRadioTextColor;
  Color? tileListColor;
  TextStyle? textFieldQuestionStyle;
  TextStyle? buttonTextStyle;
  String? buttonText;
  BoxDecoration? buttonDecoration;
  AlertDialog? submitSurveyPopup;
  Function(bool? result,int healthScore,  HashMap<String, dynamic> answersMap)? showResultant;
  bool isNavigation;



  @override
  State<SurveyTree> createState() => _SurveyTreeState();
}

class _SurveyTreeState extends State<SurveyTree> with TickerProviderStateMixin{
  late AnimationController scaleController = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);
  late Animation<double> scaleAnimation = CurvedAnimation(parent: scaleController, curve: Curves.elasticOut);
  late AnimationController checkController = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this);
  late Animation<double> checkAnimation = CurvedAnimation(parent: checkController, curve: Curves.linear);
  int currentDataIndex = 0;
  int currentMainChildrenlistIndex = 0;
  bool isLast = false;
  Map<String, dynamic> scoreMap = {};
  int sumOfScores = 0;
  bool isLoad = false;
  TreeModel? pageviewTree;



  GlobalKey _scafoldKey = GlobalKey<ScaffoldState>();
  HashMap<String, dynamic> answersMap = HashMap();
  Map<int, TextEditingController> textControllers = {};



  List<Map<String, dynamic>>? jsonResult;

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
    _controller = AnimationController(
      vsync: this,
      lowerBound: 0.5,
      duration: Duration(seconds: 3),
      reverseDuration: Duration(seconds: 3)
    )..repeat();
  }

  TextEditingController nameController = TextEditingController();
  List<String> answers = [];
  String? selectedValue;
  List<Map<String, dynamic>> followUpQuestions = [];
  PageController pageController = PageController();
  int currentQuestionIndex = 0;

  void resetOption() {
    if ( pageController.page?.toInt()== 0) {
      answersMap.clear();
    }
  }
  void sumOfScoresData() {
    sumOfScores=0;
    answersMap.forEach((key, value) {
      if (value['score'] != null && value['score'] is int) {
        sumOfScores += value['score'] as int;
      }
    });
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          pageController.previousPage(
              duration: const Duration(milliseconds: 500), curve: Curves.ease);
          if (pageviewTree != null) {
            isLast = false;
            if(pageController.page?.toInt() ==0){

            }else{
              removeTheNode();
              setState(() {});
            }

          }
          return false;
        },
        child: Scaffold(
          key: _scafoldKey,
          appBar: AppBar(
            title:  Text(
              "Survey App",
              style:TextStyle(color: Colors.blueGrey.shade900,fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.blueGrey.shade400,
          ),
          body: isLoad? const Center(
              child: CircularProgressIndicator())
              :Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.blueGrey.shade200,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: PageView.builder(
                physics: const NeverScrollableScrollPhysics(),
                controller: pageController,
                itemCount: pageviewTree?.nodes.length ?? 0,
                itemBuilder: (context, index) {

                    return buildQuestion(pageviewTree!.nodes, index);
                },
              ),
            ),
          ),
        ),
      );
  }

  ValueNotifier<double> sliderValue = ValueNotifier<double>(50);

  Widget buildSliderQuestion(TreeNode questionData) {
    ValueNotifier<double> sliderValue = ValueNotifier<double>(25);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

            Text(
          questionData.question??"",
          style: widget.sliderQuestionStyle?? const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 12,
        ),
        ValueListenableBuilder<double>(
          valueListenable: sliderValue,
          builder: (context, value, child) {
            return Column(
              children: [
                Slider(
                  value: value.clamp(0, 100),
                  divisions: 100,
                  onChanged: (double newValue) {
                    sliderValue.value = newValue;
                  },
                  max: 100,
                 inactiveColor:   widget.inactiveColorSlider ?? Colors.blueGrey.shade300,
                  activeColor: widget.activeColorSlider ?? Colors.blueGrey,
                  label: sliderValue.value.toStringAsFixed(0),
                ),
                Text(
                  "Saved Value: ${sliderValue.value.toStringAsFixed(0)}",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple.shade400),
                ),
              ],
            );
          },
        ),
        const SizedBox(
          height: 25,
        ),
        GestureDetector(
          onTap: () {
            if (isLast) {
              answersMap[questionData.question!]={
                'score':questionData.score,
                'answer':sliderValue.value.toStringAsFixed(0)
              };
              _showSubmitDialog();
            } else {
              addTheFollowUpQuestion('',
                  isNestedchoice: true,
                  question: questionData.question,
                  answeValue: {
                    'score': questionData.answerChoices == null
                        ? 0
                        : questionData.score,
                    'answer': '${sliderValue.value.toStringAsFixed(0)}'
                  });
              pageController.nextPage(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            }
          },
          child: Container(
            width: 120,
            height: 40,
            decoration: widget.buttonDecoration ?? BoxDecoration(
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
              child: Text(widget.buttonText ??
                'Next',
                style: widget.buttonTextStyle ?? const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
             ],
    );
  }

  Widget buildQuestion(List<TreeNode> data, int pageIndex) {
    String questionType = data[pageIndex].questionType;
    switch (questionType) {
      case "radio":
        return buildRadioQuestion(data[pageIndex], pageIndex);
      case "slider":
        return buildSliderQuestion(data[pageIndex]);
      case "multipleChoices":
        return buildMultipleChoicesQuestion(data[pageIndex]);
      case "datetime":
        return buildDateTimeQuestion(data[pageIndex]);
      case "list":
        return buildLIstQuestioins(data[pageIndex]);
      case "text-field":
        return buildTextQuestion(data[pageIndex], pageIndex);
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


  void addTheFollowUpQuestion(String answer,
      {bool isNestedchoice = false,
      String? question,
      Map<String, dynamic>? answeValue,
      bool isRecrusive = false}) async {
    TreeModel? model;
    TreeNode? node;
    resetOption();
    if (!isRecrusive) {
      answersMap[question!] = answeValue;
    }

    print('the answer choices were ' + answersMap.toString());
    if (isNestedchoice) {
      if (pageviewTree!
              .nodes[pageController.page!.toInt() ].answerChoices[answer] ==
          null) {
        currentMainChildrenlistIndex = currentMainChildrenlistIndex + 1;
        if (currentMainChildrenlistIndex == widget.treeModel!.nodes.length -1) {
          isLast = true;
        }
        node = widget.treeModel!.nodes[currentMainChildrenlistIndex];
      } else {
//    print('The answer choices where----'+pageviewTree!
 //   .nodes[pageController.page!.toInt() ].answerChoices[answer].toString());
        model = TreeModel.fromJson(pageviewTree!
            .nodes[pageController.page!.toInt() ].answerChoices[answer]);
        node = model.nodes[0];
      }
    } else {
      // print('The answer choices where----'+pageviewTree!
      //     .nodes[pageController.page!.toInt() ].answerChoices[answer]);
      model = TreeModel.fromJson(
          widget.treeModel!.nodes[currentQuestionIndex].answerChoices[answer]);
      node = model.nodes[0];
    }
    if (node.questionType != "") {
      pageviewTree!.nodes.add(node);
    } else {
      //Recursion Alogorithm
      addTheFollowUpQuestion('', isNestedchoice: true, isRecrusive: true);
    }

    setState(() {});
  }

  var sum = 0;
  static const double _shadowHeight = 4;
  double _position = 4;
  final double _height = 50 - _shadowHeight;
  double circleSize = 140;
  double iconSize = 108;

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
          insetPadding: const EdgeInsets.only(top: 180, bottom: 180),
          title: const Text('Submit Survey?'),
          content: Column(
            children: [
              const Text('Do you want to submit the survey?'),
              const SizedBox(height: 40,),

              Container(
            height: circleSize,
            width: circleSize,
            decoration: BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.circle,
                border: Border.all(color: Colors.green,width: 12)
            ),
            child: SizeTransition(
                sizeFactor: checkAnimation,
                axis: Axis.horizontal,
                axisAlignment: -1,
                child: Center(
                    child: Icon(Icons.check, color: Colors.green, size: iconSize)
                )
            ),
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
                widget.showResultant!(true,sumOfScores,answersMap);
                print('------------------------------------printing the all values are     ${widget.showResultant}');
                if(widget.isNavigation==true) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              Answers(scores: sumOfScores,
                                answersMap: answersMap,
                              )));
                }else{
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
          insetPadding: const EdgeInsets.only(left: 20,right: 20,top: 150,bottom: 180),
          title: const Text('Your Health Score is:', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 20)),
          elevation: 0,
          content: Column(
            children: [
              const SizedBox(height: 30),
              _buildBody(),
              const SizedBox(height: 30),
              Container(
                height: 10,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.red, Colors.orange, Colors.yellow, Colors.greenAccent, Colors.green],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: Colors.transparent,
                    inactiveTrackColor: Colors.transparent,
                    trackHeight: 0.1,
                    thumbColor: Colors.red,
                    overlayColor: Colors.yellow.withAlpha(1),
                  ),
                  child: Slider(
                    min: 0,
                    max: 100,divisions: 10,
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

  late AnimationController _controller;

  Widget _buildContainer(double radius) {
    return Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue.withOpacity(1 - _controller.value),
      ),
    );
  }

  Widget _buildBody() {
    return AnimatedBuilder(
      animation: CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn),
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            _buildContainer(100 * _controller.value),
            _buildContainer(150 * _controller.value),
            _buildContainer(200 * _controller.value),
            _buildContainer(250 * _controller.value),
            _buildContainer(250 * _controller.value),
            Align(child: Text('$sumOfScores', style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold))),
          ],
        );
      },
    );
  }

  void removeTheNode() async {
    bool shouldBreak = false;

    for (int j = 0; j < pageviewTree!.nodes.length; j++) {
      String question =
          pageviewTree!.nodes[pageController.page!.toInt() ].question;

      for (int i = 0; i < widget.treeModel!.nodes.length; i++) {
        if (question == widget.treeModel!.nodes[i].question) {
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
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.question??'',
            style: widget.radioQuestion ?? const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          Column(
            children: (data.answerChoices as Map<String, dynamic>)
                .keys
                .map<Widget>((answer) {
              if (data.answerChoices[answer] != null) {
                if (answersMap.containsKey(data.question)) {
                  selectedValue = answersMap[data.question]['answer'];
                }
              }
                return RadioListTile(
                    title:  Text(answer,style: widget.optionRadioStyle ?? TextStyle( color: selectedValue==answer?Colors.deepPurple:Colors.black,fontWeight: FontWeight.w400,fontSize: 16),),
                    value: answer,
                    activeColor: widget.activeRadioColor ?? Colors.deepPurple,
                    groupValue: selectedValue?.isNotEmpty ?? false
                        ? selectedValue
                        : null,
                    onChanged: (selectedAnswer) {
                      setState(() {
                        selectedValue = selectedAnswer;
                        answer = selectedAnswer!;
                      });
                      if(isLast){
                        answersMap[data.question!]={
                          'score':data.answerChoices == null?data.score:data.answerChoices[selectedValue][0]
                          ['score'],
                          'answer':selectedValue
                        };
                        sumOfScoresData();

                        ScaffoldMessenger.maybeOf(context)!.showSnackBar(
                            SnackBar(content: Text('Your Score Is $sumOfScores')));

                        _showSubmitDialog();
                      }else {
                        addTheFollowUpQuestion(answer,
                            isNestedchoice: true,
                            question: data.question,
                            answeValue: {
                              'score':data.answerChoices[selectedAnswer]!=null? data.answerChoices[selectedAnswer][0]
                              ['score']:0,
                              'answer': selectedAnswer
                            });

                        pageController.nextPage(
                            duration: const Duration(milliseconds: 500), curve: Curves.ease);
                      }
                    });
             // }
            }).toList(),
          ),
          SizedBox(height: 20,),
          widget.customButton ??
          GestureDetector(
            onTap: () {

              if (isLast) {

                if(answersMap.containsKey(data.question)){
                  sumOfScoresData();

                  ScaffoldMessenger.maybeOf(context)!.showSnackBar(
                      SnackBar(content: Text('Your Score Is $sumOfScores')));

                  _showSubmitDialog();
                }else{
                  ScaffoldMessenger.maybeOf(context)!.showSnackBar(const SnackBar(content: Text('Please select at least one answer'),behavior: SnackBarBehavior.floating,));

                }
              } else {
                if(data.isMandatory==true) {
                  if (answers.isEmpty) {
                    ScaffoldMessenger.maybeOf(context)!.showSnackBar(
                        const SnackBar(
                          content: Text('Please select at least one answer'),
                          behavior: SnackBarBehavior.floating,));
                    return;
                  }
                  addTheFollowUpQuestion('',
                      isNestedchoice: true,
                      question: data.question,
                      answeValue: {
                        'score': data.answerChoices == null ? 0 : data.score,
                        'answer': ''
                      });
                  pageController.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                }else{
                  addTheFollowUpQuestion('',
                      isNestedchoice: true,
                      question: data.question,
                      answeValue: {
                        'score': data.answerChoices == null ? 0 : data.score,
                        'answer': ''
                      });
                  pageController.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                }
              }
            },
            child: Container(
              width: 120,
              height: 40,
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
                  isLast ? 'SubmitSurvey!':'Next',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLIstQuestioins(TreeNode questionData) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 430),
      color: Colors.blueGrey.shade200,
      child: Padding(
        padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              questionData.question,
              style: widget.listTileQuestionStyle ?? const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Column(
              children: (questionData.answerChoices as Map<String, dynamic>)
                  .keys
                  .map<Widget>((answer) {
                bool isSelected = answersMap.containsKey(questionData.question) &&
                    answersMap[questionData.question]['answer'] == answer;

                if (questionData.answerChoices[answer] == null) {
                  return ListTile(
                    selectedColor: Colors.red,
                    title: Text(answer,style: widget.optionListTileStyle ?? const TextStyle(color: Colors.black,fontWeight: FontWeight.w400,fontSize: 16),),
                    tileColor:  isSelected ? widget.tileListColor ?? Colors.green.withOpacity(0.2) : null,
                  );
                } else {
                  return ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(answer),
                        if (isSelected)
                          const Icon(
                            Icons.check,
                            color: Colors.black,
                          ),
                      ],
                    ),
                   // selectedTileColor: widget.tileListColor ?? Colors.green,
                    tileColor: isSelected ? widget.tileListColor ?? Colors.green : null,

                    onTap: () {
                      addTheFollowUpQuestion(answer,
                          isNestedchoice: true,
                          question: questionData.question,
                          answeValue: {
                            'score': questionData.answerChoices[answer][0]['score'],
                            'answer': answer
                          });
                      pageController.nextPage(
                          duration: const Duration(milliseconds: 500), curve: Curves.ease);
                    },
                  );
                }
              }).toList(),
            ),
            SizedBox(height: 20,),
            widget.customButton ??
                GestureDetector(
                  onTap: () {

                    if (isLast) {

                      if(answersMap.containsKey(questionData.question)){
                        sumOfScoresData();

                        ScaffoldMessenger.maybeOf(context)!.showSnackBar(
                            SnackBar(content: Text('Your Score Is $sumOfScores')));

                        _showSubmitDialog();
                      }else{
                        ScaffoldMessenger.maybeOf(context)!.showSnackBar(const SnackBar(content: Text('Please select at least one answer'),behavior: SnackBarBehavior.floating,));

                      }
                    } else {
                      if(questionData.isMandatory==true) {
                        if (answers.isEmpty) {
                          ScaffoldMessenger.maybeOf(context)!.showSnackBar(
                              const SnackBar(
                                content: Text('Please select at least one answer'),
                                behavior: SnackBarBehavior.floating,));
                          return;
                        }
                        addTheFollowUpQuestion('',
                            isNestedchoice: true,
                            question: questionData.question,
                            answeValue: {
                              'score': questionData.answerChoices == null ? 0 : questionData.score,
                              'answer': ''
                            });
                        pageController.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      }else{
                        addTheFollowUpQuestion('',
                            isNestedchoice: true,
                            question: questionData.question,
                            answeValue: {
                              'score': questionData.answerChoices == null ? 0 : questionData.score,
                              'answer': ''
                            });
                        pageController.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      }
                    }
                  },
                  child: Container(
                    width: 120,
                    height: 40,
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
                        isLast ? 'SubmitSurvey!':'Next',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }


  Widget buildTextQuestion(TreeNode questionData, int index) {
    textControllers.putIfAbsent(index, () => TextEditingController(text: ''));

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Text(
            questionData.question,
            style: widget.textFieldQuestionStyle ?? const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Your Answer',
            ),
            controller: textControllers[index],
            onChanged: (text) {
              text = nameController.text.trim();
              //int score = int.parse(text);
              //radioSelectedValues?.add(score);
            },
          ),
          const SizedBox(
            height: 15,
          ),
          // currentQuestionIndex == surveyData.length-1
      //    widget.isLastButton ??
          Center(
            child: GestureDetector(
              onTap: () {
                String textAnswer = textControllers[index]?.text ?? '';

                if (isLast) {
                  textControllers[index]?.text;

                  answersMap[questionData.question!]={
                    'score':questionData.score,
                    'answer':textAnswer
                  };

                  sumOfScoresData();

                  ScaffoldMessenger.maybeOf(context)!.showSnackBar(
                      SnackBar(content: Text('Your Score Is $sumOfScores')));

                  _showSubmitDialog();

                  //show Popup Dailog here
                } else {
                  addTheFollowUpQuestion(textAnswer,
                      isNestedchoice: true,
                      question: questionData.question,
                      answeValue: {
                        'score': questionData.score,
                        'answer': textAnswer
                      });
                  pageController.nextPage(
                      duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
                }
              },
              child: SizedBox(
                height: _height + _shadowHeight,
                width: 150,
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 0,
                      child: Container(
                        height: _height,
                        width: 150,
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.all(
                            Radius.circular(16),
                          ),
                        ),
                      ),
                    ),
                    AnimatedPositioned(
                      curve: Curves.easeIn,
                      bottom: _position,
                      duration: const Duration(milliseconds: 70),
                      child: Container(
                        height: _height,
                        width: 150,
                        decoration: const BoxDecoration(
                          color: Colors.blueGrey,
                          borderRadius: BorderRadius.all(
                            Radius.circular(16),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            isLast ? 'Submit Survey!' : 'Next',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildMultipleChoicesQuestion(
      TreeNode questionData,
      ) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            questionData.question,
            style: widget.checkBoxQuestionStyle ?? const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Column(
            children: (questionData.answerChoices as Map<String, dynamic>)
                .keys
                .map<Widget>((answer) {
              return CheckboxListTile(
                title: Text(answer,style: widget.optionCheckBoxStyle ?? const TextStyle(fontWeight: FontWeight.w400,fontSize: 16),),
                value: answers.contains(answer),
                onChanged: (selected) {
                  setState(() {
                    if (answers.contains(answer)) {
                      answers.remove(answer);
                    } else {
                      answers.add(answer);
                    }
                  });
                },
              );
            }).toList(),
          ),
          SizedBox(height: 20,),
          widget.customButton ??
              GestureDetector(
                onTap: () {
                  int score = 0;
                  if(questionData.isMandatory==true){
                  if (answers.isEmpty) {
                    ScaffoldMessenger.maybeOf(context)!.showSnackBar(const SnackBar(content: Text('Please select at least one option')));
                    return;
                  }
                  for (int i = 0; i < answers.length; i++) {
                    if (questionData.answerChoices != null) {
                      score = score +
                          questionData.answerChoices[answers[i]][0]['score'] as int;
                    }
                  }
                  if(isLast){
                    answersMap[questionData.question!]={
                      'score':score,
                      'answer':answers
                    };
                    sumOfScoresData();
                    ScaffoldMessenger.maybeOf(context)!.showSnackBar(SnackBar(content: Text('Your Score Is $sumOfScores')));
                    _showSubmitDialog();
                  }else{

                    setState(() {

                      addTheFollowUpQuestion(answers.toString(),
                          isNestedchoice: true,
                          question: questionData.question,
                          answeValue: {'score': score, 'answer': answers});
                      pageController.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    });
                  }}else{
                    setState(() {
                      addTheFollowUpQuestion(answers.toString(),
                          isNestedchoice: true,
                          question: questionData.question,
                          answeValue: {'score': score, 'answer': answers});
                      pageController.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    });
                  }},
                child: Container(
                  width: 120,
                  height: 40,
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
                      isLast?'Submit Survey':'Next',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }

  Widget buildDateTimeQuestion(TreeNode questionData) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            questionData.question,
            style: widget.dateTimeQuestionStyle ?? TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

              GestureDetector(
                onTap: () => _selectDate(context),
                child: Container(
                  width: 200,
                  height: 40,
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
          const SizedBox(height: 20),
          Text(
            '$selectedDate',
          //  '00:00:00',
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple.shade400),
          ),
          const SizedBox(height: 15),
       //   widget.isLastButton ??
              Center(
                child: GestureDetector(
                  onTap: () {
                    if(isLast){

                      answersMap[questionData.question]={
                        'score':questionData.score,
                        'answer':selectedDate
                      };


                      sumOfScoresData();

                      ScaffoldMessenger.maybeOf(context)!.showSnackBar(SnackBar(content: Text('Your Score Is $sumOfScores')));
                      _showSubmitDialog();

//Show PopUp dailog here
                    }else{
                      addTheFollowUpQuestion('',isNestedchoice: true,

                          question: questionData.question,answeValue: {
                            'score':questionData.answerChoices.isEmpty?0: questionData.score,
                            'answer':selectedDate
                          }
                      );
                      pageController.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.ease);

                    }


                  },
                  child: SizedBox(
                    height: _height + _shadowHeight,
                    width: 150,
                    child: Stack(
                      children: [
                        Positioned(
                          bottom: 0,
                          child: Container(
                            height: _height,
                            width: 150,
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.all(
                                Radius.circular(16),
                              ),
                            ),
                          ),
                        ),
                        AnimatedPositioned(
                          curve: Curves.easeIn,
                          bottom: _position,
                          duration: const Duration(milliseconds: 70),
                          child: Container(
                            height: _height,
                            width: 150,
                            decoration: const BoxDecoration(
                              color: Colors.blueGrey,
                              borderRadius: BorderRadius.all(
                                Radius.circular(16),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                isLast ? 'Submit Survey!' : 'Next',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
        ],
      ),
    );
  }
}
