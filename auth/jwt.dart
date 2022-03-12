/// This file is handling all the functionalities related to JWT
import 'package:dotenv/dotenv.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';

class JWT {
  /// Creating of a token with the [id] of the user
  /// Returning the created token
  String signToken(int id) {
    final claimSet = JwtClaim(
        issuer: env['ISSUER'],
        subject: '$id',
        issuedAt: DateTime.now(),
        maxAge: const Duration(hours: 24));
    final String secret = env['SECRET'];
    return issueJwtHS256(claimSet, secret);
  }
}

/// Validation of the [token] if it is valid from when it was created
///
/// Returns [true] when it is valid
/// On Expection of not valid token return [false]
bool isValidToken(String token) {
  final key = env['SECRET'];
  try {
    verifyJwtHS256Signature(token, key);
    return true;
  } on JwtException {
    print('invalid token or expired token');
  }
  return false;
}
