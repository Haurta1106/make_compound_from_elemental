import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:make_compound_from_elemental/main.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:auto_translate_text_widget/auto_translate_text_widget.dart';

class Encyclopediapage extends StatefulWidget {
  final List<String> makedCompounds;
  final int point;
  final int level;
  final AudioPlayer BGM;

  const Encyclopediapage({Key? key, required this.makedCompounds, required this.level, required this.point, required this.BGM}) : super(key: key);

  @override
  State<Encyclopediapage> createState() => Encyclopediastate();
}

class Encyclopediastate extends State<Encyclopediapage> {

  final ScrollController height = ScrollController();
  final ScrollController width = ScrollController();
  final TextEditingController search = TextEditingController();
  final TextEditingController search2 = TextEditingController();
  String searchKeyjaall = "";
  String searchKeyenall = "";
  String searchKey = "";
  String messageText = "";
  String languageText = "";
  bool isShowFumola = false;

  Future<void> setSearchKey() async {
    searchKey = await AutoTranslate.translateText(search.text, to: "en");
  }
  Future<void> setSearch() async {
    searchKeyjaall = await AutoTranslate.translateText(search.text, to: "ja");
  }
  Future<void> setMessageText() async {
    messageText = await AutoTranslate.translateText('''化合物は${widget.makedCompounds.toSet().length}種類作ったよ!
${widget.makedCompounds.toSet().length != 0? "作ったのは${widget.makedCompounds.toSet().join("と")}だよ!" : ""}
今レベル${widget.level}だよ!''', to: LanguageService.language.value);
  }

  @override
  void initState() {
    super.initState();

    languageText = LanguageService.language.value;
  }

