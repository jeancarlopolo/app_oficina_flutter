import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:oficina/main.dart';
import 'package:signals_flutter/signals_core.dart';
import 'package:sqflite/sqflite.dart';

class OficinaDB {
  OficinaDB._();

  static final OficinaDB instance = OficinaDB._();

  late Database _db;

  final dataChanged = signal(0);

  Future<void> init() async {
    _db = await openDatabase('oficina.db', version: 6,
        onConfigure: (Database db) async {
      await db.execute('PRAGMA foreign_keys = ON;');
    }, onCreate: (Database db, int version) async {
      await db.execute('''
      CREATE TABLE proprietario (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        telefone TEXT
      )
    ''');
      await db.execute('''
      CREATE TABLE carro (
        placa TEXT PRIMARY KEY,
        modelo TEXT,
        cor TEXT,
        marca TEXT,
        ano INTEGER,
        quilometragem INTEGER,
        motorista TEXT,
        proprietarioId INTEGER,
        FOREIGN KEY(proprietarioId) REFERENCES proprietario(id) ON DELETE CASCADE
      )
    ''');
      await db.execute('''
      CREATE TABLE checklist (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        dataHorario INTEGER, -- segundos desde 1970
        placa TEXT,
        FOREIGN KEY(placa) REFERENCES carro(placa) ON DELETE CASCADE
      )
    ''');
      await db.execute('''
      CREATE TABLE item (
        id INTEGER PRIMARY KEY,
        nome TEXT NOT NULL UNIQUE
      )
    ''');
      await db.execute('''
      CREATE TABLE checklistItem (
        checklistId INTEGER,
        itemId INTEGER,
        precisaReparo INTEGER CHECK (precisaReparo IN (0, 1)),
        precisaTrocar INTEGER CHECK (precisaTrocar IN (0, 1)),
        observacao TEXT,
        FOREIGN KEY (checklistId) REFERENCES checklist (id) ON DELETE CASCADE,
        FOREIGN KEY (itemId) REFERENCES item (id),
        PRIMARY KEY (checklistId, itemId)
      )
    ''');
    });
    if (await _db.rawQuery('''SELECT COUNT(*) FROM item''').then(
            (value) => value[0].values.first) ==
        0) {
      await OficinaDB.instance.inserirItens();
    }
  }

  Future<void> inserirItens() async {
    String itemCsv = await rootBundle.loadString('mock/item.csv');
    final itens = const CsvToListConverter(eol: '\n').convert(itemCsv);
    for (var item in itens) {
      var itemTratado = {
        'nome': item[1].toString().replaceAll('\r', ''),
        'id': item[0]
      };
      await inserirItem(itemTratado);
    }
    logger.i('${await buscarItens()} itens inseridos');
  }

  Future<void> mock() async {
    String proprietarioCsv =
        await rootBundle.loadString('mock/proprietario.csv');
    List<List<dynamic>> proprietarios =
        const CsvToListConverter(eol: '\n').convert(proprietarioCsv);
    for (var proprietario in proprietarios) {
      await inserirProprietario(
          {'nome': proprietario[1], 'telefone': proprietario[2]});
    }
    String carroCsv = await rootBundle.loadString('mock/carro.csv');
    List<List<dynamic>> carros =
        const CsvToListConverter(eol: '\n').convert(carroCsv);
    for (var carro in carros) {
      await inserirCarro({
        'placa': carro[0],
        'marca': carro[1],
        'modelo': carro[2],
        'cor': carro[3],
        'ano': carro[4],
        'quilometragem': carro[5],
        'motorista': carro[6],
        'proprietarioId': carro[7]
      });
    }
    String checklistCsv = await rootBundle.loadString('mock/checklist.csv');
    List<List<dynamic>> checklists =
        const CsvToListConverter(eol: '\n').convert(checklistCsv);
    for (var checklist in checklists) {
      await inserirChecklist(
          {'dataHorario': checklist[1], 'placa': checklist[2]});
    }
    String checklistItemCsv =
        await rootBundle.loadString('mock/checklistItem.csv');
    List<List<dynamic>> checklistItens =
        const CsvToListConverter(eol: '\n').convert(checklistItemCsv);
    for (var checklistItem in checklistItens) {
      await inserirChecklistItem({
        'checklistId': checklistItem[0],
        'itemId': checklistItem[1],
        'precisaReparo': checklistItem[2],
        'precisaTrocar': checklistItem[3],
        'observacao': checklistItem[4]
      });
    }
    logger.i('Mock inserido');
  }

  Future<int> inserirProprietario(Map<String, dynamic> proprietario) async {
    final id = await _db.insert('proprietario', proprietario);
    dataChanged.value++;
    logger.i('Proprietario $id ${proprietario['nome']} inserido');
    return id;
  }

