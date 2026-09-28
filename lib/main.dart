import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:make_compound_from_elemental/encyclopedia.dart';
import 'package:make_compound_from_elemental/game.dart';
import 'package:make_compound_from_elemental/howtoplay.dart';
import 'package:video_player/video_player.dart';
import 'package:auto_translate_text_widget/auto_translate_text_widget.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LanguageService.init();
  runApp(myapp());
}

class myapp extends StatelessWidget {
  const myapp ({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MyLoadingPage(),);
  }
}

class MyLoadingPage extends StatefulWidget {

  const MyLoadingPage({Key? key,}) : super(key: key);

  @override
  State<MyLoadingPage> createState() => MyLoadingState();
}

class MyLoadingState extends State<MyLoadingPage> {
  VideoPlayerController? controller;
  final AudioPlayer audioPlayer = AudioPlayer();
  final ScrollController height = ScrollController();
  final ScrollController width = ScrollController();
  bool ifVideoEnd = false;
  bool isFirst = true;
  bool isBGMOn = true;

  @override
  void dispose() {
    controller!.dispose();
    audioPlayer.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    controller = VideoPlayerController.asset('assets/movies/LoadingMovie.mp4')
    ..initialize().then((_) {
      setState(() {
        
      });
    });
    controller!.addListener(() {
      if (controller!.value.isCompleted == true) {
        finishVideo();
      }
    });
  }

  Future<void> finishVideo() async {
    await Future.delayed(Duration(seconds: 1, milliseconds: 200));
    audioPlayer.pause();
    Navigator.push(context, MaterialPageRoute(builder: (_) => Mypage(point: 0,level: 0, size: 100, makedCompounds: [], BGM: AudioPlayer(),)));
  }

  Future<void> initAudio() async {
    audioPlayer.audioCache = AudioCache(prefix: "");
    final source = AssetSource("audio/MakeCompoundFromElemental_BGM_Loading.wav");    
    await audioPlayer.play(source);
    await audioPlayer.stop();
    await audioPlayer.resume();
    await audioPlayer.setReleaseMode(ReleaseMode.release);
    await audioPlayer.setVolume(isBGMOn? 1 : 0);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center( 
        child: !controller!.value.isInitialized?
          CircularProgressIndicator() :
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
                                      child: SizedBox(width: MediaQuery.of(context).size.width, 
                                      height: MediaQuery.of(context).size.height, child:  Stack(
                                              alignment: Alignment.bottomCenter,
                                              children: [
                                                  AspectRatio(aspectRatio: controller!.value.aspectRatio,
                                                    child: VideoPlayer(controller!),
                                                  ),
                                                  controller!.value.isPlaying? Text("") : Column(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      SizedBox(height: MediaQuery.of(context).size.height/6.5,),
                                                      Row (mainAxisAlignment: MainAxisAlignment.center, children: [
                                                        !controller!.value.isPlaying? ElevatedButton(
                                                          onPressed: () {
                                                            if (audioPlayer.state != PlayerState.playing) {
                                                              setState(() {
                                                                controller!.play();
                                                              });
                                                              initAudio();
                                                            }                                                            
                                                          }, child: Icon(Icons.play_arrow, size: ((MediaQuery.of(context).size.width/51.2)+(MediaQuery.of(context).size.height/26))/2,), style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(controller!.value.isPlaying? Color.fromARGB(0, 0, 0, 0) : Colors.white,),fixedSize: WidgetStatePropertyAll(Size(150, 150)))) : Text(""),
                                                        SizedBox(width: 30,),
                                                      ],),                                                      
                                                        SizedBox(height: MediaQuery.of(context).size.height/6.5,),
                                                    ],
                                                  ),
                                                  Row(mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    SizedBox(height: MediaQuery.of(context).size.height/6.5,width: MediaQuery.of(context).size.width-500,),
                                                    ElevatedButton(onPressed: () {
                                                      audioPlayer.pause();
                                                      Navigator.push(context, MaterialPageRoute(builder: (_) => Mypage(point: 0,level: 0, size: 100, makedCompounds: [], BGM: AudioPlayer(),)));
                                                    }, child: Stack(alignment: Alignment.center,children: [
                                                      Icon(Icons.arrow_forward_ios, size: 20,),
                                                      Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                                                        SizedBox(width: 20,),
                                                        Icon(Icons.arrow_forward_ios, size: 20,),
                                                      ],)
                                                    ],),style: ButtonStyle(fixedSize: WidgetStatePropertyAll(Size(150, 150)))),
                                                    SizedBox(height: MediaQuery.of(context).size.height/6.5,),
                                                  ],
                                                ),
                                                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                                  SizedBox(height: MediaQuery.of(context).size.height/6.5,),
                                                  ElevatedButton(onPressed: () {
                                                    setState(() {
                                                      isBGMOn = !isBGMOn;
                                                      audioPlayer.setVolume(isBGMOn? 1 : 0);
                                                    });
                                                  }, child: Icon(isBGMOn? Icons.volume_up : Icons.volume_off, size: 40,), style: ButtonStyle(fixedSize: WidgetStatePropertyAll(Size(150, 150)))),
                                                  SizedBox(width: MediaQuery.of(context).size.width-500,),
                                                ],),
                                              ],
                                            ),)
                                    ))))  
      ),
    );
  }
}

