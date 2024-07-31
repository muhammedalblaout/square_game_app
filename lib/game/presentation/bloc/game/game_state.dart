part of 'game_bloc.dart';

@immutable
sealed class GameState {}

final class GameInitial extends GameState {}
final class UpdateGame extends GameState {}

