import 'dart:convert';
import 'dart:math';

import 'package:daily_manager/features/home/people_card.dart';
import 'package:daily_manager/history/history.dart';
import 'package:flutter/material.dart';

import '../daily/daily_page.dart';

class HomePage extends StatefulWidget {
  final String? id;
  final int? minutes;

  const HomePage({
    super.key,
    this.id,
    this.minutes = 30,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  String? get id => widget.id;

  Codec<String, String> stringToBase64 = utf8.fuse(base64);

  List<String> people = [];
  int minutes = 30;

  @override
  void initState() {
    super.initState();
    decode();
  }

  void encode() {
    final text = people.join('\n');

    if (text.isEmpty) {
      updatePath('');
    } else {
      String encoded = stringToBase64.encode(text);
      updatePath(encoded);
    }
  }

  void updatePath(String id) {
    debugPrint('updatePath: $id');
    History().pushState(id.isEmpty ? '' : '?id=$id&minutes=$minutes');
  }

  void decode() {
    debugPrint('decode $id');

    if (id == null) return;

    String decoded = stringToBase64.decode(id!);
    debugPrint('decoded: $decoded');

    setState(() {
      people = decoded.split('\n');
    });
  }

  int get indexPresenter {
    DateTime now = DateTime.now();
    final date = DateTime(now.year, now.month, now.day);

    final random = Random(date.millisecondsSinceEpoch);
    final index = random.nextInt(people.length);
    return index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciador de Daily'),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 1200,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        decoration: const InputDecoration(
                          labelText: 'Adicionar nome',
                          hintText: 'Digite um nome e pressione Enter',
                          border: OutlineInputBorder(),
                        ),
                        onSubmitted: _onPressAddName,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.sort_by_alpha),
                      onPressed: _onPressOrderByAlpha,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 300,
                    mainAxisExtent: 100,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                  ),
                  itemBuilder: (context, index) {
                    return PeopleCard(
                      name: people[index],
                      presenter: index == indexPresenter,
                      activeEvents: true,
                      onPressed: () {
                        people.removeAt(index);
                        setState(() {});
                        encode();
                      },
                    );
                  },
                  itemCount: people.length,
                ),
              ),
              Column(
                children: [
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: _onPressDecMinute,
                        icon: const Icon(Icons.keyboard_arrow_left),
                      ),
                      Column(
                        children: [
                          Text(
                            minutes.toString(),
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                          const Text('minutos'),
                        ],
                      ),
                      IconButton(
                        onPressed: _onPressIncMinute,
                        icon: const Icon(Icons.keyboard_arrow_right),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: ElevatedButton.icon(
                      onPressed: _onPressStartDaily,
                      icon: const Icon(Icons.play_arrow),
                      label: const Padding(
                        padding: EdgeInsets.all(12),
                        child: Text('Iniciar Daily'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onPressAddName(String name) {
    _focusNode.requestFocus();
    if (name.isEmpty) return;

    _controller.clear();

    if (people.contains(name)) return;

    people.insert(0, name);
    setState(() {});
    encode();
  }

  void _onPressOrderByAlpha() {
    setState(() {
      people.sort();
    });
    encode();
    _focusNode.requestFocus();
  }

  void _onPressIncMinute() {
    setState(() {
      minutes++;
    });
    encode();
  }

  void _onPressDecMinute() {
    if (minutes == 1) return;

    setState(() {
      minutes--;
    });
    encode();
  }

  void _onPressStartDaily() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DailyPage(
          people: people,
          minutes: minutes,
        ),
        fullscreenDialog: true,
      ),
    );
  }
}
