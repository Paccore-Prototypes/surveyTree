 # <p align="center">

 # <img src="https://github.com/Paccore-Prototypes/info_survey/blob/main/assets/images/infoswiftCorp.jpeg?raw=true" width="1100">

 # </p>

# SurveyKit: Create beautiful surveys with Flutter (inspired by [iOS ResearchKit Surveys](https://researchkit.org/docs/docs/Survey/CreatingSurveys.html))

Survey kits, also known as survey platforms or survey software, are tools used to design, distribute, and analyze surveys. These tools are used by individuals, businesses, organizations, and researchers to collect data from respondents on various topics.Users start by designing their survey questionnaires using the survey kit's interface. This involves creating various types of questions such as multiple-choice, open-ended, Likert scale, rating scale, etc.
This is an early version and work in progress. Do not hesitate to give feedback, ideas or improvements via an issue.
# flowchat
<p align="center">
<img src="https://github.com/Paccore-Prototypes/info_survey/blob/main/assets/images/Flow%20Diagram%20.png?raw=true"height="700">

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
<img src="https://github.com/Paccore-Prototypes/info_survey/blob/main/assets/images/Screenshots/surveyplugin.gif?raw=true" width="350">
</p>

###### Screenshots

|                                                                                                                                         | | | | | 
|:---------------------------------------------------------------------------------------------------------------------------------------:| :---: | :---: | :---: | :---: |
| <img src="https://github.com/Paccore-Prototypes/info_survey/blob/main/assets/images/Screenshots/1.jpg?raw=true" width="200"> | <img src="https://github.com/Paccore-Prototypes/info_survey/blob/main/assets/images/Screenshots/2.jpg?raw=true" width="200">  | <img src="https://github.com/Paccore-Prototypes/info_survey/blob/main/assets/images/Screenshots/3.jpg?raw=true" width="200"> | <img src="https://github.com/Paccore-Prototypes/info_survey/blob/main/assets/images/Screenshots/4.jpg?raw=true" width="200">  | <img src="https://github.com/Paccore-Prototypes/info_survey/blob/main/assets/images/Screenshots/5.jpg?raw=true" width="200"> |
|<img src="https://github.com/Paccore-Prototypes/info_survey/blob/main/assets/images/Screenshots/6.jpg" width="200">  | <img src="https://github.com/Paccore-Prototypes/info_survey/blob/main/assets/images/Screenshots/7.jpg?raw=true" width="200"> | <img src="https://github.com/Paccore-Prototypes/info_survey/blob/main/assets/images/Screenshots/8.jpg?raw=true" width="200"> |<img src="https://github.com/Paccore-Prototypes/info_survey/blob/main/assets/images/Screenshots/1.jpg?raw=true" width="200">|<img src="https://github.com/Paccore-Prototypes/info_survey/blob/main/assets/images/Screenshots/1.jpg?raw=true" width="200">




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
  Infosurvey_kit: ^0.1.1
