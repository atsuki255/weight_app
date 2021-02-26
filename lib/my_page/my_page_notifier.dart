import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:state_notifier/state_notifier.dart';

part 'my_page_notifier.freezed.dart';

@freezed
abstract class MyPageState with _$MyPageState {
  const factory MyPageState({
    @Default(0) int count,
    String weight,
    String comment,
    @Default([]) List<Map<String, String>> record,
  }) = _MyPageState;
}

class MyPageNotifier extends StateNotifier<MyPageState> with LocatorMixin {
  MyPageNotifier({
    @required this.context,
  }) : super(const MyPageState());

  final BuildContext context;

  @override
  void dispose() {
    print('dispose');
    super.dispose();
  }

  @override
  void initState() {}

  void popUpForm() {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text('今日の体重を入力しよう'),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 24,
          ),
          children: [
            Row(
              children: [
                Container(
                  width: 200,
                  padding: EdgeInsets.only(left: 4),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: '嘘つくなよ',
                      labelText: '今日の体重',
                    ),
                    onChanged: (value) {
                      _saveWeight(value);
                    }, // 体重の数値入力
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text('Kg'),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: 200,
              padding: EdgeInsets.only(left: 4),
              child: TextFormField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '後悔先に立たず',
                    labelText: '懺悔の一言'),
                onChanged: (value) {
                  _saveComment(value);
                }, // コメントの入力
              ),
            ),
            SizedBox(
              height: 20,
            ),
            InkWell(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 40),
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  border: Border.all(color: Colors.blueAccent),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '登録',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ),
              onTap: () {
                //TODO
                _register();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _saveWeight(String value) {
    state = state.copyWith(weight: value);
    print(state.weight);
  }

  void _saveComment(String value) {
    state = state.copyWith(comment: value);
    print(state.comment);
  }

  void _register() {
    final dateTime = DateTime.now();
    final day = '${dateTime.year}年${dateTime.month}月${dateTime.day}日';
    final formRecord = {
      'weight': state.weight,
      'comment': state.comment,
      'day': DateTime.now().toString(),
    };
    print(formRecord);
    final newRecord = List<Map<String, String>>.from(state.record);
    newRecord.add(formRecord);
    state = state.copyWith(record: newRecord);
    print(state.record);
  }
}
