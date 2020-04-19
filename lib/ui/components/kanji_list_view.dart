import 'package:flutter/material.dart';

import 'package:kanji_dictionary/ui/kanji_detail_page.dart';
import 'package:kanji_dictionary/models/kanji.dart';
import 'chip_collections.dart';
import 'kanji_list_tile.dart';

//typedef void StringCallback(String str);

class KanjiListView extends StatelessWidget {
  final List<Kanji> kanjis;
  final String fallBackFont;
  final ValueChanged<String> onLongPressed;
  final bool canRemove;
  final ScrollController scrollController;
  final ScrollPhysics scrollPhysics;

  KanjiListView(
      {this.kanjis,
      this.fallBackFont,
      this.onLongPressed,
      this.canRemove = false,
      this.scrollController,
      this.scrollPhysics = const AlwaysScrollableScrollPhysics()})
      : assert(kanjis != null);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        physics: scrollPhysics,
        shrinkWrap: true,
        controller: scrollController,
        itemBuilder: (_, index) {
          return KanjiListTile(
            kanji: kanjis[index],
            onLongPressed: onLongPressed,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => KanjiDetailPage(kanji: kanjis[index]))),
          );
        },
        separatorBuilder: (_, __) => Divider(height: 0),
        itemCount: kanjis.length);
  }
}