  Future<void> inserirCarro(Map<String, dynamic> carro) async {
    carro['placa'] =
        carro['placa'].toUpperCase().replaceAll(' ', '').replaceAll('-', '');
    carro.remove('placaAntiga');
    await _db.insert('carro', carro,
        conflictAlgorithm: ConflictAlgorithm.replace);
    dataChanged.value++;
    logger.i('Carro {${carro['placa']}} inserido');
  }

  Future<int> inserirChecklist(Map<String, dynamic> checklist) async {
    checklist['placa'] = checklist['placa']
        .toUpperCase()
        .replaceAll(' ', '')
        .replaceAll('-', '');
    if (await _db.rawQuery('''
      SELECT EXISTS(SELECT 1 FROM carro WHERE placa = ?)
    ''', [checklist['placa']]).then((value) => value[0].values.first) == 0) {
      logger.e('Placa ${checklist['placa']} não existe');
      return -1;
    }
    final id = await _db.insert('checklist', checklist);
    dataChanged.value++;
    logger.i('Checklist $id inserido');
    return id;
  }

  Future<void> inserirItem(Map<String, dynamic> item) async {
    await _db.insert('item', item);
    dataChanged.value++;
  }

  Future<void> inserirChecklistItem(Map<String, dynamic> checklistItem) async {
    // verifica se a checklist existe
    if (await _db.rawQuery('''
      SELECT EXISTS(SELECT 1 FROM checklist WHERE id = ?)
    ''', [
          checklistItem['checklistId']
        ]).then((value) => value[0].values.first) ==
        0) {
      logger.e('Checklist ${checklistItem['checklistId']} não existe');
      return;
    }
    // verifica se o item existe
    if (await _db.rawQuery('''
      SELECT EXISTS(SELECT 1 FROM item WHERE id = ?)
    ''', [checklistItem['itemId']]).then((value) => value[0].values.first) ==
        0) {
      logger.e('Item ${checklistItem['itemId']} não existe');
      return;
    }
    await _db.insert('checklistItem', checklistItem,
        conflictAlgorithm: ConflictAlgorithm.replace);
    dataChanged.value++;
    logger.i(
        'ChecklistItem {${checklistItem['checklistId']}, ${checklistItem['itemId']}} inserido');
  }

  Future<List<Map<String, dynamic>>> buscarProprietarios(int pageKey) async {
    return await _db.rawQuery('''
      SELECT * FROM proprietario LIMIT 10 OFFSET $pageKey
    ''');
  }

  Future<List<Map<String, dynamic>>> buscarCarros(
      int proprietarioId, int pageKey) async {
    return await _db.rawQuery('''
      SELECT * FROM carro WHERE proprietarioId = $proprietarioId LIMIT 10 OFFSET $pageKey
    ''');
  }

  Future<List<Map<String, dynamic>>> buscarChecklists(
      String placa, int pageKey) async {
    return await _db.rawQuery('''
      SELECT * FROM checklist WHERE placa = '$placa' LIMIT 10 OFFSET $pageKey
    ''');
  }

  Future<List<Map<String, dynamic>>> buscarItens() async {
    return await _db.rawQuery('''
      SELECT * FROM item
    ''');
  }

  Future<Map<String, dynamic>> buscarItem(int id) async {
    final result = await _db.rawQuery('''
      SELECT * FROM item WHERE id = ?
    ''', [id]);
    return result[0];
  }

  Future<List<Map<String, dynamic>>> buscarChecklistItens(
      int checklistId) async {
    // Insere os itens faltantes com valores padrão
    final itens = await buscarItens();
    final idsExistentes = (await _db.rawQuery('''
      SELECT itemId FROM checklistItem WHERE checklistId = ?
    ''', [checklistId])).map((e) => e['itemId']).toList();
    for (var item in itens) {
      if (!idsExistentes.contains(item['id'])) {
        await inserirChecklistItem({
          'checklistId': checklistId,
          'itemId': item['id'],
          'precisaReparo': 0,
          'precisaTrocar': 0,
          'observacao': ''
        });
      }
    }

    // Retorna todos os itens do checklist
    final result = await _db.rawQuery('''
      SELECT item.id, precisaReparo, precisaTrocar, observacao, checklistId, itemId
      FROM item
      LEFT JOIN checklistItem
          ON item.id = checklistItem.itemId
          AND checklistItem.checklistId = ?
    ''', [checklistId]);

    return result;
  }

