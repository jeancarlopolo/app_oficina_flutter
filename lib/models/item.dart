// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Item {
  int id;
  String nome;
  Item({
    required this.id,
    required this.nome,
  });

  Item copyWith({
    int? id,
    String? nome,
  }) {
    return Item(
      id: id ?? this.id,
      nome: nome ?? this.nome,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nome': nome,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'] as int,
      nome: map['nome'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Item.fromJson(String source) => Item.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Item(id: $id, nome: $nome)';

  @override
  bool operator ==(covariant Item other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.nome == nome;
  }

  @override
  int get hashCode => id.hashCode ^ nome.hashCode;
}
