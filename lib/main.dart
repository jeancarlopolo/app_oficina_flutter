import 'package:flutter/material.dart';
import 'package:oficina/database/oficina_db.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setup();
  runApp(const ());
}

Future<void> setup() async {
  await OficinaDB.instance.init();
  //OficinaDB.instance.apagarTudo();
  

  bool mock = true; // pra inserir dados de teste
  if (mock) {
    
  }
  
}

