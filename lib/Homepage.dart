// Import 'CompletePage.dart' at the top

import 'package:flutter/material.dart';
import 'package:quizzapp_2/CompletePage.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:quizzapp_2/Options.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);
  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List responseData = [];
  int number = 0;
  late Timer _timer;
  int _correctAnswersCount = 0;
  int _secondRemaining = 15;
  List<String> shuffledOptions = [];
  String? selectedOptionText; // Variable to hold selected option text

  Future api() async {
    final response =
        await http.get(Uri.parse('http://geryjdakdai-001-site32.ktempurl.com/api/Home/getQuestions'));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['results'];
      setState(() {
        responseData = data;
        updateShuffleOption();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    api();
    startTimer();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            SizedBox(
              height: 300,
              width: 400,
              child: Stack(
                children: [
                  Container(
                    height: 240,
                    width: 390,
                    decoration: BoxDecoration(
                        color: const Color(0xffA42FC1),
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  Positioned(
                      bottom: 60,
                      left: 22,
                      child: Container(
                        height: 170,
                        width: 350,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(0, 1),
                                  blurRadius: 5,
                                  spreadRadius: 3,
                                  color: Color(0xffA42FC1).withOpacity(.4))
                            ]),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    '05',
                                    style: TextStyle(
                                        color: Colors.green, fontSize: 20),
                                  ),
                                  Text(
                                    (number + 1).toString(),
                                    style: const TextStyle(
                                        color: Colors.green, fontSize: 20),
                                  ),
                                ],
                              ),
                              Center(
                                child: Text(
                                  "Question ${number + 1}/10",
                                  style:
                                      const TextStyle(color: Color(0xffA42FC1)),
                                ),
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              Text(responseData.isNotEmpty
                                  ? responseData[number]['question']
                                  : '')
                            ],
                          ),
                        ),
                      )),
                  Positioned(
                      bottom: 210,
                      left: 140,
                      child: CircleAvatar(
                        radius: 42,
                        backgroundColor: Colors.white,
                        child: Center(
                          child: Text(
                            _secondRemaining.toString(),
                            style: TextStyle(
                                color: const Color(0xffA42FC1), fontSize: 25),
                          ),
                        ),
                      ))
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              selectedOptionText ?? '',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Column(
              children: (responseData.isNotEmpty &&
                      responseData[number]['incorrect_answers'] != null)
                  ? shuffledOptions.map((option) {
                      return Options(
                        option: option.toString(),
                        selectedOption: null,
                        onTapOption: (selectedOption) {
                          setState(() {
                            selectedOptionText =
                                "Option $selectedOption tapped";
                            if (answer != "" && answer == selectedOption) {
                              _correctAnswersCount++;
                            }
                          });
                        },
                      );
                    }).toList()
                  : [],
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color(0xffA42FC1),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                ),
                onPressed: () {
                  nextQuestion();
                },
                child: Container(
                  alignment: Alignment.center,
                  child: const Text(
                    'Next',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void nextQuestion() {
    if (number == 9) {
      completed();
    }
    setState(() {
      number = number + 1;
      updateShuffleOption();
      _secondRemaining = 15;
    });
  }

  void completed() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Completed(correctAnswersCount: _correctAnswersCount),
      ),
    );
  }

  void updateShuffleOption() {
    setState(() {
      selectedOptionText = "";
    });
    if (responseData.isNotEmpty && number < responseData.length) {
      setState(() {
        answer = responseData[number]['correct_answer'].toString();
        print(answer);
        shuffledOptions = shuffledOption([
          responseData[number]['correct_answer'],
          ...(responseData[number]['incorrect_answers'] as List)
        ]);
      });
    }
  }

  String answer = "";
  List<String> shuffledOption(List<String> option) {
    List<String> shuffledOptions = List.from(option);
    shuffledOptions.shuffle();
    return shuffledOptions;
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer) {
      setState(() {
        if (_secondRemaining > 0) {
          _secondRemaining--;
        } else {
          nextQuestion();
          _secondRemaining = 15;
          updateShuffleOption();
        }
      });
    });
  }
}
