import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:oficina/models/checklist_item.dart';
import 'package:oficina/presentation/widgets/cards/item_card.dart';
import 'package:oficina/services/item_controller.dart';

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
    if (_itemController.pagingController.itemList?.isEmpty ?? true) {
      _itemController.pagingController.addPageRequestListener(
        (pageKey) => _itemController.fetchItens(widget.checklistId),
      );
    }
  }

  final _itemController = ItemController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estado das Peças'),
      ),
      body: PagedListView(
        pagingController: _itemController.pagingController,
        builderDelegate: PagedChildBuilderDelegate<Map<String,dynamic>>(
          itemBuilder: (context, item, index) {
            return ItemCard(checklistItem: ChecklistItem.fromMap(item));
          },
        ),
      ),
    );
  }
}
