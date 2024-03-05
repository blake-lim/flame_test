import 'dart:ui';

import 'package:flame/components.dart';

class Pipe extends SpriteComponent {
  Pipe(
      {required Sprite sprite,
      required Vector2 position,
      required Vector2 size})
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
