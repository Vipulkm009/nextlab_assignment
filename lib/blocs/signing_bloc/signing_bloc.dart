import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';
import 'package:nextlab_assignment/services/google_services.dart';

part 'signing_event.dart';
part 'signing_state.dart';

class SigningBloc extends Bloc<SigningEvent, SigningState> {
  GoogleServices? googleServices;

  SigningBloc() : super(SigningReadyState()) {
    googleServices = GoogleServices();
    getPermissions();

    on<SignInEvent>((event, emit) {
      emit(SigningSignedState());
    });

    on<SignOutEvent>((event, emit) {
      emit(SigningInitialState());
    });

    on<SignLoadingEvent>((event, emit) {
      emit(SigningLoadingState());
    });

    on<SignReadyEvent>((event, emit) {
      emit(SigningReadyState());
    });

    print(googleServices);
    if (googleServices != null) add(SignOutEvent());
  }

  getPermissions() async {
    await Geolocator.requestPermission();
  }
}
