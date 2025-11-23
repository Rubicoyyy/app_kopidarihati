import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart'; 
import '../providers/login_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _attemptLogin() async {
    setState(() { _isLoading = true; });

    final loginProvider = context.read<LoginProvider>();
    final success = await loginProvider.login(
      _usernameController.text,
      _passwordController.text,
    );

    if (mounted) {
      setState(() { _isLoading = false; });
      
      if (!success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(loginProvider.loginError),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch, 
            children: [
              const SizedBox(height: 40),
              Text(
                'Kopi Dari Hati',
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF6F4E37),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Silakan login untuk melanjutkan',
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 48),
              
              // Input Username
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              
              // Input Password
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 32),
              
              // Tombol Login
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _attemptLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6F4E37),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Login',
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
              
              const SizedBox(height: 24),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Belum punya akun? "),
                  InkWell( 
                    onTap: () {
                      print("Tombol Daftar ditekan!"); 
                      context.push('/register');
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0), 
                      child: Text(
                        "Daftar di sini",
                        style: TextStyle(
                          color: Color(0xFF6F4E37),
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline, 
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // --------------------------

              const SizedBox(height: 16),
              Text(
                'Hint: Coba "admin" / "123" ...',
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}