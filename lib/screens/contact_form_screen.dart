import 'package:flutter/material.dart';
import '../models/contact.dart';
import '../utils/validator.dart';
import '../utils/mask.dart';

class ContactFormScreen extends StatefulWidget {
  final Contact? contact;
  final int? index;
  final Function(Contact)? onAdd;
  final Function(int, Contact)? onEdit;

  ContactFormScreen({this.contact, this.index, this.onAdd, this.onEdit});

  @override
  _ContactFormScreenState createState() => _ContactFormScreenState();
}

class _ContactFormScreenState extends State<ContactFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.contact != null) {
      _nameController.text = widget.contact!.name;
      _phoneController.text = widget.contact!.phone;
      _emailController.text = widget.contact!.email;
    }
  }

  void _showSuccessMessage(text) {
    final snackBar = SnackBar(
      content: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.green,
      duration: Duration(seconds: 2),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _saveContact() {
    if (_formKey.currentState!.validate()) {
      final contact = Contact(
        name: _nameController.text,
        phone: _phoneController.text,
        email: _emailController.text,
      );

      if (widget.onAdd != null) {
        widget.onAdd!(contact);
        _showSuccessMessage('Contato salvo com sucesso!');
      } else if (widget.onEdit != null && widget.index != null) {
        widget.onEdit!(widget.contact!.id!, contact);
        _showSuccessMessage('Contato alterado com sucesso!');
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title:
              Text(widget.contact == null ? 'Novo Contato' : 'Editar Contato')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nome'),
                validator: Validator.validateName,
              ),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Telefone'),
                validator: Validator.validatePhone,
                keyboardType: TextInputType.phone,
                inputFormatters: [PhoneNumberInputFormatter()],
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'E-mail'),
                validator: Validator.validateEmail,
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveContact,
                child: Text('Salvar', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
