import 'package:oficina/database/oficina_db.dart';
import 'package:oficina/models/carro.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:signals_flutter/signals_core.dart';

class CarroController {
  final pagingController = PagingController<int, Carro>(firstPageKey: 0);

  late final dispose = effect(() {
    OficinaDB.instance.dataChanged;
    pagingController.refresh();
  });

  Future<void> fetchCarros(int proprietarioId, int pageKey) async {
    try {
      final mapas =
          await OficinaDB.instance.buscarCarros(proprietarioId, pageKey);
      final carros = mapas.map((mapa) => Carro.fromMap(mapa)).toList();
      final isLastPage = carros.length < 10;
      if (isLastPage) {
        pagingController.appendLastPage(carros);
      } else {
        final nextPageKey = pageKey + 1;
        pagingController.appendPage(carros, nextPageKey);
      }
    } catch (error) {
      pagingController.error = error;
    }
  }
}
