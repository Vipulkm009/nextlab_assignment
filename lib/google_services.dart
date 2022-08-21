import 'package:google_sign_in/google_sign_in.dart';

class GoogleServices {
  GoogleSignIn? _googleSignIn;

  GoogleSignInAccount? _currentUser;

  GoogleServices() {
    _googleSignIn = GoogleSignIn(
      scopes: ['email'],
    );
    _googleSignIn!.onCurrentUserChanged.listen((account) {
      _currentUser = account;
    });
    _googleSignIn!.signInSilently();
  }

  get getUser => _currentUser;

  Future<void> signOut() async {
    await _googleSignIn!.disconnect();
  }

  Future<void> signIn() async {
    try {
      await _googleSignIn!.signIn();
    } catch (e) {
      print('Error : $e');
    }
  }
}
