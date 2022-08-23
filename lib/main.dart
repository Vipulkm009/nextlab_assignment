import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nextlab_assignment/blocs/signing_bloc/signing_bloc.dart';
import 'package:nextlab_assignment/home_page.dart';
import 'package:nextlab_assignment/services/sheets_api.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SheetsAPI.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SigningBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(),
      ),
    );
  }
}
