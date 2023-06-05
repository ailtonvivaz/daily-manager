import 'dart:math';

import 'package:daily_manager/features/home/people_card.dart';
import 'package:flutter/material.dart';

import '../../core/widgets/countdown.dart';

class DailyPage extends StatefulWidget {
  final List<String> people;
  final int minutes;

  DailyPage({
    super.key,
    required List<String> people,
    required this.minutes,
  }) : people = people.toList();

  @override
  State<DailyPage> createState() => _DailyPageState();
}

class _DailyPageState extends State<DailyPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  List<String> get people => widget.people;

  List<String> absentPeople = [];
  List<String> presentPeople = [];

  late String currentPerson;

  late bool emptyPeople;

  bool finished = false;

  @override
  void initState() {
    super.initState();
    emptyPeople = people.isEmpty;

    _controller = AnimationController(
      vsync: this,
      duration: Duration(minutes: widget.minutes),
    );
    _controller.forward();
    _nextPerson();
  }

  void _nextPerson() {
    if (emptyPeople) return;

    if (people.isNotEmpty) {
      int index = Random().nextInt(people.length);
      setState(() {
        currentPerson = people[index];
      });
      people.removeAt(index);
    } else {
      setState(() {
        finished = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Daily'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Countdown(
                animation: StepTween(
                  begin: widget.minutes * 60,
                  end: 0,
                ).animate(_controller),
                listenable: _controller,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _onPressPauseTimer,
                child: const Text('Pause Timer'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _onPressResumeTimer,
                child: const Text('Resume Timer'),
              ),              
              finished ? _finished() : _inProgress(),
            ],
          ),
        ),
      ),
    );
  }

  // Rest of code...
  
  void _onPressPauseTimer() {
    _controller.stop();
  }
  
  void _onPressResumeTimer() {
    _controller.forward();
  }  
}
