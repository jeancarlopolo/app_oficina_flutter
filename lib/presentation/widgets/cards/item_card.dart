import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:oficina/database/oficina_db.dart';
import 'package:oficina/models/checklist_item.dart';

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
    OficinaDB.instance.buscarItem(widget.checklistItem.itemId).then((value) {
      setState(() {
        nomeItem = value['nome'];
      });
    });
  }

  String nomeItem = '';
  String observacao = '';

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
                  final mapa = widget.checklistItem.toMap();
                  mapa['precisaReparo'] = 1 - mapa['precisaReparo'];
                  OficinaDB.instance.atualizarChecklistItem(mapa);
                },
                icon: widget.checklistItem.precisaReparo
                    ? Icons.warning
                    : Icons.warning_amber,
                backgroundColor: widget.checklistItem.precisaReparo
                    ? Colors.yellow
                    : Colors.grey,
              ),
              SlidableAction(
                onPressed: (context) {
                  final mapa = widget.checklistItem.toMap();
                  mapa['precisaTrocar'] = 1 - mapa['precisaTrocar'];
                  OficinaDB.instance.atualizarChecklistItem(mapa);
                },
                icon: widget.checklistItem.precisaTrocar
                    ? Icons.build
                    : Icons.build_circle,
                backgroundColor: widget.checklistItem.precisaTrocar
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
                          actions: [
                            TextButton(
                              onPressed: () {
                                OficinaDB.instance.atualizarChecklistItem(widget.checklistItem.copyWith(observacao: observacao).toMap());
                                Navigator.of(context).pop();
                              },
                              child: const Text('Confirmar'),
                            ),
                          ],
                          content: TextField(
                            controller: TextEditingController()
                              ..text = widget.checklistItem.observacao,
                            onChanged: (value) {
                              observacao = value;
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
              Text(nomeItem == ''
                  ? ''
                  : nomeItem[0].toUpperCase() + nomeItem.substring(1)),
              const SizedBox(width: 8),
              widget.checklistItem.precisaReparo
                  ? const Icon(Icons.warning, color: Colors.yellow)
                  : const SizedBox(),
              const SizedBox(width: 8),
              widget.checklistItem.precisaTrocar
                  ? const Icon(Icons.build, color: Colors.red)
                  : const SizedBox(),
            ]),
            subtitle: Text(widget.checklistItem.observacao),
            trailing: const Icon(Icons.arrow_back),
          )),
    );
  }
}
