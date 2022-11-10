import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:quiz_app/api/Endpoints.dart';

import 'package:html_unescape/html_unescape.dart';
import 'package:quiz_app/widgets/Selection.dart';

class Quiz extends StatefulWidget {
  const Quiz({
    super.key,
    required this.response,
  });

  final List<dynamic> response;

  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  int _currentIndex = 0;

  int _correctAnswers = 0;
  int _incorrectAnswers = 0;

  bool _showSummary = false;

  dynamic _selectedOption;

  HtmlUnescape htmlUnescape = HtmlUnescape();
  List<dynamic> _questions = [];

  void renderQuestions() {
    setState(() {
      _questions = shuffle([
        htmlUnescape.convert(widget.response[_currentIndex]['correct_answer']),
        ...widget.response[_currentIndex]['incorrect_answers']
            .map((text) => htmlUnescape.convert(text))
      ]);
    });
  }

  @override
  void initState() {
    super.initState();
    renderQuestions();
  }

  List shuffle(List items) {
    var random = new Random();

    // Go through all elements.
    for (var i = items.length - 1; i > 0; i--) {
      // Pick a pseudorandom number according to the list length
      var n = random.nextInt(i + 1);

      var temp = items[i];
      items[i] = items[n];
      items[n] = temp;
    }

    return items;
  }

  void selectAnswer(dynamic answer) {
    setState(() {
      _selectedOption = answer;
    });
  }

  void validateAnswer(dynamic answer) {
    setState(() {
      _selectedOption = null;
      if (widget.response[_currentIndex]['correct_answer'] == answer) {
        _correctAnswers++;
      } else {
        _incorrectAnswers++;
      }
      if (_currentIndex >= widget.response.length - 1) {
        _showSummary = true;
        // Navigator.of(context).pop();
      } else {
        _currentIndex += _currentIndex >= widget.response.length - 1 ? 0 : 1;
        renderQuestions();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _showSummary
            ? Padding(
                padding: const EdgeInsets.all(24.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Color(Colors.green.shade500.value),
                        ),
                        child: Align(
                          child: Text('Correct answers: $_correctAnswers',
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white)),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 80,
                        margin: const EdgeInsets.only(top: 4),
                        decoration: BoxDecoration(
                          color: Color(Colors.red.shade600.value),
                        ),
                        child: Align(
                          child: Text('Incorrect answers: $_incorrectAnswers',
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white)),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            height: 80,
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.only(top: 24, bottom: 36),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.deepPurple.shade300,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'Go back to main screen',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18),
                            )),
                      ),
                    ],
                  ),
                ),
              )
            : Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24.0, vertical: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.arrow_back_ios_new),
                        Expanded(
                            child: Text(
                                widget.response[_currentIndex]['category'],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16))),
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 36),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                                'Question ${_currentIndex + 1}/${widget.response.length}',
                                style: TextStyle(
                                    color: Color(Colors.yellow.shade800.value),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16)),
                            Text(
                                htmlUnescape.convert(
                                    widget.response[_currentIndex]['question']),
                                style: TextStyle(
                                  color: Color(Colors.grey.shade800.value),
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                )),
                            Expanded(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: widget.response[_currentIndex]
                                          ['type'] ==
                                      'boolean'
                                  ? [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20.0),
                                        child: Selection(
                                          selected: _selectedOption == 'True',
                                          onPressed: () {
                                            selectAnswer("True");
                                          },
                                          label: 'Correct',
                                        ),
                                      ),
                                      Selection(
                                        selected: _selectedOption == 'False',
                                        onPressed: () {
                                          selectAnswer("False");
                                        },
                                        label: 'Incorrect',
                                      ),
                                    ]
                                  : [
                                      for (var fls in _questions)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 20.0),
                                          child: Selection(
                                            selected: _selectedOption == fls,
                                            onPressed: () {
                                              selectAnswer(fls);
                                            },
                                            label: fls,
                                          ),
                                        ),
                                    ],
                            )),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        validateAnswer(_selectedOption);
                      },
                      child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          height: 80,
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.only(top: 4, bottom: 36),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.deepPurple.shade300,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Next',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 18),
                          )),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
