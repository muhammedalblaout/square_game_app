import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/power_up_item.dart';
import '../../models/moving_item.dart';
import '../../physics/physics.dart';
import '../../utils/ticker.dart';
import '../bloc/game/game_bloc.dart';
import '../bloc/score/score_bloc.dart';
import '../widget/floor_build.dart';
import '../widget/score_widget.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  bool isGameFinshed = false;
  bool isGameStarted = false;

  int score1 = 100;
  int score2 = 100;
  PowerUpItem? healItem;
  PowerUpItem? changeMovementItem;

  GameBloc floorGameBloc = GameBloc();
  List<MovingItem> items = [
    MovingItem(
        position: (const Offset(100, 300)),
        color: Colors.blueAccent,
        size: 100,
        v: const Offset(2, 2),
        id: 0),
    MovingItem(
        position: (const Offset(200, 420)),
        color: Colors.redAccent,
        size: 100,
        v: const Offset(2, 2),
        id: 1),
  ];
  Ticker ticker = const Ticker();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    ticker.tick().listen((event) {
      if(isGameStarted){
        healItem = genaratePowerUpItem(items, (width / 2), (height / 2), 300, 20);
        changeMovementItem =
            genaratePowerUpItem(items, (width / 2), (height / 2), 300, 20);
      }

    });
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          isGameStarted = true;
        },
        child: Stack(
          children: [
            StreamBuilder(
                stream: ticker.tick(),
                builder: (context, snapshot) {
                  return BlocConsumer<GameBloc, GameState>(
                    listener: (context, state) {},
                    builder: (context, state) {
                      return Stack(children: [
                        healItem == null || isGameFinshed
                            ? const SizedBox()
                            : Positioned(
                                left: healItem?.position.dx,
                                top: healItem?.position.dy,
                                child: Container(
                                  width: healItem?.size,
                                  height: healItem?.size,
                                  decoration: const BoxDecoration(
                                    color: Colors.greenAccent,
                                  ),
                                ),
                              )
                      ]);
                    },
                  );
                }),
            StreamBuilder(
                stream: ticker.tick(),
                builder: (context, snapshot) {
                  return BlocConsumer<GameBloc, GameState>(
                    listener: (context, state) {},
                    builder: (context, state) {
                      return Stack(children: [
                        changeMovementItem == null || isGameFinshed
                            ? const SizedBox()
                            : Positioned(
                                left: changeMovementItem?.position.dx,
                                top: changeMovementItem?.position.dy,
                                child: Container(
                                  width: changeMovementItem?.size,
                                  height: changeMovementItem?.size,
                                  decoration: const BoxDecoration(
                                    color: Colors.purpleAccent,
                                  ),
                                ),
                              )
                      ]);
                    },
                  );
                }),
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: 1),
              duration: const Duration(milliseconds: 1000000000),
              builder: (BuildContext context, double value, Widget? child) {
                return Stack(
                  children: items.map((e) {
                    if (isGameStarted) {
                      if (isGameFinshed == false) {
                        for (int i = 0; i < items.length; i++) {
                          if (items[i].id != e.id &&
                              (e.size != 0 && items[i].size != 0)) {
                            if (collide(e, items[i])) {
                              //size
                              e.setSize(e.size - 10);
                              items[i].setSize(items[i].size - 10);
                              score1 = score1 - 10;
                              score2 = score2 - 10;
                              context.read<ScoreBloc>().add(ChangeScoreEvent());

                              //v
                              transferEnergy(e,items[i]);



                            }
                          }
                        }
                        if (healItem != null && e.size != 0) {
                          if (collide(e, healItem!)) {
                            if (e.id == 0) {
                              score1 = score1 + 10;
                            }
                            if (e.id == 1) {
                              score2 = score2 + 10;
                            }
                            context.read<ScoreBloc>().add(ChangeScoreEvent());

                            e.setSize(e.size + 10);
                            context.read<GameBloc>().add(UpdateGameEvent());
                            healItem = null;
                          }
                        }

                        if (changeMovementItem != null && e.size != 0) {
                          if (collide(e, changeMovementItem!)) {
                            Random random = Random();
                            var vx = random.nextInt(8) - 4;
                            var vy = random.nextInt(8) - 4;
                            vx == 0 ? vx = 4 : vx = vx;
                            vy == 0 ? vy = 4 : vy = vy;
                            e.setV(Offset(vx.toDouble(), vy.toDouble()));
                            context.read<ScoreBloc>().add(ChangeScoreEvent());
                            context.read<GameBloc>().add(UpdateGameEvent());
                            changeMovementItem = null;
                          }
                        }

                        if (score1 <= 0 || score2 <= 0) {
                          isGameFinshed = true;
                        }
                      }
                      if (isGameFinshed) {
                        if (e.size >= 5 && e.size < 300) {
                          context.read<ScoreBloc>().add(ChangeScoreEvent());
                          e.setSize(e.size + 10);
                          e.setV(const Offset(0, 0));
                        }
                      }
                      if (wallCollide(e, width / 2, height / 2, 300) &&
                          !isGameFinshed) {
                        floorGameBloc.add(UpdateGameEvent());
                      }
                      e.setPosition(Offset(
                          e.position.dx + e.v.dx, e.position.dy + e.v.dy));
                    }

                    return Positioned(
                      left: e.position.dx,
                      top: e.position.dy,
                      child: e.size <= 0
                          ? const SizedBox()
                          : Container(
                              width: e.size,
                              height: e.size,
                              decoration: BoxDecoration(
                                color: e.color,
                              ),
                            ),
                    );
                  }).toList(),
                );
              },
            ),
            Positioned(
                left: (width / 2) - 150,
                top: (height / 2) - 150,
                child: BlocProvider(
                  create: (context) => floorGameBloc,
                  child: const FloorBuild(),
                )),
            Positioned(
                left: 0,
                top: 0,
                child: BlocConsumer<ScoreBloc, ScoreState>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    if (state is ScoreChange) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 42),
                        width: width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ScoreWidget(
                                color: Colors.blueAccent,
                                score: score1,
                                background: const Color(0xFF232323)),
                            ScoreWidget(
                                color: Colors.redAccent,
                                score: score2,
                                background: const Color(0xFF232323)),
                          ],
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ))
          ],
        ),
      ),
    );
  }
}
