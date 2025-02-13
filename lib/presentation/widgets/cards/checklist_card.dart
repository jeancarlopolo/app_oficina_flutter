import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:oficina/database/oficina_db.dart';
import 'package:oficina/models/checklist.dart';

class ChecklistCard extends StatelessWidget {

  const ChecklistCard({ super.key , required this.checklist});

  final Checklist checklist;

   @override
   Widget build(BuildContext context) {
       return Slidable(
      key: const ValueKey(0),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: <Widget>[
          SlidableAction(
            onPressed: (context) {showDialog(context: context, builder: builder)}, // TODO editar_checklist.dart
            icon: Icons.edit,
            backgroundColor: Colors.blue,
          ),
          SlidableAction(
            onPressed: (context) {OficinaDB.instance.apagarChecklist(checklist.id);},
            icon: Icons.delete,
            backgroundColor: Colors.red,
          ),
        ],
      ),
      child: ListTile(
        title: Text('${checklist.dataHorario.day}/${checklist.dataHorario.month}/${checklist.dataHorario.year}'),
        
        
        ));
  }
}