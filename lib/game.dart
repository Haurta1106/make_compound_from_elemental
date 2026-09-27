import 'dart:math';

import 'package:flame/geometry.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/effects.dart';
import 'package:make_compound_from_elemental/score.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:auto_translate_text_widget/auto_translate_text_widget.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

enum gamemode {
  puzzle, freedom,
}

class Mygamepage extends StatefulWidget {

  final gamemode gamemodesettings;

  final int point;
  final int level;
  final List<String> makedCompounds;
  final int stage;

  final int size;

  final AudioPlayer BGM;

  const Mygamepage({Key? key, required this.gamemodesettings, required this.point, required this.level, required this.size, required this.makedCompounds, required this.BGM, required this.stage}) : super(key: key);

  @override
  State<Mygamepage> createState() => mygamestate();
}

class mygamestate extends State<Mygamepage> {

  final ScrollController height = ScrollController();
  final ScrollController width = ScrollController();
  final TextEditingController ID = TextEditingController();
  int level = 0;
  int point = 0;

  bool isCombination = false;

  double leftrightPosition = 1;
  bool isPressingright = false;

  double size = 1;
  
  final AudioPlayer audioPlayer = AudioPlayer();

  Map<String, Map<String, int>> makeedCompounds = {};

  Map<String, String> compoundsJapanese = {};

