import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:oficina/database/oficina_db.dart';
import 'package:oficina/main.dart';
import 'package:oficina/models/carro.dart';
import 'package:oficina/presentation/widgets/cards/carro_card.dart';
import 'package:oficina/presentation/widgets/dialogs/carro_dialog.dart';
import 'package:oficina/services/carro_controller.dart';
import 'package:signals_flutter/signals_flutter.dart';

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
    _carroController.pagingController.addPageRequestListener(
      (pageKey) => _carroController.fetchCarros(widget.proprietarioId, pageKey),
    );
  }

  final _carroController = CarroController();

  @override
  Widget build(BuildContext context) {
    effect(() {
      OficinaDB.instance.dataChanged.watch(context);
      _carroController.pagingController.refresh();
    });
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
            try {
              await OficinaDB.instance.inserirCarro(novoCarro);
            } catch (e) {
              logger.e(e);
              if (context.mounted) {
                // placa já existe
                await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Erro'),
                    content: const Text('Placa já cadastrada'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              }
            }
          }
        },
        child: const Icon(Icons.add),
      ),
      body: Watch((context) {
        OficinaDB.instance.dataChanged;
        return PagedListView(
          pagingController: _carroController.pagingController,
          builderDelegate: PagedChildBuilderDelegate<Carro>(
            itemBuilder: (context, carro, index) {
              return CarroCard(carro: carro);
            },
          ),
        );
      }),
    );
  }
}
