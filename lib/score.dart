import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:make_compound_from_elemental/encyclopedia.dart';
import 'package:make_compound_from_elemental/game.dart';
import 'package:make_compound_from_elemental/main.dart';
import 'package:auto_translate_text_widget/auto_translate_text_widget.dart';
import 'package:flutter/services.dart';

class Scorepage extends StatefulWidget {

  final int time;
  final madecount;
  final gamemode gamemodesettings;
  final nowpoint;
  final nowlevel;
  final bool isClear;
  final List<String> makedCompounds;
  final AudioPlayer BGM;
  final int stage;

  const Scorepage({Key? key, required this.time, required this.madecount, required this.gamemodesettings, required this.nowlevel, required this.nowpoint, required this.isClear, required this.makedCompounds, required this.BGM, required this.stage}) : super(key: key);

  @override
  State<Scorepage> createState() => Scorestate();
}

class Scorestate extends State<Scorepage> {

  final ScrollController height = ScrollController();
  final ScrollController width = ScrollController();
  int level = 0;
  int point = 0;
  int addpoint = 0;
  int resultLevel = 0;
  int resultPoint = 0;

  @override
    void initState() {
      super.initState();

      level = widget.nowlevel;
      point = widget.nowpoint;
      resultLevel = level;
      resultPoint = point;
      if (widget.gamemodesettings == gamemode.puzzle && widget.isClear) {
        addpoint = 100;
      } else {
        if (widget.isClear) {
          addpoint = (widget.madecount*4*widget.stage);
        } else {
          addpoint = (widget.madecount*2*widget.stage);
        }
      }
      
      if (widget.madecount == 0){
        addpoint = 0;
      }
      add();
    }

  void add() async {
    for (int i = 1; i <= addpoint; i++) {
      setState(() {
        point += 1;
        if (point >= 100) {
          point = 0;
          level += 1;
        }
      });   
      await Future.delayed(Duration(milliseconds: 125));
    }
  }

  List<int> addResult() {
    int thisPoint = resultPoint;
    int thisLevel = resultLevel;

    for (int i = 1; i <= addpoint; i++) {
      thisPoint += 1;
      if (thisPoint >= 100) {
        thisPoint = 0;
        thisLevel += 1;
      }
    }

    return [thisLevel, thisPoint];
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
                                          AutoTranslateText("ゲームモード：${widget.gamemodesettings == gamemode.puzzle? "パズル" : "自由"}", style: TextStyle(fontSize: 50),),
                                          AutoTranslateText("タイム：${widget.gamemodesettings == gamemode.puzzle && widget.isClear==false? widget.time-1 : widget.time} 分", style: TextStyle(fontSize: 20),),
                                          AutoTranslateText(widget.madecount==1? "作った化合物数：${widget.madecount}" : "作った化合物数：${widget.madecount}", style: TextStyle(fontSize: 20),),
                                          AutoTranslateText("ゲットしたポイント：${addpoint}p", style: TextStyle(fontSize: 20),),
                                          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                            Text("Lv.${level}", style: TextStyle(fontSize: 20),),
                                            SizedBox(width: 30,),
                                            Text("${point}p", style: TextStyle(fontSize: 20),),
                                          ],),
                                          SizedBox(height: 50,),
                                          ElevatedButton(onPressed: () async {
            String messageText = await AutoTranslate.translateText('''化合物は${widget.makedCompounds.toSet().length}種類作ったよ!
${widget.makedCompounds.toSet().length != 0? "作ったのは${widget.makedCompounds.toSet().join("と")}だよ!" : ""}
今レベル${addResult().first}だよ!''', to: LanguageService.language.value);
            String text = messageText;
            await Clipboard.setData(ClipboardData(text: text));
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${LanguageService.language.value == "ja"? "テキストをコピーしました：": "Text copied:"}${text}")));
          }, child: AutoTranslateText("作った化合物リストをコピーする",style: TextStyle(fontSize: 20)),style: ButtonStyle(fixedSize: WidgetStatePropertyAll(Size(500, 150)))),
                                          SizedBox(height: 50,),
                                          ElevatedButton(onPressed: () {
                                            widget.BGM.stop();
                                            Navigator.push(context, MaterialPageRoute(builder: (_) => Encyclopediapage(point: addResult().last, level: addResult().first, makedCompounds: widget.makedCompounds, BGM: widget.BGM,)));
                                          }, child: AutoTranslateText("閉じる", style: TextStyle(fontSize: 20),),style: ButtonStyle(fixedSize: WidgetStatePropertyAll(Size(150, 150)))),
                                          SizedBox(height: 200,),
                                        ],
                                      )
                                    )
                    )
                    )
                    )
      ),
    );
  }
}