import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class QuestionForm extends StatefulWidget {
  @override
  _QuestionFormState createState() => _QuestionFormState();
}

class _QuestionFormState extends State<QuestionForm> {
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _correctAnswerController =
      TextEditingController();
  final TextEditingController _incorrectAnswer1Controller =
      TextEditingController();
  final TextEditingController _incorrectAnswer2Controller =
      TextEditingController();
  final TextEditingController _incorrectAnswer3Controller =
      TextEditingController();

  Future<void> _createQuestions() async {
    try {
      final uri = Uri.http(
          'geryjdakdai-001-site32.ktempurl.com', '/api/Home/createQuestion', {
        'question': _questionController.text,
        'correct_answer': _correctAnswerController.text,
        'incorrect_answers_1': _incorrectAnswer1Controller.text,
        'incorrect_answers_2': _incorrectAnswer2Controller.text,
        'incorrect_answers_3': _incorrectAnswer3Controller.text,
      });

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        // Successful response, parse data if necessary
        // You can use response.body to access the response data
        print(response.body);
      } else {
        // Error getting questions
        print('Failed to get questions. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Exception occurred
      print('An error occurred: $e');
    }
  }

  Future<List<String>> _getQuestions() async {
    try {
      final response =
          await http.get(Uri.parse('https://opentdb.com/api.php?amount=11'));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        List<String> questions = List<String>.from(
            jsonData['results'].map((question) => question['question']));
        return questions;
      } else {
        print('Failed to get questions. Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('An error occurred while fetching questions: $e');
      return [];
    }
  }

  Future<void> _deleteQuestion(String index) async {
    try {
      // Make API call to delete the question at the specified index
      final uri = Uri.http(
          'geryjdakdai-001-site32.ktempurl.com', '/api/Home/deleteQuestion', {
        'id': index,
      });
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        // If deletion is successful, remove the question from the list
        setState(() {
          _getQuestions();
        });
        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Question deleted successfully')),
        );
      } else {
        // If deletion fails, show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete question')),
        );
      }
    } catch (e) {
      // Handle any exceptions or errors that occur during the API call
      print('An error occurred while deleting question: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Question App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _questionController,
              decoration: InputDecoration(labelText: 'Question'),
            ),
            TextFormField(
              controller: _correctAnswerController,
              decoration: InputDecoration(labelText: 'Correct Answer'),
            ),
            TextFormField(
              controller: _incorrectAnswer1Controller,
              decoration: InputDecoration(labelText: 'Incorrect Answer 1'),
            ),
            TextFormField(
              controller: _incorrectAnswer2Controller,
              decoration: InputDecoration(labelText: 'Incorrect Answer 2'),
            ),
            TextFormField(
              controller: _incorrectAnswer3Controller,
              decoration: InputDecoration(labelText: 'Incorrect Answer 3'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createQuestions,
              child: Text('Submit Question'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                List<String> questions = await _getQuestions();
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Questions'),
                      content: SizedBox(
                        height: 300,
                        width: 300,
                        child: ListView.builder(
                          itemCount: questions.length,
                          itemBuilder: (context, index) {
                            final questionName = questions[index];
                            return ListTile(
                              title: Text(questionName),
                              trailing: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  // Call the API to delete the question
                                  _deleteQuestion(questionName);
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Close'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Get Questions'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: QuestionForm(),
  ));
}
