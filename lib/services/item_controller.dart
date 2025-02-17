import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:oficina/database/oficina_db.dart';
import 'package:oficina/models/checklist_item.dart';

class ItemController {
  final pagingController =
      PagingController<int, ChecklistItem>(firstPageKey: 0);

  Future<void> fetchItens(int checklistId) async {
    try {
      final mapas = await OficinaDB.instance.buscarChecklistItens(checklistId);
      final List<ChecklistItem> itens = [];
      for (var mapa in mapas) {
        final item = ChecklistItem.fromMap(mapa);
        itens.add(item);
      }
      pagingController.appendLastPage(itens);
    } catch (error) {
      pagingController.error = error;
    }
  }
}
