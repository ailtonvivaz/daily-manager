import 'dart:convert';

import 'package:daily_manager/features/home/people_card.dart';
import 'package:flutter/material.dart';
import 'dart:html' as html;

class HomePage extends StatefulWidget {
  final String? id;

  const HomePage({super.key, this.id});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  String? get id => widget.id;

  Codec<String, String> stringToBase64 = utf8.fuse(base64);

  List<String> people = [];
  int minutes = 15;

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
    html.window.history.pushState(
      '',
      '',
      id.isEmpty ? '' : '?id=$id',
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciador de Daily'),
      ),
      body: Center(
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
            Column(
              children: [
                IconButton(
                  onPressed: _onPressIncMinute,
                  icon: const Icon(Icons.keyboard_arrow_up),
                ),
                Column(
                  children: [
                    Text(
                      minutes.toString(),
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    const Text('minutos'),
                  ],
                ),
                IconButton(
                  onPressed: _onPressDecMinute,
                  icon: const Icon(Icons.keyboard_arrow_down),
                ),
              ],
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
                      onHover: (hovered) {},
                      onPressed: () {
                        people.removeAt(index);
                        setState(() {});
                        encode();
                      });
                  // return Card(
                  //   child: InkWell(
                  //     onHover: (value) {
                  //       debugPrint(value.toString());
                  //     },
                  //     onTap: () {},
                  //     child: Padding(
                  //       padding: const EdgeInsets.all(8.0),
                  //       child: Center(
                  //         child: Text(
                  //           people[index],
                  //           style:
                  //               Theme.of(context).textTheme.subtitle1?.copyWith(
                  //                     fontWeight: FontWeight.bold,
                  //                   ),
                  //           textAlign: TextAlign.center,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // );
                },
                itemCount: people.length,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.play_arrow),
                label: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Text('Iniciar Daily'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onPressAddName(String name) {
    _focusNode.requestFocus();
    if (name.isEmpty) return;

    _controller.clear();

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
}
