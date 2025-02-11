// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Carro {
  String placa;
  String modelo;
  String cor;
  int proprietarioId;
  String motorista;
  int ano;
  String marca;
  int quilometragem;
  Carro({
    required this.placa,
    required this.modelo,
    required this.cor,
    required this.proprietarioId,
    required this.motorista,
    required this.ano,
    required this.marca,
    required this.quilometragem,
  });


  Carro copyWith({
    String? placa,
    String? modelo,
    String? cor,
    int? proprietarioId,
    String? motorista,
    int? ano,
    String? marca,
    int? quilometragem,
  }) {
    return Carro(
      placa: placa ?? this.placa,
      modelo: modelo ?? this.modelo,
      cor: cor ?? this.cor,
      proprietarioId: proprietarioId ?? this.proprietarioId,
      motorista: motorista ?? this.motorista,
      ano: ano ?? this.ano,
      marca: marca ?? this.marca,
      quilometragem: quilometragem ?? this.quilometragem,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'placa': placa,
      'modelo': modelo,
      'cor': cor,
      'proprietarioId': proprietarioId,
      'motorista': motorista,
      'ano': ano,
      'marca': marca,
      'quilometragem': quilometragem,
    };
  }

  factory Carro.fromMap(Map<String, dynamic> map) {
    return Carro(
      placa: map['placa'] as String,
      modelo: map['modelo'] as String,
      cor: map['cor'] as String,
      proprietarioId: map['proprietarioId'] as int,
      motorista: map['motorista'] as String,
      ano: map['ano'] as int,
      marca: map['marca'] as String,
      quilometragem: map['quilometragem'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Carro.fromJson(String source) => Carro.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Carro(placa: $placa, modelo: $modelo, cor: $cor, proprietarioId: $proprietarioId, motorista: $motorista, ano: $ano, marca: $marca, quilometragem: $quilometragem)';
  }

  @override
  bool operator ==(covariant Carro other) {
    if (identical(this, other)) return true;
  
    return 
      other.placa == placa &&
      other.modelo == modelo &&
      other.cor == cor &&
      other.proprietarioId == proprietarioId &&
      other.motorista == motorista &&
      other.ano == ano &&
      other.marca == marca &&
      other.quilometragem == quilometragem;
  }

  @override
  int get hashCode {
    return placa.hashCode ^
      modelo.hashCode ^
      cor.hashCode ^
      proprietarioId.hashCode ^
      motorista.hashCode ^
      ano.hashCode ^
      marca.hashCode ^
      quilometragem.hashCode;
  }
}
