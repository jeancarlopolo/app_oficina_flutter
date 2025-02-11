// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ChecklistItem {
  int checklistId;
  int itemId;
  bool precisaReparo;
  bool precisaTrocar;
  String observacao;
  ChecklistItem({
    required this.checklistId,
    required this.itemId,
    required this.precisaReparo,
    required this.precisaTrocar,
    required this.observacao,
  });

  ChecklistItem copyWith({
    int? checklistId,
    int? itemId,
    bool? precisaReparo,
    bool? precisaTrocar,
    String? observacao,
  }) {
    return ChecklistItem(
      checklistId: checklistId ?? this.checklistId,
      itemId: itemId ?? this.itemId,
      precisaReparo: precisaReparo ?? this.precisaReparo,
      precisaTrocar: precisaTrocar ?? this.precisaTrocar,
      observacao: observacao ?? this.observacao,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'checklistId': checklistId,
      'itemId': itemId,
      'precisaReparo': precisaReparo,
      'precisaTrocar': precisaTrocar,
      'observacao': observacao,
    };
  }

  factory ChecklistItem.fromMap(Map<String, dynamic> map) {
    return ChecklistItem(
      checklistId: map['checklistId'] as int,
      itemId: map['itemId'] as int,
      precisaReparo: map['precisaReparo'] as bool,
      precisaTrocar: map['precisaTrocar'] as bool,
      observacao: map['observacao'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChecklistItem.fromJson(String source) => ChecklistItem.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ChecklistItem(checklistId: $checklistId, itemId: $itemId, precisaReparo: $precisaReparo, precisaTrocar: $precisaTrocar, observacao: $observacao)';
  }

  @override
  bool operator ==(covariant ChecklistItem other) {
    if (identical(this, other)) return true;
  
    return 
      other.checklistId == checklistId &&
      other.itemId == itemId &&
      other.precisaReparo == precisaReparo &&
      other.precisaTrocar == precisaTrocar &&
      other.observacao == observacao;
  }

  @override
  int get hashCode {
    return checklistId.hashCode ^
      itemId.hashCode ^
      precisaReparo.hashCode ^
      precisaTrocar.hashCode ^
      observacao.hashCode;
  }
}
