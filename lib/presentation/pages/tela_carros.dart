import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:oficina/models/carro.dart';
import 'package:oficina/presentation/widgets/cards/carro_card.dart';
import 'package:oficina/presentation/widgets/dialogs/carro_dialog.dart';
import 'package:oficina/services/carro_controller.dart';

class TelaCarros extends StatefulWidget {
  const TelaCarros({super.key, required this.proprietarioId});

  final int proprietarioId;

  @override
  State<TelaCarros> createState() => _TelaCarrosState();
}

class _TelaCarrosState extends State<TelaCarros> {
  @override
  void initState() {
    super.initState();
    if (_carroController.pagingController.itemList?.isEmpty ?? true) {
      _carroController.pagingController.addPageRequestListener(
        (pageKey) =>
            _carroController.fetchCarros(widget.proprietarioId, pageKey),
      );
    }
  }

  final _carroController = CarroController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carros'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final novoCarro = await showDialog(
            context: context,
            builder: (context) {
              return CarroDialog(proprietarioId: widget.proprietarioId);
            },
          );
          if (novoCarro != null) {
            _carroController.pagingController.itemList!.add(novoCarro);
          }
        },
        child: const Icon(Icons.add),
      ),
      body: PagedListView(
        pagingController: _carroController.pagingController,
        builderDelegate: PagedChildBuilderDelegate<Carro>(
          itemBuilder: (context, carro, index) {
            return CarroCard(carro: carro);
          },
        ),
      ),
    );
  }
}
