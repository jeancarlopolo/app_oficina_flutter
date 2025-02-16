import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:logger/logger.dart';
import 'package:oficina/database/oficina_db.dart';
import 'package:oficina/models/checklist.dart';
import 'package:oficina/presentation/widgets/cards/checklist_card.dart';
import 'package:oficina/services/checklist_controller.dart';
import 'package:signals_flutter/signals_flutter.dart';

class TelaChecklists extends StatefulWidget {
  const TelaChecklists({super.key, required this.placa});

  final String placa;

  @override
  State<TelaChecklists> createState() => _TelaChecklistsState();
}

class _TelaChecklistsState extends State<TelaChecklists> {
  @override
  void initState() {
    super.initState();
      _checklistController.pagingController.addPageRequestListener(
        (pageKey) =>
            _checklistController.fetchChecklists(widget.placa, pageKey),
      );
  }

  final _checklistController = ChecklistController();



  @override
  Widget build(BuildContext context) {
    effect(() {
      OficinaDB.instance.dataChanged.watch(context);
      _checklistController.pagingController.refresh();
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checklists'),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        final checklist = {'placa': widget.placa, 'dataHorario': (DateTime.now().millisecondsSinceEpoch / 1000).floor()};
        Logger().i(checklist);
        OficinaDB.instance.inserirChecklist(checklist);
      }, child: const Icon(Icons.add)),
      body: PagedListView(
        pagingController: _checklistController.pagingController,
        builderDelegate: PagedChildBuilderDelegate<Checklist>(
          itemBuilder: (context, checklist, index) {
            return ChecklistCard(checklist: checklist);
          },
        ),
      ),
    );
  }
}
