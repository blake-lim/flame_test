import 'package:collection/collection.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame_test/components/bird.dart';
import 'package:flame_test/components/pipe.dart';
import 'package:flutter/material.dart';
import 'dart:math';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(GameWidget(game: MyGame()));
}

class MyGame extends FlameGame with TapDetector {
  late final SpriteComponent background1;
  late final SpriteComponent background2;
  late Timer _timer;
  final Random random = Random();
  bool _isGameOver = false;
  final TextPaint _gameOverTextPaint = TextPaint(
    style: const TextStyle(
      color: Colors.red,
      fontSize: 48,
      fontWeight: FontWeight.w700,
    ),
  );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    await Flame.images.loadAll(['bg.png', 'pipe_up.png', 'pipe_down.png']);
    background1 = SpriteComponent(
      sprite: Sprite(await Flame.images.load('bg.png')),
      size: size,
    );
    add(background1);

    background2 = SpriteComponent(
      sprite: Sprite(await Flame.images.load('bg.png')),
      size: size,
      position: Vector2(size.x, 0),
    );
    add(background2);

    add(Bird());

    _timer = Timer(2, repeat: true, onTick: () {
      if (!_isGameOver) {
        addPipe();
      }
    });
    _timer.start();
  }

  void addPipe() async {
    print("Adding new pipes");
    double gapSize = 150.0;
    double gapStart = random.nextDouble() * (size.y - gapSize - 200.0) + 100.0;

    final pipeUpSprite = Sprite(await Flame.images.load('pipe_up.png'));
    final pipeDownSprite = Sprite(await Flame.images.load('pipe_down.png'));

    final pipeUp = Pipe(
      sprite: pipeUpSprite,
      position: Vector2(size.x, gapStart - 320),
      size: Vector2(52.0, 320.0),
    );
    add(pipeUp);

    final pipeDown = Pipe(
      sprite: pipeDownSprite,
      position: Vector2(size.x, gapStart + gapSize),
      size: Vector2(52.0, 320.0),
    );
    add(pipeDown);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!_isGameOver) {
      _timer.update(dt);
    }

    background1.position.x -= 50 * dt;
    background2.position.x -= 50 * dt;

    if (background1.position.x <= -size.x) {
      background1.position.x = background2.position.x + size.x;
    }
    if (background2.position.x <= -size.x) {
      background2.position.x = background1.position.x + size.x;
    }

    final bird =
        children.firstWhereOrNull((component) => component is Bird) as Bird?;

    if (bird != null && !_isGameOver) {
      children.whereType<Pipe>().forEach((pipe) {
        if (bird.toRect().overlaps(pipe.toRect())) {
          _isGameOver = true;
        }
      });
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (_isGameOver) {
      final gameOverTextPaint = TextPaint(
        style: const TextStyle(
            color: Colors.red, fontSize: 48.0, fontWeight: FontWeight.w700),
      );
      gameOverTextPaint.render(
          canvas, "Game Over", Vector2(size.x / 2 - 100, size.y / 2));
    }
  }

  @override
  void onTapDown(TapDownInfo event) {
    if (!_isGameOver) {
      super.onTapDown(event);
      final bird = children
          .toList()
          .firstWhereOrNull((component) => component is Bird) as Bird?;
      bird?.jump();
    }
  }
}
