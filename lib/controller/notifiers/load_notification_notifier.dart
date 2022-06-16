import 'package:equatable/equatable.dart';
import 'package:state_notifier/state_notifier.dart';

class LoadNotificationController extends StateNotifier<LoadState> {
  LoadNotificationController() : super(const LoadState(false));

  void loadNotification() {
    state = const LoadState(true);
  }

  void unloadNotification() {
    state = const LoadState(false);
  }

  bool getLoadState() {
    return state.load;
  }
}

class LoadState extends Equatable {
  final bool load;
  const LoadState(this.load);
  @override
  List<Object?> get props => [load];
}
