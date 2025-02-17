import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oficina/database/oficina_db.dart';

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
              // OficinaDB.instance.relatorioProprietariosMaisCarros() retorna uma string
              Clipboard.setData(
                ClipboardData(
                  text: await OficinaDB.instance
                      .relatorioProprietariosMaisCarros(),
                ),
              );
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content:
                        Text('Relatório copiado para a área de transferência'),
                  ),
                );
              }
            },
            child: const Text('Gerar relatório de quem tem mais carros'),
          ),
          ElevatedButton(
            onPressed: () async {
              // OficinaDB.instance.relatorioCarrosMaisNecessitados() retorna uma string
              Clipboard.setData(
                ClipboardData(
                  text: await OficinaDB.instance
                      .relatorioCarrosMaisNecessitados(),
                ),
              );
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content:
                        Text('Relatório copiado para a área de transferência'),
                  ),
                );
              }
            },
            child: const Text('Gerar relatório de carros com mais problemas'),
          ),
          ElevatedButton(
            onPressed: () async {
              // OficinaDB.instance.relatorioCarrosQueFazemMaisTempoDesdeAUltimaChecklist() retorna uma string
              Clipboard.setData(
                ClipboardData(
                  text: await OficinaDB.instance
                      .relatorioCarrosQueFazemMaisTempoDesdeAUltimaChecklist(),
                ),
              );
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content:
                        Text('Relatório copiado para a área de transferência'),
                  ),
                );
              }
            },
            child: const Text(
                'Gerar relatório de carros que estão mais tempo sem checklist'),
          ),
          ElevatedButton(
              onPressed: () async {
                await OficinaDB.instance.apagarTudo();
                OficinaDB.instance.inserirItens();
              },
              child: const Text('APAGAR TUDO')),
          ElevatedButton(
              onPressed: () async {
                await OficinaDB.instance.mock();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Dados falsos adicionados'),
                    ),
                  );
                }
              },
              child: const Text('Adicionar dados falsos (demora um pouco)')),
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
