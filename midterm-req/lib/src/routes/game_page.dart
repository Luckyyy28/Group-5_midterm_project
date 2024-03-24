import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:flutter_fruit_ninja/box.dart';
import 'package:flutter_fruit_ninja/src/components/back_button.dart';
import 'package:flutter_fruit_ninja/src/components/pause_button.dart';
import 'package:flutter_fruit_ninja/src/components/rectangle_test.dart';
import 'package:flutter_fruit_ninja/src/config/app_config.dart';
import 'package:flutter_fruit_ninja/src/game.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_fruit_ninja/src/routes/game_over_page.dart';

import '../components/fruit_component.dart';

class GamePage extends Component
    with DragCallbacks, HasGameReference<MainRouterGame> {
  final Random random = Random();
  late List<double> fruitsTime;
  late double time, countDown;
  TextComponent? _countdownTextComponent,
    _mistakeTextComponent,
    _scoreTextComponent
  ;
  bool _countdownFinished = false;
  late int mistakeCount, score;

  late AudioPlayer player;

  var highscore = hscore.get("highscore");

  ParallaxComponent? _bgimg;

  @override
  void onMount() async{
    super.onMount();

    player = AudioPlayer();
    player.play(AssetSource("bg_music.mp3"));
    player.setReleaseMode(ReleaseMode.loop);

    fruitsTime = [];
    countDown = 3;
    mistakeCount = 5;
    score = 0;
    time = 0;
    _countdownFinished = false;

    double initTime = 0;
    for (int i = 0; i < 100; i++) {
      if (i != 0) {
        initTime = fruitsTime.last;
      }
      final millySecondTime = random.nextInt(100) / 100;
      final componentTime = random.nextInt(1) + millySecondTime + initTime;
      fruitsTime.add(componentTime);
    }

    addAll([
      _bgimg = ParallaxComponent(
          parallax: Parallax(
              [await ParallaxLayer.load(ParallaxImageData('bg2.png'))])),
      BackButton(onPressed: () {
        removeAll(children);
        game.router.pop();
        player.pause();
      }),
      PauseButton(),
      _countdownTextComponent = TextComponent(
        text: '${countDown.toInt() + 1}',
        size: Vector2.all(50),
        position: game.size / 2,
        anchor: Anchor.center,
      ),
      _mistakeTextComponent = TextComponent(
        text: 'Life: $mistakeCount',
        // 10 is padding
        position: Vector2(game.size.x - 10, 10),
        anchor: Anchor.topRight,
      ),
      _scoreTextComponent = TextComponent(
        text: 'Score: $score',
        position: Vector2(game.size.x - 10,
            _mistakeTextComponent!.position.y + 40),
        anchor: Anchor.topRight,
      ),
    ]);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!_countdownFinished) {
      countDown -= dt;

      _countdownTextComponent?.text = (countDown.toInt() + 1).toString();
      if (countDown < 0) {
        _countdownFinished = true;
      }
    } else {
      _countdownTextComponent?.removeFromParent();

      time += dt;

      fruitsTime.where((element) => element < time).toList().forEach((element) {
        final gameSize = game.size;

        double posX = random.nextInt(gameSize.x.toInt()).toDouble();

        Vector2 fruitPosition = Vector2(posX, gameSize.y);
        Vector2 velocity = Vector2(0, game.maxVerticalVelocity);

        final randFruit = game.fruits.random();

        add(FruitComponent(
          this,
          fruitPosition,
          acceleration: AppConfig.acceleration,
          fruit: randFruit,
          size: Vector2(70, 70),
          image: game.images.fromCache(randFruit.image),
          pageSize: gameSize,
          velocity: velocity,
        ));
        fruitsTime.remove(element);
      });
    }
  }

  @override
  bool containsLocalPoint(Vector2 point) => true;

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);

    componentsAtPoint(event.canvasPosition).forEach((element) {
      if(element is FruitComponent){
        if(element.canDragOnShape){
          element.touchAtPoint(event.canvasPosition);
        }
      }
    });
  }

  void gameOver() {
    new_highscore();
    game.router.pushNamed("game-over");
    player.pause();
    _bgimg!.removeFromParent();
  }

  void addScore() {
    score++;
    _scoreTextComponent?.text = 'Score: $score';
  }

  void addMistake(){
    mistakeCount--;
    _mistakeTextComponent?.text = 'Life: $mistakeCount';
    if(mistakeCount == 0){
      gameOver();
    }
  }

  void new_highscore()async{
    if(highscore == null){
      hscore.put("highscore", score);
    }
    else if(highscore < score){
      //hscore.clear();
      hscore.put("highscore", score);
    }
  }
}
