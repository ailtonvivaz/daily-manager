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
              finished ? _finished() : _inProgress(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inProgress() {
    if (emptyPeople) {
      return ElevatedButton(
        onPressed: _onPressFinish,
        child: const Text('Finalizar'),
      );
    }

    return Column(
      children: [
        SizedBox(
          width: 300,
          height: 100,
          child: PeopleCard(name: currentPerson),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: _onPressAbsent,
              child: const Text('Ausente'),
            ),
            const SizedBox(width: 24),
            ElevatedButton(
              onPressed: _onPressPresented,
              child: const Text('Apresentado'),
            )
          ],
        )
      ],
    );
  }

  Widget _finished() {
    final title = absentPeople.isEmpty
        ? 'Todos os participantes apresentaram'
        : 'Alguns participantes estão ausentes';
    return Column(
      children: [
        Text(title),
        const SizedBox(height: 24),
        if (absentPeople.isNotEmpty) ...[
          ...absentPeople.map(
            (person) => Text(
              person,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const SizedBox(height: 24),
        ],
        ElevatedButton(
          onPressed: _onPressFinish,
          child: const Text('Finalizar'),
        ),
      ],
    );
  }

  void _onPressPresented() {
    presentPeople.add(currentPerson);
    _nextPerson();
  }

  void _onPressAbsent() {
    absentPeople.add(currentPerson);
    _nextPerson();
  }

  void _onPressFinish() {
    Navigator.pop(context);
  }

  Future<bool> _onWillPop() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            // contentPadding: const EdgeInsets.all(0),
            title: const Text('Deseja mesmo fechar?'),
            content: const Text('Você encerrará o daily.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Não'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Sim'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
