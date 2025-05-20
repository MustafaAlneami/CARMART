import 'package:carmart/core/components/custom_button.dart';
import 'package:carmart/core/components/custom_text.dart';
import 'package:carmart/core/components/custom_text_field.dart';
import 'package:carmart/core/components/snack.dart';
import 'package:carmart/features/home/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLogin = true;

  Future<void> _authenticate() async {
    try {
      if (isLogin) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        Snack().success(context, "User Logged in Successfully");
      } else {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        Snack().success(context, "User Created in Successfully");
      }

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (c) => HomePage()),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      resizeToAvoidBottomInset: true, // ensures keyboard pushing works
      appBar: AppBar(
        backgroundColor: Colors.grey.shade300,
        toolbarHeight: 0,
        elevation: 0,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      const SizedBox(height: 80),
                      const Icon(CupertinoIcons.lock, size: 100),
                      const SizedBox(height: 30),
                      CustomTextField(
                        controller: _emailController,
                        hint: 'Email',
                        type: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: _passwordController,
                        hint: 'Password',
                        type: TextInputType.visiblePassword,
                      ),
                      const SizedBox(height: 20),
                      CustomButton(
                        onTap: _authenticate,
                        width: double.infinity,
                        height: 40,
                        color: Colors.black87,
                        radius: 8,
                        child: Center(
                          child: CustomText(
                            text: isLogin ? "🔓 Login" : "📝 Register",
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => setState(() => isLogin = !isLogin),
                        child: CustomText(
                          text: isLogin
                              ? " Create new account"
                              : " Already have an account? Login",
                          color: Colors.black,
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
