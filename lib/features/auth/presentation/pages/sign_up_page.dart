import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:practice_app/core/widgets/custom_button.dart';
import 'package:practice_app/core/widgets/display_text.dart';
import 'package:practice_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:practice_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:practice_app/features/auth/presentation/bloc/auth_state.dart';
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
  final String _strWelcome = 'Sign Up';
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
        title: Text(_strWelcome),
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 100,
                  child: Align(
                    alignment: Alignment.center,
                    child: TextFormField(controller: _firstNamecontroller),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 100,
                  child: Align(
                    alignment: Alignment.center,
                    child: TextFormField(controller: _lastNamecontroller),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 100,
                  child: Align(
                    alignment: Alignment.center,
                    child: TextFormField(controller: _emailcontroller),
                  ),
                ),
                const SizedBox(height: 50),
                CustomButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(
                      SignUpEvent(
                        firstName: _firstNamecontroller.text.toString(),
                        lastName: _lastNamecontroller.text.toString(),
                        email: _emailcontroller.text.toString(),
                      ),
                    );
                  },
                  text: "Sign Up",
                ),
                const SizedBox(height: 50),
                CustomButton(
                  onPressed: () {
                    GoRouter.of(context).pop();
                  },
                  text: "Existing User? Sign In",
                ),
                const SizedBox(height: 50),
                SizedBox(
                  height: 200,
                  child: Align(
                    alignment: Alignment.center,
                    child: BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        return _buildAuthData(state);
                      },
                    ),
                  ),
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
      case AuthInitail():
        return DisplayText(text: "");
      case AuthError():
        return DisplayText(text: state.message);
      case AuthLoading():
        return SizedBox(
          height: 50,
          width: 50,
          child: Align(
            alignment: Alignment.center,
            child: const CircularProgressIndicator(),
          ),
        );
      case AuthLoaded():
        return DisplayText(
          text:
              "${state.user.firstName} ${state.user.lastName} ${state.user.email}",
        );
      default:
        return Container();
    }
  }
}
