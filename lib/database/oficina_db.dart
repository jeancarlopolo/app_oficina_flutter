import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';

class OficinaDB {
  OficinaDB._();

  static final OficinaDB instance = OficinaDB._();

  late Database _db;

  Future<void> init() async {
    _db = await openDatabase('oficina.db', version: 1,
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
        FOREIGN KEY(proprietarioId) REFERENCES proprietario(id)
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
        id INTEGER PRIMARY KEY AUTOINCREMENT,
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
      await db.execute('''
      CREATE INDEX idx_carro_proprietarioId ON carro(proprietarioId);
    ''');
      await db.execute('''
      CREATE INDEX idx_checklist_placa ON checklist(placa);
    ''');
      
    });
  }

  Future<void> inserirProprietario(Map<String, dynamic> proprietario) async {
    await _db.insert('proprietario', proprietario);
    Logger().i('Proprietario {${proprietario['nome']}} inserido');
  }

  Future<void> inserirCarro(Map<String, dynamic> carro) async {
    await _db.insert('carro', carro);
    Logger().i('Carro {${carro['placa']}} inserido');
  }

  Future<void> inserirChecklist(Map<String, dynamic> checklist) async {
    await _db.insert('checklist', checklist);
    Logger().i('Checklist {${checklist['id']}} inserido');
  }

  Future<void> inserirItem(Map<String, dynamic> item) async {
    await _db.insert('item', item);
    Logger().i('Item {${item['nome']}} inserido');
  }

  Future<void> inserirChecklistItem(Map<String, dynamic> checklistItem) async {
    await _db.insert('checklistItem', checklistItem, conflictAlgorithm: ConflictAlgorithm.replace);
    Logger().i(
        'ChecklistItem {${checklistItem['checklistId']}, ${checklistItem['itemId']}} inserido');
  }

  Future<List<Map<String, dynamic>>> buscarProprietarios() async {
    return await _db.rawQuery('''
      SELECT * FROM proprietario
    ''');
  }

  Future<List<Map<String, dynamic>>> buscarCarros(int proprietarioId) async {
    return await _db.rawQuery('''
      SELECT * FROM carro WHERE proprietarioId = ?
    ''', [proprietarioId]);
  }

  Future<List<Map<String, dynamic>>> buscarChecklists(String placa) async {
    return await _db.rawQuery('''
      SELECT * FROM checklist WHERE placa = ?
    ''', [placa]);
  }

  Future<List<Map<String, dynamic>>> buscarItens() async {
    return await _db.rawQuery('''
      SELECT * FROM item
    ''');
  }

  Future<List<Map<String, dynamic>>> buscarChecklistItens(
      int checklistId) async {
    return await _db.rawQuery('''
      SELECT * FROM checklistItem WHERE checklistId = ?
    ''', [checklistId]);
  }

  Future<void> atualizarProprietario(Map<String, dynamic> proprietario) async {
    await _db.rawUpdate('''
      UPDATE proprietario SET nome = ?, telefone = ? WHERE id = ?
    ''', [proprietario['nome'], proprietario['telefone'], proprietario['id']]);
    Logger().i('Proprietario {${proprietario['nome']}} atualizado');
  }

  Future<void> atualizarCarro(Map<String, dynamic> carro) async {
    await _db.rawUpdate('''
      UPDATE carro SET modelo = ?, cor = ?, motorista = ?, proprietarioId = ? WHERE placa = ?
    ''', [
      carro['modelo'],
      carro['cor'],
      carro['motorista'],
      carro['proprietarioId'],
      carro['placa']
    ]);
    Logger().i('Carro {${carro['placa']}} atualizado');
  }

  Future<void> atualizarChecklist(Map<String, dynamic> checklist) async {
    await _db.rawUpdate('''
      UPDATE checklist SET dataHorario = ?, placa = ? WHERE id = ?
    ''', [checklist['dataHorario'], checklist['placa'], checklist['id']]);
    Logger().i('Checklist {${checklist['id']}} atualizado');
  }

  Future<void> atualizarItem(Map<String, dynamic> item) async {
    await _db.rawUpdate('''
      UPDATE item SET nome = ? WHERE id = ?
    ''', [item['nome'], item['id']]);
    Logger().i('Item {${item['nome']}} atualizado');
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
    Logger().i(
        'ChecklistItem {${checklistItem['checklistId']}, ${checklistItem['itemId']}} atualizado');
  }

  Future<void> apagarProprietario(int id) async {
    await _db.rawDelete('''
      DELETE FROM proprietario WHERE id = ?
    ''', [id]);
    Logger().i('Proprietario {id: $id} apagado');
  }

  Future<void> apagarCarro(String placa) async {
    await _db.rawDelete('''
      DELETE FROM carro WHERE placa = ?
    ''', [placa]);
    Logger().i('Carro {placa: $placa} apagado');
  }

  Future<void> apagarChecklist(int id) async {
    await _db.rawDelete('''
      DELETE FROM checklist WHERE id = ?
    ''', [id]);
    Logger().i('Checklist {id: $id} apagado');
  }

  Future<void> apagarItem(int id) async {
    await _db.rawDelete('''
      DELETE FROM item WHERE id = ?
    ''', [id]);
    Logger().i('Item {id: $id} apagado');
  }

  Future<void> apagarChecklistItem(int checklistId, int itemId) async {
    await _db.rawDelete('''
      DELETE FROM checklistItem WHERE checklistId = ? AND itemId = ?
    ''', [checklistId, itemId]);
    Logger().i(
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
    ORDER BY 'Quantidade de Problemas' DESC;
    ''');
    String relatorio = 'Carros mais necessitados:\n';
    for (var carro in carros) {
      relatorio +=
          '${carro['Dono']} - ${carro['Placa do Carro']} - ${carro['Quantidade de Problemas']} problemas\n';
    }
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
    ORDER BY 'Quantidade de Carros' DESC;
    ''');
    String relatorio = 'Proprietarios com mais carros:\n';
    for (var proprietario in proprietarios) {
      relatorio +=
          '${proprietario['Dono']} - ${proprietario['Quantidade de Carros']} carros\n';
    }
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
      var dias =
          (carro['Tempo Desde Última Checklist (segundos)'] / 86400).floor();
      var horas =
          ((carro['Tempo Desde Última Checklist (segundos)'] % 86400) / 3600)
              .floor();
      var minutos =
          ((carro['Tempo Desde Última Checklist (segundos)'] % 3600) / 60)
              .floor();
      relatorio +=
          '${carro['Nome do Dono']} - ${carro['Placa do Carro']} - ${carro['Tempo Desde Última Checklist (segundos)']} segundos ($dias dias, $horas horas, $minutos minutos)\n';
    }
    return relatorio;
  }

  Future<void> apagarTudo() async {
    await _db.execute('''
      DELETE FROM proprietario
    ''');
    Logger().i('Todos os proprietarios apagados');
    await _db.execute('''
      DELETE FROM carro
    ''');
    Logger().i('Todos os carros apagados');
    await _db.execute('''
      DELETE FROM checklist
    ''');
    Logger().i('Todos os checklists apagados');
    await _db.execute('''
      DELETE FROM item
    ''');
    Logger().i('Todos os itens apagados');
    await _db.execute('''
      DELETE FROM checklistItem
    ''');
    Logger().i('Todos os checklistItens apagados');
  }
}
