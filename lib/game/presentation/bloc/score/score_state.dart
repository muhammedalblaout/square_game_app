part of 'score_bloc.dart';

@immutable
sealed class ScoreState {}

final class ScoreInitial extends ScoreState {
}
final class ScoreChange extends ScoreState {

}