class Mypage extends StatefulWidget {

  final int point;
  final int level;
  final List<String> makedCompounds;
  final AudioPlayer BGM;

  final int size;

  const Mypage({Key? key, required this.point, required this.level, required this.size, required this.makedCompounds, required this.BGM}) : super(key: key);

  @override
  State<Mypage> createState() => mystate();
}

class mystate extends State<Mypage> {

 gamemode gamemodesettings = gamemode.puzzle;
 int size = 0;
 int level = 0;
 int point = 0;
 List<String> makedCompounds = [];
 final ScrollController height = ScrollController();
 final ScrollController width = ScrollController();
 final TextEditingController sizeText = TextEditingController(text: "100");
 final TextEditingController ID = TextEditingController();
 String language = "";
 final AudioPlayer audioPlayer = AudioPlayer();
 bool isBGMOn = true;

 List<String> compounds = ["H2", "N2", "O2", "O3", "F2", "Cl2", "Br2",
    "BH3", "CH4", "NH3", "H2O", "HF", "AlH3", "SiH4", "PH3", "H2S", "HCl", "GaH3", "GeH4", "AsH3", "H2Se", "HBr", "InH3",
    "SnH4", "H2Te", "HI", "TlH3", "PbH4", "BiH3", "CH3Li", "LiN3", "LiCl", "Li2O2", "Li2O", "ClLiO", "Li2B4O7", "LiBr",
    "LiNO3", "LiOH", "LiAlH4", "LiH", "Li2CO3", "LiTaO3", "Li3N", "LiNbO3", "LiF", "LiPF6", "LiI", "Li2S",
    "Li2SO4", "BeBr2", "Be2C", "BeCl2", "BeCO3", "BeF2", "BeH2", "BeI2", "Be3N2", "BeO", "Be3P2", "BeS", "BeSe", "BeSO4",
    "BeTe", "BAs", "BBr3", "B2Br4", "BCl3", "B2Cl4", "BF", "BF3", "B2F4", "B2H6", "BI3", "B2I4", "BN", "BO", "B2O3",
    "BP", "B2S3", "B3N3H6", "HBF4", "HBO2", "CO2", "CO", "C3O2", "C2O", "CO3", "H2CO3", "K2CO3", "CaCO3", "Na2CO3", "BaCO3",
    "MgCO3", "CuCO3", "FeCO3", "Ag2CO3", "KHCO3", "NBr3", "NCl3", "NF3", "N2F2", "N2F4", "N2H2",
    "N2H4", "NI3", "NO", "NO2", "N2O", "N2O3", "N2O4", "N2O5", "N2S2", "N2S4", "N4S4", "HNO2", "HNO3", "H2N2O2", "NCBr",
    "NCCl", "NCF", "NCI", "NOBr", "NOCl", "NO2Cl", "NOF", "NO2F", "NSF", "NSF3", "HNCO", "NOBF4", "NO2BF4",
    "OF2", "O2F", "O2F2", "O4F2", "AlF3", "CaF2", "NaF", "UF6", "CF4", "SF4", "SF6", "XeF2", "XeF4", "XeF6", "XePtF6",
    "Na3As", "NaBr", "Na2C2", "NaCl", "NaH", "NaI", "NaI3", "NaN3", "Na3N", "NaO2", "NaO3", "Na2O2", "Na2O",
    "Na2Po", "Na3P", "Na2S", "Na2Se", "Na2Te", "Na3AlF6", "NaAlH4", "NaAuCl4", "Na3BF4", "NaBH4", "Na2B4O7", "NaCH3",
    "Na2C2O4", "NaCN", "Na2CN2", "NaHF2", "NaHS", "NaHSe", "NaNH2", "NaOH", "NaPF6", "Na2PtCl4", "Na2PtCl6", "Na2SiF6",
    "C6H5ONa", "NaBH3CN", "NaOCH3", "NaOCN", "NaSCN", "NaAlO2", "NaBiO3", "NaBO2", "Na2B8O13", "Na3BO3", "NaBrO", "NaBrO2",
    "NaBrO3", "NaBrO4", "NaClO", "NaClO2", "NaClO3", "NaClO4", "Na2CrO4", "Na2Cr2O7", "NaIO", "NaIO2", "NaIO3",
    "NaIO4", "Na5IO6", "NaMnO4", "Na2MnO4", "Na3MnO4", "NaNO2", "NaNO3", "NaPH2O2", "Na2HPO3", "Na2PO3F", "Na3PSO3", 
    "Na3PS2O2", "Na3PO4", "Na4P2O7", "Na5P3O10", "NaReO4", "Na2SeO3", "Na2SeO4", "Na2SiO3", "Na2SO3", "Na2SO4", "Na2S2O3",
    "Na2S2O4", "Na2S2O5", "Na2S2O6", "Na2S2O7", "Na2S2O8", "Na2S3O6", "NaTcO4", "Na2TeO3", "NaVO3", "Na3VO4", "Na2WO4",
    "NaHCO3", "NaH2PO4", "Na2HPO4", "Na2H2P2O7", "Na3HP2O7", "NaHSeO3", "NaHSeO4", "NaHSO3",
    "NaHSO4", "MgB2", "MgBr2", "MgC2", "MgCl2", "MgF2", "MgH2", "MgI2", "Mg3N2", "MgO", "MgO2", "Mg3P2", "MgS", "MgSe",
    "Mg2Si", "MgSO3", "MgSO4", "MgU2O7", "MgHPO4", "AlAs", "AlB2", "AlB12", "AlBr3", "Al4C3", "AlCl", "AlCl3",
    "AlF", "AlI", "AlI3", "AlN", "AlO", "Al2O", "Al2O3", "AlP", "Al2S3", "AlSb", "Al2Se3", "Al2Te3",
    "AlPO4", "SiBr2", "SiBr4", "SiC", "SiCl2", "SiCl4", "SiF2", "SiF4", "Si2H6", "SiI4", "Si3N4", "SiO", "SiO2",
    "SiS2", "H2SiF6", "PBr3", "PBr5", "PCl3", "PCl5", "P2Cl4", "PF3", "PF5", "P2F4", "P2H4", "PI3", "P2I4", "PN",
    "P2O3", "P2O5", "P2S5", "P4S3", "P2Se5", "P4Se3", "POBr3", "POCl3", "POF3", "POI3", "PSBr3", "PSCl3", "PSF3", "PSI3",
    "SBr2", "SBr4", "S2Br2", "SCl2", "SCl4", "S2Cl2", "SF2", "S2F2", "S2F4", "S2F10", "SO", "SO2", "SO3",
    "S2O", "H2SO3", "H2SO4", "H2SO5", "H2S2O3", "H2S2O4", "H2S2O5", "H2S2O6", "H2S2O7", "H2S2O8", "SOBr2",
    "SOCl2", "SOF2", "SOF4", "SO2Cl2", "SO2F2", "ClF", "ClF3", "ClF5", "ClNO3", "ClO", "ClO2", "Cl2O", "Cl2O4", "Cl2O6",
    "Cl2O7", "ClOF3", "ClO2F", "ClO2F3", "ClO3F", "HClO", "HClO2", "HClO3", "HClO4", "HArF", "K3As", "KBr", "K2C2", "KCl",
    "KF", "KH", "KI", "KI3", "KN3", "K3N", "KO2", "KO3", "K2O", "K2O2", "K3P", "K2S", "K2Se", "K2Te", "KAlF4", "KBF4",
    "KBH4", "KCH3", "KCN", "KHF2", "KHS", "KNH2", "KOH", "KPF6", "KOCH3", "KONC", "KSCN", "Ca3As2", "CaB6", "CaBr2",
    "CaC2", "CaCl2", "CaH2", "CaI2", "Ca3N2", "CaO", "CaO2", "Ca3P2", "CaS", "CaSe", "CaSi", "CaSi2", "CaTe",
    "CaCN2", "CaC2O4", "CaCrO4", "CaCr2O7", "Ca2P2O7", "CaSeO4", "CaSiO3", "CaSO3", "CaTiO3", "CaHPO4", "ScB12",
    "ScBr3", "ScCl3", "ScF3", "ScH2", "ScI3", "ScN", "Sc2O3", "Sc2S3", "TiB2", "TiBr3", "TiBr4", "TiC", "TiCl2", "TiCl3",
    "TiCl4", "TiF2", "TiF3", "TiF4", "TiH2", "TiI3", "TiI4", "TiN", "TiO", "TiO2", "Ti2O3", "TiP", "TiS", "TiS2", "Ti2S3",
    "TiSi2", "VBr2", "VBr3", "VBr4", "VC", "VCl2", "VCl3", "VCl4", "VI2", "VI3", "VN", "VO", "VO2", "V2O3", "V2O5",
    "VP", "VS", "VSe", "VBrO", "VBr2O", "VBr3O", "VClO", "VCl2O", "VCl3O", "VFO", "VF2O", "VF3O", "VI2O", "VSO4",
    "CrBr2", "CrBr3", "Cr3C2", "CrCl2", "CrCl3", "CrF2", "CrF3", "CrF4", "CrF5", "CrF6", "CrI2", "CrI3", "CrN",
    "CrO", "CrO2", "CrO3", "CrO5", "Cr2O3", "CrP", "CrS", "CrO2Cl2", "CrO2F2", "MnBr2", "MnBr3", "MnCl2", "MnCl3",
    "MnCl4", "MnF2", "MnF3", "MnF4", "MnI2", "MnO", "MnO2", "Mn2O3", "Mn2O7", "Mn3O4", "MnS", "MnS2", "MnSe", "MnSe2",
    "HMnO4", "H2MnO4", "MnCO3", "MnSeO4", "MnSO3", "MnSO4", "FeBr2", "FeBr3", "Fe3C", "FeCl2", "FeCl3", "FeF2", "FeF3",
    "FeH2", "FeI2", "FeI3", "Fe3N", "FeO", "Fe2O3", "Fe3O4", "FeS", "FeS2", "Fe2S3", "Fe3S4", "FeSe",  "Fe2Se3", "FeSi2",
    "FeCO3", "FeC2O4", "FeMnO4", "FeMoO4", "FePO4", "FeSeO4", "FeSO3", "FeSO4", "H2FeO4", "CoBr2", "CoCl2", "CoCl3", "CoF2",
    "CoF3", "CoI2", "CoO", "Co2O3", "Co3O4", "CoS", "CoS2", "Co3S4", "CoCO3", "CoC2O4", "CoCrO4", "CoSO3", "CoS4", "CoTiO3",
    "NiBr2", "NiCl2", "NiF2", "NiI2", "NiO", "NiO2", "Ni2O3", "NiS", "NiS2", "NiCO3", "NiCrO4", "NiSO3", "NiSO4", "C6H6",
    "C6H6O", "C10H8", "C6H12O6", "C12H22O11", "AgBr", "AgNO3", "CH2F2", "C2H6O", "C2H6S", "C6H7NO2", "CaSO4", "CeO2", "GaAs",
    "GaN", "KAlSi3O8", "SrAl2O4", 
  ];

