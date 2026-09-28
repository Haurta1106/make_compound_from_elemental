import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:make_compound_from_elemental/main.dart';
import 'package:video_player/video_player.dart';
import 'package:auto_translate_text_widget/auto_translate_text_widget.dart';

class MyHowToPlayPage extends StatefulWidget {
  final int point;
  final int level;
  final List<String> makedCompounds;
  final AudioPlayer BGM;

  const MyHowToPlayPage({Key? key, required this.point, required this.level, required this.makedCompounds, required this.BGM}) : super(key: key);

  @override
  State<MyHowToPlayPage> createState() => MyHowToPlayState();
}

class MyHowToPlayState extends State<MyHowToPlayPage> {

  final ScrollController height = ScrollController();
  final ScrollController width = ScrollController();
  Map<String,String> videoList = {"パズルか自由モードが選べる" : "/movies/PuzzleAndFreedom.mp4", "画面サイズを変更する方法" : "/movies/ScreenSizePuzzle.mp4", "ゲームを終了する方法" : "/movies/HowToEndTheGame.mp4", "配置をシャッフルする方法" : "/movies/HowToShuffle.mp4", "元素は自動で落ちてくる" : "/movies/AutoDropElemental.mp4", "次の元素が表示される" : "/movies/NextAutoDropElemental.mp4", "落ちてきた元素の列を変える方法" : "/movies/HowToChangeDropingElementalXPosition.mp4", "タップで化合物を作る" : "/movies/HowToMakeCompound.mp4", "作った化合物を見る方法" : "/movies/HowToLookMadeCompound.mp4", " 画面サイズを変更する方法 " : "/movies/ScreenSizeFreedom.mp4", "結合・結合しないモードについて" : "/movies/BlendOrNotBlend.mp4", "落とす元素の列を変える方法" : "/movies/HowToChangeWantDropElementalXPosition.mp4", "ボタンを押して元素を落とす方法" : "/movies/HowToDropElemental.mp4", "今の配置のIDをコピーする方法" : "/movies/HowToCopyPlacementID.mp4", "配置のIDを入力して配置を変える" : "/movies/HowToSetPastedPlacementID.mp4", " タップで化合物を作る " : "/movies/HowToMakeBlueCompound.mp4", " 作った化合物を見る方法 " : "/movies/HowToSeeMadeCompound.mp4", " ゲームを終了する方法 " : "/movies/HowToEndTheFreedomGame.mp4", "作った化合物が化合物図鑑に記録される" : "/movies/CompoundDictionary.mp4", "レベルとポイントと作った化合物のデータをコピーする方法" : "/movies/HowToCopyData.mp4", "コピーしておいたデータを入力して読み込む方法" : "/movies/HowToLoadData.mp4"};
  Map<String,VideoPlayerController>? controller;  
  Map<String,bool>? isstoped;

  @override
  void dispose() {
    super.dispose();
    if (controller != null) {
      for (var element in controller!.values) {
        element.dispose();
      }
    }  
  }

  @override
  void initState() {
    super.initState();

    for (var element in videoList.values) {
      if (isstoped == null) {
        isstoped = {element : true};
      } else {
        isstoped!.addAll({element : true});
      }
    }

    for (var element in videoList.values) {
      if (controller == null) {
        controller = {element : VideoPlayerController.asset(element)..initialize().then((_) {
      setState(() {
        controller![element]!.addListener(() {
          if (controller![element]!.value.isCompleted && isstoped![element] == false) {
            controller![element]!.pause();
            isstoped![element] = true;            
            setState(() {
              
            });            
          }
        });
      });
    })};
      } else {
        controller!.addAll({element : VideoPlayerController.asset(element)..initialize().then((_) {
      setState(() {
        controller![element]!.addListener(() {
          if (controller![element]!.value.isCompleted && isstoped![element] == false) {
            controller![element]!.pause();
            isstoped![element] = true;
            setState(() {
              
            });
          }
        });
      });
    })});
      }      
    }
  }

