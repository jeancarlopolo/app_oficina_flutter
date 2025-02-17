import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:oficina/aplicativo.dart';
import 'package:oficina/database/oficina_db.dart';

final Logger logger = Logger();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await OficinaDB.instance.init();
  await OficinaDB.instance.inserirItens();

  runApp(const Aplicativo());
}
