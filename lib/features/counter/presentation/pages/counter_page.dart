import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:practice_app/features/counter/presentation/bloc/counter_bloc.dart';
import 'package:practice_app/features/counter/presentation/bloc/counter_event.dart';
import 'package:practice_app/features/counter/presentation/bloc/counter_state.dart';
import 'package:practice_app/features/counter/presentation/widgets/circular_icon_button.dart';
import 'package:practice_app/core/widgets/custom_button.dart';
import 'package:practice_app/core/widgets/display_text.dart';
import 'package:practice_app/injection_container.dart';

class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CounterBloc>()..add(GetCachedCountEvent()),
      child: CounterView(),
    );
  }
}

class CounterView extends StatelessWidget {
  final String _strCounter = 'Counter';
  final String _strInitialText = "Start searching !";
  final String _strRandomBtnText = "Get random counter";

  const CounterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => GoRouter.of(context).pop(),
        ),
        title: Text(_strCounter),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocBuilder<CounterBloc, CounterState>(
              builder: (context, state) {
                return _buildCounterText(state);
              },
            ),
            const SizedBox(height: 100),
            CustomButton(
              onPressed: () {
                context.read<CounterBloc>().add(GetCountEvent());
              },
              text: _strRandomBtnText,
            ),

            const SizedBox(height: 20),
            BlocBuilder<CounterBloc, CounterState>(
              builder: (context, state) {
                final count =
                    (state is CounterLoaded)
                        ? state.counter.count.toString()
                        : "";
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularIconButton(
                      onPressed: () {
                          context.read<CounterBloc>().add(
                            IncrementCountEvent(count: count),
                          );
                      },
                      icon: Icons.add,
                    ),
                    const SizedBox(width: 20),
                    CircularIconButton(
                      onPressed: () {
                        context.read<CounterBloc>().add(
                          DecrementCountEvent(count: count),
                        );
                      },
                      icon: Icons.remove,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCounterText(CounterState state) {
    switch (state) {
      case CounterEmpty():
        return DisplayText(text: _strInitialText);
      case CounterError():
        return DisplayText(text: state.message);
      case CounterLoading():
        return const CircularProgressIndicator(padding: EdgeInsets.all(7));
      case CounterLoaded():
        return DisplayText(text: state.counter.count.toString());
      default:
        return Container();
    }
  }
}
