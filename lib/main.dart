import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tic_tac_toe/DRAW_ANIMATION.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic-Tac-Toe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0D0D1A),
        fontFamily: "Poppins",
      ),
      home: const TicTacToeGame(),
    );
  }
}

class TicTacToeGame extends StatefulWidget {
  const TicTacToeGame({super.key});

  @override
  State<TicTacToeGame> createState() => _TicTacToeGameState();
}

class _TicTacToeGameState extends State<TicTacToeGame> {
  late List<String> _board;
  late String _currentPlayer;
  late String _winner;
  late bool _isDraw;
  List<int> _winningLine = [];

  int _scoreX = 0;
  int _scoreO = 0;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    setState(() {
      _board = List.filled(9, '');
      _currentPlayer = 'X';
      _winner = '';
      _isDraw = false;
      _winningLine = [];
    });
  }

  void _handleTap(int index) {
    if (_winner.isNotEmpty || _isDraw || _board[index].isNotEmpty) return;

    setState(() {
      _board[index] = _currentPlayer;
      _checkWinner();
      if (_winner.isEmpty) {
        _checkDraw();
        if (!_isDraw) {
          _currentPlayer = _currentPlayer == 'X' ? 'O' : 'X';
        }
      }
    });
  }

  void _checkWinner() {
    const winningLines = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var line in winningLines) {
      String player = _board[line[0]];
      if (player.isNotEmpty &&
          player == _board[line[1]] &&
          player == _board[line[2]]) {
        setState(() {
          _winner = player;
          _winningLine = line;
          if (_winner == 'X') {
            _scoreX++;
          } else {
            _scoreO++;
          }
        });
        return;
      }
    }
  }

  void _checkDraw() {
    if (!_board.contains('')) {
      setState(() {
        _isDraw = true;
      });
    }
  }

  Widget _buildStatusMessage() {
    String message;
    if (_winner.isNotEmpty) {
      message = '🏆 Player $_winner Wins!';
    } else if (_isDraw) {
      message = '🤝 It\'s a Draw!';
    } else {
      message = '🎮 Player $_currentPlayer\'s Turn';
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder:
          (child, anim) => FadeTransition(opacity: anim, child: child),
      child: Text(
        message,
        key: ValueKey(message),
        style: const TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildGrid() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color.fromARGB(255, 35, 52, 96),
            Color.fromARGB(255, 46, 110, 188),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(115, 204, 204, 204),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 9,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          final isWinningCell = _winningLine.contains(index);
          return GestureDetector(
            onTap: () => _handleTap(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              decoration: BoxDecoration(
                gradient:
                    isWinningCell
                        ? const LinearGradient(
                          colors: [Colors.greenAccent, Colors.teal],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                        : const LinearGradient(
                          colors: [Color(0xFF1A1A40), Color(0xFF1A1A2E)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                borderRadius: BorderRadius.circular(15),
                boxShadow:
                    isWinningCell
                        ? [
                          BoxShadow(
                            color: Colors.greenAccent.withOpacity(0.6),
                            blurRadius: 12,
                            spreadRadius: 3,
                          ),
                        ]
                        : [
                          const BoxShadow(
                            color: Colors.black54,
                            blurRadius: 6,
                            offset: Offset(2, 2),
                          ),
                        ],
              ),
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder:
                      (child, anim) =>
                          ScaleTransition(scale: anim, child: child),
                  child: Text(
                    _board[index],
                    key: ValueKey(_board[index]),
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color:
                          _board[index] == 'X'
                              ? const Color(0xFFE94560)
                              : const Color(0xFF53BF9D),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildScoreBoard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white24, width: 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _scoreTile("Player X", _scoreX, Colors.redAccent),
              _scoreTile("Player O", _scoreO, Colors.greenAccent),
            ],
          ),
        ),
      ),
    );
  }

  Widget _scoreTile(String label, int score, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          "$score",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  void _resetScores() {
    setState(() {
      _scoreX = 0;
      _scoreO = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('✨ Tic-Tac-Toe', style: TextStyle(fontSize: 25)),
                    const SizedBox(height: 10),
                    _buildScoreBoard(),
                    const SizedBox(height: 30),
                    _buildStatusMessage(),
                    const SizedBox(height: 30),
                    _buildGrid(),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Restart Button
                        ElevatedButton.icon(
                          icon: const Icon(Icons.play_arrow, size: 22),
                          label: const Text(
                            '🎮 Restart',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: _initializeGame,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                            backgroundColor: const Color(0xFF0F3460),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                12,
                              ), // squared style
                            ),
                            elevation: 4,
                            shadowColor: Colors.black45,
                          ),
                        ),

                        const SizedBox(width: 20),

                        // Reset Scores Button
                        ElevatedButton.icon(
                          icon: const Icon(Icons.refresh, size: 22),
                          label: const Text(
                            'Reset Scores',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: _resetScores,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                            backgroundColor: Colors.redAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                12,
                              ), // squared style
                            ),
                            elevation: 4,
                            shadowColor: Colors.black45,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // 🎉 Winner Overlay
            if (_winner.isNotEmpty) ...[
              // Full-screen glass effect
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.zero,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Container(
                      color: Colors.white.withOpacity(0.1),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.zero,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // Lottie animation
                        SizedBox(
                          height: 360,
                          width: 360,
                          child: Lottie.asset(
                            "assets/animations/win.json",
                            repeat: false,
                          ),
                        ),
                        // Winner text with glow effect
                        AnimatedScale(
                          scale: 1.0,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.elasticOut,
                          child: Text(
                            _winner,
                            style: TextStyle(
                              fontSize: 72,
                              fontWeight: FontWeight.bold,
                              color: Colors.amberAccent,
                              shadows: [
                                Shadow(
                                  blurRadius: 25,
                                  color: Colors.amber.withOpacity(0.8),
                                  offset: const Offset(0, 0),
                                ),
                                Shadow(
                                  blurRadius: 15,
                                  color: Colors.black45,
                                  offset: const Offset(2, 2),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    // Play again button with nicer style
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        backgroundColor: Colors.amberAccent,
                        foregroundColor: Colors.black87,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: _initializeGame,
                      child: const Text(
                        "Play Again",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            if (_isDraw) ...[
              // Full-screen glass effect
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.zero,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Container(
                      color: Colors.white.withOpacity(0.1),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.zero,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Lottie animation
                    SizedBox(
                      height: 250,
                      width: 250,
                      child: DrawTextDottedAnimation(),
                    ),
                    const SizedBox(height: 30),
                    // Draw text with glow
                    AnimatedScale(
                      scale: 1.0,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.elasticOut,
                      child: Text(
                        '🤝 It\'s a Draw!',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.amberAccent,
                          shadows: [
                            Shadow(
                              blurRadius: 20,
                              color: Colors.amber.withOpacity(0.8),
                              offset: const Offset(0, 0),
                            ),
                            Shadow(
                              blurRadius: 15,
                              color: Colors.black45,
                              offset: const Offset(2, 2),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Play Again button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        backgroundColor: Colors.amberAccent,
                        foregroundColor: Colors.black87,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: _initializeGame,
                      child: const Text(
                        "Play Again",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
