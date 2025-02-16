import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:oficina/database/oficina_db.dart';
import 'package:oficina/models/proprietario.dart';
import 'package:oficina/presentation/widgets/cards/proprietario_card.dart';
import 'package:oficina/presentation/widgets/dialogs/config_dialog.dart';
import 'package:oficina/presentation/widgets/dialogs/proprietario_dialog.dart';
import 'package:oficina/services/proprietario_controller.dart';
import 'package:signals_flutter/signals_flutter.dart';

class TelaProprietarios extends StatefulWidget {
  const TelaProprietarios({super.key});

  @override
  State<TelaProprietarios> createState() => _TelaProprietariosState();
}

class _TelaProprietariosState extends State<TelaProprietarios> {
  @override
  void initState() {
    super.initState();
    _proprietarioController.pagingController.addPageRequestListener(
      (pageKey) => _proprietarioController.fetchProprietarios(pageKey),
    );
  }

  final ProprietarioController _proprietarioController =
      ProprietarioController();

  @override
  Widget build(BuildContext context) {
    effect(() {
      OficinaDB.instance.dataChanged.watch(context);
      _proprietarioController.pagingController.refresh();
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('Proprietários'),
        actions: [
          IconButton(
            onPressed: () => showDialog(
              context: context,
              builder: (context) => const ConfigDialog(),
            ),
            icon: const Icon(Icons.settings),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final novoProprietario = await showDialog(
              context: context,
              builder: (context) {
                return const ProprietarioDialog();
              },
            );
            if (novoProprietario != null) {
              OficinaDB.instance.inserirProprietario(novoProprietario);
            }
          },
          child: const Icon(Icons.add)),
      body: PagedListView(
        pagingController: _proprietarioController.pagingController,
        builderDelegate: PagedChildBuilderDelegate<Proprietario>(
          itemBuilder: (context, proprietario, index) =>
              ProprietarioCard(proprietario: proprietario),
        ),
      ),
    );
  }
}
