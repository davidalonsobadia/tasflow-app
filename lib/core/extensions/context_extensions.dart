import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskflow_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:taskflow_app/features/auth/presentation/cubit/auth_state.dart';

extension AuthContextExtension on BuildContext {
  String getUserLocationCode() {
    final authState = read<AuthCubit>().state;
    if (authState is Authenticated) {
      return authState.user.location;
    }
    return '';
  }

  bool isCollaboratingWorkshop() {
    final authState = read<AuthCubit>().state;
    if (authState is Authenticated) {
      return authState.user.collaboratingWorkshop;
    }
    return false;
  }
}