  @override
    void dispose() {
      super.dispose();

      audioPlayer.dispose();
    }

  @override
    void initState() {
      super.initState();

      initAgoAudio();
      
      level = widget.level;
      point = widget.point;
      size = widget.size;
      makedCompounds = widget.makedCompounds;

      initLLanguage();

      audioPlayer.setVolume(0);
    

      setState(() {
        
      });
    }

  Future<void> initLLanguage() async {
    String a = await LanguageService.language.value;
    setState(() {
      language = a;
    });
  }

  Future<void> initAgoAudio() async {
    isBGMOn = widget.BGM.volume == 1;
    await widget.BGM.stop();
  } 

  Future<void> initAudio() async {
    audioPlayer.audioCache = AudioCache(prefix: "");
    final source = AssetSource("audio/MakeCompoundFromElemental_BGM.wav");    
    await audioPlayer.play(source);
    await audioPlayer.setReleaseMode(ReleaseMode.loop);    
  }

  String makeCopyData() {
    String levelth = "${level}";
    levelth.replaceAll(('0'), 'a');
    levelth.replaceAll(('1'), 'b');
    levelth.replaceAll(('2'), 'c');
    levelth.replaceAll(('3'), 'd');
    levelth.replaceAll(('4'), 'e');
    levelth.replaceAll('5', 'f');
    levelth.replaceAll('6', 'g');
    levelth.replaceAll('7', 'h');
    levelth.replaceAll('8', 'i');
    levelth.replaceAll('9', 'j');
    String pointth = "${point}";
    pointth.replaceAll(('0'), 'a');
    pointth.replaceAll(('1'), 'b');
    pointth.replaceAll(('2'), 'c');
    pointth.replaceAll(('3'), 'd');
    pointth.replaceAll(('4'), 'e');
    pointth.replaceAll(('5'), 'f');
    pointth.replaceAll(('6'), 'g');
    pointth.replaceAll(('7'), 'h');
    pointth.replaceAll(('8'), 'i');
    pointth.replaceAll(('9'), 'j');
    List<String> makedCompoundsth = List.from(makedCompounds);
    for (var element in makedCompoundsth) {
      makedCompoundsth[makedCompoundsth.indexOf(element)] = "${compounds.indexOf(element)}";
    }
    String makedCompoundsID = makedCompoundsth.join("~");
    String Result = "$levelth,$pointth,$makedCompoundsID";
    return Result;
  }

