import 'package:elmotamizon/common/base/exports.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

abstract interface class SocialAuthDataSource {
  Future<Either<Failure, void>> googleAuth();

  Future<Either<Failure, void>> appleAuth();
}

class SocialAuthDataSourceImpl implements SocialAuthDataSource {
  final GenericDataSource _genericDataSource;

  SocialAuthDataSourceImpl(this._genericDataSource);

  @override
  Future<Either<Failure, void>> googleAuth() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      return Left(AuthFailure(message: 'Google Sign-In failed'));
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    return _genericDataSource.postData<void>(
      endpoint: Endpoints.socialLogin,
      data: {
        "provider_id": "google",
        "id_token": googleAuth.idToken,
        "access_token": googleAuth.accessToken,
        "email": googleUser.email,
        "image": googleUser.photoUrl,
        "name": googleUser.displayName,
      },
    );
  }

  @override
  Future<Either<Failure, void>> appleAuth() async {
    final AuthorizationCredentialAppleID appleCredential =
        await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    return _genericDataSource.postData<void>(
      endpoint: Endpoints.socialLogin,
      data: {
        "provider_id": "apple",
        "id_token": appleCredential.identityToken,
        "access_token": appleCredential.authorizationCode,
        "email": appleCredential.email,
        "name": appleCredential.givenName,
      },
    );
  }
}
