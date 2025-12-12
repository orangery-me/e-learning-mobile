import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'root_event.dart';
part 'root_state.dart';

@injectable
class RootBloc extends Bloc<RootEvent, RootState> {
  RootBloc() : super(const RootState()) {
    on<RootBottomTabChange>(_onBottomTabChanged);
  }

  void _onBottomTabChanged(
    RootBottomTabChange event,
    Emitter<RootState> emit,
  ) {
    if (event.newIndex == state.currentIndex) return;

    emit(state.copyWith(currentIndex: event.newIndex));
  }
}