  Future<void> atualizarProprietario(Map<String, dynamic> proprietario) async {
    await _db.rawUpdate('''
      UPDATE proprietario SET nome = ?, telefone = ? WHERE id = ?
    ''', [proprietario['nome'], proprietario['telefone'], proprietario['id']]);
    dataChanged.value++;
    logger.i('Proprietario {${proprietario['nome']}} atualizado');
  }

  // passar placa antiga e nova
  Future<void> atualizarCarro(Map<String, dynamic> carro) async {
    if (carro['placa'] != carro['placaAntiga']) {
      bool jaExiste = (await _db.rawQuery('''
        SELECT EXISTS(SELECT 1 FROM carro WHERE placa = ?)
      ''', [carro['placa']]))[0].values.first == 1;
      if (jaExiste) {
        throw Exception('Placa já existe');
      }
    }
    carro.remove('placaAntiga');
    carro['placa'] =
        carro['placa'].toUpperCase().replaceAll(' ', '').replaceAll('-', '');

    await _db.rawUpdate('''
      UPDATE carro SET modelo = ?, cor = ?, motorista = ?, proprietarioId = ? WHERE placa = ?
    ''', [
      carro['modelo'],
      carro['cor'],
      carro['motorista'],
      carro['proprietarioId'],
      carro['placa']
    ]);
    dataChanged.value++;
    logger.i('Carro {${carro['placa']}} atualizado');
  }

  Future<void> atualizarChecklist(Map<String, dynamic> checklist) async {
    await _db.rawUpdate('''
      UPDATE checklist SET dataHorario = ?, placa = ? WHERE id = ?
    ''', [checklist['dataHorario'], checklist['placa'], checklist['id']]);
    dataChanged.value++;
    logger.i('Checklist {${checklist['id']}} atualizado');
  }

  Future<void> atualizarItem(Map<String, dynamic> item) async {
    await _db.rawUpdate('''
      UPDATE item SET nome = ? WHERE id = ?
    ''', [item['nome'], item['id']]);
    dataChanged.value++;
    logger.i('Item {${item['nome']}} atualizado');
  }

  Future<void> atualizarChecklistItem(
      Map<String, dynamic> checklistItem) async {
    await _db.rawUpdate('''
      UPDATE checklistItem SET precisaReparo = ?, precisaTrocar = ?, observacao = ? WHERE checklistId = ? AND itemId = ?
    ''', [
      checklistItem['precisaReparo'],
      checklistItem['precisaTrocar'],
      checklistItem['observacao'],
      checklistItem['checklistId'],
      checklistItem['itemId']
    ]);
    dataChanged.value++;
    logger.i(
        'ChecklistItem {${checklistItem['checklistId']}, ${checklistItem['itemId']}} atualizado');
  }

  Future<void> apagarProprietario(int id) async {
    await _db.rawDelete('''
      DELETE FROM proprietario WHERE id = ?
    ''', [id]);
    dataChanged.value++;
    logger.i('Proprietario {id: $id} apagado');
  }

  Future<void> apagarCarro(String placa) async {
    await _db.rawDelete('''
      DELETE FROM carro WHERE placa = ?
    ''', [placa]);
    dataChanged.value++;
    logger.i('Carro {placa: $placa} apagado');
  }

  Future<void> apagarChecklist(int id) async {
    await _db.rawDelete('''
      DELETE FROM checklist WHERE id = ?
    ''', [id]);
    dataChanged.value++;
    logger.i('Checklist {id: $id} apagado');
  }

  Future<void> apagarItem(int id) async {
    await _db.rawDelete('''
      DELETE FROM item WHERE id = ?
    ''', [id]);
    dataChanged.value++;
    logger.i('Item {id: $id} apagado');
  }

  Future<void> apagarChecklistItem(int checklistId, int itemId) async {
    await _db.rawDelete('''
      DELETE FROM checklistItem WHERE checklistId = ? AND itemId = ?
    ''', [checklistId, itemId]);
    dataChanged.value++;
    logger.i(
        'ChecklistItem {checklistId: $checklistId, itemId: $itemId} apagado');
  }

