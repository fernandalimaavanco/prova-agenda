import 'package:flutter/material.dart';
import '../models/contact.dart';
import '../database/database_helper.dart';
import 'contact_form_screen.dart';

class ContactListScreen extends StatefulWidget {
  @override
  _ContactListScreenState createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  List<Contact> contacts = [];
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    await _dbHelper.database;
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    final loadedContacts = await _dbHelper.getContacts();
    setState(() {
      contacts = loadedContacts;
    });
  }

  void _addContact(Contact contact) async {
    await _dbHelper.insertContact(contact);
    _loadContacts();
  }

  void _editContact(int id, Contact contact) async {
    await _dbHelper.updateContact(id, contact);
    _loadContacts();
  }

  void _showDeleteMessage() {
    final snackBar = SnackBar(
      content: Text(
        'Contato deletado com sucesso!',
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.green,
      duration: Duration(seconds: 2),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _prepareDeleteContact(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color.fromARGB(255, 231, 211, 239),
        title: Row(
          children: [
            Icon(Icons.delete, color: Colors.red),
            SizedBox(width: 8),
            Text('Confirmar Exclusão'),
          ],
        ),
        content: Text('Você tem certeza que deseja excluir este contato?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              _deleteContact(id);
              Navigator.of(context).pop();
            },
            child: Text('Deletar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _deleteContact(int id) async {
    await _dbHelper.deleteContact(id);
    _loadContacts();
    _showDeleteMessage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Row(
          children: [
            Icon(Icons.contact_page, color: Colors.white),
            SizedBox(width: 8),
            Text('Lista de Contatos', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
      body: contacts.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.sentiment_dissatisfied,
                      size: 50, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Você ainda não possui contatos!',
                      style: TextStyle(fontSize: 18, color: Colors.grey)),
                ],
              ),
            )
          : ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: Icon(Icons.person, color: Colors.purple),
                    title: Text(contacts[index].name),
                    subtitle: Text(
                        '${contacts[index].phone}\n${contacts[index].email}'),
                    isThreeLine: true,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          color: Colors.purple,
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ContactFormScreen(
                                  contact: contacts[index],
                                  index: index,
                                  onEdit: _editContact,
                                ),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          color: Colors.red,
                          onPressed: () =>
                              _prepareDeleteContact(contacts[index].id!),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ContactFormScreen(
                onAdd: _addContact,
              ),
            ),
          );
        },
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.purple,
      ),
    );
  }
}
