import 'package:check_disposable_email/src/disposable/disposable.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('Test Disposable Email Address', () async {
    String email = 'zen@mailinator.com';
    bool isValid = Disposable.instance.hasValidEmail(email) ?? false;
    expect(false, isValid);
  });
  test('Test Valid Email Address', () async {
    String email = 'zen@gmail.com';
    bool isValid = Disposable.instance.hasValidEmail(email) ?? false;
    expect(true, isValid);
  });
}
