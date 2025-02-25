import 'package:flutter/material.dart';

class EndGameScreen extends StatelessWidget {
  final String? winner;

  const EndGameScreen({
    super.key,
    required this.winner,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        elevation: 0.0,
        title: const Center(
          child: Text(
            'Koniec gry',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Koniec gry!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (winner == '')
              const Text(
                'Remis!',
                style: TextStyle(fontSize: 20),
              ),
            if (winner != null && winner != '')
              Column(
                children: [
                  const Text(
                    'Zwycięzca:',
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    winner!,
                    style: const TextStyle(
                        fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/game');
              },
              child: const Text('Nowa gra'),
            ),
          ],
        ),
      ),
    );
  }
}
