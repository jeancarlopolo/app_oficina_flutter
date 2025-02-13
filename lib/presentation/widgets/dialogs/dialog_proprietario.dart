import 'package:flutter/material.dart';
import 'package:oficina/models/proprietario.dart';

class ProprietarioDialog extends StatefulWidget {
  final Proprietario? proprietario;

  const ProprietarioDialog({super.key, this.proprietario});

  @override
  State<ProprietarioDialog> createState() => _ProprietarioDialogState();
}

class _ProprietarioDialogState extends State<ProprietarioDialog> {
  final _formKey = GlobalKey<FormState>();
  late String _nome;
  late String _telefone;

  @override
  void initState() {
    super.initState();
    // Inicializa os valores com o proprietário existente ou padrões
    _nome = widget.proprietario?.nome ?? '';
    _telefone = widget.proprietario?.telefone ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.proprietario == null
          ? 'Novo Proprietário'
          : 'Editar Proprietário'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                initialValue: _nome,
                decoration: const InputDecoration(labelText: 'Nome*'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nome obrigatório';
                  }
                  return null;
                },
                onSaved: (value) => _nome = value!,
              ),
              TextFormField(
                initialValue: _telefone,
                decoration: const InputDecoration(labelText: 'Telefone'),
                onSaved: (value) => _telefone = value ?? '',
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
              final novoProprietario = Proprietario(
                nome: _nome,
                telefone: _telefone,
              );
              Navigator.of(context).pop(novoProprietario);
            }
          },
        ),
      ],
    );
  }
}
