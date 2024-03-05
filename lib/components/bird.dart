import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';

const double birdWidth = 52.0;
const double birdHeight = 36.7;
const int amountOfFrames = 3;
const String textureFile = 'bird.png';

class Bird extends SpriteAnimationComponent {
  double velocityY = 0.0; // 수직 속도
  double velocityX = 5.0; // 수평 속도 추가
  final double gravity = 900.0; // 중력 값

  Bird() : super(size: Vector2(birdWidth, birdHeight));

  @override
  Future<void> onLoad() async {
    super.onLoad();
    animation = await SpriteAnimation.load(
      textureFile,
      SpriteAnimationData.sequenced(
        amount: amountOfFrames,
        stepTime: 0.1,
        textureSize: Vector2(17, 12),
      ),
    );
    anchor = Anchor.center;
  }

  @override
  void update(double dt) {
    super.update(dt);

    // 중력 적용하여 수직 위치 업데이트
    velocityY += gravity * dt;
    y += velocityY * dt;

    // 수평 속도 적용하여 수평 위치 업데이트
    x += velocityX * dt;

    // 화면 바닥에 도달했는지 체크
    if (parent != null && y > (parent as FlameGame).size.y) {
      y = (parent as FlameGame).size.y;
      velocityY = 0.0; // 바닥에 닿으면 수직 속도를 리셋
    }
  }

  void jump() {
    velocityY = -350.0; // 위로 튀어오르는 속도
  }
}
