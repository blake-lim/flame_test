import 'dart:ui';
import 'package:flame/components.dart';

class Pipe extends SpriteComponent {
  Pipe(
      {required Sprite sprite, // 파이프의 스프라이트 이미지
      required Vector2 position, // 파이프의 초기 위치
      required Vector2 size // 파이프의 크기
      })
      : super(sprite: sprite, position: position, size: size);

  @override
  Future<void> onLoad() async {
    super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    position.add(Vector2(-100 * dt, 0));

    if (position.x + size.x < 0) {
      removeFromParent();
    }
  }
}
