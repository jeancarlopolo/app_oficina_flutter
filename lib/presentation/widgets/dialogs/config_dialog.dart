import 'dart:io';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:oficina/database/oficina_db.dart';
import 'package:path_provider/path_provider.dart';

class ConfigDialog extends StatelessWidget {
  const ConfigDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Configurações'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ElevatedButton(
            onPressed: () async {
              // salva no dispositivo relatorio_mais_carros.txt
              // OficinaDB.instance.relatorioProprietariosMaisCarros() retorna uma string
              final path = await getApplicationDocumentsDirectory()
                ..path;
              final file = File('$path/relatorio_mais_carros.txt');
              await file.create(recursive: true);
              await file.writeAsString(
                await OficinaDB.instance.relatorioProprietariosMaisCarros(),
              );
              Logger().i('Relatório salvo em $path/relatorio_mais_carros.txt');
            },
            child: const Text('Gerar relatório de quem tem mais carros'),
          ),
          ElevatedButton(
            onPressed: () async {
              // salva no dispositivo relatorio_carros_com_mais_problemas.txt
              // OficinaDB.instance.relatorioCarrosMaisNecessitados() retorna uma string
              final path = await getApplicationDocumentsDirectory()
                ..path;
              final file =
                  File('$path/relatorio_carros_com_mais_problemas.txt');
              await file.create(recursive: true);

              await file.writeAsString(
                await OficinaDB.instance.relatorioCarrosMaisNecessitados(),
              );
              Logger().i(
                  'Relatório salvo em $path/relatorio_carros_com_mais_problemas.txt');
            },
            child: const Text('Gerar relatório de carros com mais problemas'),
          ),
          ElevatedButton(
            onPressed: () async {
              // salva no dispositivo relatorio_carros_desatualizados.txt
              // OficinaDB.instance.relatorioCarrosQueFazemMaisTempoDesdeAUltimaChecklist() retorna uma string
              final path = await getApplicationDocumentsDirectory()
                ..path;
              final file = File('$path/relatorio_carros_desatualizados.txt');
              await file.create(recursive: true);
              await file.writeAsString(
                await OficinaDB.instance
                    .relatorioCarrosQueFazemMaisTempoDesdeAUltimaChecklist(),
              );
              Logger().i(
                  'Relatório salvo em $path/relatorio_carros_desatualizados.txt');
            },
            child: const Text(
                'Gerar relatório de carros que estão mais tempo sem checklist'),
          ),
          ElevatedButton(
              onPressed: () => OficinaDB.instance.apagarTudo(),
              child: const Text('APAGAR TUDO')),
          ElevatedButton(
              onPressed: () => OficinaDB.instance.mock(),
              child: const Text('Adicionar dados falsos')),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Fechar'),
        ),
      ],
    );
  }
}
