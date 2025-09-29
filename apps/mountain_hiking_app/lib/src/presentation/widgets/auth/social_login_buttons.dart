
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mountain_hiking_app/src/business_logic/auth/auth_bloc.dart';

class SocialLoginButtons extends StatelessWidget {
  const SocialLoginButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              // In a real app, you would need to add the google_sign_in package
              // and configure it for each platform.
              context.read<AuthBloc>().add(LoginWithGoogleRequested());
            },
            // icon: Image.asset('assets/icon/google_logo.png', height: 24.0), // Requires asset setup
            icon: const Icon(Icons.g_mobiledata), // Placeholder icon
            label: const Text('Google'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
            ),
          ),
        ),
        
      ],
    );
  }
}
