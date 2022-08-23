part of 'signing_bloc.dart';

@immutable
abstract class SigningState {}

class SigningInitialState extends SigningState {}

class SigningReadyState extends SigningState {}

class SigningLoadingState extends SigningState {}

class SigningSignedState extends SigningState {}
