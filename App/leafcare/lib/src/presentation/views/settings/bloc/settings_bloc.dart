import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsState()) {
    on<SetServerIP>(
      (event, emit) async {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('IP', event.ip);
        emit(SettingsState());
      },
    );
  }
}
