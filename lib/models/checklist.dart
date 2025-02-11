// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Checklist {
  int id;
  DateTime dataHorario;
  String placa;
  Checklist({
    required this.id,
    required this.dataHorario,
    required this.placa,
  });

  Checklist copyWith({
    int? id,
    DateTime? dataHorario,
    String? placa,
  }) {
    return Checklist(
      id: id ?? this.id,
      dataHorario: dataHorario ?? this.dataHorario,
      placa: placa ?? this.placa,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'dataHorario': dataHorario.millisecondsSinceEpoch / 1000 as int,
      'placa': placa,
    };
  }

  factory Checklist.fromMap(Map<String, dynamic> map) {
    return Checklist(
      id: map['id'] as int,
      dataHorario: DateTime.fromMillisecondsSinceEpoch(map['dataHorario'] * 1000 as int),
      placa: map['placa'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Checklist.fromJson(String source) => Checklist.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Checklist(id: $id, dataHorario: $dataHorario, placa: $placa)';

  @override
  bool operator ==(covariant Checklist other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.dataHorario == dataHorario &&
      other.placa == placa;
  }

  @override
  int get hashCode => id.hashCode ^ dataHorario.hashCode ^ placa.hashCode;
}
