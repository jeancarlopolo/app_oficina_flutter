import 'package:flutter/material.dart';
import 'package:oficina/presentation/pages/tela_proprietarios.dart';

class Aplicativo extends StatelessWidget {
  const Aplicativo({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'App Oficina',
      home: TelaProprietarios(),
      debugShowCheckedModeBanner: false,
    );
  }
}
