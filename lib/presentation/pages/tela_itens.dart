import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:oficina/database/oficina_db.dart';
import 'package:oficina/models/checklist_item.dart';
import 'package:oficina/presentation/widgets/cards/item_card.dart';
import 'package:oficina/services/item_controller.dart';
import 'package:signals_flutter/signals_flutter.dart';

class TelaItens extends StatefulWidget {
  const TelaItens({super.key, required this.checklistId});

  final int checklistId;

  @override
  State<TelaItens> createState() => _TelaItensState();
}

class _TelaItensState extends State<TelaItens> {
  @override
  void initState() {
    super.initState();
    _itemController.pagingController.addPageRequestListener(
      (pageKey) => _itemController.fetchItens(widget.checklistId),
    );
  }

  final _itemController = ItemController();



  @override
  Widget build(BuildContext context) {
    effect(() {
      OficinaDB.instance.dataChanged.watch(context);
      _itemController.pagingController.refresh();
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estado das Peças'),
      ),
      body: PagedListView(
        pagingController: _itemController.pagingController,
        builderDelegate: PagedChildBuilderDelegate<ChecklistItem>(
          itemBuilder: (context, item, index) {
            return ItemCard(checklistItem: item);
          },
        ),
      ),
    );
  }
}
