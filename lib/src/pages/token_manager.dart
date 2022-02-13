import 'package:http/http.dart' as http;

class TokenManager {
  String? refreshToken;
  int refreshTokenExpiresIn = 0;
  String? accessToken;
  int accessTokenExpiresIn = 0;

  void storeToken(Map<String, String> data) {
    refreshToken = data['refresh_token'];
    accessToken = data['access_token'];
    refreshTokenExpiresIn = calculateExpiresDate(data['refresh_token_expires_in']!);
    accessTokenExpiresIn = calculateExpiresDate(data['access_token_expires_in']!);
  }

  int calculateExpiresDate(String expiresDate) {
    int expiresIn = 0;
    try {
      expiresIn = int.parse(expiresDate);
      if (expiresIn < 0) expiresIn = 0;
    } on FormatException {
      expiresIn = 0;
    }
    return DateTime.now()
       .add(Duration(seconds:  expiresIn))
       .millisecondsSinceEpoch;
 }

 /// If return value is -1, it means invalid token
 String getAccessToken(http.Client client) {
   throw UnimplementedError();
 }

 bool _isExpired(int expiresIn, int secondsToExpiration) {
   var now = DateTime.now();
   DateTime expiresDate = DateTime.fromMillisecondsSinceEpoch(expiresIn);
   return expiresDate.difference(now).inSeconds < secondsToExpiration;
 }

 bool isExpiredAccessToken({secondsToExpiration = 60 * 10/*10min*/}) {
   return _isExpired(accessTokenExpiresIn, secondsToExpiration);
 }

 bool isExpiredRefreshToken({secondsToExpiration = 60 * 10/*10min*/}) {
   return _isExpired(refreshTokenExpiresIn, secondsToExpiration);
 }
}

// 토큰 저장
// get ->  acceetoken ? in -> accesstoken
// if refresh token ? -> post -> refresh
// 만료  -> -1