import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';

/* Bird의 기본 크기와 애니메이션 프레임 설정 */
const double birdWidth = 52.0;
const double birdHeight = 36.7;
const int amountOfFrames = 3;
const String textureFile = 'bird.png';

class Bird extends SpriteAnimationComponent {
  double velocityY = 0.0; // Bird의 수직 속도 초기값
  double velocityX = 5.0; // Bird의 수평 속도 추가
  final double gravity = 900.0; // 게임 내 중력 값

/* Bird 클래스 생성자, Bird의 크기를 설정 */
  Bird() : super(size: Vector2(birdWidth, birdHeight));

  @override
  Future<void> onLoad() async {
    super.onLoad();
    /* Bird의 애니메이션 로드 */
    animation = await SpriteAnimation.load(
      textureFile,
      SpriteAnimationData.sequenced(
        amount: amountOfFrames, // 애니메이션 프레임 수
        stepTime: 0.1, // 각 프레임이 지속되는 시간
        textureSize: Vector2(17, 12), // 각 프레임의 텍스처 크기
      ),
    );
    anchor = Anchor.center; // 애니메이션의 앵커 포인트를 중앙으로 설정
  }

  @override
  void update(double dt) {
    super.update(dt);

    /* 중력의 영향을 받아 수직 속도와 위치 업데이트 */
    velocityY += gravity * dt;
    y += velocityY * dt;

    /* 설정된 수평 속도를 적용하여 수평 위치 업데이트 */
    x += velocityX * dt;

    /*  Bird가 화면 바닥에 도달했는지 체크 */
    if (parent != null && y > (parent as FlameGame).size.y) {
      y = (parent as FlameGame).size.y; // 화면 바닥에 위치 고정
      velocityY = 0.0; // 바닥에 닿으면 수직 속도 리셋
    }
  }

  /* Bird가 점프할 때 호출되는 함수 */
  void jump() {
    velocityY = -350.0; // 위로 튀어오르는 속도 설정
  }
}
