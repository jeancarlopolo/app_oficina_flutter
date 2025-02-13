// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';

enum Cor {
  amarelo(decoration: BoxDecoration(color: Color(0xFFFFEB3B)), nome: 'Amarelo'),
  azul(decoration: BoxDecoration(color: Color(0xFF2196F3)), nome: 'Azul'),
  bege(decoration: BoxDecoration(color: Color(0xFFF5F5DC)), nome: 'Bege'),
  branca(decoration: BoxDecoration(color: Color(0xFFFFFFFF)), nome: 'Branca'),
  cinza(decoration: BoxDecoration(color: Color(0xFF9E9E9E)), nome: 'Cinza'),
  dourada(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Color(0xFFFFF176),
          Color(0xFFFFD700),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    nome: 'Dourada',
  ),
  grena(decoration: BoxDecoration(color: Color(0xFF800000)), nome: 'Grená'),
  laranja(decoration: BoxDecoration(color: Color(0xFFFF9800)), nome: 'Laranja'),
  marrom(decoration: BoxDecoration(color: Color(0xFF795548)), nome: 'Marrom'),
  prata(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Color(0xFFE0E0E0),
          Color(0xFFC0C0C0),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    nome: 'Prata',
  ),
  preta(decoration: BoxDecoration(color: Color(0xFF000000)), nome: 'Preta'),
  rosa(decoration: BoxDecoration(color: Color(0xFFFFC0CB)), nome: 'Rosa'),
  roxa(decoration: BoxDecoration(color: Color(0xFF9C27B0)), nome: 'Roxa'),
  verde(decoration: BoxDecoration(color: Color(0xFF4CAF50)), nome: 'Verde'),
  vermelha(
      decoration: BoxDecoration(color: Color(0xFFF44336)), nome: 'Vermelha'),
  fantasia(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Colors.red,
          Colors.orange,
          Colors.yellow,
          Colors.green,
          Colors.blue,
          Colors.indigo,
          Colors.purple,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    nome: 'Fantasia',
  );

  final BoxDecoration decoration;
  final String nome;

  const Cor({required this.decoration, required this.nome});

  static Cor getCor (String nome) {
    for (final cor in Cor.values) {
      if (cor.nome.toUpperCase() == nome.toUpperCase()) {
        return cor;
      }
    }
    return Cor.branca;
  }

  Color get textColor {
    if (decoration.color != null) {
      return decoration.color!.computeLuminance() > 0.5 ? Colors.black : Colors.white;
    } else {
      final colors = (this as Gradient).colors;
      final averageLuminance = colors
          .map((color) => color.computeLuminance())
          .reduce((a, b) => a + b) / colors.length;
      return averageLuminance > 0.5 ? Colors.black : Colors.white;
    }
  }
}

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

  factory Carro.fromJson(String source) =>
      Carro.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Carro(placa: $placa, modelo: $modelo, cor: $cor, proprietarioId: $proprietarioId, motorista: $motorista, ano: $ano, marca: $marca, quilometragem: $quilometragem)';
  }

  @override
  bool operator ==(covariant Carro other) {
    if (identical(this, other)) return true;

    return other.placa == placa &&
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
