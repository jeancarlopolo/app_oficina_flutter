import 'package:flutter/material.dart';
import 'package:oficina/aplicativo.dart';
import 'package:oficina/database/oficina_db.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setup();
  runApp(const Aplicativo());
}

Future<void> setup() async {
  await OficinaDB.instance.init();
}

