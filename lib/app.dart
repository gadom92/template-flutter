import 'package:flutter/material.dart';
import 'welcome.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kółko i krzyżyk',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/game', // Zmiana na ekran gry jako ekran startowy
      routes: {
        '/': (context) =>  WelcomeScreen(),
        '/game': (context) => const TicTacToeScreen(),
      },
    );
  }
}

class TicTacToeScreen extends StatefulWidget {
  const TicTacToeScreen({Key? key}) : super(key: key);

  @override
  TicTacToeScreenState createState() => TicTacToeScreenState();
}

class TicTacToeScreenState extends State<TicTacToeScreen> {
  late List<List<String>> gameBoard;
  late bool isPlayer1Turn;
  late bool gameEnded;
  late String? winner;

  @override
  void initState() {
    super.initState();
    startNewGame();
  }

  void startNewGame() {
    setState(() {
      gameBoard = List.generate(3, (_) => List.filled(3, ''));
      isPlayer1Turn = true;
      gameEnded = false;
      winner = null;
    });
  }

  void makeMove(int row, int col) {
    if (gameEnded || gameBoard[row][col].isNotEmpty) return;

    setState(() {
      gameBoard[row][col] = isPlayer1Turn ? 'X' : 'O';
      isPlayer1Turn = !isPlayer1Turn;
      checkForWin();
    });
  }

  void checkForWin() {
    // Logika sprawdzania zwycięstwa - ta część jest taka sama jak wcześniej
    // ...

    // Sprawdzanie remisu
    bool isDraw = true;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (gameBoard[i][j].isEmpty) {
          isDraw = false;
          break;
        }
      }
    }

    if (isDraw) {
      setWinner('');
    }
  }

  void setWinner(String? symbol) {
    setState(() {
      gameEnded = true;
      winner = symbol;
    });
  }

  Widget buildSymbol(int row, int col) {
    String symbol = gameBoard[row][col];
    return InkWell(
      onTap: () => makeMove(row, col),
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
        ),
        child: Center(
          child: Text(
            symbol,
            style: const TextStyle(fontSize: 48),
          ),
        ),
      ),
    );
  }

  Widget buildGameBoard() {
    return Column(
      children: [
        for (int i = 0; i < 3; i++)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int j = 0; j < 3; j++) ...[
                buildSymbol(i, j),
                if (j < 2)
                  const VerticalDivider(
                    color: Colors.black,
                    width: 2,
                  ),
              ],
            ],
          ),
      ],
    );
  }

  Widget buildGameResult() {
    if (winner == '') {
      return const Text(
        'Remis!',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      );
    } else if (winner != null) {
      return Column(
        children: [
          const Text(
            'Zwycięzca:',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            winner!,
            style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
          ),
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kółko i krzyżyk'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Tura gracza: ${isPlayer1Turn ? 'X' : 'O'}',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 16),
            buildGameBoard(),
            const SizedBox(height: 16),
            if (gameEnded) buildGameResult(),
            if (gameEnded)
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(
                      context, '/game'); // Zaczynamy nową grę
                  startNewGame(); // Resetujemy stan gry
                },
                child: const Text('Nowa gra'),
              ),
          ],
        ),
      ),
    );
  }
}
