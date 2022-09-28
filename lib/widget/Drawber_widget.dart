import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Entry
{
  final String title;
  final List<Entry> children;
  Entry(this.title,[this.children=const <Entry>[]]);
}

final List<Entry> data=<Entry>[
  Entry(
      'Chapter A',
      <Entry>[
        Entry('Section AB',
            <Entry>[
              Entry('Item A1'),
              Entry('Item A2'),
              Entry('Item A3'),
            ]),
      ]
  ),
  Entry(
    'Chapter B',
  ),
  Entry(
    'Chapter C',
  ),
  Entry(
    'Chapter C',
        <Entry>[
          Entry('Item c1'),
          Entry('Item c2'),
          Entry('Item c3'),
        ]),
];

class EntryItem extends StatelessWidget{
  const EntryItem(this.entry);
  final Entry entry;

  Widget _buildTiles(Entry root)
  {
      if(root.children.isEmpty)
        {
          return ListTile(title: Text(root.title)
          );
        }
      return ExpansionTile(
        key: PageStorageKey<Entry>(root),
        title: Text(root.title),
        children: root.children.map<Widget>(_buildTiles).toList(),
      );
  }

  @override
  Widget build(BuildContext context)
  {
    return _buildTiles(entry);
  }
}