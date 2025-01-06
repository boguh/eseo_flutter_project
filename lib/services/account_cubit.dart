import 'dart:ffi';

import 'package:app/widgets/google_auth_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountCubit extends Cubit<Map<String,dynamic>> {
  AccountCubit() : super({
    'isAuthenticated': false,

  });

  bool get isAuthenticated => state['isAuthenticated'];

  void updateAccount(bool isAuthenticated) {
    emit({
      'isAuthenticated': isAuthenticated,
    });

  }
}