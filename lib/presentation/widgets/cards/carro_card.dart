import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:oficina/database/oficina_db.dart';
import 'package:oficina/models/carro.dart';
import 'package:signals_flutter/signals_core.dart';

class CarroCard extends StatelessWidget {
  CarroCard({super.key, required this.carro});

  final Carro carro;

  late final Cor cor = Cor.getCor(carro.cor);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: const ValueKey(0),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: <Widget>[
          SlidableAction(
            onPressed: (context) {showDialog(context: context, builder: builder)}, // TODO editar_carro.dart
            icon: Icons.edit,
            backgroundColor: Colors.blue,
          ),
          SlidableAction(
            onPressed: (context) {OficinaDB.instance.apagarCarro(carro.placa);},
            icon: Icons.delete,
            backgroundColor: Colors.red,
          ),
        ],
      ),
      
      
      
      
      
      child: ListTile(
        textColor: cor.textColor,
        title: Container(decoration: cor.decoration, child: ListTile(
          textColor: cor.textColor,
          title: Text(carro.modelo),
          subtitle: Text(carro.placa),
          leading: Icon(Icons.directions_car, color: cor.textColor),
        )),
        ),
      );
  }
}