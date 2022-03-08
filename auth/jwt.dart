import 'package:jaguar_jwt/jaguar_jwt.dart';

import '../config.dart';

class JWT {
  String signToken(int id) {
    final claimSet = JwtClaim(
        issuer: 'API Games',
        subject: '$id',
        issuedAt: DateTime.now(),
        maxAge: const Duration(hours: 24));
    const String secret = Properties.jwtSecret;
    print("created JWT");
    return issueJwtHS256(claimSet, secret);
  }
}

bool isValidToken(String token) {
  const key = Properties.jwtSecret;
  try {
    verifyJwtHS256Signature(token, key);
    return true;
  } on JwtException {
    print('invalid token or expired token');
  }
  return false;
}
