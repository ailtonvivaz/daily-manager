import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:js' as js;

class HomePage extends StatefulWidget {
  final String? id;

  const HomePage({super.key, this.id});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();

  String? get id => widget.id;

  Codec<String, String> stringToBase64 = utf8.fuse(base64);

  @override
  void initState() {
    super.initState();
    decode();
  }

  void encode() {
    String encoded = stringToBase64.encode(_controller.text);
    html.window.history.pushState(
      '',
      '',
      '?id=$encoded',
    );
  }

  void decode() {
    debugPrint('decode $id');

    if (id == null) return;

    String decoded = stringToBase64.decode(id!);
    debugPrint('decoded: $decoded');

    _controller.text = decoded;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Gerenciador de Daily'),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              maxLines: null,
              decoration: const InputDecoration(
                labelText: 'Enter your name',
              ),
              onChanged: (String value) {
                encode();
              },
            ),
          ],
        ),
      ),
    );
  }
}
