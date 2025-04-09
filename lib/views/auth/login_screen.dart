import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../viewmodels/auth_provider.dart';

class LoginScreen extends HookWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final formKey = GlobalKey<FormState>();
    final isLoading = useState(false);
    final authProvider = context.read<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Entrar'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              Center(
                child: Text(
                  'iFood',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 5.0,
                        color: Colors.black.withOpacity(0.1),
                        offset: const Offset(1.0, 1.0),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 48),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu e-mail';
                  }
                  if (!value.contains('@')) {
                    return 'E-mail inválido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Senha',
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira sua senha';
                  }
                  if (value.length < 6) {
                    return 'A senha deve ter pelo menos 6 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // Implementar recuperação de senha
                  },
                  child: const Text('Esqueceu a senha?'),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: isLoading.value
                    ? null
                    : () async {
                        if (formKey.currentState!.validate()) {
                          isLoading.value = true;
                          try {
                            final success = await authProvider.login(
                              emailController.text,
                              passwordController.text,
                            );
                            
                            if (success && context.mounted) {
                              context.go('/');
                            }
                          } finally {
                            isLoading.value = false;
                          }
                        }
                      },
                child: isLoading.value
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Entrar'),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Ainda não tem conta?'),
                  TextButton(
                    onPressed: () {
                      context.push('/register');
                    },
                    child: const Text('Cadastre-se'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
} 