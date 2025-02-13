import 'package:flutter/material.dart';
import 'package:oficina/models/carro.dart';

class CarroDialog extends StatefulWidget {
  final Carro? carro;
  final int proprietarioId;

  const CarroDialog({
    super.key,
    this.carro,
    required this.proprietarioId,
  });

  @override
  State<CarroDialog> createState() => _CarroDialogState();
}

class _CarroDialogState extends State<CarroDialog> {
  final _formKey = GlobalKey<FormState>();
  late String _placa;
  late String _modelo;
  late String _cor;
  late String _motorista;
  late String _marca;
  late int _ano;
  late int _quilometragem;

  @override
  void initState() {
    super.initState();
    // Inicializa os valores com o carro existente ou padrões
    _placa = widget.carro?.placa ?? '';
    _modelo = widget.carro?.modelo ?? '';
    _cor = widget.carro?.cor ?? Cor.branca.nome;
    _marca = widget.carro?.marca ?? '';
    _ano = widget.carro?.ano ?? DateTime.now().year;
    _quilometragem = widget.carro?.quilometragem ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.carro == null ? 'Novo Carro' : 'Editar Carro'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                initialValue: _placa,
                decoration: const InputDecoration(labelText: 'Placa*'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Placa obrigatória';
                  }
                  return null;
                },
                onSaved: (value) => _placa = value!,
              ),
              TextFormField(
                initialValue: _modelo,
                decoration: const InputDecoration(labelText: 'Modelo'),
                onSaved: (value) => _modelo = value!,
              ),
              DropdownButtonFormField<String>(
                value: _cor,
                decoration: const InputDecoration(labelText: 'Cor'),
                items: Cor.values.map((Cor cor) {
                  return DropdownMenuItem<String>(
                    value: cor.nome,
                    child: Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: cor.decoration,
                        ),
                        const SizedBox(width: 10),
                        Text(cor.nome),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _cor = value!),
              ),
              TextFormField(
                initialValue: _motorista,
                decoration: const InputDecoration(labelText: 'Motorista'),
                onSaved: (value) => _motorista = value!,
              ),
              TextFormField(
                initialValue: _marca,
                decoration: const InputDecoration(labelText: 'Marca'),
                onSaved: (value) => _marca = value!,
              ),
              TextFormField(
                initialValue: _ano.toString(),
                decoration: const InputDecoration(labelText: 'Ano'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _ano = int.parse(value!),
              ),
              TextFormField(
                initialValue: _quilometragem.toString(),
                decoration: const InputDecoration(labelText: 'Quilometragem'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _quilometragem = int.parse(value!),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancelar'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: const Text('Salvar'),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              final novoCarro = {
                'placa': _placa,
                'modelo': _modelo,
                'cor': _cor,
                'proprietarioId': widget.proprietarioId,
                'motorista': _motorista,
                'ano': _ano,
                'marca': _marca,
                'quilometragem': _quilometragem,
              };
              Navigator.of(context).pop(novoCarro);
            }
          },
        ),
      ],
    );
  }
}