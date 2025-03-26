import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:practice_app/core/widgets/custom_button.dart';
import 'package:practice_app/core/widgets/display_text.dart';
import 'package:practice_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:practice_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:practice_app/features/auth/presentation/bloc/auth_state.dart';
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
  final String _strWelcome = 'Incubyte COE App';
  final TextEditingController _controller = TextEditingController();

  _SignInViewState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_strWelcome)),
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
                  child: Text("Welcome!", style: TextStyle(fontSize: 24)),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Enter your email',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 50),
                CustomButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(
                      SignInEvent(email: _controller.text.toString()),
                    );
                  },
                  text: "Sign in",
                ),
                const SizedBox(height: 20),
                CustomButton(
                  onPressed: () {
                    GoRouter.of(context).push('/signup');
                  },
                  text: "New User? Sign Up",
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
