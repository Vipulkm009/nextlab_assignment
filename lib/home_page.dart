import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nextlab_assignment/google_services.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GoogleServices? googleServices;
  bool isLoading = false;
  GoogleSignInAccount? user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    googleServices = GoogleServices();
  }

  @override
  Widget build(BuildContext context) {
    user = googleServices!.getUser;
    return Scaffold(
      appBar: AppBar(title: Text('NextLab Assignment')),
      body: user == null
          ? Center(
              child: isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      child: Text('Sign In'),
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        await googleServices!.signIn();
                        setState(() {
                          isLoading = false;
                        });
                      },
                    ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ListTile(
                  leading: GoogleUserCircleAvatar(
                    identity: user!,
                  ),
                  title: Text(user!.displayName ?? ''),
                  subtitle: Text(user!.email),
                ),
                SizedBox(
                  height: 20.0,
                ),
                isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            isLoading = true;
                          });
                          await googleServices!.signOut();
                          setState(() {
                            isLoading = false;
                          });
                        },
                        child: Text('Sign Out'),
                      ),
              ],
            ),
    );
  }
}
