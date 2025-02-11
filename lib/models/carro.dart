// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Carro {
  String placa;
  String modelo;
  String cor;
  int proprietarioId;
  String motorista;
  Carro({
    required this.placa,
    required this.modelo,
    required this.cor,
    required this.proprietarioId,
    required this.motorista,
  });
  

  Carro copyWith({
    String? placa,
    String? modelo,
    String? cor,
    int? proprietarioId,
    String? motorista,
  }) {
    return Carro(
      placa: placa ?? this.placa,
      modelo: modelo ?? this.modelo,
      cor: cor ?? this.cor,
      proprietarioId: proprietarioId ?? this.proprietarioId,
      motorista: motorista ?? this.motorista,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'placa': placa,
      'modelo': modelo,
      'cor': cor,
      'proprietarioId': proprietarioId,
      'motorista': motorista,
    };
  }

  factory Carro.fromMap(Map<String, dynamic> map) {
    return Carro(
      placa: map['placa'] as String,
      modelo: map['modelo'] as String,
      cor: map['cor'] as String,
      proprietarioId: map['proprietarioId'] as int,
      motorista: map['motorista'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Carro.fromJson(String source) => Carro.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Carro(placa: $placa, modelo: $modelo, cor: $cor, proprietarioId: $proprietarioId, motorista: $motorista)';
  }

  @override
  bool operator ==(covariant Carro other) {
    if (identical(this, other)) return true;
  
    return 
      other.placa == placa &&
      other.modelo == modelo &&
      other.cor == cor &&
      other.proprietarioId == proprietarioId &&
      other.motorista == motorista;
  }

  @override
  int get hashCode {
    return placa.hashCode ^
      modelo.hashCode ^
      cor.hashCode ^
      proprietarioId.hashCode ^
      motorista.hashCode;
  }
}
