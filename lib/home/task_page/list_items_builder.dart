import 'package:flutter/material.dart';
import 'package:habit_shift/home/task_page/empty_content.dart';

typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

class ListItemsBuilder<T> extends StatelessWidget {
  const ListItemsBuilder({
    Key key,
    @required this.snapshot,
    @required this.itemBuilder,
  }) : super(key: key);

  final AsyncSnapshot<List<T>> snapshot;
  final ItemWidgetBuilder<T> itemBuilder;

  @override
  Widget build(BuildContext context) {
    if (snapshot.hasData) {
      final List<T> items = snapshot.data;
      if (items.isNotEmpty) {
        return _buildList(items);
      } else {
        return EmptyContent();
      }
    } else if (snapshot.hasError) {
      return EmptyContent(
        title: 'Ooops Something went wrong',
        message: 'Network Connection Needed',
      );
    }
    return Center(child: CircularProgressIndicator());
  }

  Widget _buildList(List<T> items) {
    return ListView.separated(
        itemBuilder: (context, index) {
          if (index == 0 || index == items.length + 1) {
            return Container();
          }
          return itemBuilder(context, items[index - 1]);
        },
        separatorBuilder: (context, index) => Divider(
              height: 16,
            ),
        itemCount: items.length + 2);
  }
}