   List<List<Widget>> Effects = [
    [SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),],
    [SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),],
    [SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),],
    [SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),],
    [SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),],
    [SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),],
    [SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),],
    [SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),],
    [SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),],
    [SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),],
    [SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),],
    [SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),],
    [SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),],
    ];

  List<List<String>> elemental = [
    ["block","","","","","","","","","","","","","","","","","block",],
    ["block","","","","","","","","","","","","","","","","","block",],
    ["block","","","","","","","","","","","","","","","","","block",],
    ["block","","","","","","","","","","","","","","","","","block",],
    ["block","","","","","","","","","","","","","","","","","block",],
    ["block","block","","","","","","","","","","","block","block","block","block","block","block",],
    ["block","block","","","","","","","","","","","block","block","block","block","block","block",],
    ["block","block","block","block","block","block","block","block","block","block","block","block","block","block","block","block","block","block",],
    ["block","block","block","block","block","block","block","block","block","block","block","block","block","block","block","block","block","block",],
    ["block","block","block","block","block","block","block","block","block","block","block","block","block","block","block","block","block","block",],
    ["block","block","block","block","block","block","block","block","block","block","block","block","block","block","block","block","block","block",],
    ["block","block","block","block","block","block","block","block","block","block","block","block","block","block","block","block","block","block",],
    ["block","block","block","block","block","block","block","block","block","block","block","block","block","block","block","block","block","block",],
    ];
  List<List<bool>> isMoveOK = [
    [false, true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true, false,],
    [false, true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true, false,],
    [false, true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true, false,],
    [false, true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true, false,],
    [false, true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true, false,],
    [false, false,true,true,true,true,true,true,true,true,true,true,false,false,false,false,false, false,],
    [false, false,true,true,true,true,true,true,true,true,true,true,false,false,false,false,false, false,],
    [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,],
    [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,],
    [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,],
    [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,],
    [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,],
    [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,],
  ];

  List<List<bool>> isCanBlending = [
    [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,],
    [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,],
    [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,],
    [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,],
    [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,],
    [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,],
    [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,],
    [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,],
    [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,],
    [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,],
    [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,],
    [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,],
    [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,],
  ];

  List<List<bool>> isMouseOn = [
    [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,],
    [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,],
    [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,],
    [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,],
    [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,],
    [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,],
    [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,],
    [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,],
    [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,],
  ];

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

  List<List<String>> puzzleelemental = [];

  Map<String, String> addingJA = {};

  Map<String,String> compoundsdic = {};

  List<String> allowedElements = [];

  bool isnotshuffle = false;

  bool isNotDo = true;

  int madeCount = 0;
  
  String nextRandomElemental = "";

  Stopwatch timer = Stopwatch();

  bool isCompletebool = false;

  @override
    void initState() {
      super.initState();
      final removed = removeDuplicates(compounds, japanese);
      point = widget.point;
      level = widget.level;

      compounds = removed.keys.toList();
      japanese = removed.values.toList();
      if (compounds.length == japanese.length) {
        compoundsdic = makeCompounds(compounds);

        for (var element in compounds) {
          addingJA.addAll({element : japanese[compounds.indexOf(element)]});
        }

        compoundsJapanese.addEntries(addingJA.entries);

        setState(() {
          puzzle();
        });
      }

      if (widget.gamemodesettings == gamemode.puzzle) {
        summonRandomElemental();
      }

      timer.start();

      
    }

  Future<void> summonRandomElemental() async {
    List<String> RandomResult = List.from(allowedElements);
    while (isCompletebool == false) {
      RandomResult.shuffle();
      nextRandomElemental = RandomResult[0];
      await Future.delayed(Duration(seconds: 7));      
      setState(() {
        spawnElementalPuzzle(RandomResult[0], int.parse("$leftrightPosition"));
      });            
    }
  }

  void spawnElementalPuzzle(String elementalName, int wherethis) async {
    if (elemental[0][int.parse("$leftrightPosition")] == "") {
      if (elemental[1][int.parse("$leftrightPosition")] == "") {
        elemental[0].fillRange(int.parse("$leftrightPosition"), int.parse("$leftrightPosition")+1, "$elementalName");
        String element = elementalName;
        int where = wherethis;
          int whereline = 0;
            isMoveOK[whereline][where] = false;          
            while (whereline + 1 < elemental.length && elemental[whereline+1][where] != "block") {
              await Future.delayed(Duration(seconds: 1));
              if (elemental[whereline+1][int.parse("$leftrightPosition")] == "") {
                setState(() {
                  elemental[whereline+1].fillRange(int.parse("$leftrightPosition"), int.parse("$leftrightPosition")+1, "$element");
                  isMoveOK[whereline+1].fillRange(where, where+1, false);
                  elemental[whereline].fillRange(where, where+1, ""); 
                  isMoveOK[whereline].fillRange(int.parse("$leftrightPosition"), int.parse("$leftrightPosition")+1, true);               
                  whereline = whereline + 1;
                  where = int.parse("$leftrightPosition");
                });
              } else {
                setState(() {
                  element = addElement(
                    elemental[whereline+1][int.parse("$leftrightPosition")],
                    element,
                  );
                  elemental[whereline+1].fillRange(int.parse("$leftrightPosition"), int.parse("$leftrightPosition")+1, "$element");
                  isMoveOK[whereline+1].fillRange(where, where+1, false);
                  elemental[whereline].fillRange(where, where+1, "");
                  isMoveOK[whereline].fillRange(int.parse("$leftrightPosition"), int.parse("$leftrightPosition")+1, true);
                  isCanBlending[whereline+1].fillRange(int.parse("$leftrightPosition"), int.parse("$leftrightPosition")+1, isCanBlendingFunction(element));             
                  whereline = whereline + 1;
                  where = int.parse("$leftrightPosition");
                });
              }            
            }
            if (elemental[whereline-1][where] == "") {
              isMoveOK[whereline].fillRange(where, where+1, true);
            }
          }
      } else {
        if (elemental[2][int.parse("$leftrightPosition")] != "") {
          elemental[0].fillRange(int.parse("$leftrightPosition"), int.parse("$leftrightPosition")+1, "$elementalName");
            String element = elementalName;
            int where = wherethis;
              int whereline = 0;
                isMoveOK[whereline][where] = false;
                if (isCombination == false) {
                while (whereline + 1 < elemental.length && elemental[whereline+1][where] == "") {
                  await Future.delayed(Duration(seconds: 1));
                  setState(() {
                    elemental[whereline+1].fillRange(where, where+1, "$element");       
                    isMoveOK[whereline+1].fillRange(where, where+1, false);       
                    elemental[whereline].fillRange(where, where+1, "");
                    isMoveOK[whereline].fillRange(where, where+1, true);
                    whereline = whereline + 1;
                  });
                }
                if (elemental[whereline-1][where] == "") {
                  isMoveOK[whereline].fillRange(where, where+1, true);
                }
              }else {
                while (whereline + 1 < elemental.length && elemental[whereline+1][int.parse("$leftrightPosition")] != "block" && isMoveOK[whereline+1][int.parse("$leftrightPosition")] == true) {
                  await Future.delayed(Duration(seconds: 1));
                  if (elemental[whereline+1][int.parse("$leftrightPosition")] == "") {
                    setState(() {
                      elemental[whereline+1].fillRange(int.parse("$leftrightPosition"), int.parse("$leftrightPosition")+1, "$element");
                      isMoveOK[whereline+1].fillRange(where, where+1, false);
                      elemental[whereline].fillRange(where, where+1, ""); 
                      isMoveOK[whereline].fillRange(int.parse("$leftrightPosition"), int.parse("$leftrightPosition")+1, true);               
                      whereline = whereline + 1;
                      where = int.parse("$leftrightPosition");
                    });
                  } else {
                    setState(() {
                      element = addElement(
                        elemental[whereline+1][int.parse("$leftrightPosition")],
                        element,
                      );
                      elemental[whereline+1].fillRange(int.parse("$leftrightPosition"), int.parse("$leftrightPosition")+1, "$element");
                      isMoveOK[whereline+1].fillRange(where, where+1, false);
                      elemental[whereline].fillRange(where, where+1, "");
                      isMoveOK[whereline].fillRange(int.parse("$leftrightPosition"), int.parse("$leftrightPosition")+1, true);
                      isCanBlending[whereline+1].fillRange(int.parse("$leftrightPosition"), int.parse("$leftrightPosition")+1, isCanBlendingFunction(element));             
                      whereline = whereline + 1;
                      where = int.parse("$leftrightPosition");
                    });
                  }         
                }
                if (elemental[whereline-1][where] == "") {
                  isMoveOK[whereline].fillRange(where, where+1, true);
                }
              }
              isCanBlending[whereline-1].fillRange(where, where+1, false);
              isCanBlending[whereline].fillRange(where, where+1, isCanBlendingFunction(element));
              setIsCanBlending();
        }
      }
  }

  Future<void> initAudio() async {
    audioPlayer.audioCache = AudioCache(prefix: "");
    final source = AssetSource("audio/MakeCompoundFromElemental_Pop.wav");    
    await audioPlayer.play(source);   
    await audioPlayer.setReleaseMode(ReleaseMode.release); 
    await audioPlayer.setVolume(1);
  }

  Future<void> puzzle() async {
    if (widget.gamemodesettings == gamemode.puzzle) {

      isnotshuffle = false;

      puzzleelemental.clear();

      elemental = [
        ["block","","","","","","","","","","","","","","","","","block",],
        ["block","","","","","","","","","","","","","","","","","block",],
        ["block","","","","","","","","","","","","","","","","","block",],
        ["block","","","","","","","","","","","","","","","","","block",],
        ["block","","","","","","","","","","","","","","","","","block",],
        ["block","block","","","","","","","","","","","block","block","block","block","block","block",],
        ["block","block","","","","","","","","","","","block","block","block","block","block","block",],
        ["block","block","block","block","block","block","block","block","block","block","block","block","block","block","block","block","block","block",],
        ["block","block","block","block","block","block","block","block","block","block","block","block","block","block","block","block","block","block",],
        ["block","block","block","block","block","block","block","block","block","block","block","block","block","block","block","block","block","block",],
        ["block","block","block","block","block","block","block","block","block","block","block","block","block","block","block","block","block","block",],
        ["block","block","block","block","block","block","block","block","block","block","block","block","block","block","block","block","block","block",],
        ["block","block","block","block","block","block","block","block","block","block","block","block","block","block","block","block","block","block",],
      ];

      isMoveOK = [
        [false, true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true, false,],
        [false, true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true, false,],
        [false, true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true, false,],
        [false, true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true, false,],
        [false, true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true, false,],
        [false, false,true,true,true,true,true,true,true,true,true,true,false,false,false,false,false, false,],
        [false, false,true,true,true,true,true,true,true,true,true,true,false,false,false,false,false, false,],
        [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,],
        [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,],
        [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,],
        [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,],
        [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,],
        [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,],
      ];

      isCanBlending = [
        [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,],
        [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,],
        [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,],
        [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,],
        [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,],
        [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,],
        [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,],
        [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,],
        [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,],
        [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,],
        [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,],
        [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,],
        [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,],
      ];

      isMouseOn = [
        [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,],
        [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,],
        [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,],
        [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,],
        [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,],
        [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,],
        [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,],
        [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,],
        [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,],
      ];
      
      final shuffle = List<String>.from(compounds);
      shuffle.shuffle();
      if (widget.stage == 1) {
        allowedElements = ["H","O",];
      } else if (widget.stage == 2) {
        allowedElements = ["H","O","N"];
      } else if (widget.stage == 3) {
        allowedElements = ["H","O","N","C"];
      } else if (widget.stage == 4) {
        allowedElements = ["H","O","N","C","Na"];
      } else if (widget.stage == 5) {
        allowedElements = ["H","O","N","C","Na","Cl"];
      } else if (widget.stage == 6) {
        allowedElements = ["H","O","N","C","Na","Cl","S"];
      } else if (widget.stage == 7) {
        allowedElements = ["H","O","N","C","Na","Cl","S","K"];
      } else if (widget.stage == 8) {
        allowedElements = ["H","O","N","C","Na","Cl","S","K","Ca"];
      } else if (widget.stage == 9) {
        allowedElements = ["H","O","N","C","Na","Cl","S","K","Ca","Fe"];
      } else if (widget.stage == 10) {
        allowedElements = ["H","O","N","C","Na","Cl","S","K","Ca","Fe","F"];
      } else if (widget.stage == 11) {
        allowedElements = ["H","O","N","C","Na","Cl","S","K","Ca","Fe","F","P"];
      } else if (widget.stage == 12) {
        allowedElements = ["H","O","N","C","Na","Cl","S","K","Ca","Fe","F","P","V"];
      } else if (widget.stage == 13) {
        allowedElements = ["H","O","N","C","Na","Cl","S","K","Ca","Fe","F","P","V","Li"];
      } else if (widget.stage == 14) {
        allowedElements = ["H","O","N","C","Na","Cl","S","K","Ca","Fe","F","P","V","Li","Be"];
      } else if (widget.stage == 15) {
        allowedElements = ["H","O","N","C","Na","Cl","S","K","Ca","Fe","F","P","V","Li","Be","B"];
      } else if (widget.stage == 16) {
        allowedElements = ["H","O","N","C","Na","Cl","S","K","Ca","Fe","F","P","V","Li","Be","B","Mg"];
      } else if (widget.stage == 17) {
        allowedElements = ["H","O","N","C","Na","Cl","S","K","Ca","Fe","F","P","V","Li","Be","B","Mg","Al"];
      } else if (widget.stage ==18) {
        allowedElements = ["H","O","N","C","Na","Cl","S","K","Ca","Fe","F","P","V","Li","Be","B","Mg","Al","Si"];
      } else if (widget.stage == 19) {
        allowedElements = ["H","O","N","C","Na","Cl","S","K","Ca","Fe","F","P","V","Li","Be","B","Mg","Al","Si","Ar","Sc"];
      } else if (widget.stage == 20) {
        allowedElements = ["H","O","N","C","Na","Cl","S","K","Ca","Fe","F","P","V","Li","Be","B","Mg","Al","Si","Ar","Sc","Ti"];
      } else if (widget.stage == 21) {
        allowedElements = ["H","O","N","C","Na","Cl","S","K","Ca","Fe","F","P","V","Li","Be","B","Mg","Al","Si","Ar","Sc","Ti","Cr"];
      } else if (widget.stage == 22) {
        allowedElements = ["H","O","N","C","Na","Cl","S","K","Ca","Fe","F","P","V","Li","Be","B","Mg","Al","Si","Ar","Sc","Ti","Cr","Mn"];
      } else if (widget.stage == 23) {
        allowedElements = ["H","O","N","C","Na","Cl","S","K","Ca","Fe","F","P","V","Li","Be","B","Mg","Al","Si","Ar","Sc","Ti","Cr","Mn","Co"];
      } else if (widget.stage == 24) {
        allowedElements = ["H","O","N","C","Na","Cl","S","K","Ca","Fe","F","P","V","Li","Be","B","Mg","Al","Si","Ar","Sc","Ti","Cr","Mn","Co","Ni"];
      }

      List<int> maxLength = [4,6,6,6,6,6,6,6,6,6,6,4,4,4,4,4];


      for (int i = 0; i < shuffle.length; i++) {
        if (puzzleelemental.length < 16) {
          if (i == shuffle.length-1) {
            i = 0;
          }
        }
        if (decomposeFormula(shuffle[i]).length <= 5) {
          if (containsOnlyAllowedElements(shuffle[i])) {
            if (puzzleelemental.length < 16) {
              puzzleelemental.add(decomposeFormula(shuffle[i]));
            }  
          }  
        }
        if (puzzleelemental.length == 16) {
          break;
        }
      }

      puzzleelemental.shuffle();

      for (int i = 0; i < puzzleelemental.length; i++) {
        puzzleelemental[i].shuffle();

        if (puzzleelemental[i].isNotEmpty) {
          puzzleelemental[i].removeAt(0);
        }
      }

      for (int col = 0; col < puzzleelemental.length; col++) {
        for (final one in puzzleelemental[col]) {
          for (int row = elemental.length - 1; row >= 0; row--) {
            if (elemental[row][col + 1] == "") {
              elemental[row][col+1] = one;
              break;
            }
          }
        }
      }    
    }

    isnotshuffle = true;
    isCombination = true;
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

  Map<String, String> removeDuplicates(
    List<String> formulas,
    List<String> names,
  ) {
    Set<String> seenFormula = {};
    Set<String> seenName = {};
    Map<String, String> result = {};

    for (int i = formulas.length - 1; i >= 0; i--) {
      String formulaKey = normalizeText(formulas[i]);

      if (!seenFormula.contains(formulaKey) &&
          !seenName.contains(names[i])) {

        seenFormula.add(formulaKey);
        seenName.add(names[i]);

        result[formulas[i]] = names[i];
      }
    }

    return result;
  }

  Map<String,String> makeCompounds(List<String> textList) {
    Map<String,String> add = {};

    for (var element in textList) {
      add.putIfAbsent(
        normalizeText(element),
        () => element,
      );
    }

    return add;
  }

  void spawnElemental(String elementalName, int wherethis) async {
    if (elemental[0][int.parse("$leftrightPosition")] == "") {
      if (elemental[1][int.parse("$leftrightPosition")] == "") {
        elemental[0].fillRange(int.parse("$leftrightPosition"), int.parse("$leftrightPosition")+1, "$elementalName");
        String element = elementalName;
        int where = wherethis;
          int whereline = 0;
            isMoveOK[whereline][where] = false;
            if (isCombination == false) {
            while (whereline + 1 < elemental.length && elemental[whereline+1][where] == "") {
              await Future.delayed(Duration(seconds: 1));
              setState(() {
                elemental[whereline+1].fillRange(where, where+1, "$element");       
                isMoveOK[whereline+1].fillRange(where, where+1, false);       
                elemental[whereline].fillRange(where, where+1, "");
                isMoveOK[whereline].fillRange(where, where+1, true);
                whereline = whereline + 1;
              });
            }
            if (elemental[whereline-1][where] == "") {
              isMoveOK[whereline].fillRange(where, where+1, true);
            }
          }else {
            while (whereline + 1 < elemental.length && elemental[whereline+1][where] != "block" && isMoveOK[whereline+1][where] == true) {
              await Future.delayed(Duration(seconds: 1));
              if (elemental[whereline+1][where] == "") {
                setState(() {
                  elemental[whereline+1].fillRange(where, where+1, "$element");
                  isMoveOK[whereline+1].fillRange(where, where+1, false);
                  elemental[whereline].fillRange(where, where+1, ""); 
                  isMoveOK[whereline].fillRange(where, where+1, true);               
                  whereline = whereline + 1;
                });
              } else {
                setState(() {
                  element = addElement(
                    elemental[whereline+1][where],
                    element,
                  );
                  elemental[whereline+1].fillRange(where, where+1, "$element");
                  isMoveOK[whereline+1].fillRange(where, where+1, false);
                  elemental[whereline].fillRange(where, where+1, "");
                  isMoveOK[whereline].fillRange(where, where+1, true);
                  isCanBlending[whereline+1].fillRange(where, where+1, isCanBlendingFunction(element));             
                  whereline = whereline + 1;
                });
              }            
            }
            if (elemental[whereline-1][where] == "") {
              isMoveOK[whereline].fillRange(where, where+1, true);
            }
          }
      } else {
        if (elemental[2][int.parse("$leftrightPosition")] != "") {
          elemental[0].fillRange(int.parse("$leftrightPosition"), int.parse("$leftrightPosition")+1, "$elementalName");
            String element = elementalName;
            int where = wherethis;
              int whereline = 0;
                isMoveOK[whereline][where] = false;
                if (isCombination == false) {
                while (whereline + 1 < elemental.length && elemental[whereline+1][where] == "") {
                  await Future.delayed(Duration(seconds: 1));
                  setState(() {
                    elemental[whereline+1].fillRange(where, where+1, "$element");       
                    isMoveOK[whereline+1].fillRange(where, where+1, false);       
                    elemental[whereline].fillRange(where, where+1, "");
                    isMoveOK[whereline].fillRange(where, where+1, true);
                    whereline = whereline + 1;
                  });
                }
                if (elemental[whereline-1][where] == "") {
                  isMoveOK[whereline].fillRange(where, where+1, true);
                }
              }else {
                while (whereline + 1 < elemental.length && elemental[whereline+1][where] != "block" && isMoveOK[whereline+1][where] == true) {
                  await Future.delayed(Duration(seconds: 1));
                  if (elemental[whereline+1][where] == "") {
                    setState(() {
                      elemental[whereline+1].fillRange(where, where+1, "$element");
                      isMoveOK[whereline+1].fillRange(where, where+1, false);
                      elemental[whereline].fillRange(where, where+1, ""); 
                      isMoveOK[whereline].fillRange(where, where+1, true);
                      whereline = whereline + 1;
                    });
                  } else {
                    setState(() {
                      element = addElement(
                        elemental[whereline+1][where],
                        element,
                      );
                      elemental[whereline+1].fillRange(where, where+1, "$element");
                      isMoveOK[whereline+1].fillRange(where, where+1, false);
                      elemental[whereline].fillRange(where, where+1, "");
                      isMoveOK[whereline].fillRange(where, where+1, true);
                      whereline = whereline + 1;
                    });
                  }            
                }
                if (elemental[whereline-1][where] == "") {
                  isMoveOK[whereline].fillRange(where, where+1, true);
                }
              }
              isCanBlending[whereline-1].fillRange(where, where+1, false);
              isCanBlending[whereline].fillRange(where, where+1, isCanBlendingFunction(element));
              setIsCanBlending();
        }
      }
    } else {
      return;
    } 
  }

  String normalizeText(String text) {
    final matches =
        RegExp(r'([A-Z][a-z]?)(\d*)').allMatches(text);

    Map<String, int> elements = {};

    for (final m in matches) {
      final symbol = m.group(1)!;
      final countText = m.group(2)!;

      elements[symbol] =
          (elements[symbol] ?? 0) +
          (countText.isEmpty ? 1 : int.parse(countText));
    }

    List<String> symbols = elements.keys.toList()
      ..sort();

    String result = "";

    for (final symbol in symbols) {
      result += symbol;

      if (elements[symbol]! > 1) {
        result += elements[symbol]!.toString();
      }
    }

    return result;
  }

  int indexOfValue<T>(Iterable<T> iterable, T target) {
    var index = 0;
    for (final value in iterable) {
      if (value == target) return index;
      index++;
    }
    return -1;
  }

  String addElement(String formula, String element) {
    final matches =
        RegExp(r'([A-Z][a-z]?)(\d*)').allMatches(formula);

    final matches2 =
        RegExp(r'([A-Z][a-z]?)(\d*)').allMatches(element);

    String result = "";

    Map<String, int> addMap = {};

    Set<String> used = {};

    for (final m in matches2) {
      final symbol = m.group(1)!;
      final countText = m.group(2)!;

      addMap[symbol] =
          countText.isEmpty ? 1 : int.parse(countText);
    }

    for (final m in matches) {
      final symbol = m.group(1)!;
      final countText = m.group(2)!;

      int count =
          countText.isEmpty ? 1 : int.parse(countText);

      if (addMap.containsKey(symbol)) {
        count += addMap[symbol]!;
        used.add(symbol);
      }

      result += symbol;

      if (count > 1) {
        result += count.toString();
      }
    }

    addMap.forEach((symbol, count) {
      if (!used.contains(symbol)) {
        result += symbol;

        if (count > 1) {
          result += count.toString();
        }
      }
    });

    String key = normalizeText(result);

    String? name; 
    
    try {
      name = compoundsdic.values.elementAt(indexOfValue(compoundsdic.keys, key));
    } catch (e) {

    }

    result = name ?? result;

    return result;
  }

  bool isCanBlendingFunction(String text) {
    String key = normalizeText(text);

    String? name; 
    
    try {
      name = compoundsdic.values.elementAt(indexOfValue(compoundsdic.keys, key));
    } catch (e) {

    }

    String result = name ?? "";

    if (result != "") {
      return true;
    } else {
      return false;
    }
  }

  bool containsOnlyAllowedElements(String formula) {
    final matches =
        RegExp(r'([A-Z][a-z]?)(\d*)').allMatches(formula);

    for (final m in matches) {
      final symbol = m.group(1)!;

      if (!allowedElements.contains(symbol)) {
        return false;
      }
    }

    return true;
  }

  void setIsCanBlending() {
    for (var i = 0; i < elemental.length; i++) {
      for (var i2 = 0; i < elemental[i].length; i++) {
        if (elemental[i][i2] == "") {
          isCanBlending[i][i2] = false;
        }
      }
    }
  }

  void updateElemental(int wherelineisthis, int whereisthis, String name) async {
        String element = name;
        int where = whereisthis;
        int whereline = wherelineisthis;
          isMoveOK[whereline][where] = false;
          if (isCombination == false) {
          while (whereline + 1 < elemental.length && elemental[whereline+1][where] == "") {
            await Future.delayed(Duration(seconds: 1));
            setState(() {
              elemental[whereline+1].fillRange(where, where+1, "$element");       
              isMoveOK[whereline+1].fillRange(where, where+1, false);       
              elemental[whereline].fillRange(where, where+1, "");
              isMoveOK[whereline].fillRange(where, where+1, true);
              whereline = whereline + 1;
            });
          }
          isMoveOK[whereline].fillRange(where, where+1, true);
        }else {
          while (whereline + 1 < elemental.length && elemental[whereline+1][where] != "block") {
            await Future.delayed(Duration(seconds: 1));
            if (elemental[whereline+1][where] == "") {
              setState(() {
                elemental[whereline+1].fillRange(where, where+1, "$element");
                isMoveOK[whereline+1].fillRange(where, where+1, false);
                elemental[whereline].fillRange(where, where+1, ""); 
                isMoveOK[whereline].fillRange(where, where+1, true);               
                whereline = whereline + 1;
              });
            } else {
              setState(() {
                element = addElement(
                  elemental[whereline+1][where],
                  element,
                );
                elemental[whereline+1].fillRange(where, where+1,
                "$element");
                isMoveOK[whereline+1].fillRange(where, where+1, false);
                elemental[whereline].fillRange(where, where+1, "");
                isMoveOK[whereline].fillRange(where, where+1, true);                
                whereline = whereline + 1;
              });
            }            
          }
          isMoveOK[whereline].fillRange(where, where+1, true);
        }
  }

  List<Widget> makeMadeCompounds() {
    List<Widget> adding = [];
    List<Widget> widget = [];

    int num = 0;
    int bignum = 0;
    
    makeedCompounds.forEach((key, value) {
      do {
        adding.add(Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("$key", style: TextStyle(fontSize: 25*size),),
            SizedBox(height: 10*size,),
            AutoTranslateText("${value.keys.first}", style: TextStyle(fontSize: 25*size),),
          ],
        ));
        adding.add(SizedBox(width: 50*size,));
        num++;
        bignum++;
        if (bignum == 3) {
          widget.add(Row(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...adding
          ],));
          widget.add(SizedBox(height: 50*size,));
          adding.clear();
          bignum = 0;
        }
      } while (num < value.values.first);
      num = 0;
    });

    return [Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      ...widget,
      SizedBox(height: 50*size,),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [...adding],),
    ],)];
  }

  List<Widget> makeMIPPYShow() {
    List<Widget> showlist = [];
    List<Widget> makeshowlist = [];    

    List<List<String>> showstr = [
      ["/images/HydrogenMippy.png","a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","/images/HeliumMippy.png",],
      ["/images/LithiumMippy.png","a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","/images/BerylliumMippy.png",],
      ["/images/BoronMippy.png","a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","/images/IronMippy.png",],
      ["/images/GoldMippy.png","a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","/images/BismuthMippy.png",],
    ];

    for (var element in showstr) {
      for (var one in element) {
        makeshowlist.add(Column(mainAxisAlignment: MainAxisAlignment.center, children: [ 
        /*showstr.indexWhere((thisstr) => thisstr==element)==0&&element.indexWhere((thisstr) => thisstr==one) == leftrightPosition?
        Icon(Icons.arrow_downward) : Text("",style: TextStyle(fontSize: 1),),
        Container(
          color: one.contains("/")? Colors.amber[100] : Colors.white,
          width: 100,
          height: 100,
          child: one.contains("/")? Image.asset("$one") : SizedBox(),
        ),*/
        showstr.indexWhere((thisstr) => thisstr==element)==0&&element.indexWhere((thisstr) => thisstr==one) == leftrightPosition?
        Icon(Icons.arrow_downward, size: 30*size,) : Text("",style: TextStyle(fontSize: 1*size),),
        Container(color: one.contains("/")? Colors.green[100] : element.indexWhere((thisstr) => thisstr==one) == leftrightPosition? Colors.orange[200] : Colors.amber[100],
              width: 110*size, height: 110*size,
              child: one.contains("/")? Image.asset("$one") : 
               elemental[showstr.indexWhere((thisline) => thisline==element)][element.indexWhere((thiselement) => thiselement == one)]!=""? 
              Container(alignment:Alignment.center,width: 110*size,height: 110*size,decoration: BoxDecoration(color: isCanBlending[showstr.indexWhere((thisline) => thisline==element)+4][element.indexWhere((thiselement) => thiselement == one)]? Colors.blue[200] : Colors.lightGreen[100], borderRadius: BorderRadius.circular(100*size)),child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [ Text("${elemental[showstr.indexWhere((thisline) => thisline==element)][element.indexWhere((thiselement) => thiselement == one)]}", style: TextStyle(fontSize: 25*size),),/*isCanBlending[showstr.indexWhere((thisline) => thisline==element)+4][element.indexWhere((thiselement) => thiselement == one)]?
                RotatedBox(quarterTurns: 2, child: Icon(Icons.wb_incandescent_sharp,color: Colors.cyanAccent,size: 20*size,),) : Text(""),*/])):
              Container(
                color: one.contains("/")? Colors.green[100] : element.indexWhere((thisstr) => thisstr==one) == leftrightPosition? Colors.orange[200] : Colors.amber[100],
                width: 110*size,
                height: 110*size,
                child: one.contains("/")? Image.asset("$one") : SizedBox(),
              ),
        )])
              ,
            );
        makeshowlist.add(SizedBox(width: 10*size,));
      }
      showlist.add(Row(mainAxisAlignment: MainAxisAlignment.center,children: [...makeshowlist],));
      showlist.add(SizedBox(height: 10*size,));
      makeshowlist.clear();
    }

    return showlist;
  }

  void makeAllow(List<List<List<String>>> showstr) {
    int num = 1;

    allowedElements.clear();

    for (var element in showstr) {
      if (num < level+2) {
        for (var one in element) {
          if (one[0] != "") {
            allowedElements.add(one[0]);
          }      
        }
      }

      num++;
    }
  }

  void isComplete() {
    if (widget.gamemodesettings == gamemode.puzzle) {
        if (check()) {
              isCompletebool = true;
            }
    }
  }
  bool check() {
    for (var element in elemental) {
      for (var onlyone in element) {
        if (onlyone.contains("block")) {

        } else if (onlyone != "") {
          return false;
        }
      }
    }

    return true;
  }

  void ShowEffect(String compound, int line, int where) async {
    setState(() {
      Effects[line].fillRange(where, where+1,
        SizedBox(
          width: 100*size,
          height: 100*size,
          child: GameWidget(
            game: MyGame(compound: compound, size2: size),
          ),
        ));
    });
    await Future.delayed(Duration(milliseconds: 400));
    if (compound == "O3") {
      await Future.delayed(Duration(milliseconds: 600));
    } else if (compound == "CO2") {
      await Future.delayed(Duration(milliseconds: 600));
    }
    setState(() {
      Effects[line].fillRange(where, where+1, SizedBox());
    });
    setState(() {
      Effects[line].fillRange(where, where+1, SizedBox(width: 110*size, height: 110*size,child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(compound, style: TextStyle(fontSize: 20*size),),
        AutoTranslateText(compoundsJapanese[compound] ?? "", style: TextStyle(fontSize: 20*size),),
      ],),));
    });      
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      Effects[line].fillRange(where, where+1, SizedBox());
    });
  }

  Widget makeElementalShow() {

    List<Widget> showlist = [];
    List<Widget> makeshowlist = [];
    List<List<List<String>>> showstr = [
      [["H", "水素","Hydrogen","1"],["", "","",""],["", "","",""],["", "","",""],["", "","",""],["", "","",""],["", "","",""],["", "","",""],["", "","",""],["", "","",""],["", "","",""],["", "","",""],["", "","",""],["", "","",""],["", "","",""],["", "","",""],["", "","",""],["He", "ヘリウム","Helium","2"],],
      [["Li", "リチウム","Lithium","3"],["Be", "ベリリウム","Beryllium","4"],["", "","",""],["", "","",""],["", "","",""],["", "","",""],["", "","",""],["", "","",""],["", "","",""],["", "","",""],["", "","",""],["", "","",""],["B", "ホウ素","Boron","5"],["C", "炭素","Carbon","6"],["N", "窒素","Nitrogen","7"],["O", "酸素","Oxygen","8"],["F", "フッ素","Fluorine","9"],["Ne", "ネオン","Neon","10"],],
      [["Na", "ナトリウム","Sodium","11"],["Mg", "マグネシウム","Magnesium","12"],["", "","",""],["", "","",""],["", "","",""],["", "","",""],["", "","",""],["", "","",""],["", "","",""],["", "","",""],["", "","",""],["", "","",""],["Al", "アルミニウム","Aluminium","13"],["Si", "ケイ素","Silicon","14"],["P", "リン","Phosphorus","15"],["S", "硫黄","Sulfur","16"],["Cl", "塩素","Chlorine","17"],["Ar", "アルゴン","Argon","18"],],
      [["K", "カリウム","Potassium","19"],["Ca", "カルシウム","Calcium","20"],["Sc", "スカンジウム","Scandium","21"],["Ti", "チタン","Titanium","22"],["V", "バナジウム","Vanadium","23"],["Cr", "クロム","Chromium","24"],["Mn", "マンガン","Manganese","25"],["Fe", "鉄","Iron","26"],["Co", "コバルト","Cobalt","27"],["Ni", "ニッケル","Nickel","28"],["Cu", "銅","Copper","29"],["Zn", "亜鉛","Zinc","30"],["Ga", "ガリウム","Gallium","31"],["Ge", "ゲルマニウム","Germanium","32"],["As", "ヒ素","Arsenic","33"],["Se", "セレン","Selenium","34"],["Br", "臭素","Bromine","35"],["Kr", "クリプトン","Krypton","36"],],
      [["Rb", "ルビジウム","Rubidium","37"],["Sr", "ストロンチウム","Strontium","38"],["Y", "イットリウム","Yttrium","39"],["Zr", "ジルコニウム","Zirconium","40"],["Nb", "ニオブ","Niobium","41"],["Mo", "モリブデン","Molybdenum","42"],["Tc", "テクネチウム","Technetium","43"],["Ru", "ルテニウム","Ruthenium","44"],["Rh", "ロジウム","Rhodium","45"],["Pd", "パラジウム","Palladium","46"],["Ag", "銀","Silver","47"],["Cd", "カドミウム","Cadmium","48"],["In", "インジウム","Indium","49"],["Sn", "スズ","Tin","50"],["Sb", "アンチモン","Antimony","51"],["Te", "テルル","Tellurium","52"],["I", "ヨウ素","Iodine","53"],["Xe", "キセノン","Xenon","54"],],
      [["Cs", "セシウム","Cesium","55"],["Ba", "バリウム","Barium","56"],[" ","ランタノイド"," "," "],["Hf", "ハフニウム","Hafnium","72"],["Ta", "タンタル","Tantalum","73"],["W", "タングステン","Tungsten","74"],["Re", "レニウム","Rhenium","75"],["Os", "オスミウム","Osmium","76"],["Ir", "イリジウム","Iridium","77"],["Pt", "白金","Platinum","78"],["Au", "金","Gold","79"],["Hg", "水銀","Mercury","80"],["Tl", "タリウム","Thallium","81"],["Pb", "鉛","Lead","82"],["Bi", "ビスマス","Bismuth","83"],["Po", "ポロニウム","Polonium","84"],["At", "アスタチン","Astatine","85"],["Rn", "ラドン","Radon","86"],],
      [["Fr", "フランシウム","Francium","87"],["Ra", "ラジウム","Radium","88"],[" ","アクチノイド"," "," "],["Rf", "ラザホージウム","Rutherfordium","104"],["Db", "ドブニウム","Dubnium","105"],["Sg", "シーボーギウム","Seaborgium","106"],["Bh", "ボーリウム","Bohrium","107"],["Hs", "ハッシウム","Hassium","108"],["Mt", "マイトネリウム","Meitnerium","109"],["Ds", "ダームスタチウム","Darmstadtium","110"],["Rg", "レントゲニウム","Roentgenium","111"],["Cn", "コペルニシウム","Copernicium","112"],["Nh", "ニホニウム","Nihonium","113"],["Fl", "フレロビウム","Flerovium","114"],["Mc", "モスコビウム","Moscovium","115"],["Lv", "リバモリウム","LIvermorium","116"],["Ts", "テネシン","Tennessine","117"],["Og", "オガネソン","Oganesson","118"],],
      [[" ","ランタノイド"," "," "],["La", "ランタン","Lanthanum","57"],["Ce", "セリウム","Cerium","58"],["Pr", "プラセオジム","Praseodymium","59"],["Nd", "ネオジム","Neodymium","60"],["Pm", "プロメチウム","Promethium","61"],["Sm", "サマリウム","Samarium","62"],["Eu", "ユウロピウム","Europium","63"],["Gd", "ガドリニウム","Gadolinium","64"],["Tb", "テルビウム","Terbium","65"],["Dy", "ジスプロシウム","Dysprosium","66"],["Ho", "ホルミウム","Holmium","67"],["Er", "エルビウム","Erbium","68"],["Tm", "ツリウム","Thulium","69"],["Yb", "イッテルビウム","Ytterbium","70"],["Lu", "ルテチウム","Lutetium","71"],[" "," "," "," "],[" "," "," "," "],],
      [[" ","アクチノイド"," "," "],["Ac", "アクチニウム","Actinium","89"],["Th", "トリウム","Thorium","90"],["Pa", "プロトアクチニウム","Protactinium","91"],["U", "ウラン","Uranium","92"],["Np", "ネプツニウム","Neptunium","93"],["Pu", "プルトニウム","Plutonium","94"],["Am", "アメリシウム","Americium","95"],["Cm", "キュリウム","Curium","96"],["Bk", "バークリウム","Berkelium","97"],["Cf", "カリホルニウム","Californium","98"],["Es", "アインスタイニウム","Einsteinium","99"],["Fm", "フェルミウム","Fermium","100"],["Md", "メンデレビウム","Mendelevium","101"],["No", "ノーベリウム","Nobelium","102"],["Lr", "ローレンシウム","Lawrencium","103"],[" "," "," "," "],[" "," "," "," "],],
    ];
    List<List<Color>> showcolor = [
      [Colors.lightBlue[100]!, Colors.amber[100]!, Colors.amber[100]!, Colors.amber[100]!, Colors.amber[100]!, Colors.amber[100]!, Colors.amber[100]!, Colors.amber[100]!, Colors.amber[100]!, Colors.amber[100]!, Colors.amber[100]!, Colors.amber[100]!, Colors.amber[100]!, Colors.amber[100]!, Colors.amber[100]!, Colors.amber[100]!, Colors.amber[100]!, Colors.blue[700]!],
      [Colors.pink[100]!, Colors.green[300]!, Colors.amber[100]!, Colors.amber[100]!, Colors.amber[100]!, Colors.amber[100]!, Colors.amber[100]!, Colors.amber[100]!, Colors.amber[100]!, Colors.amber[100]!, Colors.amber[100]!, Colors.amber[100]!, Colors.red[300]!, Colors.grey, Colors.purple[300]!, Colors.orange[300]!, Colors.deepPurple[400]!, Colors.blue[700]!],
      [Colors.pink[100]!, Colors.green[300]!, Colors.amber[100]!, Colors.amber[100]!, Colors.amber[100]!, Colors.amber[100]!, Colors.amber[100]!, Colors.amber[100]!, Colors.amber[100]!, Colors.amber[100]!, Colors.amber[100]!, Colors.amber[100]!, Colors.red[300]!, Colors.grey, Colors.purple[300]!, Colors.orange[300]!, Colors.deepPurple[400]!, Colors.blue[700]!],
      [Colors.pink[100]!, Colors.lightGreenAccent[400]!, Colors.yellowAccent, Colors.yellowAccent, Colors.yellowAccent, Colors.yellowAccent, Colors.yellowAccent, Colors.yellowAccent, Colors.yellowAccent, Colors.yellowAccent, Colors.yellowAccent, Colors.yellowAccent, Colors.red[300]!, Colors.grey, Colors.purple[300]!, Colors.orange[300]!, Colors.deepPurple[400]!, Colors.blue[700]!],
      [Colors.pink[100]!, Colors.lightGreenAccent[400]!, Colors.yellowAccent, Colors.yellowAccent, Colors.yellowAccent, Colors.yellowAccent, Colors.yellowAccent, Colors.yellowAccent, Colors.yellowAccent, Colors.yellowAccent, Colors.yellowAccent, Colors.yellowAccent, Colors.red[300]!, Colors.grey, Colors.purple[300]!, Colors.orange[300]!, Colors.deepPurple[400]!, Colors.blue[700]!],
      [Colors.pink[100]!, Colors.lightGreenAccent[400]!, Colors.tealAccent, Colors.yellowAccent, Colors.yellowAccent, Colors.yellowAccent, Colors.yellowAccent, Colors.yellowAccent, Colors.yellowAccent, Colors.yellowAccent, Colors.yellowAccent, Colors.yellowAccent, Colors.red[300]!, Colors.grey, Colors.purple[300]!, Colors.orange[300]!, Colors.deepPurple[400]!, Colors.blue[700]!],
      [Colors.pink[100]!, Colors.lightGreenAccent[400]!, Colors.blueGrey[600]!, Colors.yellowAccent, Colors.yellowAccent, Colors.yellowAccent, Colors.yellowAccent, Colors.yellowAccent, Colors.yellowAccent, Colors.yellowAccent, Colors.yellowAccent, Colors.yellowAccent, Colors.red[300]!, Colors.grey, Colors.purple[300]!, Colors.orange[300]!, Colors.deepPurple[400]!, Colors.blue[700]!],
      [Colors.tealAccent, Colors.tealAccent, Colors.tealAccent, Colors.tealAccent, Colors.tealAccent, Colors.tealAccent, Colors.tealAccent, Colors.tealAccent, Colors.tealAccent, Colors.tealAccent, Colors.tealAccent, Colors.tealAccent, Colors.tealAccent, Colors.tealAccent, Colors.tealAccent, Colors.tealAccent, Colors.tealAccent, Colors.tealAccent,],
      [Colors.blueGrey[600]!, Colors.blueGrey[600]!, Colors.blueGrey[600]!, Colors.blueGrey[600]!, Colors.blueGrey[600]!, Colors.blueGrey[600]!, Colors.blueGrey[600]!, Colors.blueGrey[600]!, Colors.blueGrey[600]!, Colors.blueGrey[600]!, Colors.blueGrey[600]!, Colors.blueGrey[600]!, Colors.blueGrey[600]!, Colors.blueGrey[600]!, Colors.blueGrey[600]!, Colors.blueGrey[600]!, Colors.blueGrey[600]!, Colors.blueGrey[600]!,],      
    ];
    List<List<Color>> showcolorOnMouse = [
      [Colors.lightBlue[200]!, Colors.amber[100]!, Colors.amber[100]!, Colors.amber[100]!, Colors.amber[100]!, Colors.amber[100]!, Colors.amber[100]!, Colors.amber[100]!, Colors.amber[100]!, Colors.amber[100]!, Colors.amber[100]!, Colors.amber[100]!, Colors.amber[100]!, Colors.amber[100]!, Colors.amber[100]!, Colors.amber[100]!, Colors.amber[100]!, Colors.blue[800]!],
      [Colors.pink[200]!, Colors.green[400]!, Colors.amber[100]!, Colors.amber[100]!, Colors.amber[100]!, Colors.amber[100]!, Colors.amber[100]!, Colors.amber[100]!, Colors.amber[100]!, Colors.amber[100]!, Colors.amber[100]!, Colors.amber[100]!, Colors.red[400]!, Colors.grey[600]!, Colors.purple[400]!, Colors.orange[400]!, Colors.deepPurple, Colors.blue[800]!],
      [Colors.pink[200]!, Colors.green[400]!, Colors.amber[100]!, Colors.amber[100]!, Colors.amber[100]!, Colors.amber[100]!, Colors.amber[100]!, Colors.amber[100]!, Colors.amber[100]!, Colors.amber[100]!, Colors.amber[100]!, Colors.amber[100]!, Colors.red[400]!, Colors.grey[600]!, Colors.purple[400]!, Colors.orange[400]!, Colors.deepPurple, Colors.blue[800]!],
      [Colors.pink[200]!, Colors.lightGreenAccent[700]!, Colors.yellowAccent[400]!, Colors.yellowAccent[400]!, Colors.yellowAccent[400]!, Colors.yellowAccent[400]!, Colors.yellowAccent[400]!, Colors.yellowAccent[400]!, Colors.yellowAccent[400]!, Colors.yellowAccent[400]!, Colors.yellowAccent[400]!, Colors.yellowAccent[400]!, Colors.red[400]!, Colors.grey[600]!, Colors.purple[400]!, Colors.orange[400]!, Colors.deepPurple, Colors.blue[800]!],
      [Colors.pink[200]!, Colors.lightGreenAccent[700]!, Colors.yellowAccent[400]!, Colors.yellowAccent[400]!, Colors.yellowAccent[400]!, Colors.yellowAccent[400]!, Colors.yellowAccent[400]!, Colors.yellowAccent[400]!, Colors.yellowAccent[400]!, Colors.yellowAccent[400]!, Colors.yellowAccent[400]!, Colors.yellowAccent[400]!, Colors.red[400]!, Colors.grey[600]!, Colors.purple[400]!, Colors.orange[400]!, Colors.deepPurple, Colors.blue[800]!],
      [Colors.pink[200]!, Colors.lightGreenAccent[700]!, Colors.tealAccent, Colors.yellowAccent[400]!, Colors.yellowAccent[400]!, Colors.yellowAccent[400]!, Colors.yellowAccent[400]!, Colors.yellowAccent[400]!, Colors.yellowAccent[400]!, Colors.yellowAccent[400]!, Colors.yellowAccent[400]!, Colors.yellowAccent[400]!, Colors.red[400]!, Colors.grey[600]!, Colors.purple[400]!, Colors.orange[400]!, Colors.deepPurple[500]!, Colors.blue[800]!],
      [Colors.pink[200]!, Colors.lightGreenAccent[700]!, Colors.blueGrey[600]!, Colors.yellowAccent[400]!, Colors.yellowAccent[400]!, Colors.yellowAccent[400]!, Colors.yellowAccent[400]!, Colors.yellowAccent[400]!, Colors.yellowAccent[400]!, Colors.yellowAccent[400]!, Colors.yellowAccent[400]!, Colors.yellowAccent[400]!, Colors.red[400]!, Colors.grey[600]!, Colors.purple[400]!, Colors.orange[400]!, Colors.deepPurple[500]!, Colors.blue[800]!],
      [Colors.tealAccent, Colors.tealAccent[400]!, Colors.tealAccent[400]!, Colors.tealAccent[400]!, Colors.tealAccent[400]!, Colors.tealAccent[400]!, Colors.tealAccent[400]!, Colors.tealAccent[400]!, Colors.tealAccent[400]!, Colors.tealAccent[400]!, Colors.tealAccent[400]!, Colors.tealAccent[400]!, Colors.tealAccent[400]!, Colors.tealAccent[400]!, Colors.tealAccent[400]!, Colors.tealAccent[400]!, Colors.tealAccent, Colors.tealAccent,],
      [Colors.blueGrey[600]!, Colors.blueGrey[700]!, Colors.blueGrey[700]!, Colors.blueGrey[700]!, Colors.blueGrey[700]!, Colors.blueGrey[700]!, Colors.blueGrey[700]!, Colors.blueGrey[700]!, Colors.blueGrey[700]!, Colors.blueGrey[700]!, Colors.blueGrey[700]!, Colors.blueGrey[700]!, Colors.blueGrey[700]!, Colors.blueGrey[700]!, Colors.blueGrey[700]!, Colors.blueGrey[700]!, Colors.blueGrey[600]!, Colors.blueGrey[600]!,],      
    ];

    if (isNotDo) {
      isNotDo = false;
      makeAllow(showstr);
    }
    
    for (var element in showstr) {
      for (var one in element) {
        makeshowlist.add(Stack( alignment: Alignment.center, children: [
          SizedBox(width: 110*size, height: 110*size,
          child: MouseRegion(
            onEnter: (event) {
              if (widget.gamemodesettings == gamemode.freedom) {
                setState(() {
                  isMouseOn[showstr.indexOf(element)].fillRange(element.indexOf(one), element.indexOf(one)+1, true);
                });
              }              
            },
            onExit: (event) {
              if (widget.gamemodesettings == gamemode.freedom) {
                setState(() {
                  isMouseOn[showstr.indexOf(element)].fillRange(element.indexOf(one), element.indexOf(one)+1, false);
                });
              }    
            },
            cursor: one[0] != "" && one[1] != "アクチノイド" && one[1] != "ランタノイド" && one[1] != " "? SystemMouseCursors.click : isCanBlending[showstr.indexOf(element)+4][element.indexOf(one)] == false? SystemMouseCursors.basic : SystemMouseCursors.click,
            child: GestureDetector(          
              onTap: () {
                if (one[0] != "" && one[1] != "アクチノイド" && one[1] != "ランタノイド" && one[1] != " ") {
                  if (widget.gamemodesettings == gamemode.freedom) {
                    setState(() {
                      spawnElemental(one[0],int.parse("$leftrightPosition"));
                    });
                  }                                  
                }
                if (elemental[showstr.indexWhere((thisline) => thisline==element)+4][element.indexWhere((thiselement) => thiselement == one)]!="" && elemental[showstr.indexWhere((thisline) => thisline==element)+4][element.indexWhere((thiselement) => thiselement == one)] !="block" && compoundsJapanese[elemental[showstr.indexWhere((thisline) => thisline==element)+4][element.indexWhere((thiselement) => thiselement == one)]] != null) {
                  setState(() {
                    if (widget.BGM.volume == 1) {
                      initAudio();
                    }
                    ShowEffect(elemental[showstr.indexWhere((thisline) => thisline==element)+4][element.indexWhere((thiselement) => thiselement == one)], showstr.indexWhere((thisline) => thisline==element)+4, element.indexWhere((thiselement) => thiselement == one));
                    makeedCompounds.addAll({"${elemental[showstr.indexWhere((thisline) => thisline==element)+4][element.indexWhere((thiselement) => thiselement == one)]}" : makeedCompounds.containsKey("${elemental[showstr.indexWhere((thisline) => thisline==element)+4][element.indexWhere((thiselement) => thiselement == one)]}")? {compoundsJapanese[elemental[showstr.indexWhere((thisline) => thisline==element)+4][element.indexWhere((thiselement) => thiselement == one)]] ?? "" : makeedCompounds["${elemental[showstr.indexWhere((thisline) => thisline==element)+4][element.indexWhere((thiselement) => thiselement == one)]}"]!.values.first+1} : {compoundsJapanese[elemental[showstr.indexWhere((thisline) => thisline==element)+4][element.indexWhere((thiselement) => thiselement == one)]] ?? "" : 1}});
                    isCanBlending[showstr.indexWhere((thisline) => thisline==element)+4].fillRange(element.indexWhere((thiselement) => thiselement == one), element.indexWhere((thiselement) => thiselement == one)+1, false);
                    elemental[showstr.indexWhere((thisline) => thisline==element)+4].fillRange(element.indexWhere((thiselement) => thiselement == one), element.indexWhere((thiselement) => thiselement == one)+1, "");
                    madeCount++;      
                  });
                  isComplete();
                }   
              },
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(color: element.indexWhere((thisstr) => thisstr==one) == leftrightPosition && showcolor[showstr.indexOf(element)][element.indexOf(one)]==Colors.amber[100]!? Colors.orange[200] : (isMouseOn[showstr.indexOf(element)][element.indexOf(one)] == false? showcolor[showstr.indexOf(element)][element.indexOf(one)] : showcolorOnMouse[showstr.indexOf(element)][element.indexOf(one)]),
                width: 110*size, height: 110*size,
                child:one[0] != ""? Stack(alignment: Alignment.center, children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(one[3],style: TextStyle(fontSize: 12*size),),
                          Text(one[0], style: TextStyle(fontSize: 20*size),),
                          Text(one[1],style: TextStyle(fontSize: 12*size),),
                          Text(one[2],style: TextStyle(fontSize: 12*size),),
                        ],
                      ),
                    ],) : elemental[showstr.indexWhere((thisline) => thisline==element)+4][element.indexWhere((thiselement) => thiselement == one)]!=""? 
                Container(alignment:Alignment.center,width: 110*size,height: 110*size,decoration: BoxDecoration(color: isCanBlending[showstr.indexWhere((thisline) => thisline==element)+4][element.indexWhere((thiselement) => thiselement == one)]? (isMouseOn[showstr.indexOf(element)][element.indexOf(one)] == false? Colors.blue[200] : Colors.blue[300]) : Colors.lightGreen[100],borderRadius: BorderRadius.circular(100*size)),child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  isCanBlending[showstr.indexWhere((thisline) => thisline==element)+4][element.indexWhere((thiselement) => thiselement == one)]?
                  RotatedBox(quarterTurns: 2, child: Icon(Icons.wb_incandescent_sharp,color: Colors.cyanAccent, size: 20*size,),) : Text(""),
                  Text("${elemental[showstr.indexWhere((thisline) => thisline==element)+4][element.indexWhere((thiselement) => thiselement == one)]}",style: TextStyle(fontSize: 25*size),),])):
                    Stack(alignment: Alignment.center, children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(one[3],style: TextStyle(fontSize: 12*size),),
                          Text(one[0], style: TextStyle(fontSize: 20*size),),
                          Text(one[1],style: TextStyle(fontSize: 12*size),),
                          Text(one[2],style: TextStyle(fontSize: 12*size),),
                        ],
                      ),
                    ],)
                ,
              ),
            ])),
          ),),                    
          Effects[showstr.indexOf(element)+4][element.indexOf(one)],
        ],));
          makeshowlist.add(SizedBox(width: 10*size,));
      }
      showlist.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ...makeshowlist
        ],
      ));
      showlist.add(SizedBox(height: 10*size,));
      makeshowlist.clear();
    }
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [...showlist],);
  }

  String makeCopyID() {
    String returnText = "";
    for (var element in elemental) {
      for (var one in element) {
        if (one == "") {
          returnText = returnText==""? "1" : "$returnText,1";
        } else {
          returnText = returnText==""? one : "$returnText,$one";
        }        
      }
    }
    return returnText;
  }

  void setPlacementID(String ID) {
    List<String> splited = ID.split(",");
    int num = 0;
    for (var element in elemental) {
      for (var one in element) {
        if (splited[num] == "1") {
          setState(() {
            elemental[elemental.indexOf(element)][element.indexOf(one)] = splited[num];
          });          
        } else {
          setState(() {
            elemental[elemental.indexOf(element)][element.indexOf(one)] = splited[num];
          });     
        }          
        num = num + 1;
      }
    }
    for (var element in elemental) {
      for (var one in element) {
        if (one == "1") {
          elemental[elemental.indexOf(element)][element.indexOf(one)] = "";
        }
      }
    }
    setIsCanBlending();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: InteractiveViewer(panEnabled: false, minScale: 0.1, maxScale: 1,  child: Scrollbar(
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
                                      child: 
                                      Column(mainAxisAlignment: MainAxisAlignment.center,
                                      children: [

                                          SizedBox(height: size*200,),
                                          AutoTranslateText("画面サイズ",style: TextStyle(fontSize: 20*size),),
                                          SizedBox(height: 100*size, width: 400*size, child: Slider(value: size, onChanged: (double value) {
                                            setState(() {
                                              size = value;
                                            });                                            
                                          },
                                          min: 0.5,
                                          max: 1,
                                          activeColor: Colors.grey[400],
                                          inactiveColor: Colors.grey[350],
                                          thumbColor: Colors.black,
                                          label: LanguageService.language.value == "ja"? "縮小 & 拡大" : "Shrink & Enlarge",
                                          ),),
                                          /*SizedBox(width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height, child: FractionallySizedBox(
                                            widthFactor: size,
                                            heightFactor: size,
                                            child:*/
                                          Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [                                                
                                                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                                  AutoTranslateText("ゲームモード：${widget.gamemodesettings == gamemode.puzzle? "パズル" : "自由"}",style: TextStyle(fontSize: 40*size),),
                                                  widget.gamemodesettings == gamemode.puzzle && isCompletebool == false? ElevatedButton(onPressed: () {
                                                    Navigator.push(context, MaterialPageRoute(builder: (_) => Scorepage(time: timer.elapsed.inMinutes+1, madecount: madeCount, gamemodesettings: gamemode.puzzle, nowlevel: level, nowpoint: point, isClear: false, makedCompounds: [...widget.makedCompounds,...makeedCompounds.keys], BGM: widget.BGM, stage: widget.stage)));
                                                  }, child: AutoTranslateText("ゲームを終了する", style: TextStyle(fontSize: 20*size),),style: ButtonStyle(fixedSize: WidgetStatePropertyAll(Size(300*size, 50*size)))) : Text(""),
                                                  widget.gamemodesettings == gamemode.freedom? ElevatedButton(onPressed: () {
                                                    setState(() {
                                                      isCombination = !isCombination;
                                                    });
                                                  }, child: isCombination? AutoTranslateText("結合モード", style: TextStyle(fontSize: 20*size),) : AutoTranslateText("結合しないモード", style: TextStyle(fontSize: 20*size),)
                                                  ,style: ButtonStyle(fixedSize: WidgetStatePropertyAll(Size(300*size, 50*size))),) : Text(""),
                                                  widget.gamemodesettings == gamemode.freedom? Image.asset(isCombination? "images/Combination.png" : "images/NotCombination.png",width: 300*size,height: 100*size,) : Text(""),
                                                  widget.gamemodesettings == gamemode.puzzle? ElevatedButton(onPressed: () {setState(() {
                                                    puzzle();
                                                  });}, child: AutoTranslateText("シャッフル", style: TextStyle(fontSize: 20*size),),style: ButtonStyle(fixedSize: WidgetStatePropertyAll(Size(300*size, 50*size)))) : ElevatedButton(onPressed: () {
                                                    timer.stop();
                                                    Navigator.push(context, MaterialPageRoute(builder: (_) => Scorepage(time: timer.elapsed.inMinutes, madecount: madeCount, gamemodesettings: gamemode.freedom, nowlevel: level, nowpoint: point, isClear: false, makedCompounds: [...widget.makedCompounds,...makeedCompounds.keys], BGM: widget.BGM, stage: widget.stage)));
                                                  }, child: AutoTranslateText("スコアを見て終了", style: TextStyle(fontSize: 20*size),),style: ButtonStyle(fixedSize: WidgetStatePropertyAll(Size(300*size, 50*size)))),
                                                  widget.gamemodesettings == gamemode.puzzle? isCompletebool==true? ElevatedButton(onPressed: () {
                                                    timer.stop();
                                                    Navigator.push(context, MaterialPageRoute(builder: (_) => Scorepage(time: timer.elapsed.inMinutes, madecount: madeCount, gamemodesettings: gamemode.puzzle, nowlevel: level, nowpoint: point, isClear: true, makedCompounds: [...widget.makedCompounds,...makeedCompounds.keys], BGM: widget.BGM, stage: widget.stage)));
                                                  }, child: AutoTranslateText("スコアを見て終了", style: TextStyle(fontSize: 20*size),),style: ButtonStyle(fixedSize: WidgetStatePropertyAll(Size(300*size, 50*size)))) : Text("") : Text(""),
                                                  SizedBox(width: 100*size,),
                                                ],),
                                                SizedBox(height: 10*size,),
                                                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                                  widget.gamemodesettings == gamemode.puzzle? AutoTranslateText("次：", style: TextStyle(fontSize: 50*size, color: Colors.lightGreenAccent)) : Text(""), 
                                                  widget.gamemodesettings == gamemode.puzzle? Text(nextRandomElemental, style: TextStyle(fontSize: 50*size, color: Colors.lightGreenAccent)) : Text(""),
                                                  widget.gamemodesettings == gamemode.freedom? SizedBox(width: 500*size, height: 150*size, child: TextField(
                                                    controller: ID,
                                                    decoration: InputDecoration(label: AutoTranslateText("配置ID",style: TextStyle(fontSize: 20*size),)),
                                                  ),) : Text(""),  
                                                  widget.gamemodesettings == gamemode.freedom? ElevatedButton(onPressed: () {
                                                    setPlacementID(ID.text);
                                                  }, child: AutoTranslateText("配置を変える",style: TextStyle(fontSize: 20*size),),style: ButtonStyle(fixedSize: WidgetStatePropertyAll(Size(400*size, 50*size)))) : Text(""),
                                                  widget.gamemodesettings == gamemode.freedom? ElevatedButton(onPressed: () async {
                                                    String text = makeCopyID();
                                                    await Clipboard.setData(ClipboardData(text: text));
                                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${LanguageService.language.value == "ja"? "テキストをコピーしました：": "Text copied:"}${text}")));
                                                  }, child: AutoTranslateText("今の配置IDをコピーする",style: TextStyle(fontSize: 20*size),),style: ButtonStyle(fixedSize: WidgetStatePropertyAll(Size(400*size, 50*size)))) : Text(""),                
                                                ],),
                                                SizedBox(height: 100*size,),
                                                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                                  ElevatedButton(onPressed: () {
                                                  if (leftrightPosition == 1) {
                                                    setState(() {
                                                      leftrightPosition = 16;
                                                    });
                                                  } else {
                                                    setState(() {
                                                      leftrightPosition -= 1;
                                                    });
                                                  }
                                                }, child: RotatedBox(
                                                    quarterTurns: 2,
                                                    child: Icon(Icons.arrow_right_alt, size: 50*size,),
                                                  ),style: ButtonStyle(fixedSize: WidgetStatePropertyAll(Size(150*size, 150*size)))),
                                                  ElevatedButton(onPressed: () {
                                                  if (leftrightPosition == 16) {
                                                    setState(() {
                                                      leftrightPosition = 1;
                                                    });
                                                  } else {
                                                    setState(() {
                                                      leftrightPosition += 1;
                                                    });
                                                  }
                                                }, child: Icon(Icons.arrow_right_alt,size: 50*size,),style: ButtonStyle(fixedSize: WidgetStatePropertyAll(Size(150*size, 150*size)))),
                                                ],),                  
                                                  Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    ...makeMIPPYShow()
                                                  ],
                                                ),
                                                makeElementalShow(),
                                                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                                  ElevatedButton(onPressed: () {
                                                  if (leftrightPosition == 1) {
                                                    setState(() {
                                                      leftrightPosition = 16;
                                                    });
                                                  } else {
                                                    setState(() {
                                                      leftrightPosition -= 1;
                                                    });
                                                  }
                                                }, child: RotatedBox(
                                                    quarterTurns: 2,
                                                    child: Icon(Icons.arrow_right_alt, size: 50*size,),
                                                  ),style: ButtonStyle(fixedSize: WidgetStatePropertyAll(Size(150*size, 150*size)))),
                                                  ElevatedButton(onPressed: () {
                                                  if (leftrightPosition == 16) {
                                                    setState(() {
                                                      leftrightPosition = 1;
                                                    });
                                                  } else {
                                                    setState(() {
                                                      leftrightPosition += 1;
                                                    });
                                                  }
                                                }, child: Icon(Icons.arrow_right_alt, size: 50*size,),style: ButtonStyle(fixedSize: WidgetStatePropertyAll(Size(150*size, 150*size)))),
                                                ],),
                                                SizedBox(height: 30*size,),
                                                AutoTranslateText("作った化合物",style: TextStyle(fontSize: 20*size),),
                                                Stack(alignment: Alignment.center,children: [
                                                  madeCount != 0? Container(height: (madeCount/3).toString().contains(".")? (int.parse(("${(madeCount/3).toString().split(".").first}"))+1)*200*size : (madeCount/3)*200*size,width: 600*size, decoration:  BoxDecoration(border: Border.all(color: Colors.cyanAccent, width: 3*size),),) : Text(""),
                                                  Column(mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      ...makeMadeCompounds()
                                                    ],
                                                  ),
                                                ],),
                                                SizedBox(height: 200*size,),
                                              ],
                                            ),
                                          ]))),
                                            /*]*/)),
                                      ),
                                        )            
                                           
            
      );
    
  }
}

