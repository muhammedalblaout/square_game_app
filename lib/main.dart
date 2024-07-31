import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'game/presentation/bloc/game/game_bloc.dart';
import 'game/presentation/bloc/score/score_bloc.dart';
import 'game/presentation/page/game_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(
        useMaterial3: true,
      ),
      home:  MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ScoreBloc(),
          ),
          BlocProvider(
            create: (context) => GameBloc(),)
        ],
        child: const GamePage(),
      ),
    );
  }
}
