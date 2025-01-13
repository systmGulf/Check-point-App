import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase<dynamic> bloc) {
    super.onCreate(bloc);
    // Print onCreate message in yellow
    print('\x1B[33monCreate -- ${bloc.runtimeType}\x1B[0m');
  }

  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    super.onEvent(bloc, event);
    // Print onEvent message in yellow
    print('\x1B[33monEvent -- ${bloc.runtimeType} -- Event: $event\x1B[0m');
  }

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    // Print onChange message in yellow
    print('\x1B[33monChange -- ${bloc.runtimeType} -- Change: $change.\x1B[0m');
  }

  @override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    super.onTransition(bloc, transition);
    // Print onTransition message in yellow
    print(
        '\x1B[33monTransition -- ${bloc.runtimeType} -- Transition: $transition\x1B[0m');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    // Print onError message in yellow
    print('\x1B[33monError -- ${bloc.runtimeType} -- Error: $error\x1B[0m');
  }

  @override
  void onClose(BlocBase<dynamic> bloc) {
    super.onClose(bloc);
    // Print onClose message in yellow
    print('\x1B[33monClose -- ${bloc.runtimeType}\x1B[0m');
  }
}
