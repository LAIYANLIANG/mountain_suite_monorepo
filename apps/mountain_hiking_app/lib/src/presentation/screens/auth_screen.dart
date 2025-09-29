
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mountain_hiking_app/src/business_logic/auth/auth_bloc.dart';
import 'package:mountain_hiking_app/src/presentation/widgets/auth/login_form.dart';
import 'package:mountain_hiking_app/src/presentation/widgets/auth/register_form.dart';
import 'package:mountain_hiking_app/src/presentation/widgets/auth/social_login_buttons.dart';
import 'package:mountain_hiking_app/src/widgets/language_selection_dialog.dart';
import 'package:mountain_hiking_app/src/presentation/widgets/main_scaffold.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: MainScaffold(
        appBar: AppBar(
          title: const Text('會員管理'),
          bottom: const TabBar(
            tabs: [
              Tab(text: '登入'),
              Tab(text: '註冊'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.language),
              onPressed: () {
                showLanguageSelectionDialog(context);
              },
            ),
          ],
        ),
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthAuthenticated) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('登入成功: ${state.userId}')),
              );
              Navigator.of(context).pop(); // Go back to the previous screen
            } else if (state is LoginFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('登入失敗: ${state.error}')),
              );
            } else if (state is RegisterSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('註冊成功! 請檢查您的電子郵件進行驗證。')),
              );
              // Consider switching to the login tab automatically
            } else if (state is RegisterFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('註冊失敗: ${state.error}')),
              );
            }
            // ... other state listeners for password reset etc.
          },
          child: const TabBarView(
            children: [
              _AuthFormContainer(child: LoginForm()),
              _AuthFormContainer(child: RegisterForm()),
            ],
          ),
        ),
      ),
    );
  }
}

// A helper widget to provide common layout and social login buttons
class _AuthFormContainer extends StatelessWidget {
  final Widget child;
  const _AuthFormContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          child, // This will be either LoginForm or RegisterForm
          const SizedBox(height: 16.0),
          if (child is LoginForm) ...[
            TextButton(
              onPressed: () { /* TODO: Implement Forgot Password Dialog */ },
              child: const Text('忘記密碼？'),
            ),
          ],
          const Divider(height: 32.0),
          const Text('或使用第三方帳號登入', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 16.0),
          const SocialLoginButtons(),
          const SizedBox(height: 16.0),
          // TODO: Implement Biometric Login Button
        ],
      ),
    );
  }
}
