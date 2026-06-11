import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'services/prefs_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PrefsStorage.init();
  runApp(const ProviderScope(child: GroceryApp()));
}
