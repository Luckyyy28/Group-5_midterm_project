
import 'package:audioplayers/audioplayers.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fruit_ninja/box.dart';
import 'package:flutter_fruit_ninja/src/game.dart';
import 'package:flutter_fruit_ninja/src/routes/game_page.dart';

import '../components/rounded_button.dart';


class HomePage extends Component with HasGameReference<MainRouterGame>{
  late RoundedButton _button1;
  // ParallaxComponent? _title;

  //TextComponent? _textComponent;

  // late int? get_highscore;
  // late int highscore = 0;

  final block = SpriteComponent.fromImage(Flame.images.fromCache("title.png"),
    position: Vector2(300, 80),
    size: Vector2(200, 150), 
  );

  @override
  void onLoad() async{
    // get_highscore = hscore.get("highscore");
    // super.onLoad();
    // if(get_highscore != null){
    //   highscore = get_highscore!;
    // }
    addAll([
      _button1 = RoundedButton(
        text: "Start",
        onPressed: () {
          game.router.pushNamed("game-page");
        },
        color: Colors.blue,
        borderColor: Colors.white,
      ),
      block,

      // _textComponent = TextComponent(
      //   text: "High Score: $highscore",
      //   position: Vector2(40, 40),
      // ),
    ]);
  }
  


  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    _button1.position = Vector2(390, 250);
  }
}
