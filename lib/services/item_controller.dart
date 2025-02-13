import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:oficina/database/oficina_db.dart';
import 'package:oficina/models/checklist_item.dart';
import 'package:signals_flutter/signals_core.dart';

class ItemController {
  final pagingController = PagingController<int, ChecklistItem>(firstPageKey: 0);

  late final dispose = effect(() {
    OficinaDB.instance.dataChanged;
    pagingController.refresh();
  });

  Future<void> fetchItens(int checklistId) async {
    try {
      final mapas = await OficinaDB.instance.buscarChecklistItens(checklistId);
      final itens = mapas.map((mapa) => ChecklistItem.fromMap(mapa)).toList();
      pagingController.appendLastPage(itens);
      
    } catch (error) {
      pagingController.error = error;
    }
  }
}