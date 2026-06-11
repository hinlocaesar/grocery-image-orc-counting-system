import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:grocery_budget_app/app.dart';
import 'package:grocery_budget_app/services/prefs_storage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await PrefsStorage.init();
  });

  testWidgets('App loads budget setup screen', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: GroceryApp()));
    await tester.pumpAndSettle();

    expect(find.text('Groceries'), findsOneWidget);
    expect(find.text('Setup Your Monthly Budget'), findsOneWidget);
  });
}
