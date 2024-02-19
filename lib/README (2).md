<p align="center">
<img src="https://github.com/quickbirdstudios/survey_kit/blob/main/example/assets/surveykit_logo.png?raw=true" width="500">
</p>

# SurveyKit: Create beautiful surveys with Flutter (inspired by [iOS ResearchKit Surveys](https://researchkit.org/docs/docs/Survey/CreatingSurveys.html))

Survey kits, also known as survey platforms or survey software, are tools used to design, distribute, and analyze surveys. These tools are used by individuals, businesses, organizations, and researchers to collect data from respondents on various topics.Users start by designing their survey questionnaires using the survey kit's interface. This involves creating various types of questions such as multiple-choice, open-ended, Likert scale, rating scale, etc.
This is an early version and work in progress. Do not hesitate to give feedback, ideas or improvements via an issue.
# flowchat
<p align="center">
<img src="">
Question Hierarchy: In a survey, questions are often organized hierarchically, with some questions being dependent on others. For example, follow-up questions may depend on the answers to previous questions. A tree structure allows you to represent this hierarchy efficiently. Each node in the tree can represent a question, and child nodes can represent follow-up questions or options dependent on the parent question.
Navigation Flow: A survey kit needs to manage the flow of questions, directing respondents through the survey in a logical sequence. A tree structure can represent the navigation flow, with branches representing different paths respondents can take based on their answers. This makes it easier to implement branching logic in the survey.
Conditional Logic: Many surveys include conditional logic, where the display of certain questions depends on the responses to previous questions. A tree structure facilitates the implementation of conditional logic. You can traverse the tree based on respondent answers to determine which questions to display next.
Data Validation: Trees can assist in data validation by enforcing constraints on the survey structure. For instance, you can ensure that each question has at least one answer choice, or that follow-up questions are linked to valid parent questions. This helps maintain data integrity and prevents errors in survey design.
Survey Design Tools: Survey development tools can leverage tree structures to provide a visual representation of the survey questionnaire. Users can create and edit surveys using a graphical interface that resembles a tree, making it intuitive to organize and modify survey questions.
Dynamic Survey Generation: With a tree structure representing the survey, you can dynamically generate surveys based on templates or predefined structures. This is useful for creating standardized surveys for different purposes or adapting surveys to different contexts or audiences.
Analysis and Reporting: After data collection, trees can aid in the analysis and reporting phase by providing a structured representation of survey responses. You can traverse the tree to aggregate and summarize responses, visualize data, and generate reports.

# Examples
###### Flow
<p align="center">
<img src="https://github.com/quickbirdstudios/survey_kit/blob/main/example/assets/survey-kit-demo.gif?raw=true" width="350">
</p>

###### Screenshots

| | | | | | 
| :---: | :---: | :---: | :---: | :---: |
| <img src="https://github.com/quickbirdstudios/survey_kit/blob/main/example/assets/step_01_ios.png?raw=true" width="200"> | <img src="https://github.com/quickbirdstudios/survey_kit/blob/main/example/assets/step_02_ios.png?raw=true" width="200"> | <img src="https://github.com/quickbirdstudios/survey_kit/blob/main/example/assets/step_03_ios.png?raw=true" width="200"> | <img src="https://github.com/quickbirdstudios/survey_kit/blob/main/example/assets/step_04_ios.png?raw=true" width="200"> | <img src="https://github.com/quickbirdstudios/survey_kit/blob/main/example/assets/step_05_ios.png?raw=true" width="200"> |  




