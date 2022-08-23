import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nextlab_assignment/blocs/signing_bloc/signing_bloc.dart';
import 'package:nextlab_assignment/services/google_services.dart';
import 'package:nextlab_assignment/models/record_model.dart';
import 'package:nextlab_assignment/services/sheets_api.dart';

class MyHomePage extends StatelessWidget {
  // GoogleServices? googleServices;
  GoogleSignInAccount? user;
  Position? position;

  Future getPermissions() async {
    // await Geolocator.checkPermission();
    await Geolocator.requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('NextLab Assignment')),
        body: BlocBuilder<SigningBloc, SigningState>(
          builder: (context, state) {
            if (state is SigningInitialState) {
              return Center(
                child: ElevatedButton(
                  child: const Text('Sign In'),
                  onPressed: () async {
                    // setState(() {
                    //   isLoading = true;
                    // });
                    BlocProvider.of<SigningBloc>(context)
                        .add(SignLoadingEvent());
                    await BlocProvider.of<SigningBloc>(context)
                        .googleServices!
                        .signIn();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Signed In'),
                      duration: Duration(seconds: 2),
                    ));
                    while (position == null) {
                      try {
                        position = await Geolocator.getCurrentPosition();
                      } catch (e) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('Need Location'),
                          duration: Duration(seconds: 2),
                        ));
                      }
                    }
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Got Location'),
                      duration: Duration(seconds: 2),
                    ));
                    user = await BlocProvider.of<SigningBloc>(context)
                        .googleServices!
                        .getUser;
                    final record = RecordModel(
                      email: user!.email,
                      time: TimeOfDay.now(),
                      position: position!,
                    ).toJson(context);
                    await SheetsAPI.insert([record]);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Record Saved'),
                      duration: const Duration(seconds: 2),
                    ));
                    BlocProvider.of<SigningBloc>(context).add(SignInEvent());
                    // setState(() {
                    //   isLoading = false;
                    // });
                  },
                ),
              );
            }
            if (state is SigningSignedState) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ListTile(
                    leading: GoogleUserCircleAvatar(
                      identity: user!,
                    ),
                    title: Text(user!.displayName ?? ''),
                    subtitle: Text(user!.email),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      // setState(() {
                      //   isLoading = true;
                      // });
                      BlocProvider.of<SigningBloc>(context)
                          .add(SignLoadingEvent());
                      await BlocProvider.of<SigningBloc>(context)
                          .googleServices!
                          .signOut();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Signed Out'),
                        duration: Duration(seconds: 2),
                      ));
                      BlocProvider.of<SigningBloc>(context).add(SignOutEvent());
                      // setState(() {
                      //   isLoading = false;
                      // });
                    },
                    child: const Text('Sign Out'),
                  ),
                ],
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }
}
