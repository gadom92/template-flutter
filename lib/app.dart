import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gitpod_flutter_quickstart/welcome.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

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
  TicTacToeScreenState createState() => TicTacToeScreenState();
}

class TicTacToeScreenState extends State<TicTacToeScreen> {
  late final BannerAd myBanner;
  bool isBannerLoaded = false;
  late List<List<String>> gameBoard;
  late bool isPlayer1Turn;
  late bool gameEnded;
  late String? winner;

  late FutureOr<void> bannerAdFuture;

  @override
  void initState() {
    super.initState();
    bannerAdFuture = initializeBannerAd();
    startNewGame();
  }

  FutureOr<void> initializeBannerAd() async {
    myBanner = BannerAd(
      adUnitId: 'YOUR_BANNER_AD_UNIT_ID',
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            isBannerLoaded = true;
          });
        },
      ),
    );

    await myBanner.load();
  }

  @override
  void dispose() {
    myBanner.dispose();
    super.dispose();
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
      // Tutaj zdecyduj, co chcesz zrobić po zakończeniu gry
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

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      elevation: 0.0,
      title: const Center(
        child: Text(
          'Kółko i krzyżyk',
          style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
        ),
      ),
    ),
    backgroundColor: Colors.grey,
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: FutureBuilder<void>(
        future: bannerAdFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: [
                Text(
                  'Tura gracza: ${isPlayer1Turn ? 'X' : 'O'}',
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      int row = index ~/ 3;
                      int col = index % 3;
                      return buildSymbol(row, col);
                    },
                    itemCount: 9,
                  ),
                ),
                const SizedBox(height: 16),
                if (isBannerLoaded)
                  AdWidget(ad: myBanner), // Wyświetlenie reklamy, jeśli jest załadowana
              ],
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); 
          } else {
            return const Text('Coś poszło nie tak.');
          }
        },
      ),
    ),
  );
}

}
