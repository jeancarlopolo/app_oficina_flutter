import 'package:flutter/material.dart';


class Aplicativo extends StatelessWidget {
  const Aplicativo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Oficina',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('App Oficina'),
        ),
        body: const Center(
          child: Text('Hello World'),
        ),
      ),
    );
  }
}