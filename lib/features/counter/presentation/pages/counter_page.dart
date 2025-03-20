import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practice_app/features/counter/presentation/bloc/counter_bloc.dart';
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
  String _count = "";

  CounterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Counter")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocBuilder<CounterBloc, CounterState>(
              builder: (context, state) {
                if (state is CounterEmpty) {
                  return Text(
                    "Start searching",
                    style: TextStyle(fontSize: 25),
                  );
                } else if (state is CounterError) {
                  return Text(state.message, style: TextStyle(fontSize: 25));
                } else if (state is CounterLoading) {
                  return CircularProgressIndicator();
                } else if (state is CounterLoaded) {
                  _count = state.counter.count.toString();
                  return Text(_count, style: TextStyle(fontSize: 25));
                }
                return Container();
              },
            ),
            const SizedBox(height: 100),
            ElevatedButton(
              onPressed: () {
                context.read<CounterBloc>().add(GetCountEvent());
              },
              child: Text("Get random counter"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.read<CounterBloc>().add(
                  IncrementCountEvent(count: _count),
                );
              },
              child: Text("Increment count"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.read<CounterBloc>().add(
                  DecrementCountEvent(count: _count),
                );
              },
              child: Text("Decrement count"),
            ),
          ],
        ),
      ),
    );
  }
}
