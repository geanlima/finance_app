import 'package:flutter/material.dart';
import 'package:finance_app/data/database/database_helper.dart';
import 'package:finance_app/models/group.dart';

class GroupPage extends StatefulWidget {
  @override
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  List<Group>? _groups = [];
  TextEditingController _groupNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadGroups();
  }

  _loadGroups() async {
    List<Group>? groups = await DatabaseHelper.instance.loadGroups();
    setState(() {
      _groups = groups;
    });
  }

  void _addNewGroup() async {
    String? groupName = _groupNameController.text;
    if (groupName != null && groupName.isNotEmpty) {
      Group newGroup = Group(name: groupName);
      await DatabaseHelper.instance.addGroup(newGroup);
      Navigator.of(context).pop(true);
    }
  }

  Future<void> _showEditGroupDialog(Group group) async {
    final _formKey = GlobalKey<FormState>();
    String? _groupName = group.name;

    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Editar Grupo'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  initialValue: _groupName ?? '',
                  decoration: InputDecoration(labelText: 'Nome do Grupo'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o nome do grupo';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _groupName = value;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: Text('Salvar'),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();

                  group.name = _groupName!;
                  await DatabaseHelper.instance.updateGroup(group);
                  _loadGroups();
                  Navigator.of(dialogContext).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteGroup(Group group) async {
    await DatabaseHelper.instance.deleteGroup(group.id!);
    _loadGroups();
  }

  Future<void> _showDeleteConfirmation(Group group) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Excluir Grupo'),
          content: Text(
              'Você tem certeza que deseja excluir o grupo "${group.name}"?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: Text('Excluir'),
              onPressed: () {
                _deleteGroup(group);
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Groups'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _groupNameController,
                    decoration: InputDecoration(
                      hintText: 'Digite o nome do grupo...',
                      border: UnderlineInputBorder(),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _addNewGroup,
                ),
              ],
            ),
          ),
          Expanded(
            child: (_groups == null || _groups!.isEmpty)
                ? Center(child: Text('Sem grupos para exibir'))
                : ListView.builder(
                    itemCount: _groups!.length,
                    itemBuilder: (context, index) {
                      final group = _groups![index];
                      return ListTile(
                        title: Text(group.name),
                        trailing: Wrap(
                          spacing: 12,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                _showEditGroupDialog(group);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                _showDeleteConfirmation(group);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
