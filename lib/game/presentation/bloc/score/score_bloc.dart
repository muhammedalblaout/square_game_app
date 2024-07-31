import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'score_event.dart';
part 'score_state.dart';

class ScoreBloc extends Bloc<ScoreEvent, ScoreState> {
  ScoreBloc() : super(ScoreChange()) {
    on<ScoreEvent>((event, emit) {
    });
    on<ChangeScoreEvent>((event, emit) {
      emit(ScoreChange());
    });
  }
}
