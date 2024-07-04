import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';
import 'package:project_protestas/models/user.dart';
import 'package:project_protestas/services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();

  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _photoController = TextEditingController();
  final _roleController = TextEditingController();
  final _cedulaController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? _rol;

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _photoController.dispose();
    _roleController.dispose();
    _cedulaController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade300, Colors.purple.shade300],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const Text(
                      'Volver',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Icon(
                            Icons.app_registration,
                            size: 80,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Registro de Usuario',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 32),
                          _buildTextFormField(
                            controller: _nameController,
                            label: 'Nombre',
                            icon: Icons.person,
                            validator: (value) => value == null || value.isEmpty ? 'Por favor ingrese su nombre' : null,
                          ),
                          _buildTextFormField(
                            controller: _lastNameController,
                            label: 'Apellido',
                            icon: Icons.person,
                            validator: (value) => value == null || value.isEmpty ? 'Por favor ingrese su apellido' : null,
                          ),
                          _buildTextFormField(
                            controller: _photoController,
                            label: 'Foto (URL)',
                            icon: Icons.photo,
                            validator: (value) => value == null || value.isEmpty ? 'Por favor ingrese la URL de su foto' : null,
                          ),
                          _buildDropdownButtonFormField(
                            controller: _roleController,
                            label: 'Rol',
                            value: _rol,
                            items: ['Usuario Normal', 'admin'],
                            onChanged: (value) {
                              setState(() {
                                _rol = value;
                                _roleController.text = value!;
                              });
                            },
                            validator: (value) => value == null || value.isEmpty ? 'Por favor ingrese su rol' : null,
                          ),
                          _buildTextFormField(
                            controller: _cedulaController,
                            label: 'Cédula',
                            icon: Icons.credit_card,
                            inputFormatters: [MaskedInputFormatter('###-#######-#')],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese su cédula';
                              }
                              if (!RegExp(r'^\d{3}-\d{7}-\d$').hasMatch(value)) {
                                return 'Formato de cédula inválido';
                              }
                              return null;
                            },
                          ),
                          _buildTextFormField(
                            controller: _phoneController,
                            label: 'Teléfono',
                            icon: Icons.phone,
                            inputFormatters: [MaskedInputFormatter('(###)-###-####')],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese su teléfono';
                              }
                              if (!RegExp(r'^\(\d{3}\)-\d{3}-\d{4}$').hasMatch(value)) {
                                return 'Formato de teléfono inválido';
                              }
                              return null;
                            },
                          ),
                          _buildTextFormField(
                            controller: _addressController,
                            label: 'Dirección',
                            icon: Icons.home,
                            validator: (value) => value == null || value.isEmpty ? 'Por favor ingrese su dirección' : null,
                          ),
                          _buildTextFormField(
                            controller: _emailController,
                            label: 'Correo electrónico',
                            icon: Icons.email,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese su correo electrónico';
                              }
                              if (!RegExp(r'^[\w\-.]+@([\w\-]+\.)+[\w\-]{2,4}$').hasMatch(value)) {
                                return 'Correo electrónico inválido';
                              }
                              return null;
                            },
                          ),
                          _buildTextFormField(
                            controller: _passwordController,
                            label: 'Contraseña',
                            icon: Icons.lock,
                            obscureText: true,
                            validator: (value) => value == null || value.isEmpty ? 'Por favor ingrese su contraseña' : null,
                          ),
                          _buildTextFormField(
                            controller: _confirmPasswordController,
                            label: 'Confirmar contraseña',
                            icon: Icons.lock,
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor confirme su contraseña';
                              }
                              if (value != _passwordController.text) {
                                return 'Las contraseñas no coinciden';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 32),
                          ElevatedButton(
                            onPressed: _register,
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.blue.shade700, backgroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16.0),
                              textStyle: const TextStyle(fontSize: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Registrar'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.white70),
          labelStyle: const TextStyle(color: Colors.white70),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white70),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(12),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red.shade200),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red.shade200),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        style: const TextStyle(color: Colors.white),
        obscureText: obscureText,
        inputFormatters: inputFormatters,
        validator: validator,
      ),
    );
  }

  Widget _buildDropdownButtonFormField({
    required TextEditingController controller,
    required String label,
    required String? value,
    required List<String> items,
    required void Function(String?)? onChanged,
    required String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.work, color: Colors.white70),
          labelStyle: const TextStyle(color: Colors.white70),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white70),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        dropdownColor: Colors.blue.shade700,
        style: const TextStyle(color: Colors.white),
        value: value,
        items: items.map((label) => DropdownMenuItem(
          value: label,
          child: Text(label),
        )).toList(),
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }

  void _register() async {
    if (_formKey.currentState!.validate()) {
      final newUser = User(
        name: _nameController.text,
        lastName: _lastNameController.text,
        photo: _photoController.text,
        role: _roleController.text,
        cedula: _cedulaController.text,
        phone: _phoneController.text,
        address: _addressController.text,
        email: _emailController.text,
        password: _passwordController.text,
      );

      final success = await _authService.register(newUser);

      if (success) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Registro exitoso'),
            content: const Text('Usuario agregado a la base de datos'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al registrar usuario')),
        );
      }
    }
  }
}