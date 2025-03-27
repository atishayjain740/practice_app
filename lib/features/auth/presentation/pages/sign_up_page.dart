import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:practice_app/core/constants/colors.dart';
import 'package:practice_app/core/validation/validate_email.dart';
import 'package:practice_app/core/validation/validate_name.dart';
import 'package:practice_app/core/widgets/custom_button.dart';
import 'package:practice_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:practice_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:practice_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:practice_app/features/auth/presentation/widgets/custom_text_form_field.dart';
import 'package:practice_app/injection_container.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => sl<AuthBloc>(),
      child: SignUpView(),
    );
  }
}

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignUpView> {
  final String _strSignUp = 'Sign Up';
  final String _strSignIn = 'Existing user? Sign In';
  final String _strFirstNameHintText = 'Enter your first name';
  final String _strLastNameHintText = 'Enter your last name';
  final String _strEmailHintText = 'Enter your email';
  final String _strLoading = 'Loading...';
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNamecontroller = TextEditingController();
  final TextEditingController _lastNamecontroller = TextEditingController();
  final TextEditingController _emailcontroller = TextEditingController();

  _SignInViewState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => GoRouter.of(context).pop(),
        ),
        title: Text(_strSignUp),
      ),
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
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextFormField(
                        controller: _firstNamecontroller,
                        hintText: _strFirstNameHintText,
                        validator: (value) {
                          return validateName(value!);
                        },
                      ),
                      CustomTextFormField(
                        controller: _lastNamecontroller,
                        hintText: _strLastNameHintText,
                        validator: (value) {
                          return validateName(value!);
                        },
                      ),
                      CustomTextFormField(
                        controller: _emailcontroller,
                        hintText: _strEmailHintText,
                        validator: (value) {
                          return validateEmail(value!);
                        },
                      ),
                    ],
                  ),
                ),

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
                        SignUpEvent(
                          firstName: _firstNamecontroller.text.toString(),
                          lastName: _lastNamecontroller.text.toString(),
                          email: _emailcontroller.text.toString(),
                        ),
                      );
                    }
                  },
                  text: _strSignUp,
                ),
                const SizedBox(height: 20),
                CustomButton(
                  onPressed: () {
                    GoRouter.of(context).pop();
                  },
                  text: _strSignIn,
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
