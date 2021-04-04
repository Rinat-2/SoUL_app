
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ui/user.dart';

class AuthService {
  final FirebaseAuth _fAuth = FirebaseAuth.instance;

  Future<User> signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _fAuth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      return User.fromFirebase(user);
    } catch (e) {
      return null;
    }
  }

  Future<User> logOut() async {
    await _fAuth.signOut();
  }
  Future<FirebaseUser> googleSignIn() async {
    final GoogleSignInAccount googleSignInAccount = await GoogleSignIn(
      scopes: [
        'email',
      ],
    ).signIn();
    final GoogleSignInAuthentication authentication =
    await googleSignInAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: authentication.accessToken,
        idToken: authentication.idToken);
    final AuthResult user =
    await FirebaseAuth.instance.signInWithCredential(credential);

   return user.user;
  }
  Stream<User> get currentUser {
    return _fAuth.onAuthStateChanged.map(
        (FirebaseUser user) => user != null ? User.fromFirebase(user) : null);
  }
}