  void load(String ID) {
    List<String> splited = ID.split(",");
    String levelID = splited.first;
    String pointID = splited[1];
    List<String> makedID = splited.last.split("~");
    int thislevel = 0;
    int thispoint = 0;
    levelID.replaceAll(('a'), '0');
    levelID.replaceAll(('b'), '1');
    levelID.replaceAll(('c'), '2');
    levelID.replaceAll(('d'), '3');
    levelID.replaceAll(('e'), '4');
    levelID.replaceAll(('f'), '5');
    levelID.replaceAll(('g'), '6');
    levelID.replaceAll(('h'), '7');
    levelID.replaceAll(('i'), '8');
    levelID.replaceAll(('j'), '9');
    thislevel = int.parse(levelID);
    setState(() {
      level = thislevel;
    });    
    pointID.replaceAll(('a'), '0');
    pointID.replaceAll(('b'), '1');
    pointID.replaceAll(('c'), '2');
    pointID.replaceAll(('d'), '3');
    pointID.replaceAll(('e'), '4');
    pointID.replaceAll(('f'), '5');
    pointID.replaceAll(('g'), '6');
    pointID.replaceAll(('h'), '7');
    pointID.replaceAll(('i'), '8');
    pointID.replaceAll(('j'), '9');
    thispoint = int.parse(pointID);
    setState(() {
      point = thispoint;
    });    
    makedCompounds.clear();
    for (var element in makedID) {      
      setState(() {
        makedCompounds.add(compounds[int.parse(element)]);
      });      
    }
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
      child: SizedBox.expand(child: Scrollbar(radius: Radius.circular(4),
                    thumbVisibility: true,
                    thickness: 8,
                    controller: height,
                    child: Scrollbar(radius: Radius.circular(4),
                    thumbVisibility: true,
                    thickness: 8,
                    controller: width,
                    notificationPredicate: (notification) => notification.depth == 1,
                    child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  controller: height,
                                  child:
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            SizedBox(height: 200,),
                                            Image.asset("/images/TitlePic.jpeg", width: 960, height: 540,),
                                            SizedBox(height: 50,),
                                            Column(mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text("Lv.$level",style: TextStyle(fontSize: 20),),
                                              SizedBox(height: 8),
                                              SizedBox(width: 500,height: 50,child: LinearProgressIndicator(
                                                color: Colors.amber,
                                                value: point / 100,
                                              ),),                                              
                                              SizedBox(height: 4),
                                              Text("$point / 100p",style: TextStyle(fontSize: 20),),
                                            ],
                                            ),
                                            SizedBox(height: 50,),
                                            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                              SizedBox(height: 50,width: 300, child: TextField(
                                                controller: ID,
                                                decoration: InputDecoration(
                                                  label: AutoTranslateText("コピーしたデータを入力"),
                                                ),
                                              ),),
                                              ElevatedButton(onPressed: () {
                                                setState(() {
                                                  load(ID.text);
                                                });
                                              }, child: AutoTranslateText("入力したデータを読み込み")),
                                            ],),
                                            SizedBox(height: 100,),
                                            ElevatedButton(onPressed: (){setState(() {
                                              gamemodesettings = gamemode.values[(gamemode.values.indexOf(gamemodesettings) + 1)%2];
                                            });}, child: AutoTranslateText(gamemodesettings == gamemode.puzzle? "パズル" : "自由",style: TextStyle(color: Colors.black,fontSize: 40),), style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(gamemodesettings == gamemode.puzzle? Colors.orange[300] : Colors.pink[200]), fixedSize: WidgetStatePropertyAll(Size(500, 100)),),),
                                            SizedBox(height: 100,),
                                            ElevatedButton(
                                              onPressed: () {
                                                initAudio();
                                                audioPlayer.setVolume(isBGMOn? 1 : 0);
                                                if (gamemodesettings == gamemode.freedom) {
                                                  Navigator.push(context, MaterialPageRoute(builder: (_) => Mygamepage(gamemodesettings: gamemodesettings,point: point,level: level, size: int.tryParse(sizeText.text)==null || int.tryParse(sizeText.text)! <= 0? 100 : int.tryParse(sizeText.text)!, makedCompounds: makedCompounds, BGM: audioPlayer,stage: 1,)));
                                                } else {
                                                  Navigator.push(context, MaterialPageRoute(builder: (_) => MyStageSelectpage(point: point,level: level, size: int.tryParse(sizeText.text)==null || int.tryParse(sizeText.text)! <= 0? 100 : int.tryParse(sizeText.text)!, makedCompounds: makedCompounds, BGM: audioPlayer,)));
                                                }                                                
                                              },
                                              child: AutoTranslateText("ゲームをプレイする",style: TextStyle(color: Colors.black,fontSize: 40),),
                                              style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.blue[300]), fixedSize: WidgetStatePropertyAll(Size(500, 100)))
                                            ,),
                                            SizedBox(height: 100,),
                                            ElevatedButton(
                                              onPressed: () {
                                                audioPlayer.setVolume(isBGMOn? 1 : 0);
                                                Navigator.push(context, MaterialPageRoute(builder: (_) => MyHowToPlayPage(point: point, level: level, makedCompounds: makedCompounds, BGM: audioPlayer)));
                                              },
                                              child: AutoTranslateText("遊び方",style: TextStyle(color: Colors.black,fontSize: 40),),
                                              style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.green[300]), fixedSize: WidgetStatePropertyAll(Size(500, 100)))
                                            ,),
                                            SizedBox(height: 100,),
                                            ElevatedButton(
                                              onPressed: () {
                                                audioPlayer.setVolume(isBGMOn? 1 : 0);
                                                Navigator.push(context, MaterialPageRoute(builder: (_) => Encyclopediapage(makedCompounds: makedCompounds, point: point, level: level, BGM: audioPlayer,)));
                                              },
                                              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                                Icon(Icons.menu_book, color: Colors.deepOrange[800],size: 60,),
                                                SizedBox(width: 10,),
                                                AutoTranslateText("図鑑",style: TextStyle(color: Colors.black,fontSize: 40),),                                              
                                              ],),
                                              style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.yellow[200]), fixedSize: WidgetStatePropertyAll(Size(500, 100))),
                                            ),
                                            SizedBox(height: 100,),
                                            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                              GestureDetector(onTap: () async {
                                                await LanguageService.setLanguage('ja');
                                                setState(() {
                                                  language = "ja";
                                                });                                              
                                              }, child: Container(alignment: Alignment.center, child: Text("日本語", style: TextStyle(fontSize: 20),),width: 150,height: 150, decoration: BoxDecoration(border: Border.all(width: 2, color:  Colors.amber[200]!), color: language == "ja"? Colors.amber[200] : Colors.white)),),
                                              GestureDetector(onTap: () async {
                                                await LanguageService.setLanguage('en');
                                                setState(() {
                                                  language = "en";
                                                });                                              
                                              }, child: Container(alignment: Alignment.center, child: Text("English", style: TextStyle(fontSize: 20),),width: 150,height: 150, decoration: BoxDecoration(border: Border.all(width: 2, color:  Colors.amber[200]!), color: language == "en"? Colors.amber[200] : Colors.white)),),
                                            ],),   
                                            SizedBox(height: 100,),
                                            AutoTranslateText("ゲーム音楽", style: TextStyle(fontSize: 20),),
                                            SizedBox(height: 5,),
                                            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                              GestureDetector(onTap: () async {                                                
                                                setState(() {
                                                  isBGMOn = true;
                                                });                                              
                                              }, child: Container(alignment: Alignment.center, child: Icon(Icons.volume_up ,size: 40), width: 150,height: 150, decoration: BoxDecoration(border: Border.all(width: 2, color:  Colors.amber[200]!), color: isBGMOn == true? Colors.amber[200] : Colors.white)),),
                                              GestureDetector(onTap: () async {                                                
                                                setState(() {
                                                  isBGMOn = false;
                                                });                                              
                                              }, child: Container(alignment: Alignment.center, child: Icon(Icons.volume_off ,size: 40), width: 150,height: 150, decoration: BoxDecoration(border: Border.all(width: 2, color:  Colors.amber[200]!), color: isBGMOn == false? Colors.amber[200] : Colors.white)),),
                                            ],),                 
                                            SizedBox(height: 100,),
                                            ElevatedButton(
                                              onPressed: () async {
                                                String text = makeCopyData();
                                                await Clipboard.setData(ClipboardData(text: text));
                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${LanguageService.language.value == "ja"? "テキストをコピーしました：": "Text copied:"}${text}")));
                                              },
                                              child: AutoTranslateText("データをコピー",style: TextStyle(color: Colors.black,fontSize: 40),),                                              
                                              style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.brown), fixedSize: WidgetStatePropertyAll(Size(500, 100))),
                                            ),                           
                                            /*ElevatedButton(
                                              onPressed: () async {
                                                audioPlayer.setVolume(isBGMOn? 1 : 0);
                                                Navigator.push(context, MaterialPageRoute(builder: (_) => RuletPage(makedCompounds: makedCompounds, point: point, size: 100, level: level, BGM: audioPlayer,)));
                                              },
                                              child: AutoTranslateText("ルーレット",style: TextStyle(color: Colors.black,fontSize: 40),),                                              
                                              style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.brown), fixedSize: WidgetStatePropertyAll(Size(500, 100))),
                                            ),*/          
                                            SizedBox(height: 200,),
                                          ],
                                        ),
                                  )
                                      
                                     
      ),))
      
      ));
  }
}

