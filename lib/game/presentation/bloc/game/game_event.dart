part of 'game_bloc.dart';

@immutable
sealed class GameEvent {}
class UpdateGameEvent extends GameEvent {}
