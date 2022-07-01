import 'package:flutter/material.dart';

class PeopleCard extends StatefulWidget {
  final String name;
  final GestureTapCallback? onPressed;
  final bool activeEvents;

  const PeopleCard({
    super.key,
    required this.name,
    this.onPressed,
    this.activeEvents = false,
  });

  @override
  State<PeopleCard> createState() => _PeopleCardState();
}

class _PeopleCardState extends State<PeopleCard> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    if (!widget.activeEvents) return _card();

    return MouseRegion(
      onEnter: (_) {
        debugPrint('onEnter');
        setState(() {
          hovered = true;
        });
      },
      onExit: (_) {
        debugPrint('onExit');
        setState(() {
          hovered = false;
        });
      },
      child: GestureDetector(
        onTap: widget.onPressed,
        child: Stack(
          children: [
            _card(),
            if (hovered)
              Card(
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  child: Center(
                    child: Icon(
                      Icons.delete,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget _card() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            widget.name,
            style: Theme.of(context).textTheme.subtitle1?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