```

## 2. Install it
```
flutter pub get
```

## 3. Import it
```dart
import 'package:Infosurvey_kit/Infosurvey_kit.dart';
```

# 💻 Usage
## Example
A working example project can be found [HERE](example/)


### Start the survey
All that's left is to insert the survey in the widget tree and enjoy.🎉🎊
```dart
 InfoSurvey(
  treeModel: model!,
  tileListColor: Colors.blueGrey.shade200,
  showScoreWidget: true,
  surveyResult: (healthScore, answersMap) {
    print('Health Score: $healthScore');
    print('Answers Map: $answersMap');
  },
)

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
[

  {
    "id": 1,
    "isMandatory": false,
    "question": "What is your gender?",
    "description": "Gender refers to the characteristics of women, men, girls and boys that are socially constructed.",
    "image": "https://www.pngall.com/wp-content/uploads/5/Gender-PNG-Image-File.png",
    "imagePosition": "top",
    "imagePlace": "center",
    "imageHeight": 100,
    "imageWidth": 100,
    "questionType": "radio",
    "answerChoices": {
      "Male": [
        {
          "id": 101,
          "isMandatory": false,
          "description": "Smoking is injures to health & causes cancer",
          "question": "Do you have a smoking habit?",
          "image": "https://img.freepik.com/free-vector/cigarette-dark-smoke_1284-35568.jpg?t=st=1711105101~exp=1711108701~hmac=632f37c15777c7a6c738e2cdd56c80e463fd84bf6b6e112a8273e8f071fd75a5&w=740",
          "imagePosition": "middle",
          "imagePlace": "right",
          "imageHeight": 150,
          "imageWidth": 150,
          "questionType": "list",
          "score": 8,
          "answerChoices": {
            "Yes": [
              {
                "id": 102,
                "isMandatory": true,
                "question": "How many times do you smoke per day?",
                "questionType": "text",
                "answerDescription": "Smoking is injures to health...",
                "inputType":"text",
                "image": "https://img.freepik.com/free-vector/watercolour-smoke-background_91008-447.jpg?w=900&t=st=1711106816~exp=1711107416~hmac=d354d5f4cf78fd0b1aecd93f447b507f173ef318686404d4210dc90c080d67b3",
                "imagePosition": "bottom",
                "imagePlace": "right",
                "imageHeight": 150,
                "imageWidth": 150,
                "answerChoices": null,
                "score": 5
              }
            ],
            "No": [
              {
                "question": "",
                "answerDescription": "Smoking is injures to...",
                "answerChoices": null,
                "score": 4
              }
            ]
          }
        }
      ],
      "Female": [
        {
          "id": 103,
          "isMandatory": false,
          "question": "Are you pregnant?",
          "description": "giving the description",
          "image": "https://img.freepik.com/free-vector/baby-birth-concept-illustration_114360-8159.jpg?w=740&t=st=1711106976~exp=1711107576~hmac=3dcdda818ab96ed24dbbf399172c2a37866519f9d3e145ed44456effddeb0d8f",
          "imagePosition": "middle",
          "imageHeight": 150,
          "imageWidth": 150,
          "imagePlace": "center",
          "questionType": "list",
          "answerChoices": {
            "Yes": [
              {
                "id": 104,
                "isMandatory": false,
                "question": "Are you taking medication?",
                "description": null,
                "imageHeight": 150,
                "imageWidth": 150,
                "questionType": "radio",
                "answerChoices": {
                  "Yes": [
                    {
                      "id": 105,
                      "isMandatory": false,
                      "imageHeight": 150,
                      "imageWidth": 150,
                      "question": "From when are you taking medication?",
                      "questionType": "datetime",
                      "answerChoices": null,
                      "score": 4
                    }
                  ],
                  "No": [
                    {
                      "id": 106,
                      "isMandatory": false,
                      "question": "Are You Taking Any Other Medication Not Related To Pregnecy",
                      "questionType": "list",
                      "imageHeight": 150,
                      "imageWidth": 150,
                      "answerChoices": {
                        "Yes": [
                          {
                            "id": 107,
                            "isMandatory": true,
                            "question": "Name The Medicine You Are Taking",
                            "questionType": "text",
                            "imageHeight": 150,
                            "imageWidth": 150,
                            "answerChoices": null
                          }
                        ],
                        "No": [
                          {
                            "question": "",
                            "questionType": null,
                            "answerChoices": null,
                            "score": 4
                          }
                        ]
                      },
                      "score": 10
                    }
                  ]
                },
                "score": 6
              }
            ],
            "No": [
              {
                "id": 109,
                "isMandatory": true,
                "question": "Are you taking medication?",
                "questionType": "list",
                "imageHeight": 150,
                "imageWidth": 150,
                "answerChoices": {
                  "Yes": [
                    {
                      "id": 110,
                      "isMandatory": true,
                      "imageHeight": 150,
                      "imageWidth": 150,
                      "question": "From when are you taking medication?",
                      "questionType": "datetime",
                      "answerChoices": null,
                      "score": 4
                    }
                  ],
                  "No": [
                    {
                      "score": 8
                    }
                  ]
                },
                "score": 2
              }
            ]
          },
          "score": 4
        }
      ],
      "Other": [
      ]
    }
  },
  
  {
    "id": 402,
    "isMandatory": false,
    "question": "List your previous \ninterventions",
    "questionType": "custom_widget",
    "description": " Select all that apply.",
    "image": "https://img.freepik.com/free-vector/one-happy-boy-eating-table_1308-68783.jpg?w=740&t=st=1711106859~exp=1711107459~hmac=2afd13dc2fed656de8d90fffb61d47b9e5995fded340798d555f2ced1a929acd",
    "imagePosition": "middle",
    "imageHeight": 150,
    "imageWidth": 150,
    "imagePlace": "center",
    "answerChoices": {
      "Wisdom Teeth":  null,
      "Incisors": [
        {
          "question": null,
          "questionType": null,
          "answerChoices": null,
          "score": 8
        }
      ],
      "Canines": [
        {
          "question": null,
          "questionType": null,
          "answerChoices": null,
          "score": 6
        }
      ],
      "Premolars": [
        {
          "question": null,
          "questionType": null,
          "answerChoices": null,
          "score": 1
        }
      ],
      "Molars": [
        {
          "question": null,
          "questionType": null,
          "answerChoices": null,
          "score": 1
        }
      ]
    }
  },


  {
    "id": 903,
    "isMandatory": false,
    "question": "Which item you want to have ?",
    "description": "The follow items are emulsion or colloid of butterfat globules within a water-based fluid that contains dissolved carbohydrates and protein aggregates with minerals.",
    "image": "https://img.freepik.com/free-vector/fruits-vegetales-icon-set_603843-2722.jpg?t=st=1711105196~exp=1711108796~hmac=8d3cdde944b75834df8cb9b37a021451d8f53100813048a0517fe01423f68001&w=1060",
    "questionType": "search_item",
    "imageHeight": 150,
    "imageWidth": 150,
    "listGridType" : true,
    "answerChoices": {
      "Milk": null,
      "Curd":[ {
        "score": 7
      }],
      "Butter-Milk": [
        {
          "score": 7
        }
      ],
      "Other":[ {

        "score": 7
      }],
      "Badam_Milk": [
        {
          "score": 7
        }
      ]
    },
    "score": 6
  },

  {
    "id": 404,
    "isMandatory": false,
    "question": "Scan the description?",
    "description": "Language is a structured system of communication that consists of grammar and vocabulary",
    "image": "https://img.freepik.com/free-vector/translator-concept-illustration_114360-6334.jpg?w=740&t=st=1711106890~exp=1711107490~hmac=81da96b4cdc1851164f83fda9f7ae4e130c20866ce09cac7ce6273074986bcdc",
    "imagePosition": "middle",
    "imagePlace": "center",
    "imageHeight": 150,
    "imageWidth": 150,
    "questionType": "custom_widget",
    "score": 6,
    "answerChoices": null
  },

  {
    "id": 904,
    "isMandatory": false,
    "question": "Types of non-veg that you had lunch?",
    "description": "A dish composed with a sauce or gravy seasoned with a mixture of ground spices ",
    "image": "https://img.freepik.com/free-photo/realistic-heart-shape-with-city_23-2150827308.jpg?t=st=1711104825~exp=1711108425~hmac=2b890f2136c691396da160b2463cf50bf30d459e4810833e1f6a6009a7a61996&w=740",
    "questionType": "radio",
    "imageHeight": 150,
    "imageWidth": 150,
    "listGridType" : true,
    "isMultiListSelects" : false,
    "answerChoices": {
      "Chicken": [
        {
          "score": 7,
          "id": 9040,
          "isMandatory": false,
          "question": "Non-veg types are..?",
          "questionType": "radio",
          "isMultiListSelects" : true,
          "description": "A dish composed with a sauce or gravy seasoned with a mixture of ground spices ",
          "imageOption": "https://www.pngall.com/wp-content/uploads/5/Gender-PNG-Image-File.png",
          "answerDescription": "Will have chicken...",
          "answerChoices": {
            "Chicken": [
              {
                "score": 7,
                "imageOption": "https://www.pngall.com/wp-content/uploads/5/Gender-PNG-Image-File.png",
                "answerDescription": "Will have chicken..."
              }
            ],
            "Mutton":[ {
              "score": 7,
              "imageOption": "https://img.freepik.com/free-vector/fruits-vegetales-icon-set_603843-2722.jpg?t=st=1711105196~exp=1711108796~hmac=8d3cdde944b75834df8cb9b37a021451d8f53100813048a0517fe01423f68001&w=1060",
              "answerDescription": "Will have mutton."

            }],
            "Fish": [
              {
                "score": 7,
                "imageOption": "https://img.freepik.com/free-vector/fruits-vegetales-icon-set_603843-2722.jpg?t=st=1711105196~exp=1711108796~hmac=8d3cdde944b75834df8cb9b37a021451d8f53100813048a0517fe01423f68001&w=1060",
                "answerDescription": "Will have Fish.."
              }
            ],
            "Other":[ {
              "score": 7,
              "imageOption": "https://www.pngall.com/wp-content/uploads/5/Gender-PNG-Image-File.png",
              "answerDescription": "Will have Non-veg item.."

            }]
          }
        }
      ],
      "Mutton":[ {
        "score": 7,
        "imageOption": "https://img.freepik.com/free-vector/fruits-vegetales-icon-set_603843-2722.jpg?t=st=1711105196~exp=1711108796~hmac=8d3cdde944b75834df8cb9b37a021451d8f53100813048a0517fe01423f68001&w=1060",
        "answerDescription": "Will have mutton."

      }],
      "Fish": [
        {
          "score": 7,
          "imageOption": "https://img.freepik.com/free-vector/fruits-vegetales-icon-set_603843-2722.jpg?t=st=1711105196~exp=1711108796~hmac=8d3cdde944b75834df8cb9b37a021451d8f53100813048a0517fe01423f68001&w=1060",
          "answerDescription": "Will have Fish.."
        }
      ],
      "Other":[ {
        "score": 7,
        "imageOption": "https://www.pngall.com/wp-content/uploads/5/Gender-PNG-Image-File.png",
        "answerDescription": "Will have Non-veg item.."

      }]
    },
    "score": 6
  },
  {
    "id": 409,
    "isMandatory": false,
    "question": "Let's scan QR and get the details",
    "description": "A QR code (quick response code) is a type of two dimensional (2D) bar code that is used to provide easy access to online information through the digital camera on a smartphone or tablet.",
    "image": "https://img.freepik.com/free-vector/translator-concept-illustration_114360-6334.jpg?w=740&t=st=1711106890~exp=1711107490~hmac=81da96b4cdc1851164f83fda9f7ae4e130c20866ce09cac7ce6273074986bcdc",
    "imagePosition": "middle",
    "imagePlace": "center",
    "imageHeight": 150,
    "imageWidth": 150,
    "questionType": "custom_widget",
    "score": 6,
    "answerChoices": null
  },

  {
    "id": 90,
    "isMandatory": false,
    "question": "Types item that you had dinner?",
    "description": "The most important cereal crop in the developing world and is the staple food of over half the world's population",
    "image": "https://img.freepik.com/free-vector/fruits-vegetales-icon-set_603843-2722.jpg?t=st=1711105196~exp=1711108796~hmac=8d3cdde944b75834df8cb9b37a021451d8f53100813048a0517fe01423f68001&w=1060",
    "questionType": "drop_down",
    "listGridType" : false,
    "imageHeight": 150,
    "imageWidth": 150,
    "answerChoices": {
      "Rice": [
        {
          "score": 7,
          "imageOption": "https://img.freepik.com/free-vector/watercolor-pilaf-illustration_23-2149444767.jpg?w=740&t=st=1711107010~exp=1711107610~hmac=62f5fe61ead18dfd26821e7f9264d60597822582215493fdbae7ec9de526bc4d",
          "answerDescription": "Will have rice."

        }
      ],
      "Biryani":[ {
        "score": 7,
        "imageOption": "https://img.freepik.com/free-vector/watercolor-pilaf-illustration_23-2149444767.jpg?w=740&t=st=1711107010~exp=1711107610~hmac=62f5fe61ead18dfd26821e7f9264d60597822582215493fdbae7ec9de526bc4d",
        "answerDescription": "Will have biryani."

      }],
      "Roties": [
        {
          "score": 7,
          "imageOption": "https://www.pngall.com/wp-content/uploads/5/Gender-PNG-Image-File.png",
          "answerDescription": "Will have roties.."

        }
      ],
      "Other":[ {
        "score": 7,
        "imageOption": "https://www.pngall.com/wp-content/uploads/5/Gender-PNG-Image-File.png",
        "answerDescription": "Will have other.."

      }]
    },
    "score": 6
  },


  {
    "id": 2,
    "isMandatory": false,
    "question": "How fluent you are in spanish?",
    "description": "Language is a structured system of communication that consists of grammar and vocabulary",
    "image": "https://img.freepik.com/free-vector/translator-concept-illustration_114360-6334.jpg?w=740&t=st=1711106890~exp=1711107490~hmac=81da96b4cdc1851164f83fda9f7ae4e130c20866ce09cac7ce6273074986bcdc",
    "imagePosition": "middle",
    "imagePlace": "center",
    "imageHeight": 150,
    "imageWidth": 150,
    "questionType": "slider",
    "score": 6,
    "answerChoices": null
  },

  {
    "id": 402,
    "isMandatory": false,
    "question": "List of languages did you know?",
    "questionType": "multipleChoices",
    "description": " Select all that apply.",
    "image": "https://img.freepik.com/free-vector/one-happy-boy-eating-table_1308-68783.jpg?w=740&t=st=1711106859~exp=1711107459~hmac=2afd13dc2fed656de8d90fffb61d47b9e5995fded340798d555f2ced1a929acd",
    "imagePosition": "middle",
    "imageHeight": 150,
    "imageWidth": 150,
    "imagePlace": "center",
    "answerChoices": {
      "Telugu":  null,
      "English": [
        {
          "question": null,
          "questionType": null,
          "answerChoices": null,
          "score": 8
        }
      ],
      "Hindi": [
        {
          "question": null,
          "questionType": null,
          "answerChoices": null,
          "score": 6
        }
      ],
      "Spanish": [
        {
          "question": null,
          "questionType": null,
          "answerChoices": null,
          "score": 1
        }
      ],
      "Germany": [
        {
          "question": null,
          "questionType": null,
          "answerChoices": null,
          "score": 1
        }
      ]
    }
  }
]

```

You can find the complete example [HERE](https://github.com/Alavalaiah123/SurveyTree/blob/main/assets/survey.json)

# 👤 Author
This Flutter library is created with 💙 by [QuickBird Studios](https://quickbirdstudios.com/).

# ❤️ Contributing
Open an issue if you need help, if you found a bug, or if you want to discuss a feature request.

Open a PR if you want to make changes to SurveyKit.

# 📃 License
SurveyKit is released under an MIT license. See [License](LICENSE) for more information.
