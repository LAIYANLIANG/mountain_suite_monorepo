
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mountain_hiking_app/src/business_logic/auth/auth_bloc.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _accountNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _nameController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _agreedToTerms = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _accountNameController.dispose();
    _phoneNumberController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if ((_formKey.currentState?.validate() ?? false) && _agreedToTerms) {
      context.read<AuthBloc>().add(
            RegisterRequested(
              email: _emailController.text,
              password: _passwordController.text,
              accountName: _accountNameController.text.isEmpty ? null : _accountNameController.text,
              phoneNumber: _phoneNumberController.text.isEmpty ? null : _phoneNumberController.text,
              name: _nameController.text.isEmpty ? null : _nameController.text,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: '電子郵件', border: OutlineInputBorder(), prefixIcon: Icon(Icons.email)),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) return '請輸入電子郵件';
              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) return '請輸入有效的電子郵件地址';
              return null;
            },
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: '密碼',
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: IconButton(
                icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
              ),
            ),
            obscureText: !_isPasswordVisible,
            validator: (value) {
              if (value == null || value.isEmpty) return '請輸入密碼';
              if (value.length < 8 || value.length > 20) return '密碼長度需介於 8 到 20 個字元';
              if (!value.contains(RegExp(r'[a-zA-Z]'))) return '密碼需包含至少一個英文字母';
              if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) return '密碼需包含至少一個特殊符號';
              return null;
            },
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: _confirmPasswordController,
            decoration: InputDecoration(
              labelText: '確認密碼',
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: IconButton(
                icon: Icon(_isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off),
                onPressed: () => setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
              ),
            ),
            obscureText: !_isConfirmPasswordVisible,
            validator: (value) {
              if (value != _passwordController.text) return '兩次輸入的密碼不一致';
              return null;
            },
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: _accountNameController,
            decoration: const InputDecoration(labelText: '帳號名 (選填)', border: OutlineInputBorder(), prefixIcon: Icon(Icons.person)),
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: _phoneNumberController,
            decoration: const InputDecoration(labelText: '電話號碼 (選填)', border: OutlineInputBorder(), prefixIcon: Icon(Icons.phone)),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: '姓名/暱稱 (選填)', border: OutlineInputBorder(), prefixIcon: Icon(Icons.badge)),
          ),
          const SizedBox(height: 16.0),
          Row(
            children: [
              Checkbox(value: _agreedToTerms, onChanged: (value) => setState(() => _agreedToTerms = value ?? false)),
              const Expanded(child: Text('我已閱讀並同意服務條款與隱私權政策', style: TextStyle(fontSize: 13.0))),
            ],
          ),
          const SizedBox(height: 16.0),
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              return ElevatedButton(
                onPressed: (state is AuthLoading || !_agreedToTerms) ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                ),
                child: state is AuthLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('註冊', style: TextStyle(fontSize: 18.0)),
              );
            },
          ),
        ],
      ),
    );
  }
}
