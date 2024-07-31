import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/game/game_bloc.dart';

class FloorBuild extends StatefulWidget {
  const FloorBuild({super.key});

  @override
  State<FloorBuild> createState() => _FloorBuildState();
}

class _FloorBuildState extends State<FloorBuild> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GameBloc, GameState>(
      listener: (context, state) {
      if(state is UpdateGame){
        setState(() {

        });
      }
      },
      builder: (context, state) {
        if(state is UpdateGame){
          var kay=Random().nextDouble();
          return TweenAnimationBuilder(
              key: ValueKey(kay),
              tween: Tween<double>(begin: 1, end: 0.4),
            duration: const Duration(milliseconds: 500),
            builder: (BuildContext context, double value, Widget? child) {
              return Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                    border: Border.all(
                        color: HSVColor.fromColor(const Color(0xFF383838)).withValue(
                            value).toColor(), width: 3)),
              );
            },
          );
        }
        else{
          return Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
                border: Border.all(
                    color: const Color(0xFF383838), width: 3)),
          );
        }
      },
    );
  }
}
