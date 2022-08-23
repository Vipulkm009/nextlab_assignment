part of 'signing_bloc.dart';

@immutable
abstract class SigningEvent {}

class SignReadyEvent extends SigningEvent {}

class SignInEvent extends SigningEvent {}

class SignOutEvent extends SigningEvent {}

class SignLoadingEvent extends SigningEvent {}