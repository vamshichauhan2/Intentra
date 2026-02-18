import 'package:flutter/material.dart';
import 'app/app.dart';
import 'core/services/usage_sync_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ THIS IS THE ONLY LINE YOU WERE MISSING
  await UsageSyncService.sync();

  runApp(const MyApp());
}
