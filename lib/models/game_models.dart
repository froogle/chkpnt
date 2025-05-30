enum GameStatus { playing, completed, backlog, abandoned }

class GameItem {
  final String title;
  final String platform;
  final GameStatus status;
  final double progress;

  const GameItem({
    required this.title,
    required this.platform,
    required this.status,
    required this.progress,
  });
}
