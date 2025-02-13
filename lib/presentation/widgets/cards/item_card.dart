import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:oficina/database/oficina_db.dart';
import 'package:oficina/models/checklist_item.dart';
import 'package:signals_flutter/signals_core.dart';
import 'package:signals_flutter/signals_flutter.dart';

class ItemCard extends StatefulWidget {
  const ItemCard({super.key, required this.checklistItem});

  final ChecklistItem checklistItem;

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  @override
  void initState() {
    super.initState();
    precisaReparo.value = widget.checklistItem.precisaReparo ? 1 : 0;
    precisaTrocar.value = widget.checklistItem.precisaTrocar ? 1 : 0;
    OficinaDB.instance.buscarItem(widget.checklistItem.itemId).then((value) {
      setState(() {
        nomeItem = value['nome'];
      });
    });
  }

  String nomeItem = '';
  final precisaReparo = signal(0);
  final precisaTrocar = signal(0);

  @override
  Widget build(BuildContext context) {
    return Slidable(
        key: const ValueKey(0),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: <Widget>[
            SlidableAction(
              onPressed: (context) {
                final mapa = widget.checklistItem.toMap();
                mapa['precisaReparo'] = 1 - mapa['precisaReparo'];
                OficinaDB.instance.atualizarChecklistItem(mapa);
              },
              icon: precisaReparo.watch(context) == 1
                  ? Icons.warning
                  : Icons.warning_amber,
              backgroundColor: precisaReparo.watch(context) == 1
                  ? Colors.yellow
                  : Colors.grey,
            ),
            SlidableAction(
              onPressed: (context) {
                final mapa = widget.checklistItem.toMap();
                mapa['precisaTrocar'] = 1 - mapa['precisaTrocar'];
                OficinaDB.instance.atualizarChecklistItem(mapa);
              },
              icon: precisaTrocar.watch(context) == 1
                  ? Icons.build
                  : Icons.build_circle,
              backgroundColor: precisaTrocar.watch(context) == 1
                  ? Colors.red
                  : Colors.grey,
            ),
            SlidableAction(
              onPressed: (context) {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Observação'),
                        content: TextField(
                          controller: TextEditingController()
                            ..text = widget.checklistItem.observacao,
                          onChanged: (value) {
                            final mapa = widget.checklistItem.toMap();
                            mapa['observacao'] = value;
                            OficinaDB.instance.atualizarChecklistItem(mapa);
                          },
                        ),
                      );
                    });
              },
              icon: Icons.edit,
              backgroundColor: Colors.blue,
            ),
          ],
        ),
        child: ListTile(
      title: Row(children: [
        widget.checklistItem.precisaReparo
            ? const Icon(Icons.warning, color: Colors.yellow)
            : const SizedBox(),
        widget.checklistItem.precisaTrocar
            ? const Icon(Icons.build, color: Colors.red)
            : const SizedBox(),
        Text(nomeItem),
      ]),
      subtitle: Text(widget.checklistItem.observacao),
    ));
  }
}