class MyStageSelectpage extends StatefulWidget {

  final int point;
  final int level;
  final List<String> makedCompounds;
  final AudioPlayer BGM;

  final int size;

  const MyStageSelectpage({Key? key, required this.point, required this.level, required this.size, required this.makedCompounds, required this.BGM}) : super(key: key);

  @override
  State<MyStageSelectpage> createState() => MyStageSelectState();
}

class MyStageSelectState extends State<MyStageSelectpage> {

  final ScrollController height = ScrollController();
  final ScrollController width = ScrollController();

  Widget makeStageSelectButton(int max) {
    List<Widget> returnButtons = [];
    List<Widget> returnRowButtons = [];
    returnButtons.add(SizedBox(height: 100,));
    returnRowButtons.add(SizedBox(width: 100,));
    for (var i = 1; i < max+1; i++) {
      returnRowButtons.add(ElevatedButton(onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => Mygamepage(gamemodesettings: gamemode.puzzle, point: widget.point,level: widget.level, size: widget.size, makedCompounds: widget.makedCompounds, BGM: widget.BGM,stage: i,)));
      }, child: AutoTranslateText("ステージ$i",style: TextStyle(color: Colors.white, fontSize: 20),), style: ButtonStyle(fixedSize: WidgetStatePropertyAll(Size(150, 150)),backgroundColor: WidgetStatePropertyAll(Color.from(alpha: 0.5, red: (i/max), green: 1, blue: 1)))));
      returnButtons.add(SizedBox(width: 100,));
      if (returnRowButtons.length == 6) {
        returnButtons.add(Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          ...returnRowButtons
        ],));
        returnButtons.add(SizedBox(height: 100,));
        returnRowButtons.clear();
        returnRowButtons.add(SizedBox(width: 100,));
      }
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ...returnButtons,
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          ...returnRowButtons
        ],)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center( 
        child: 
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
                                          ElevatedButton(onPressed: () {
                                            Navigator.push(context, MaterialPageRoute(builder: (_) => Mypage(point: widget.point, level: widget.level, size: 100, makedCompounds: widget.makedCompounds, BGM: widget.BGM,)));
                                          }, child: AutoTranslateText("戻る",style: TextStyle(fontSize: 20),),style: ButtonStyle(fixedSize: WidgetStatePropertyAll(Size(150, 150)))),
                                          SizedBox(height: 100,),
                                          makeStageSelectButton(24),
                                        ],
                                      )
                                    )
                    )
                    )
          )
      )
    );
  }
}

