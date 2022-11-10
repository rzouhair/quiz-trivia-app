import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:quiz_app/api/Endpoints.dart';
import 'package:quiz_app/pages/Quiz.dart';

import 'dart:convert' as convert;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _MyAppState();
}

class _MyAppState extends State<Home> {
  final _formKey = GlobalKey<FormState>();

  int _amount = 10;
  int? _category;
  String? _type;
  String? _difficulty;

  bool _isLoading = false;

  final Map<String, ExamTypes> _types = {
    'Multiple': ExamTypes.MULTIPLE,
    'Boolean': ExamTypes.BOOLEAN,
  };

  final Map<String, Difficulty> _difficulties = {
    'Easy': Difficulty.EASY,
    'Medium': Difficulty.MEDIUM,
    'Hard': Difficulty.HARD,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade300,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: 180,
              width: MediaQuery.of(context).size.width,
              color: Colors.deepPurple[300],
              padding: const EdgeInsets.only(top: 24.0, right: 24, left: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: const [
                  Text('Let\'s play',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      )),
                  Text('And be the first',
                      style: TextStyle(
                        color: Colors.white,
                      )),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 24, right: 24, top: 100),
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    offset: Offset(0, 15),
                    spreadRadius: 7,
                    blurRadius: 50,
                    color: Color.fromRGBO(0, 0, 0, 0.2),
                  )
                ],
                borderRadius: BorderRadius.circular(4.0),
                color: Colors.white,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 2),
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: TextFormField(
                                initialValue: _amount.toString(),
                                decoration: const InputDecoration(
                                  hintText: 'Amount (Required)',
                                  fillColor: Colors.grey,
                                  border: InputBorder.none,
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  setState(() {
                                    _amount = int.parse(value);
                                  });
                                },
                                validator: (value) =>
                                    (value == null || value.isEmpty)
                                        ? 'This field is required'
                                        : null),
                          ),
                          /* TextFormField(
                            onChanged: (value) {
                              setState(() {
                                _category = int.parse(value);
                              });
                            },
                            decoration: const InputDecoration(hintText: 'Category')), */
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 2),
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: DropdownButton(
                                underline: Container(),
                                hint: const Text('Type'),
                                isExpanded: true,
                                value: _type,
                                items: <String>['Multiple', 'Boolean']
                                    .map((String value) {
                                  return DropdownMenuItem<String>(
                                      value: value, child: Text(value));
                                }).toList(),
                                onChanged: ((value) {
                                  setState(() {
                                    _type = value;
                                  });
                                })),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 2),
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: DropdownButton(
                                underline: Container(),
                                hint: const Text('Difficulty'),
                                isExpanded: true,
                                value: _difficulty,
                                items: <String>['Easy', 'Medium', 'Hard']
                                    .map((String value) {
                                  return DropdownMenuItem<String>(
                                      value: value, child: Text(value));
                                }).toList(),
                                onChanged: ((value) {
                                  setState(() {
                                    _difficulty = value;
                                  });
                                })),
                          ),
                          GestureDetector(
                            onTap: () async {
                              if (_formKey.currentState!.validate() &&
                                  !_isLoading) {
                                try {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  dynamic resp = await Endpoints.getQuestions(
                                      Endpoints.getLink(
                                          _category,
                                          _difficulties[_difficulty],
                                          _types[_type],
                                          amount: _amount));

                                  dynamic decodedResp =
                                      convert.jsonDecode(resp.body)['results'];
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        Quiz(response: decodedResp),
                                  ));
                                  setState(() {
                                    _isLoading = false;
                                  });
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          backgroundColor: Colors.red,
                                          content: Text(
                                              'An error occurred: ${e.toString()}')));
                                } finally {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        backgroundColor: Colors.red,
                                        content: Text(
                                            'Please fill in the required fields')));
                              }
                            },
                            child: AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                height: 50,
                                width: MediaQuery.of(context).size.width,
                                margin: const EdgeInsets.only(top: 4),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: _isLoading
                                      ? Colors.deepPurple.shade100
                                      : Colors.deepPurple,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'Start quiz',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
