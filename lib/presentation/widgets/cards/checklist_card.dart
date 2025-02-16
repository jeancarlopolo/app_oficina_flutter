import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:oficina/database/oficina_db.dart';
import 'package:oficina/models/checklist.dart';
import 'package:oficina/presentation/pages/tela_itens.dart';

class ChecklistCard extends StatelessWidget {
  const ChecklistCard({super.key, required this.checklist});

  final Checklist checklist;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Slidable(
          key: const ValueKey(0),
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: <Widget>[
              SlidableAction(
                onPressed: (context) {
                  OficinaDB.instance.apagarChecklist(checklist.id!);
                },
                icon: Icons.delete,
                backgroundColor: Colors.red,
              ),
            ],
          ),
          child: ListTile(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => TelaItens(checklistId: checklist.id!),
              ),
            ),
            title: Text(
                '${checklist.dataHorario.day.toString().padLeft(2, '0')}/${checklist.dataHorario.month.toString().padLeft(2, '0')}/${checklist.dataHorario.year} - ${checklist.dataHorario.hour.toString().padLeft(2, '0')}:${checklist.dataHorario.minute.toString().padLeft(2, '0')}'),
          )),
    );
  }
}
