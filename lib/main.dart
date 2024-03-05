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
  // 게임 내 사용될 주요 변수 선언
  late final SpriteComponent background1;
  late final SpriteComponent background2;
  late Timer _timer;
  final Random random = Random();
  bool _isGameOver = false;
  final TextPaint _gameOverTextPaint = TextPaint(
      style: const TextStyle(
    color: Colors.white,
    fontSize: 48,
  ));

  @override
  Future<void> onLoad() async {
    super.onLoad();
    await Flame.images.loadAll(['bg.png', 'pipe_up.png', 'pipe_down.png']);
    // 배경 이미지 로드 및 추가
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

    /*  2초마다 파이프 추가를 위한 타이머 설정 */
    _timer = Timer(2, repeat: true, onTick: () {
      if (!_isGameOver) {
        addPipe();
      }
    });
    _timer.start();
  }

/* 파이프를 생성하고 게임 월드에 추가하는 메서드 */
  void addPipe() async {
    double gapSize = 150.0; // 파이프 사이 간격
    double gapStart = random.nextDouble() * (size.y - gapSize - 200.0) + 100.0;

    /* 상단 파이프 생성 및 추가 */
    final pipeUpSprite = Sprite(await Flame.images.load('pipe_up.png'));
    final pipeDownSprite = Sprite(await Flame.images.load('pipe_down.png'));

    final pipeUp = Pipe(
      sprite: pipeUpSprite,
      position: Vector2(size.x, gapStart - 320),
      size: Vector2(52.0, 320.0),
    );
    add(pipeUp);

    /* 하단 파이프 생성 및 추가 */
    final pipeDown = Pipe(
      sprite: pipeDownSprite,
      position: Vector2(size.x, gapStart + gapSize),
      size: Vector2(52.0, 320.0),
    );
    add(pipeDown);
  }

/* 게임의 상태를 업데이트하는 메서드 */
  @override
  void update(double dt) {
    super.update(dt);
    /* 게임 오버가 아니면 타이머 업데이트 */
    if (!_isGameOver) {
      _timer.update(dt);
    }

    /* 배경 이동 로직 */
    background1.position.x -= 70 * dt;
    background2.position.x -= 70 * dt;

    /* 배경 재배치 로직 */
    if (background1.position.x <= -size.x) {
      background1.position.x = background2.position.x + size.x;
    }
    if (background2.position.x <= -size.x) {
      background2.position.x = background1.position.x + size.x;
    }

    /* Bird와 파이프의 충돌 검사 */
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

  /* 게임 화면을 그리는 메서드 */
  @override
  void render(Canvas canvas) {
    super.render(canvas);
    /* 게임 오버 시 텍스트 표시 */
    if (_isGameOver) {
      final gameOverTextPaint = TextPaint(
        style: const TextStyle(
            color: Colors.red, fontSize: 48.0, fontWeight: FontWeight.w700),
      );
      gameOverTextPaint.render(
          canvas, "Game Over", Vector2(size.x / 2 - 100, size.y / 2));
    }
  }

/* 사용자의 탭 이벤트를 처리하는 메서드 */
  @override
  void onTapDown(TapDownInfo event) {
    /* 게임 오버 상태가 아닐 때만 새를 점프시킴 */
    if (!_isGameOver) {
      super.onTapDown(event);
      final bird = children
          .toList()
          .firstWhereOrNull((component) => component is Bird) as Bird?;
      bird?.jump();
    }
  }
}
