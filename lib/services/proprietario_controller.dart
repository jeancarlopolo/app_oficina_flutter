import 'package:oficina/database/oficina_db.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:oficina/models/proprietario.dart';
import 'package:signals_flutter/signals_core.dart';


class ProprietarioController {
  final pagingController = PagingController<int, Proprietario>(firstPageKey: 0);

  late final dispose = effect(() {
    OficinaDB.instance.dataChanged;
    pagingController.refresh();
  });

  Future<void> fetchProprietarios(int pageKey) async {
    try {
      final mapas = await OficinaDB.instance.buscarProprietarios(pageKey);
      final proprietarios =
          mapas.map((mapa) => Proprietario.fromMap(mapa)).toList();
      final isLastPage = proprietarios.length < 10;
      if (isLastPage) {
        pagingController.appendLastPage(proprietarios);
      } else {
        final nextPageKey = pageKey + 1;
        pagingController.appendPage(proprietarios, nextPageKey);
      }
    } catch (error) {
      pagingController.error = error;
    }
  }
}