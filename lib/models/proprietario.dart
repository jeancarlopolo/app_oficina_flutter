// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Proprietario {
  int? id;
  String nome;
  String telefone;
  Proprietario({
    this.id,
    required this.nome,
    required this.telefone,
  });
  

  Proprietario copyWith({
    int? id,
    String? nome,
    String? telefone,
  }) {
    return Proprietario(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      telefone: telefone ?? this.telefone,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nome': nome,
      'telefone': telefone,
    };
  }

  factory Proprietario.fromMap(Map<String, dynamic> map) {
    return Proprietario(
      id: map['id'] != null ? map['id'] as int : null,
      nome: map['nome'] as String,
      telefone: map['telefone'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Proprietario.fromJson(String source) => Proprietario.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Proprietario(id: $id, nome: $nome, telefone: $telefone)';

  @override
  bool operator ==(covariant Proprietario other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.nome == nome &&
      other.telefone == telefone;
  }

  @override
  int get hashCode => id.hashCode ^ nome.hashCode ^ telefone.hashCode;
}
