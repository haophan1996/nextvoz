import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SectionHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String title;
  final double height;
  final String tag;
  final Widget child;

  SectionHeaderDelegate(this.title, this.tag, this.child, [this.height = 10]);

  @override
  Widget build(context, double shrinkOffset, bool overlapsContent) {
    return Container(alignment: Alignment.center,color: Theme.of(context).backgroundColor, child: this.child);
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
}