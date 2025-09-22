import 'package:flutter/material.dart';
import 'dart:math';

class StoneView extends StatefulWidget {
  const StoneView({super.key});

  @override
  State<StoneView> createState() => _StoneViewState();
}

class _StoneViewState extends State<StoneView> {
  late final StoneCalc calc;
  List<bool?> firstAbility = List.filled(10, null);
  List<bool?> secondAbility = List.filled(10, null);
  List<bool?> thirdAbility = List.filled(10, null);
  final List<_ActionRecord> history = [];
  int pIdx = 75; // 현재 확률 (퍼센트, 25~75)
  Choice? rec77;
  Choice? rec97;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          body: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('어빌리티 스톤 세공'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: _onBack,
                      icon: Icon(Icons.arrow_back),
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: _onReset,
                      icon: Icon(Icons.rotate_right_rounded),
                    ),
                  ),
                ],
              ),
              buildStoneRow(firstAbility, '증가 능력 1'),
              buildStoneRow(secondAbility, '증가 능력 2'),
              buildStoneRow(thirdAbility, '감소 능력'),
              const SizedBox(height: 20),
              Text("현재 확률: $pIdx%"),
              Text("77돌 기준 추천: ${rec77 == null ? '-' : choiceText(rec77!)}"),
              Text("97돌 기준 추천: ${rec97 == null ? '-' : choiceText(rec97!)}"),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    calc = StoneCalc(); // 한번만 생성
    _recalc();
  }

  Widget buildStoneRow(List<bool?> abilityList, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(title),
            SizedBox(width: 10),
            for (int i = 0; i < 10; i++)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 3),
                  child: CircleAvatar(
                    backgroundColor: abilityList[i] == null
                        ? Colors
                        .grey // 아직 세공 안 한 칸 → 회색
                        : abilityList[i] == true
                        ? Colors.cyanAccent
                        : Colors.red,
                  ),
                ),
              ),
            GestureDetector(
              onTap: () {
                final idx = abilityList.indexOf(null);
                if (idx != -1) {
                  _onAction(abilityList, idx, true);
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.black),
                ),
                padding: const EdgeInsets.all(10),
                child: const Text('성공'),
              ),
            ),

            GestureDetector(
              onTap: () {
                final idx = abilityList.indexOf(null);
                if (idx != -1) {
                  _onAction(abilityList, idx, false);
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.black),
                ),
                padding: const EdgeInsets.all(10),
                child: const Text('실패'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _onAction(List<bool?> abilityList, int index, bool success) {
    setState(() {
      history.add(_ActionRecord(abilityList, index, abilityList[index], pIdx));
      abilityList[index] = success;
      pIdx = success ? max(25, pIdx - 10) : min(75, pIdx + 10);
      _recalc();
    });
  }

  void _onBack() {
    if (history.isNotEmpty) {
      setState(() {
        final last = history.removeLast();
        last.abilityList[last.index] = last.oldValue;
        pIdx = last.oldPIdx;
        _recalc();
      });
    }
  }

  void _onReset() {
    setState(() {
      firstAbility = List.filled(10, null);
      secondAbility = List.filled(10, null);
      thirdAbility = List.filled(10, null);
      history.clear();
      pIdx = 75;
      _recalc();
    });
  }

  void _recalc() {
    final s1 = firstAbility.where((e) => e == true).length;
    final s2 = secondAbility.where((e) => e == true).length;
    final d  = thirdAbility.where((e) => e == true).length;

    final r1 = firstAbility.where((e) => e == null).length;
    final r2 = secondAbility.where((e) => e == null).length;
    final r3 = thirdAbility.where((e) => e == null).length;

    if (d >= 5) {
      rec77 = null;
      rec97 = null;
      return;
    }

    rec77 = calc.bestAction77(s1, s2, d, r1, r2, r3, pIdx);
    rec97 = calc.bestAction97(s1, s2, d, r1, r2, r3, pIdx);
  }
}

class _ActionRecord {
  final List<bool?> abilityList;
  final int index;
  final bool? oldValue;
  final int oldPIdx;
  _ActionRecord(this.abilityList, this.index, this.oldValue, this.oldPIdx);
}
class StoneCalc {
  final Map<String, double> _m77 = {};
  final Map<String, double> _m97 = {};

  static int succ(int p) => max(25, p - 10);
  static int fail(int p) => min(75, p + 10);
  static double pd(int p) => p / 100.0;

  static String k(int s1,int s2,int d,int r1,int r2,int r3,int p) =>
      "$s1,$s2,$d,$r1,$r2,$r3,$p";

  double value77(int s1,int s2,int d,int r1,int r2,int r3,int p) {
    if (d >= 5) return 0.0;
    if (r1==0&&r2==0&&r3==0) return (s1>=7&&s2>=7)?1.0:0.0;
    final key = k(s1,s2,d,r1,r2,r3,p);
    if (_m77.containsKey(key)) return _m77[key]!;
    final pr = pd(p);
    double best=-1e18;
    if (r1>0) {
      final v = pr*value77(s1+1,s2,d,r1-1,r2,r3,succ(p))
          +(1-pr)*value77(s1,s2,d,r1-1,r2,r3,fail(p));
      if (v>best) best=v;
    }
    if (r2>0) {
      final v = pr*value77(s1,s2+1,d,r1,r2-1,r3,succ(p))
          +(1-pr)*value77(s1,s2,d,r1,r2-1,r3,fail(p));
      if (v>best) best=v;
    }
    if (r3>0) {
      final v = pr*value77(s1,s2,d+1,r1,r2,r3-1,succ(p))
          +(1-pr)*value77(s1,s2,d,r1,r2,r3-1,fail(p));
      if (v>best) best=v;
    }
    return _m77[key]=best;
  }

  double value97(int s1,int s2,int d,int r1,int r2,int r3,int p) {
    if (d >= 5) return 0.0;
    if (r1==0&&r2==0&&r3==0) {
      final ok=(s1>=9&&s2>=7)||(s1>=7&&s2>=9);
      return ok?1.0:0.0;
    }
    final key=k(s1,s2,d,r1,r2,r3,p);
    if (_m97.containsKey(key)) return _m97[key]!;
    final pr=pd(p);
    double best=-1e18;
    if (r1>0) {
      final v = pr*value97(s1+1,s2,d,r1-1,r2,r3,succ(p))
          +(1-pr)*value97(s1,s2,d,r1-1,r2,r3,fail(p));
      if (v>best) best=v;
    }
    if (r2>0) {
      final v = pr*value97(s1,s2+1,d,r1,r2-1,r3,succ(p))
          +(1-pr)*value97(s1,s2,d,r1,r2-1,r3,fail(p));
      if (v>best) best=v;
    }
    if (r3>0) {
      final v = pr*value97(s1,s2,d+1,r1,r2,r3-1,succ(p))
          +(1-pr)*value97(s1,s2,d,r1,r2,r3-1,fail(p));
      if (v>best) best=v;
    }
    return _m97[key]=best;
  }

  Choice? bestAction77(int s1,int s2,int d,int r1,int r2,int r3,int p) {
    if (d>=5 || (r1==0&&r2==0&&r3==0)) return null;
    final pr=pd(p);
    double best=-1e18; Choice? ans;
    if (r1>0) {
      final v = pr*value77(s1+1,s2,d,r1-1,r2,r3,succ(p))
          +(1-pr)*value77(s1,s2,d,r1-1,r2,r3,fail(p));
      if (v>best){best=v; ans=Choice.inc1;}
    }
    if (r2>0) {
      final v = pr*value77(s1,s2+1,d,r1,r2-1,r3,succ(p))
          +(1-pr)*value77(s1,s2,d,r1,r2-1,r3,fail(p));
      if (v>best){best=v; ans=Choice.inc2;}
    }
    if (r3>0) {
      final v = pr*value77(s1,s2,d+1,r1,r2,r3-1,succ(p))
          +(1-pr)*value77(s1,s2,d,r1,r2,r3-1,fail(p));
      if (v>best){best=v; ans=Choice.dec;}
    }
    return ans;
  }

  Choice? bestAction97(int s1,int s2,int d,int r1,int r2,int r3,int p) {
    if (d>=5 || (r1==0&&r2==0&&r3==0)) return null;
    final pr=pd(p);
    double best=-1e18; Choice? ans;
    if (r1>0) {
      final v = pr*value97(s1+1,s2,d,r1-1,r2,r3,succ(p))
          +(1-pr)*value97(s1,s2,d,r1-1,r2,r3,fail(p));
      if (v>best){best=v; ans=Choice.inc1;}
    }
    if (r2>0) {
      final v = pr*value97(s1,s2+1,d,r1,r2-1,r3,succ(p))
          +(1-pr)*value97(s1,s2,d,r1,r2-1,r3,fail(p));
      if (v>best){best=v; ans=Choice.inc2;}
    }
    if (r3>0) {
      final v = pr*value97(s1,s2,d+1,r1,r2,r3-1,succ(p))
          +(1-pr)*value97(s1,s2,d,r1,r2,r3-1,fail(p));
      if (v>best){best=v; ans=Choice.dec;}
    }
    return ans;
  }
}

enum Choice { inc1, inc2, dec }
String choiceText(Choice c) =>
    c == Choice.inc1 ? "증가 능력 1" :
    c == Choice.inc2 ? "증가 능력 2" : "감소 능력";