class MyGame extends FlameGame {
  final String compound;
  final double size2;

  MyGame({required this.compound, required this.size2});

  @override
  Future<void> onLoad() async {
    images.prefix = '';
    SpriteComponent? EffectImage;

    final bigSizeEffect =
      SequenceEffect([
        CombinedEffect([
          SizeEffect.to(Vector2(100*size2,100*size2), EffectController(duration: 0.1)), 
        ]),   
        CombinedEffect([
          SizeEffect.to(Vector2(300*size2,300*size2), EffectController(duration: 0.3)), 
        ]),        
        RemoveEffect(),         
      ],);

    final BigSize =
      SequenceEffect([          
        SizeEffect.to(Vector2(125*size2,125*size2), EffectController(duration: 0.4)),        
        RemoveEffect(),         
      ],);      
    
    final MoveUpEffect =
      SequenceEffect([ 
        CombinedEffect([
          MoveEffect.to(Vector2(0,-20), EffectController(duration: 0.4)),
          SequenceEffect([
            MoveEffect.to(Vector2(-10, -10), EffectController(duration: 0.2)),
            MoveEffect.to(Vector2(10, -20), EffectController(duration: 0.2)),
          ], infinite: true),
        ]),        
        RemoveEffect(),         
      ],);

      final RotateRight =
      SequenceEffect([ 
        RotateEffect.to(tau/4, EffectController(duration: 0.4)),  
        RemoveEffect(),         
      ],);

      final RotateRightThenRotateLeft =
      SequenceEffect([ 
        RotateEffect.to(tau/8, EffectController(duration: 0.1)),  
        RotateEffect.to(0, EffectController(duration: 0.1)),
        RotateEffect.to(-tau/8, EffectController(duration: 0.1)),    
        RotateEffect.to(0, EffectController(duration: 0.1)),   
        RemoveEffect(),         
      ],);

      final Glow =
        SequenceEffect([ 
          ColorEffect(Color.fromARGB(0,0,0,0), EffectController(duration: 1)),
          RemoveEffect(),         
        ],);

      final HideThenShow =
        SequenceEffect([ 
          MoveEffect.to(canvasSize/2, EffectController(duration: 1)),
          RemoveEffect(),         
        ],);

        final HideThenShow2 =
        SequenceEffect([ 
          OpacityEffect.to(0, EffectController(duration: 0.05)),                  
          MoveEffect.to(canvasSize/2, EffectController(duration: 0.25)),
          OpacityEffect.to(1, EffectController(duration: 0.7)),
          RemoveEffect(),         
        ],);

        final Wait = 
          SequenceEffect(
            [
              MoveEffect.to(canvasSize/2, EffectController(duration: 0.2)),
              OpacityEffect.to(0, EffectController(duration: 0.8)),
              RemoveEffect(),
            ]
          );

    if (compound == "H2O") {
      final image = await images.load("/images/Effects_H2O.png");
      final sprite = Sprite(image);
      EffectImage = SpriteComponent(sprite: sprite, size: Vector2(100*size2, 100*size2),position: canvasSize/2,anchor: Anchor.center);
      add(EffectImage);
      EffectImage.add(bigSizeEffect);
    } else if (compound == "O2") {
      final image = await images.load("/images/Effects_O2.png");
      final sprite = Sprite(image);
      EffectImage = SpriteComponent(sprite: sprite, size: Vector2(100*size2, 100*size2),position: Vector2(0,0));
      add(EffectImage);
      EffectImage.add(MoveUpEffect);
    } else if (compound == "H2") {
      final image = await images.load("/images/Effects_H2.png");
      final sprite = Sprite(image);
      EffectImage = SpriteComponent(sprite: sprite, size: Vector2(100*size2, 100*size2),position: canvasSize/2, anchor: Anchor.center);
      add(EffectImage);
      EffectImage.add(RotateRight);
    } else if (compound == "O3") {
      final image = await images.load("/images/Effects_O3_1.png");
      final sprite = Sprite(image);
      final image2 = await images.load("/images/Effects_O3_2.png");
      final sprite2 = Sprite(image2);
      EffectImage = SpriteComponent(sprite: sprite, size: Vector2(100*size2, 100*size2),position: canvasSize/2, anchor: Anchor.center);
      SpriteComponent EffectImage2 = SpriteComponent(sprite: sprite2, size: Vector2(100*size2, 100*size2),position: canvasSize/2, anchor: Anchor.center);
      add(EffectImage);
      add(EffectImage2);
      EffectImage.add(Glow);
      EffectImage2.add(HideThenShow);
    } else if (compound == "LiCl") {
      final image = await images.load("/images/Effects_LiCl.png");
      final sprite = Sprite(image);
      EffectImage = SpriteComponent(sprite: sprite, size: Vector2(100*size2, 100*size2),position: Vector2(0,0));
      add(EffectImage);
      EffectImage.add(bigSizeEffect);
    } else if (compound == "NaCl") {
      final image = await images.load("/images/Effects_NaCl.png");
      final sprite = Sprite(image);
      EffectImage = SpriteComponent(sprite: sprite, size: Vector2(100*size2, 100*size2),position: Vector2(0,0));
      add(EffectImage);
      EffectImage.add(bigSizeEffect);
    } else if (compound == "KCl") {
      final image = await images.load("/images/Effects_KCl.png");
      final sprite = Sprite(image);
      EffectImage = SpriteComponent(sprite: sprite, size: Vector2(100*size2, 100*size2),position: Vector2(0,0));
      add(EffectImage);
      EffectImage.add(bigSizeEffect);
    } else if (compound == "SiO2") {
      final image = await images.load("/images/Effects_SiO2.png");
      final sprite = Sprite(image);
      EffectImage = SpriteComponent(sprite: sprite, size: Vector2(75*size2,75*size2), position: canvasSize/2, anchor: Anchor.center);
      add(EffectImage);
      EffectImage.add(RotateRightThenRotateLeft);
    } else if (compound == "CO2") {
      final image = await images.load("/images/Effects_CO2_1.png");
      final sprite = Sprite(image);
      final image2 = await images.load("/images/Effects_CO2_2.png");
      final sprite2 = Sprite(image2);            
      EffectImage = SpriteComponent(sprite: sprite, size: Vector2(117*size2,78*size2), position: canvasSize/2, anchor: Anchor.center);
      SpriteComponent? EffectImage2 = SpriteComponent(sprite: sprite2, size: Vector2(117*size2,78*size2), position: canvasSize/2, anchor: Anchor.center);
      add(EffectImage);
      EffectImage.add(Wait);
      add(EffectImage2);
      EffectImage2.add(HideThenShow2);
    } else if (compound == "NH3") {
      final image = await images.load("/images/Effects_NH3_1.png");
      final sprite = Sprite(image);
      final image2 = await images.load("/images/Effects_NH3_2.png");
      final sprite2 = Sprite(image2);
      EffectImage = SpriteComponent(sprite: sprite, size: Vector2(75*size2,75*size2), position: canvasSize/2, anchor: Anchor.center);
      SpriteComponent? EffectImage2 = SpriteComponent(sprite: sprite2, size: Vector2(75*size2,75*size2), position: canvasSize/2, anchor: Anchor.center);      
      add(EffectImage);      
      EffectImage.add(BigSize);
      add(EffectImage2);
    } else {
      final image = await images.load("/images/CompoundMippy.png");
      final sprite = Sprite(image);
      EffectImage = SpriteComponent(sprite: sprite, size: Vector2(40*size2,100*size2), position: canvasSize/2, anchor: Anchor.center);
      add(EffectImage);
    }
  }
}