class RuletPage extends StatefulWidget {

  final int point;
  final int level;
  final List<String> makedCompounds;
  final AudioPlayer BGM;

  final int size;

  const RuletPage({Key? key, required this.point, required this.level, required this.size, required this.makedCompounds, required this.BGM}) : super(key: key);

  @override
  State<RuletPage> createState() => RuletState();
}

class RuletState extends State<RuletPage> {

  final ScrollController height = ScrollController();
  final ScrollController width = ScrollController();

  bool isturning = true;
  int quarter = 0;  

  @override
  void initState() {
    super.initState();

    Rotation();
  }

  void Rotation() async {
    int num = 0;
    while (isturning == true) {
      quarter = quarter + 3;
      if (quarter == 361) {
        quarter = 0;
      }
      Future.delayed(Duration(milliseconds: 900));
    }
    while (num != 10) {
      quarter++;
      num++;
      Future.delayed(Duration(milliseconds: 900));
    }  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center( 
        child: 
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
                                          SizedBox(height: 100,),
                                          Stack(alignment: Alignment.center, children: [
                                            RotatedBox(quarterTurns: quarter, child: GestureDetector(
                                              onTap: () {
                                                isturning = false;                                                
                                              },
                                              child: LanguageService.language.value == "ja"? Image.asset("images/Rulet") : Image.asset("images/Rulet_English"),
                                            ),),
                                            Image.asset("images/RuletArrow"),
                                          ],),
                                          SizedBox(height: 200,),
                                        ],
                                      )
                                    )
                    )
                    )
          )
      )
    );
  }
}