  Future<String> relatorioCarrosMaisNecessitados() async {
    // nome do dono - placa - problemas (reparo or troca)
    List<Map<String, dynamic>> carros = await _db.rawQuery('''
    SELECT 
    p.nome AS 'Dono',
    c.placa AS 'Placa do Carro',
    SUM(CASE WHEN ci.precisaReparo = 1 OR ci.precisaTrocar = 1 THEN 1 ELSE 0 END) AS 'Quantidade de Problemas'
    FROM checklistItem ci
    INNER JOIN checklist ch ON ci.checklistId = ch.id
    INNER JOIN (
        -- Subconsulta para obter o checklist mais recente de cada carro
        SELECT placa, MAX(dataHorario) AS ultimo_dataHorario
        FROM checklist
        GROUP BY placa
    ) ultima_checklist ON ch.placa = ultima_checklist.placa AND ch.dataHorario = ultima_checklist.ultimo_dataHorario
    INNER JOIN carro c ON ch.placa = c.placa
    INNER JOIN proprietario p ON c.proprietarioId = p.id
    GROUP BY c.placa, p.nome
    HAVING 'Quantidade de Problemas' > 0
    ORDER BY SUM(CASE WHEN ci.precisaReparo = 1 OR ci.precisaTrocar = 1 THEN 1 ELSE 0 END) DESC;
    ''');
    String relatorio = 'Carros mais necessitados:\n';
    for (var carro in carros) {
      relatorio +=
          '${carro['Dono']} - ${carro['Placa do Carro']} - ${carro['Quantidade de Problemas']} problemas\n';
    }
    logger.i('Relatório: $relatorio');

    return relatorio;
  }

  Future<String> relatorioProprietariosMaisCarros() async {
    // nome do dono - quantidade de carros
    List<Map<String, dynamic>> proprietarios = await _db.rawQuery('''
    SELECT 
    p.nome AS 'Dono',
    COUNT(c.placa) AS 'Quantidade de Carros'
    FROM carro c
    INNER JOIN proprietario p ON c.proprietarioId = p.id
    GROUP BY p.nome
    ORDER BY COUNT(c.placa) DESC;
    ''');
    String relatorio = 'Proprietarios com mais carros:\n';
    for (var proprietario in proprietarios) {
      relatorio +=
          '${proprietario['Dono']} - ${proprietario['Quantidade de Carros']} carros\n';
    }
    logger.i('Relatório: $relatorio');

    return relatorio;
  }

  Future<String> relatorioCarrosQueFazemMaisTempoDesdeAUltimaChecklist() async {
    // placa - tempo desde a ultima checklist
    List<Map<String, dynamic>> carros = await _db.rawQuery('''
    SELECT 
    p.nome AS "Nome do Dono",
    c.placa AS "Placa do Carro",
    COALESCE(strftime('%s','now') - MAX(ch.dataHorario), strftime('%s','now')) AS "Tempo Desde Última Checklist (segundos)"
    FROM carro c
    LEFT JOIN checklist ch ON c.placa = ch.placa
    LEFT JOIN proprietario p ON c.proprietarioId = p.id
    GROUP BY c.placa
    ORDER BY "Tempo Desde Última Checklist (segundos)" DESC;
    ''');
    String relatorio =
        'Carros que fazem mais tempo desde a última checklist:\n';
    for (var carro in carros) {
      int dias = (int.parse(
                  carro['Tempo Desde Última Checklist (segundos)'].toString()) /
              86400)
          .floor();
      int horas = ((int.parse(carro['Tempo Desde Última Checklist (segundos)']
                      .toString()) %
                  86400) /
              3600)
          .floor();
      int minutos = ((int.parse(carro['Tempo Desde Última Checklist (segundos)']
                      .toString()) %
                  3600) /
              60)
          .floor();
      final String diasStr = dias > 0 ? '$dias dias, ' : '';
      final String horasStr = horas > 0 ? '$horas horas, ' : '';

      String linha =
          '${carro['Nome do Dono']} - ${carro['Placa do Carro']} - $diasStr$horasStr$minutos minutos\n';
      if (dias > 10000) {
        linha =
            '${carro['Nome do Dono']} - ${carro['Placa do Carro']} - Nunca fez checklist\n';
      }
      relatorio += linha;
    }
    logger.i('Relatório: $relatorio');
    return relatorio;
  }

  Future<void> apagarTudo() async {
    await _db.execute('''
      DELETE FROM proprietario 
    ''');
    await _db.execute('''
      DELETE FROM sqlite_sequence WHERE name = 'proprietario'
    ''');
    logger.i('Todos os proprietarios apagados');
    await _db.execute('''
      DELETE FROM carro
    ''');
    await _db.execute('''
      DELETE FROM sqlite_sequence WHERE name = 'carro'
    ''');
    logger.i('Todos os carros apagados');
    await _db.execute('''
      DELETE FROM checklist
    ''');
    await _db.execute('''
      DELETE FROM sqlite_sequence WHERE name = 'checklist'
    ''');
    logger.i('Todos os checklists apagados');
    await _db.execute('''
      DELETE FROM item
    ''');
    await _db.execute('''
      DELETE FROM sqlite_sequence WHERE name = 'item'
    ''');
    logger.i('Todos os itens apagados');
    await _db.execute('''
      DELETE FROM checklistItem
    ''');
    dataChanged.value++;
    logger.i('Todos os checklistItens apagados');
  }
}
