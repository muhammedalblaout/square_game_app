import 'package:flutter/material.dart';

class ScoreWidget extends StatefulWidget {
  final Color color;
  final Color background;

  final int score;

  const ScoreWidget(
      {super.key,
      required this.color,
      required this.score,
      required this.background});

  @override
  State<ScoreWidget> createState() => _ScoreWidgetState();
}

class _ScoreWidgetState extends State<ScoreWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 150,
      decoration: BoxDecoration(
          color: widget.background, borderRadius: BorderRadius.circular(12)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Score',
            style: TextStyle(color: widget.color, fontSize: 24,fontWeight: FontWeight.bold),
          ),
          Text(
            widget.score.toString(),
            style: TextStyle(color: widget.color, fontSize: 24),
          ),
        ],
      ),
    );
  }
}
