import 'package:flutter/material.dart';
import 'package:calculator/buttons.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'Montserrat'),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> buttons = [
    "AC",
    "←",
    "%",
    "/",
    "7",
    "8",
    "9",
    "×",
    "4",
    "5",
    "6",
    "-",
    "1",
    "2",
    "3",
    "+",
    "0",
    ".",
    "Ans",
    "="
  ];
  String question = " ";
  String answer = "";
  String answerGive="";

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff222831),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height / 3,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal:5),
              child: SingleChildScrollView(
                reverse: true,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    SizedBox(height: 50),
                    Container(
                      alignment: Alignment.centerRight,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        reverse: true,
                        child: Text(
                          question,
                          style:TextStyle(
                              fontSize: (question.length<=15)? 50: 40,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    Container(
                      padding: EdgeInsets.only(top: 30),
                      alignment: Alignment.centerRight,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        reverse: true,
                        child: Text(
                          answer,
                          style: TextStyle(fontSize: 25, color: Colors.grey),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              itemCount: buttons.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4),
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return MyButton(
                    onPress: () {
                      setState(() {
                        question = " ";
                        answer = "";
                        answerGive="";
                      });
                    },
                    color: Colors.red,
                    textColor: Colors.white,
                    buttonText: buttons[index],
                  );
                } else if (index == 1) {
                  return MyButton(
                    onPress: () {
                      setState(
                            () {
                          question= question[question.length-1]!="s" ? question.substring(0, question.length - 1):
                          question=question.substring(0,question.length-3);
                          if (question.length > 1) {
                            if (!isOperator(question[question.length - 1]))
                              equalPressed();
                          } else {
                            question = " ";
                            answer = "";
                          }
                        },
                      );
                    },
                    color: Colors.white,
                    textColor: Colors.black,
                    buttonText: buttons[index],
                  );
                } else if (index == 18) {
                  return MyButton(
                    onPress: () {
                      setState(() {
                        if(isOperator(question[question.length-1]) && answerGive!="") {
                          question = question + "Ans";
                        }
                        equalPressed();
                      });
                    },
                    color: Color(0xff393e46),
                    textColor: Colors.white,
                    buttonText: buttons[index],
                  );
                } else if (index == 19) {
                  return MyButton(
                    onPress: () {
                      setState(() {
                        question= "Ans";
                        answerGive=answer;
                      });
                    },
                    color: Color(0xff00adb5),
                    textColor: Colors.white,
                    buttonText: buttons[index],
                  );
                } else {
                  return MyButton(
                    onPress: () {
                      setState(() {
                        if (!(isOperator(question[question.length - 1]) &&
                            isOperator(buttons[index])) &&
                            question.length <= 50)
                          question += buttons[index];
                        if (!isOperator(buttons[index]))
                          equalPressed();
                      });
                    },
                    color: isOperator(buttons[index])
                        ? Colors.white
                        : Color(0xff393e46),
                    textColor: isOperator(buttons[index])
                        ? Colors.black
                        : Colors.white,
                    buttonText: buttons[index],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  bool isOperator(String x) {
    if (x == "/" || x == "×" || x == "-" || x == "+" || x == "=" || x == "%")
      return true;
    return false;
  }

  void equalPressed() {
    String finalQuestion = question;
    finalQuestion = finalQuestion.replaceAll("×", "*");
    finalQuestion=finalQuestion.replaceAll("Ans",answerGive);
    Parser p = Parser();
    Expression exp = p.parse(finalQuestion);
    ContextModel cm = ContextModel();
    double eval = exp.evaluate(EvaluationType.REAL, cm);
    answer = eval.toString();
  }
}
