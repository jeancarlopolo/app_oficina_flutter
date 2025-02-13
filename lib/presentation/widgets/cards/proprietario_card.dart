import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:oficina/database/oficina_db.dart';
import 'package:oficina/models/proprietario.dart';

class ProprietarioCard extends StatelessWidget {

  const ProprietarioCard({ super.key , required this.proprietario});

  final Proprietario proprietario;

   @override
   Widget build(BuildContext context) {
       return Slidable(
      key: const ValueKey(0),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: <Widget>[
          SlidableAction(
            onPressed: (context) {showDialog(context: context, builder: builder)}, // TODO editar_proprietario.dart
            icon: Icons.edit,
            backgroundColor: Colors.blue,
          ),
          SlidableAction(
            onPressed: (context) {OficinaDB.instance.apagarProprietario(proprietario.id);},
            icon: Icons.delete,
            backgroundColor: Colors.red,
          ),
        ],
      ),
      child: ListTile(
        leading: const Icon(Icons.person),
        title: Text(proprietario.nome),
        subtitle: Text(proprietario.telefone),
        ));
  }
}