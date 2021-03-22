import 'package:flutter/material.dart';
import 'app_brain.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

AppBrain appBrain = AppBrain();

void main() {
  runApp(ExamApp());
}

class ExamApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          backgroundColor: Colors.grey,
          title: Text('اختبار'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ExamPage(),
        ),
      ),
    );
  }
}

class ExamPage extends StatefulWidget {
  @override
  _ExamPageState createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> {
  List<Widget> answerResult = [];
  int rightAnswers = 0;

  void checkAnswer(bool whatUserPicked) {
    // appBrain.questionGroup[questionNumber].questionAnswer = false;
    bool correctAnswer = appBrain.getQuestionAnswer();
    setState(() {
      if (whatUserPicked == correctAnswer) {
        rightAnswers++;
        answerResult.add(
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Icon(
              Icons.thumb_up,
              color: Colors.green,
            ),
          ),
        );
      } else {
        answerResult.add(
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Icon(
              Icons.thumb_down,
              color: Colors.red,
            ),
          ),
        );
      }
      if (appBrain.isFinished() == true) {
        Alert(
          context: context,
          title: "انتهاء الاختبار",
          desc: "لقد أجبت على $rightAnswers أسئلة صحيحة من أصل 7",
          buttons: [
            DialogButton(
              child: Text(
                "ابدأ من جديد",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
              width: 120,
            )
          ],
        ).show();

        appBrain.reset();

        answerResult = [];

        rightAnswers = 0;
      } else {
        appBrain.nextQuestion();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: answerResult,
        ),
        Expanded(
          flex: 5,
          child: Column(
            children: [
              Image.asset(appBrain.getQuestionImage()),
              SizedBox(height: 20.0),
              Text(
                appBrain.getQuestionText(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24.0,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: FlatButton(
              color: Colors.indigo,
              child: Text(
                'صح',
                style: TextStyle(
                  fontSize: 22.0,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                checkAnswer(true);
              },
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: FlatButton(
              color: Colors.deepOrange,
              child: Text(
                'خطأ',
                style: TextStyle(
                  fontSize: 22.0,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                checkAnswer(false);
              },
            ),
          ),
        ),
      ],
    );
  }
}