## 📚 Overview: Creating Research Surveys
- [What SurveyKit does for you](#what-surveykit-does-for-you)
- [What SurveyKit does not (yet) do for you](#what-surveykit-does-not-yet-do-for-you)
- [🏃 Setup](#-🏃-setup)
  - [1. Add the dependecy](#1-add-the-dependecy)
  - [2. Install it](#2-install-it)
  - [3. Import it](#3-import-it)
- [💻 Usage](#-usage)
  - [Create survey steps](#create-survey-steps)
  - [Create a Task](#create-a-task)
  - [Evaluate the results](#evaluate-the-results)
  - [Style](#style)
  - [Start the survey](#start-the-survey)
- [📇 Custom steps](#-custom-steps)
- [🍏vs🤖 : Comparison of Flutter SurveyKit, SurveyKit on Android to ResearchKit on iOS](#-🍏vs🤖-:-comparison-of-flutter-surveykit,-surveykit-on-android-to-researchkit-on-iOS)
- [👤 Author](#-author)
- [❤️ Contributing](#️-contributing)
- [📃 License](#-license)

## What SurveyKit does for you
-   Simplifies the creation of surveys
-   Provides rich animations and transitions out of the box (custom animations planned)
-   Build with a consistent, lean, simple style, to fit research purposes
-   Survey navigation can be linear or based on a decision tree (directed graph)
-   Gathers results and provides them in a convinient manner to the developer for further use
-   Gives you complete freedom on creating your own questions
-   Allows you to customize the style
-   Provides an API and structure that is very similar to [iOS ResearchKit Surveys](https://researchkit.org/docs/docs/Survey/CreatingSurveys.html)

## What SurveyKit does not (yet) do for you
As stated before, this is an early version and a work in progress. We aim to extend this library until it matches the functionality of the [iOS ResearchKit Surveys](https://researchkit.org/docs/docs/Survey/CreatingSurveys.html).

# 🏃 Setup  
To use this plugin, add flutter_surveykit as a dependency in your pubspec.yaml file.

## 1. Add the dependecy
`pubspec.yaml`
```yaml
dependencies:
  survey_kit: ^0.1.1
```

## 2. Install it
```
flutter pub get
```

## 3. Import it
```dart
import 'package:survey_kit/survey_kit.dart';
```

# 💻 Usage
## Example
A working example project can be found [HERE](example/)


### Start the survey
All that's left is to insert the survey in the widget tree and enjoy.🎉🎊
```dart
Scaffold(
body: SurveyTree(
treeModel: Model!, 
customButton: ElevatedButton(
onPressed: () {
// Your onPressed callback function
},
child: Text('Next'),
),
tileListColor: Colors.blue,
),
);

```







# 🍏vs🤖 : Comparison of Flutter SurveyKit, [SurveyKit on Android](https://github.com/quickbirdstudios/SurveyKit) to [ResearchKit on iOS](https://researchkit.org/docs/docs/Survey/CreatingSurveys.html)
This is an overview of which features [iOS ResearchKit Surveys](https://researchkit.org/docs/docs/Survey/CreatingSurveys.html) provides and which ones are already supported by [SurveyKit on Android](https://github.com/quickbirdstudios/SurveyKit).
The goal is to make all three libraries match in terms of their functionality.

<p> 
<img src="https://github.com/quickbirdstudios/survey_kit/blob/main/example/assets/survey-kit-features.png?raw=true">
</p>


# 🤖 : Create your Survey via JSON
You are also able to load and create your survey via JSON. This gives you the oppertunity to dynamicly configure and deliver different surveys.
To create your survey in JSON is almost as easy as in Dart.
Just call ```dart Task.fromJson() ``` with your JSON-File or Response. The JSON should look like this:

```json
{
    "id": "123",
    "type": "navigable",
    "rules": [
        {
            "type": "conditional",
            "triggerStepIdentifier": {
                "id": "3"
            },
            "values": {
                "Yes": "2",
                "No": "10"
            }
        },
        {
            "type": "direct",
            "triggerStepIdentifier": {
                "id": "1"
            },
            "destinationStepIdentifier": {
                "id": "3"
            }
        },
        {
            "type": "direct",
            "triggerStepIdentifier": {
                "id": "2"
            },
            "destinationStepIdentifier": {
                "id": "10"
            }
        }
    ],
    "steps": [
        {
            "stepIdentifier": {
                "id": "1"
            },
            "type": "intro",
            "title": "Welcome to the\nQuickBird Studios\nHealth Survey",
            "text": "Get ready for a bunch of super random questions!",
            "buttonText": "Let's go!"
        },
        {
            "stepIdentifier": {
                "id": "2"
            },
            "type": "question",
            "title": "How old are you?",
            "answerFormat": {
                "type": "integer",
                "defaultValue": 25,
                "hint": "Please enter your age"
            }
        },
        {
            "stepIdentifier": {
                "id": "3"
            },
            "type": "question",
            "title": "Medication?",
            "text": "Are you using any medication",
            "answerFormat": {
                "type": "bool",
                "positiveAnswer": "Yes",
                "negativeAnswer": "No",
                "result": "POSITIVE"
            }
        },    
        {
            "stepIdentifier": {
                "id": "10"
            },
            "type": "completion",
            "text": "Thanks for taking the survey, we will contact you soon!",
            "title": "Done!",
            "buttonText": "Submit survey"
        }
    ]
}
```

You can find the complete example [HERE](https://github.com/Alavalaiah123/SurveyTree/blob/main/assets/survey.json)

# 👤 Author
This Flutter library is created with 💙 by [QuickBird Studios](https://quickbirdstudios.com/).

# ❤️ Contributing
Open an issue if you need help, if you found a bug, or if you want to discuss a feature request.

Open a PR if you want to make changes to SurveyKit.

# 📃 License
SurveyKit is released under an MIT license. See [License](LICENSE) for more information.
