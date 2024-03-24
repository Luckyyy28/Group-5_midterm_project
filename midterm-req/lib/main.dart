import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart' hide Game;
import 'package:flutter_fruit_ninja/box.dart';
import 'package:flutter_fruit_ninja/src/game.dart';
import 'package:hive_flutter/adapters.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  hscore = await Hive.openBox("highscore");

  Flame.device.fullScreen();
  Flame.device.setLandscape();

  runApp(GameWidget(game: MainRouterGame()));
}