  List<Widget> makeEncyclopedia() {
    setSearch();
    String searchKeyja = searchKeyjaall;
    String searchKeyen = searchKeyenall;
    String searchKey2 = search2.text;
    List<Widget> showlist = [];
    List<Widget> makeshowlist = [];
    List<String> showstr = ["H2", "N2", "O2", "O3", "F2", "Cl2", "Br2",
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

    List<String> japanese = ["水素分子", "窒素分子", "酸素分子", "オゾン", "フッ素分子", "塩素分子", "臭素分子",
    "水素化ホウ素", "メタン", "アンモニア", "水", "フッ化水素", "水素化アルミニウム","水素化ケイ素",
    "ホスフィン", "硫化水素", "塩化水素", "水素化ガリウム", "水素化ゲルマニウム", "アルシン", "セレン化水素", "臭化水素",
    "水素化インジウム", "水素化スズ", "テルル化水素", "ヨウ化水素", "水素化タリウム", "水素化鉛", "ビスムチン・水素化ビスマス",
    "メチルリチウム", "アジ化リチウム", "塩化リチウム", "過酸化リチウム", "酸化リチウム", "次亜塩素酸リチウム", "四ホウ酸リチウム",
    "臭化リチウム", "硝酸リチウム", "水酸化リチウム", "水素化アルミニウムリチウム", "水素化リチウム", "炭酸リチウム",
    "タンタル酸リチウム", "窒化リチウム", "ニオブ酸リチウム", "フッ化リチウム", "ヘキサフルオロリン酸リチウム", "ヨウ化リチウム",
    "硫化リチウム", "硫酸リチウム", "臭化ベリリウム", "炭化ベリリウム", "塩化ベリリウム",
    "炭酸ベリリウム", "フッ化ベリリウム", "水素化ベリリウム", "ヨウ化ベリリウム", "窒化ベリリウム", "酸化ベリリウム",
    "リン化ベリリウム", "硫化ベリリウム", "セレン化ベリリウム", "硫酸ベリリウム", "テルル化ベリリウム", "ヒ化ホウ素", "三臭化ホウ素",
    "四臭化ホウ素", "三塩化ホウ素", "四塩化ホウ素", "一フッ化ホウ素", "三フッ化ホウ素", "四フッ化二ホウ素", "ジボラン",
    "三ヨウ化ホウ素", "四ヨウ化二ホウ素", "窒化ホウ素", "一酸化ホウ素", "酸化ホウ素", "リン化ホウ素", "硫化ホウ素", "ボラジン",
    "テトラフルオロホウ酸", "メタホウ酸", "二酸化炭素", "一酸化炭素", "亜酸化炭素", "一酸化二炭素", "三酸化炭素", "炭酸",
    "炭酸カリウム", "炭酸カルシウム", "炭酸ナトリウム", "炭酸バリウム", "炭酸マグネシウム", "炭酸同(II)", "炭酸鉄(II)", "炭酸銀(I)",
    "炭酸水素カリウム", "三臭化窒素", "三塩化窒素", "三フッ化窒素", "二フッ化二窒素", "四フッ化二窒素", "ジアゼン", "ヒドラジン",
    "三ヨウ化窒素", "一酸化窒素", "二酸化窒素", "一酸化二窒素", "三酸化二窒素", "四酸化二窒素", "五酸化二窒素", "二硫化二窒素",
    "四硫化二窒素", "四硫化四窒素", "亜硝酸", "硝酸", "次亜硝酸", "臭化シアン", "塩化シアン", "フッ化シアン", "ヨウ化シアン",
    "臭化ニトロシル", "塩化ニトロシル", "塩化ニトロイル", "フッ化ニトロシル", "フッ化ニトロイル", "一フッ化チアジル",
    "三フッ化チアジル", "イソシアン酸", "テトラフルオロホウ酸ニトロシル", "テトラフルオロホウ酸ニトロイル", "二フッ化酸素",
    "一フッ化二酸素", "二フッ化二酸素", "二フッ化四酸素", "フッ化アルミニウム", "フッ化カルシウム", "フッ化ナトリウム",
    "六フッ化ウラン", "四フッ化炭素", "四フッ化硫黄", "六フッ化硫黄", "二フッ化キセノン", "四フッ化キセノン", "六フッ化キセノン",
    "ヘキサフルオロ白金酸キセノン", "ヒ化ナトリウム", "臭化ナトリウム", "炭化ナトリウム", "塩化ナトリウム", "水素化ナトリウム",
    "ヨウ化ナトリウム", "三ヨウ化ナトリウム", "アジ化ナトリウム", "窒化ナトリウム", "超酸化ナトリウム", "オゾン化ナトリウム",
    "過酸化ナトリウム", "酸化ナトリウム", "ポロニウム化ナトリウム", "リン化ナトリウム", "硫化ナトリウム", "セレン化ナトリウム",
    "テルル化ナトリウム", "ヘキサフルオロアルミン酸ナトリウム", "テトラヒドリドアルミン酸ナトリウム",
    "テトラクロロ金(III)酸ナトリウム", "テトラフルオロホウ酸ナトリウム", "水素化ホウ素ナトリウム", "四ホウ酸ナトリウム",
    "ナトリウムメタニド", "シュウ酸ナトリウム", "シアン化ナトリウム", "ナトリウムシアナミド", "フッ化水素ナトリウム",
    "硫化水素ナトリウム", "セレン化水素ナトリウム", "ナトリウムアミド", "水酸化ナトリウム", "ヘキサフルオロリン酸ナトリウム",
    "テトラクロロ白金(II)酸ナトリウム", "ヘキサクロロ白金(IV)酸ナトリウム", "ヘキサフルオロケイ酸ナトリウム", "ナトリウムフェノキシド",
    "シアノ水素化ホウ素ナトリウム", "ナトリウムメトキシド", "シアン酸ナトリウム", "チオシアン酸ナトリウム", "アルミン酸ナトリウム",
    "ビスマス酸ナトリウム", "メタホウ酸ナトリウム", "八ホウ酸ナトリウム", "ホウ酸ナトリウム", "次亜臭素酸ナトリウム",
    "亜臭素酸ナトリウム", "臭素酸ナトリウム", "過臭素酸ナトリウム", "次亜塩素酸ナトリウム", "亜塩素酸ナトリウム", "塩素酸ナトリウム",
    "過塩素酸ナトリウム", "クロム酸ナトリウム", "二クロム酸ナトリウム", "次亜ヨウ素酸ナトリウム", "亜ヨウ素酸ナトリウム",
    "ヨウ素酸ナトリウム", "過ヨウ素酸ナトリウム", "オルト過ヨウ素酸ナトリウム", "過マンガン酸ナトリウム", "マンガン酸ナトリウム",
    "亜マンガン酸ナトリウム", "亜硝酸ナトリウム", "硝酸ナトリウム", "ホスフィン酸ナトリウム", "ホスホン酸ナトリウム",
    "フルオロリン酸ナトリウム", "チオリン酸ナトリウム", "ジチオリン酸ナトリウム", "リン酸ナトリウム", "二リン酸ナトリウム",
    "三リン酸ナトリウム", "過レニウム酸ナトリウム", "亜セレン酸ナトリウム", "セレン酸ナトリウム", "ケイ酸ナトリウム",
    "亜硫酸ナトリウム", "硫酸ナトリウム", "チオ硫酸ナトリウム", "亜ジチオン酸ナトリウム", "二亜硫酸ナトリウム",
    "ジチオン酸ナトリウム", "二硫酸ナトリウム", "ペルオキソ二硫酸ナトリウム", "トリチオン酸ナトリウム", "過テクネチウム酸ナトリウム",
    "亜テルル酸ナトリウム", "メタバナジン酸ナトリウム", "オルトバナジン酸ナトリウム", "タングステン酸ナトリウム", "炭酸水素ナトリウム",
    "リン酸二水素ナトリウム", "リン酸水素二ナトリウム",
    "二リン酸二水素二ナトリウム", "二リン酸水素三ナトリウム", "亜セレン酸水素ナトリウム", "セレン酸水素ナトリウム",
    "亜硫酸水素ナトリウム", "硫酸水素ナトリウム", "二ホウ化マグネシウム", "臭化マグネシウム", "二炭化マグネシウム", "塩化マグネシウム",
    "フッ化マグネシウム", "水素化マグネシウム", "ヨウ化マグネシウム", "窒化マグネシウム", "酸化マグネシウム", "過酸化マグネシウム",
    "リン化マグネシウム", "硫化マグネシウム", "セレン化マグネシウム", "ケイ化マグネシウム", "亜硫酸マグネシウム", "硫酸マグネシウム",
    "二ウラン酸マグネシウム", "リン酸水素マグネシウム", "ヒ化アルミニウム", "二ホウ化アルミニウム", "十二ホウ化アルミニウム",
    "臭化アルミニウム", "三炭化四アルミニウム", "一塩化アルミニウム", "塩化アルミニウム", "一フッ化アルミニウム",
    "一ヨウ化アルミニウム", "ヨウ化アルミニウム", "窒化アルミニウム", "一酸化アルミニウム", "一酸化二アルミニウム", "酸化アルミニウム",
    "リン化アルミニウム", "硫化アルミニウム", "アンチモン化アルミニウム", "セレン化アルミニウム", "テルル化アルミニウム",
    "リン酸アルミニウム", "二臭化ケイ素", "四臭化ケイ素", "炭化ケイ素", "二塩化ケイ素", "四塩化ケイ素", "二フッ化ケイ素",
    "四フッ化ケイ素", "ジシラン", "四ヨウ化ケイ素", "窒化ケイ素", "一酸化ケイ素", "二酸化ケイ素", "二硫化ケイ素",
    "ヘキサフルオロケイ酸", "三臭化リン", "五臭化リン", "三塩化リン", "五塩化リン", "四塩化二リン", "三フッ化リン", "五フッ化リン",
    "四フッ化二リン", "ジホスフィン", "三ヨウ化リン", "四ヨウ化二リン", "一窒化リン", "三酸化二リン", "五酸化二リン", "五硫化二リン",
    "三硫化四リン", "五セレン化二リン", "三セレン化四リン", "臭化ホスホリル", "塩化ホスホリル", "フッ化ホスホリル", "ヨウ化ホスホリル",
    "臭化チオホスホリル", "塩化チオホスホリル", "フッ化チオホスホリル", "ヨウ化チオホスホリル", "二臭化硫黄", "四臭化硫黄",
    "二臭化二硫黄", "二塩化硫黄", "四塩化硫黄", "二塩化二硫黄", "二フッ化硫黄", "二フッ化二硫黄", "四フッ化二硫黄", "十フッ化二硫黄",
    "一酸化硫黄", "二酸化硫黄", "三酸化硫黄", "一酸化二硫黄", "亜硫酸", "硫酸", "ペルオキソ一硫酸", "チオ硫酸", "亜ジチオン酸",
    "二亜硫酸", "ジチオン酸", "二硫酸", "ペルオキソ二硫酸", "臭化チオニル", "塩化チオニル", "二フッ化チオニル", "四フッ化チオニル",
    "塩化スルフリル", "フッ化スルフリル", "一フッ化塩素", "三フッ化塩素", "五フッ化塩素", "硝酸塩素", "一酸化塩素", "二酸化塩素",
    "一酸化二塩素", "過塩素酸塩素", "六酸化二塩素", "七酸化二塩素", "三フッ化クロロシル", "一フッ化クロリル", "三フッ化クロリル",
    "フッ化ペルクロリル", "次亜塩素酸", "亜塩素酸", "塩素酸", "過塩素酸", "アルゴンフッ素水素化物", "ヒ化カリウム", "臭化カリウム",
    "炭化カリウム", "塩化カリウム", "フッ化カリウム", "水素化カリウム", "ヨウ化カリウム", "三ヨウ化カリウム", "アジ化カリウム",
    "窒化カリウム", "超酸化カリウム", "オゾン化カリウム", "酸化カリウム", "過酸化カリウム", "リン化カリウム", "硫化カリウム",
    "セレン化カリウム", "テルル化カリウム", "テトラフルオロアルミン酸カリウム", "テトラフルオロホウ酸カリウム",
    "テトラヒドロホウ酸カリウム", "カリウムメタニド", "シアン化カリウム", "フッ化水素カリウム", "硫化水素カリウム", "カリウムアミド",
    "水酸化カリウム", "ヘキサフルオロリン酸カリウム", "カリウムメトキシド", "雷酸カリウム", "チオシアン酸カリウム", "ヒ化カルシウム",
    "六ホウ化カルシウム", "臭化カルシウム", "炭化カルシウム", "塩化カルシウム", "水素化カルシウム", "ヨウ化カルシウム",
    "二窒化三カルシウム", "酸化カルシウム", "過酸化カルシウム", "二リン化三カルシウム", "硫化カルシウム",
    "セレン化カルシウム", "一ケイ化カルシウム", "二ケイ化カルシウム", "テルル化カルシウム", "カルシウムシアナミド",
    "シュウ酸カルシウム", "クロム酸カルシウム", "二クロム酸カルシウム", "二リン酸カルシウム", "セレン酸カルシウム",
    "ケイ酸カルシウム", "チタン酸カルシウム", "チタン酸カルシウム", "リン酸水素カルシウム", "十二ホウ化スカンジウム",
    "臭化スカンジウム(III)", "塩化スカンジウム(III)", "フッ化スカンジウム(III)", "水素化スカンジウム", "ヨウ化スカンジウム(III)",
    "窒化スカンジウム", "酸化スカンジウム(III)", "硫化スカンジウム(III)", "二ホウ化チタン", "臭化チタン(III)", "臭化チタン(IV)",
    "炭化チタン", "塩化チタン(II)", "塩化チタン(III)", "塩化チタン(IV)", "フッ化チタン(II)", "フッ化チタン(III)",
    "フッ化チタン(IV)", "水素化チタン", "ヨウ化チタン(III)", "ヨウ化チタン(IV)", "窒化チタン", "酸化チタン(II)",
    "酸化チタン(IV)", "酸化チタン(III)", "一リン化チタン", "硫化チタン(II)", "硫化チタン(IV)", "硫化チタン(III)",
    "二ケイ化チタン", "臭化バナジウム(II)", "臭化バナジウム(III)", "臭化バナジウム(IV)", "炭化バナジウム", "塩化バナジウム(II)",
    "塩化バナジウム(III)", "塩化バナジウム(IV)", "ヨウ化バナジウム(II)", "ヨウ化バナジウム(III)", "窒化バナジウム",
    "酸化バナジウム(II)", "酸化バナジウム(IV)", "酸化バナジウム(III)", "酸化バナジウム(V)", "リン化バナジウム", "硫化バナジウム(II)",
    "セレン化バナジウム(II)", "一臭化酸化バナジウム(III)", "二臭化酸化バナジウム(IV)", "三臭化酸化バナジウム(V)",
    "一塩化酸化バナジウム(III)", "二塩化酸化バナジウム(IV)", "三塩化酸化バナジウム(V)",
    "一フッ化酸化バナジウム(III)", "二フッ化酸化バナジウム(IV)", "三フッ化酸化バナジウム(V)", "二ヨウ化酸化バナジウム(IV)",
    "硫酸バナジウム(II)", "臭化クロム(II)", "臭化クロム(III)", "二炭化三クロム", "塩化クロム(II)", "塩化クロム(III)",
    "フッ化クロム(II)", "フッ化クロム(III)", "フッ化クロム(IV)", "フッ化クロム(V)", "フッ化クロム(VI)",
    "ヨウ化クロム(II)", "ヨウ化クロム(III)", "一窒化クロム", "酸化クロム(II)", "酸化クロム(IV)", "酸化クロム(VI)",
    "過酸化クロム(VI)", "酸化クロム(III)", "一リン化クロム", "硫化クロム(II)", "塩化クロミル(VI)", "フッ化クロミル(VI)",
    "臭化マンガン(II)", "臭化マンガン(III)", "塩化マンガン(II)", "塩化マンガン(III)", "塩化マンガン(IV)", "フッ化マンガン(II)",
    "フッ化マンガン(III)", "フッ化マンガン(IV)", "ヨウ化マンガン(II)", "酸化マンガン(II)", "酸化マンガン(IV)", "酸化マンガン(III)",
    "酸化マンガン(VII)", "四酸化三マンガン", "硫化マンガン(II)", "硫化マンガン(IV)", "セレン化マンガン(II)", "セレン化マンガン(IV)",
    "過マンガン酸", "マンガン酸", "炭酸マンガン(II)", "セレン酸マンガン(II)", "亜硫酸マンガン(II)", "硫酸マンガン(II)",
    "臭化鉄(II)", "臭化鉄(III)", "一炭化三鉄", "塩化鉄(II)", "塩化鉄(III)", "フッ化鉄(II)", "フッ化鉄(III)", "水素化鉄(II)", "ヨウ化鉄(II)",
    "ヨウ化鉄(III)", "一窒化三鉄", "酸化鉄(II)", "酸化鉄(III)", "四酸化三鉄", "硫化鉄(II)", "二硫化鉄(II)", "硫化鉄(III)", "四硫化三鉄",
    "セレン化鉄(II)", "セレン化鉄(III)", "二ケイ化鉄", "炭酸鉄(II)", "シュウ酸鉄(II)", "マンガン酸鉄(II)", "モリブデン酸鉄(II)", "リン酸鉄(III)",
    "セレン酸鉄(II)", "亜硫酸鉄(II)", "硫酸鉄(II)", "鉄酸", "臭化コバルト(II)", "塩化コバルト(II)", "塩化コバルト(III)", "フッ化コバルト(II)",
    "フッ化コバルト(III)", "ヨウ化コバルト(II)", "酸化コバルト(II)", "酸化コバルト(III)", "四酸化三コバルト", "硫化コバルト(II)", "二硫化コバルト(II)",
    "四硫化三コバルト", "炭酸コバルト(II)", "シュウ酸コバルト(II)", "クロム酸コバルト(II)", "亜硫酸コバルト(II)", "硫酸コバルト(II)",
    "メタチタン酸コバルト(II)", "臭化ニッケル(II)", "塩化ニッケル(II)", "フッ化ニッケル(II)", "ヨウ化ニッケル(II)", "酸化ニッケル(II)", "過酸化ニッケル",
    "酸化ニッケル(III)", "硫化ニッケル(II)", "二硫化ニッケル(II)", "炭酸ニッケル(II)", "クロム酸ニッケル(II)", "亜硫酸ニッケル(II)", "硫酸ニッケル(II)",
    "ベンゼン", "フェノール", "ナフタレン", "グルコース・ブドウ糖", "スクロース・ショ糖", "臭化銀", "硝酸銀", "ジフルオロメタン", "エタノール", "エタンチオール",
    "エチルシアノアクリレート", "硫酸カルシウム", "酸化セリウム", "ヒ化ガリウム", "窒化ガリウム", "正長石", "アルミン酸ストロンチウム", 
    ];

    Set<String> makedCompoundsSet = {};
    int num = 0;

    for (var element in widget.makedCompounds) {
      try {
        makedCompoundsSet.add(element);
      } catch (e) {
        
      }
    }
    if (searchKey2 == "") {
      if (search.text == "") {
        for (var element in showstr) {
          makeshowlist.add(GestureDetector(
            onTap: () async {
                    final Uri url = Uri.parse("https://www.bing.com/search?q=${element} ${languageText == "ja"? "化合物" : "compound"}&form=ANNTH1&refig=6a51b9a8058342e398083733d638d48b&pc=NMTS");                         
                    try {
                      await launchUrl(url, mode: LaunchMode.externalApplication);
                    } catch (e) {
                      
                    }
            },
            child: Container(decoration: BoxDecoration(color: makedCompoundsSet.contains(element)? Colors.white : Colors.grey[700], border: Border.all(color: makedCompoundsSet.contains(element)? Colors.amber : Colors.grey[700]!)),width: 150,height: 150, child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star, color: makedCompoundsSet.contains(element)? Colors.yellow : Colors.grey[700],),
                SizedBox(height: 10,),
                Text(element, style: TextStyle(color: makedCompoundsSet.contains(element)? Colors.black : (isShowFumola? Colors.black : Colors.grey[700]))),
                SizedBox(height: 5,),
                AutoTranslateText("${japanese[showstr.indexOf(element)]}",),
              ],
            ),),
          ));
          makeshowlist.add(SizedBox(width: 10,));
          num++;
          if (num == 5) {
            showlist.add(Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...makeshowlist
            ],));
            showlist.add(SizedBox(height: 10,));
            makeshowlist.clear();
            num = 0;
          }
        }
      }      
    } else {
      for (var element in showstr) {
        if (element.contains(searchKey2)) {
                makeshowlist.add(GestureDetector(
                  onTap: () async {
                    final Uri url = Uri.parse("https://www.bing.com/search?q=${element} ${LanguageService.language.value == "ja"? "化合物" : "compound"}&form=ANNTH1&refig=6a51b9a8058342e398083733d638d48b&pc=NMTS");               
                    try {
                      await launchUrl(url, mode: LaunchMode.externalApplication);
                    } catch (e) {
                      
                    }
                  },
                  child: Container(color: makedCompoundsSet.contains(element)? Colors.white : Colors.grey[700],width: 150,height: 150, child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.star, color: makedCompoundsSet.contains(element)? Colors.yellow : Colors.grey[700],),
                      SizedBox(height: 10,),
                      Text(element, style: TextStyle(color: makedCompoundsSet.contains(element)? Colors.black : (isShowFumola? Colors.black : Colors.grey[700]))),
                      SizedBox(height: 5,),
                      AutoTranslateText("${japanese[showstr.indexOf(element)]}",),
                    ],
                  ),),
                ));
                makeshowlist.add(SizedBox(width: 10,));
                num++;
                if (num == 5) {
                  showlist.add(Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ...makeshowlist
                  ],));
                  showlist.add(SizedBox(height: 10,));
                  makeshowlist.clear();
                  num = 0;
          }
        }
      }
    }
    

    return [Column(mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ...showlist,
        SizedBox(height: 10,),
        Row(mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ...makeshowlist 
        ],)
      ],
    )];
  }

  List<String> decomposeFormula(String formula) {
    final matches =
        RegExp(r'([A-Z][a-z]?)(\d*)').allMatches(formula);

    List<String> result = [];

    for (final m in matches) {
      final symbol = m.group(1)!;
      final countText = m.group(2)!;

      int count =
          countText.isEmpty ? 1 : int.parse(countText);

      for (int i = 0; i < count; i++) {
        result.add(symbol);
      }
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Scrollbar(
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
                                      child:  Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 200,),
          ElevatedButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (_) => Mypage(point: widget.point, level: widget.level, size: 100, makedCompounds: widget.makedCompounds, BGM: widget.BGM,)));
          }, child: AutoTranslateText("ホームへ",style: TextStyle(fontSize: 20),),style: ButtonStyle(fixedSize: WidgetStatePropertyAll(Size(150, 150)))),
          SizedBox(height: 50,),
          /*ElevatedButton(onPressed: () async {
            messageText = await AutoTranslate.translateText('''化合物は${widget.makedCompounds.toSet().length}種類作ったよ!
${widget.makedCompounds.toSet().length != 0? "作ったのは${widget.makedCompounds.toSet().join("と")}だよ!" : ""}
今レベル${widget.level}だよ!''', to: languageText);
            String text = messageText;
            String subject = "${languageText == "ja"? "シェア先を選択" : "Select where to share"}";
            Share.share(text, subject: subject);
          }, child: AutoTranslateText("作った化合物をシェアする",style: TextStyle(fontSize: 20),),style: ButtonStyle(fixedSize: WidgetStatePropertyAll(Size(300, 150)))),
          SizedBox(height: 50,),*/
          ElevatedButton(onPressed: () async {
            messageText = await AutoTranslate.translateText('''化合物は${widget.makedCompounds.toSet().length}種類作ったよ!
${widget.makedCompounds.toSet().length != 0? "作ったのは${widget.makedCompounds.toSet().join("と")}だよ!" : ""}
今レベル${widget.level}だよ!''', to: languageText);
            String text = messageText;
            await Clipboard.setData(ClipboardData(text: text));
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${LanguageService.language.value == "ja"? "テキストをコピーしました：": "Text copied:"}${text}")));
          }, child: AutoTranslateText("作った化合物リストをコピーする",style: TextStyle(fontSize: 20)),style: ButtonStyle(fixedSize: WidgetStatePropertyAll(Size(500, 150)))),
          SizedBox(height: 50,),
          SizedBox(
            child: AutoTranslateText("検索", style: TextStyle(fontSize: 25),),
          ),          
          SizedBox(height: 10,),
          AutoTranslateText("※検索した文字が含まれていると表示されます"),
          AutoTranslateText("例1 H → NH3は表示される"),
          AutoTranslateText("例2 H2 → NH3は表示されない"),
          AutoTranslateText("例3 N → NaOHも表示される"),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(
              height: 100,
              width: 750,
              child: 
                TextField(
                  controller: search2,
                  decoration: InputDecoration(
                    label: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search),
                        AutoTranslateText("化学式で検索"),
                      ],
                    )
                  ),
                  onChanged: (value) => setState(() {
                    
                  }),
                ),
            ),
          ],),
          SizedBox(height: 50,),
          AutoTranslateText("化合物図鑑 ", style: TextStyle(fontSize: 50),),
          SizedBox(height: 50,),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            AutoTranslateText("図鑑をタップするとその化合物について調べられます"),
            SizedBox(width: 50,),
            ElevatedButton(onPressed: () {
              setState(() {
                isShowFumola = !isShowFumola;
              });
            }, child: isShowFumola? AutoTranslateText("化学式も表示する") : AutoTranslateText("化学式は表示しない"),style: ButtonStyle(fixedSize: WidgetStatePropertyAll(Size(200, 200)))),
          ],),          
          SizedBox(height: 50,),
          Row(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...makeEncyclopedia()
          ],),
          SizedBox(height: 200,),
        ],
      )),))))
    );
  }
}