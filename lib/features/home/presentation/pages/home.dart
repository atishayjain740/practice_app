import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:practice_app/features/home/presentation/widget/custom_card.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomCard(title: "Counter", onPressed: () => GoRouter.of(context).push('/counter')),
            SizedBox(height: 20),
            CustomCard(title: "Weather", onPressed: () => GoRouter.of(context).push('/weather')),
          ],
        ),
      ),
    );
  }

  
}