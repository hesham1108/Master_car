import 'package:equatable/equatable.dart';
import 'package:state_notifier/state_notifier.dart';

class LoggedController extends StateNotifier<LoggedState> {
  LoggedController() : super(const LoggedState(false));

  void login() {
    state = const LoggedState(true);
  }

  void logout() {
    state = const LoggedState(false);
  }

  bool getLogged() {
    return state.logged;
  }
}

class LoggedState extends Equatable {
  final bool logged;
  const LoggedState(this.logged);
  @override
  List<Object?> get props {
    return [logged];
  }
}
