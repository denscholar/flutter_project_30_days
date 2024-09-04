import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notelist/firebase_options.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  // Firebase

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
      ),
      body: FutureBuilder(
          future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          ),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return Column(
                  children: [
                    TextField(
                      enableSuggestions: false,
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress,
                      decoration:
                          const InputDecoration(hintText: 'Enter your email'),
                      controller: _emailController,
                    ),
                    TextField(
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: const InputDecoration(
                            hintText: "Enter your password"),
                        controller: _passwordController),
                    TextButton(
                      onPressed: () async {
                        final emailField = _emailController.text;
                        final passwordField = _passwordController.text;

                        try {
                          final userCredential = await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                            email: emailField,
                            password: passwordField,
                          );
                          print("Print here $userCredential");
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'email-already-in-use') {
                            print('Email already in use');
                          } else if (e.code == 'weak-password') {
                            print('The password provided is too weak.');
                          }
                        } catch (e) {
                          print(e);
                        }
                      },
                      child: const Text("Register"),
                    ),
                  ],
                );
              default:
                return const Text("Loading...");
            }
          }),
    );
  }
}
