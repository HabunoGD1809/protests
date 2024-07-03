import 'package:flutter/material.dart';
import 'package:project_protestas/models/user.dart';
import 'package:project_protestas/models/protest.dart';
import 'package:project_protestas/services/protest_service.dart';
import 'package:project_protestas/screens/protest_form_screen.dart';
import 'package:project_protestas/screens/user_management_screen.dart';
import 'package:project_protestas/widgets/custom_nav_bar.dart';
import 'package:project_protestas/widgets/protest_card.dart';

class HomeScreen extends StatefulWidget {
  final User user;

  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProtestService _protestService = ProtestService();
  List<Protest> _protests = [];

  @override
  void initState() {
    super.initState();
    _loadProtests();
  }

  void _loadProtests() async {
    if (widget.user.role == 'admin') {
      _protests = await _protestService.getAllProtests();
    } else {
      _protests = await _protestService.getProtestsByUser(widget.user.id!);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
        actions: [
          if (widget.user.role == 'admin')
            IconButton(
              icon: const Icon(Icons.manage_accounts),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserManagementScreen()),
                );
              },
            ),
        ],
      ),
      body: ListView.builder(
        itemCount: _protests.length,
        itemBuilder: (context, index) {
          return ProtestCard(
            protest: _protests[index],
            onEdit: widget.user.role == 'admin' || _protests[index].userId == widget.user.id
                ? () => _editProtest(_protests[index])
                : null,
            onDelete: widget.user.role == 'admin'
                ? () => _deleteProtest(_protests[index])
                : null,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addProtest,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: CustomNavBar(
        currentIndex: 0,
        onTap: (index) {
          // Implementar la navegación a otras pantallas si es necesario
        },
      ),
    );
  }

  void _addProtest() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProtestFormScreen(userId: widget.user.id!)),
    );

    if (result == true) {
      _loadProtests();
    }
  }

  void _editProtest(Protest protest) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProtestFormScreen(
          userId: protest.userId, // Asegúrate de pasar el userId aquí
          protest: protest,
        ),
      ),
    );

    if (result == true) {
      _loadProtests();
    }
  }

  void _deleteProtest(Protest protest) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: const Text('¿Está seguro de que desea eliminar esta protesta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final success = await _protestService.deleteProtest(protest.uuid);
      if (success) {
        _loadProtests();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al eliminar la protesta')),
        );
      }
    }
  }
}