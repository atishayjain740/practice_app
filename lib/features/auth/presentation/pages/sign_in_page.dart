import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:practice_app/core/constants/colors.dart';
import 'package:practice_app/core/validation/validate_email.dart';
import 'package:practice_app/core/widgets/custom_button.dart';
import 'package:practice_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:practice_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:practice_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:practice_app/core/widgets/custom_text_form_field.dart';
import 'package:practice_app/injection_container.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => sl<AuthBloc>(),
      child: SignInView(),
    );
  }
}

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final String _strAppBarText = 'Incubyte COE App';
  final String _strWelcomeText = 'Welcome!';
  final String _strEmailHintText = 'Enter your email';
  final String _strSignIn = 'Sign In';
  final String _strSignUp = 'New user? Sign Up';
  final String _strLoading = 'Loading...';
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();

  _SignInViewState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_strAppBarText)),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthLoaded) {
              GoRouter.of(context).go('/');
            }
          },
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(_strWelcomeText, style: TextStyle(fontSize: 24)),
                ),
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: CustomTextFormField(
                    controller: _controller,
                    hintText: _strEmailHintText,
                    validator: (value) {
                      return validateEmail(value!);
                    },
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  height: 20,
                  child: BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return _buildAuthData(state);
                    },
                  ),
                ),
                const SizedBox(height: 10),
                CustomButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      context.read<AuthBloc>().add(
                        SignInEvent(email: _controller.text.toString()),
                      );
                    }
                  },
                  text: _strSignIn,
                ),
                const SizedBox(height: 20),
                CustomButton(
                  onPressed: () {
                    GoRouter.of(context).push('/signup');
                  },
                  text: _strSignUp,
                ),
                
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAuthData(AuthState state) {
    switch (state) {
      case AuthError():
        return Align(
          alignment: Alignment.centerLeft,
          child: Text(
            state.message,
            style: TextStyle(fontSize: 14, color: red),
          ),
        );
      case AuthLoading():
        return Align(
          alignment: Alignment.centerLeft,
          child: Text(_strLoading, style: TextStyle(fontSize: 14, color: red)),
        );
      default:
        return Container();
    }
  }
}
