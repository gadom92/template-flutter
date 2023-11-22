import 'package:flutter/material.dart';
import 'package:gitpod_flutter_quickstart/welcome.dart';
import 'endgame.dart'; // Dodajemy import do pliku endgame.dart

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kółko i krzyżyk',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey,
        primarySwatch: Colors.grey,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/game': (context) => const TicTacToeScreen(),
      },
    );
  }
}

class TicTacToeScreen extends StatefulWidget {
  const TicTacToeScreen({Key? key}) : super(key: key);

  @override
  _TicTacToeScreenState createState() => _TicTacToeScreenState();
}

class _TicTacToeScreenState extends State<TicTacToeScreen> {
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
    // Sprawdzanie wierszy i kolumn
    for (int i = 0; i < 3; i++) {
      if (gameBoard[i][0] == gameBoard[i][1] &&
          gameBoard[i][1] == gameBoard[i][2] &&
          gameBoard[i][0].isNotEmpty) {
        setWinner(gameBoard[i][0]);
        return;
      }
      if (gameBoard[0][i] == gameBoard[1][i] &&
          gameBoard[1][i] == gameBoard[2][i] &&
          gameBoard[0][i].isNotEmpty) {
        setWinner(gameBoard[0][i]);
        return;
      }
    }

    // Sprawdzanie przekątnych
    if (gameBoard[0][0] == gameBoard[1][1] &&
        gameBoard[1][1] == gameBoard[2][2] &&
        gameBoard[0][0].isNotEmpty) {
      setWinner(gameBoard[0][0]);
      return;
    }
    if (gameBoard[0][2] == gameBoard[1][1] &&
        gameBoard[1][1] == gameBoard[2][0] &&
        gameBoard[0][2].isNotEmpty) {
      setWinner(gameBoard[0][2]);
      return;
    }

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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => EndGameScreen(winner: winner)),
      );
    });
  }

  Widget buildSymbol(int row, int col) {
    String symbol = gameBoard[row][col];
    Color symbolColor = symbol == 'X' ? Colors.red : Colors.orange;

    return InkWell(
      onTap: () => makeMove(row, col),
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color:
              (row + col) % 2 == 0 ? Colors.white : Colors.grey, // Szachownica
          border: Border.all(color: Colors.black),
        ),
        child: Center(
          child: Text(
            symbol,
            style: TextStyle(fontSize: 48, color: symbolColor),
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

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        elevation: 0.0,
        title: const Center(
          child: Text(
            'KÓŁKO I KRZYŻYK',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Tura gracza: ${isPlayer1Turn ? 'X' : 'O'}',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: buildGameBoard(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