  Widget makeHowToButton(String text) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      AutoTranslateText(text,style: TextStyle(fontSize: 30),),
      SizedBox(height: 10,),
      Stack(
        alignment: Alignment.center,
        children: [
          Container(decoration: BoxDecoration(border: Border.all(color: Colors.lightBlue[100]!, width: 3)), width: 1000, height: 500,
          child: AspectRatio(aspectRatio: controller![videoList[text]]!.value.aspectRatio,
            child: VideoPlayer(controller![videoList[text]]!),
          ),),          
          controller![videoList[text]]!.value.isPlaying? SizedBox() : ElevatedButton(onPressed: () {
            controller![videoList[text]]!.seekTo(Duration.zero).then((_) {
              controller![videoList[text]]!.play();
            });
            isstoped![videoList[text]!] = false;
            setState(() {
              
            });
          }, child: Icon(Icons.play_arrow), style: ButtonStyle(fixedSize: WidgetStatePropertyAll(Size(150, 150))),)
        ],
      )
    ],);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: 
        Scrollbar(
                    radius: Radius.circular(4),
                    thumbVisibility: true,
                    thickness: 8,
                    controller: height,
                    child: Scrollbar(
                    radius: Radius.circular(4),
                    thumbVisibility: true,
                    thickness: 8,
                    controller: width,
                    notificationPredicate: (notification) => notification.depth == 1,
                    child:  SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  controller: height,
                                  child:
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      controller: width,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SizedBox(height: 200,),
                                          ElevatedButton(onPressed: () {
                                            Navigator.push(context, MaterialPageRoute(builder: (_) => Mypage(point: widget.point, level: widget.level, size: 100, makedCompounds: widget.makedCompounds, BGM: widget.BGM,)));
                                          }, child: AutoTranslateText("戻る",style: TextStyle(fontSize: 20),),style: ButtonStyle(fixedSize: WidgetStatePropertyAll(Size(150, 150)))),
                                          SizedBox(height: 50,),
                                          /*ElevatedButton(onPressed: () {
                                            Navigator.push(context, MaterialPageRoute(builder: (_) => HowTosSetTheModepage(point: widget.point, level: widget.level, makedCompounds: widget.makedCompounds, BGM: widget.BGM,)));
                                          }, child: AutoTranslateText("モードを設定する方法",style: TextStyle(color: Colors.black,fontSize: 30)),
                                            style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.blue[300]), fixedSize: WidgetStatePropertyAll(Size(500, 100)))
                                          ),
                                          SizedBox(height: 50,),
                                          ElevatedButton(onPressed: () {
                                            Navigator.push(context, MaterialPageRoute(builder: (_) => HowToPlayPuzzleModepage(point: widget.point, level: widget.level, makedCompounds: widget.makedCompounds, BGM: widget.BGM,)));
                                          }, child: AutoTranslateText("パズルモードの遊び方",style: TextStyle(color: Colors.black,fontSize: 30)),
                                            style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.orange[300]), fixedSize: WidgetStatePropertyAll(Size(500, 100)))
                                          ),
                                          SizedBox(height: 50,),
                                          ElevatedButton(onPressed: () {
                                            Navigator.push(context, MaterialPageRoute(builder: (_) => HowToPlayFreedomModepage(point: widget.point, level: widget.level, makedCompounds: widget.makedCompounds, BGM: widget.BGM,)));
                                          }, child: AutoTranslateText("自由モードの遊び方",style: TextStyle(color: Colors.black,fontSize: 30)),
                                            style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.pink[200]), fixedSize: WidgetStatePropertyAll(Size(500, 100)))
                                          ),*/
                                          AutoTranslateText("1/5 ゲームモードの設定",style: TextStyle(fontSize: 40),),
                                          SizedBox(height: 20,),
                                          makeHowToButton("パズルか自由モードが選べる"),
                                          SizedBox(height: 50,),
                                          AutoTranslateText("2/5 パズルモードの遊び方",style: TextStyle(fontSize: 40),),
                                          SizedBox(height: 20,),
                                          makeHowToButton("画面サイズを変更する方法"),                                                                                    
                                          SizedBox(height: 20,),
                                          makeHowToButton("元素は自動で落ちてくる"),
                                          SizedBox(height: 20,),
                                          makeHowToButton("次の元素が表示される"),
                                          SizedBox(height: 20,),
                                          makeHowToButton("落ちてきた元素の列を変える方法"),
                                          SizedBox(height: 20,),
                                          makeHowToButton("タップで化合物を作る"),
                                          SizedBox(height: 20,),
                                          makeHowToButton("作った化合物を見る方法"),
                                          SizedBox(height: 20,),
                                          makeHowToButton("配置をシャッフルする方法"),
                                          SizedBox(height: 20,),                                          
                                          makeHowToButton("ゲームを終了する方法"),
                                          SizedBox(height: 50,),
                                          AutoTranslateText("3/5 自由モードの遊び方",style: TextStyle(fontSize: 40),),
                                          SizedBox(height: 20,),                                          
                                          makeHowToButton(" 画面サイズを変更する方法 "),
                                          SizedBox(height: 20,),                                          
                                          makeHowToButton("結合・結合しないモードについて"),
                                          SizedBox(height: 20,),                                          
                                          makeHowToButton("落とす元素の列を変える方法"),
                                          SizedBox(height: 20,),                                          
                                          makeHowToButton("ボタンを押して元素を落とす方法"),
                                          SizedBox(height: 20,),                                          
                                          makeHowToButton("今の配置のIDをコピーする方法"),
                                          SizedBox(height: 20,),                                          
                                          makeHowToButton("配置のIDを入力して配置を変える"),
                                          SizedBox(height: 20,),                                          
                                          makeHowToButton(" タップで化合物を作る "),
                                          SizedBox(height: 20,),                                          
                                          makeHowToButton(" 作った化合物を見る方法 "),
                                          SizedBox(height: 20,),                                          
                                          makeHowToButton(" ゲームを終了する方法 "),
                                          SizedBox(height: 50,),
                                          AutoTranslateText("4/5 化合物図鑑",style: TextStyle(fontSize: 40),),
                                          SizedBox(height: 20,),                                          
                                          makeHowToButton("作った化合物が化合物図鑑に記録される"),
                                          SizedBox(height: 50,),
                                          AutoTranslateText("5/5 データの保存と読み込み",style: TextStyle(fontSize: 40),),
                                          SizedBox(height: 20,),                                          
                                          makeHowToButton("レベルとポイントと作った化合物のデータをコピーする方法"),
                                          SizedBox(height: 20,),                                          
                                          makeHowToButton("コピーしておいたデータを入力して読み込む方法"),
                                          SizedBox(height: 200,),
                                        ]
                                      ),
                                    
                    )
                    )
        )
      ),
      )
    );
  }
}