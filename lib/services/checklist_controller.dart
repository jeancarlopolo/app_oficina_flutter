import 'package:oficina/database/oficina_db.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:oficina/models/checklist.dart';
import 'package:signals_flutter/signals_core.dart';

class ChecklistController {
  final pagingController = PagingController<int, Checklist>(firstPageKey: 0);

  late final dispose = effect(() {
    OficinaDB.instance.dataChanged;
    pagingController.refresh();
  });

  Future<void> fetchChecklists(String placa, int pageKey) async {
    try {
      final mapas =
          await OficinaDB.instance.buscarChecklists(placa, pageKey);
      final checklists = mapas.map((mapa) => Checklist.fromMap(mapa)).toList();
      final isLastPage = checklists.length < 10;
      if (isLastPage) {
        pagingController.appendLastPage(checklists);
      } else {
        final nextPageKey = pageKey + 1;
        pagingController.appendPage(checklists, nextPageKey);
      }
    } catch (error) {
      pagingController.error = error;
    }
  }
}