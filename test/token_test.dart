import 'package:flutter_test/flutter_test.dart';
import 'package:sample_sns_login/src/pages/token_manager.dart';

void main() {
  test('token expired check', () async {
    Map<String, String> fakeValue = {
      'access_token_expires_in':'0',
      'refresh_token_expires_in':'0',
    };

    var tokenManager = TokenManager();

    fakeValue['refresh_token_expires_in'] = '1';
    tokenManager.storeToken(fakeValue);
    await Future.delayed(const Duration(seconds: 2));
    expect(tokenManager.isExpiredRefreshToken(secondsToExpiration: 0), true);

    fakeValue['refresh_token_expires_in'] = '3';
    tokenManager.storeToken(fakeValue);
    expect(tokenManager.isExpiredRefreshToken(secondsToExpiration: 0), false);

    fakeValue['refresh_token_expires_in'] = '3';
    tokenManager.storeToken(fakeValue);
    expect(tokenManager.isExpiredRefreshToken(secondsToExpiration: 3), true);

    fakeValue['access_token_expires_in'] = '1';
    tokenManager.storeToken(fakeValue);
    await Future.delayed(const Duration(seconds: 2));
    expect(tokenManager.isExpiredAccessToken(secondsToExpiration: 0), true);

    fakeValue['access_token_expires_in'] = '3';
    tokenManager.storeToken(fakeValue);
    expect(tokenManager.isExpiredAccessToken(secondsToExpiration: 0), false);

    fakeValue['access_token_expires_in'] = '3';
    tokenManager.storeToken(fakeValue);
    expect(tokenManager.isExpiredAccessToken(secondsToExpiration: 3), true);
  });

  test('get accesstoken in expires date', () async {
    Map<String, String> fakeValue = {};

    var tokenManager = TokenManager();

    fakeValue['access_token'] = 'xxx';
    fakeValue['access_token_expires_in'] = '3';

    tokenManager.storeToken(fakeValue);
    expect(tokenManager.getAccessToken(), 'xxx');
  });
}