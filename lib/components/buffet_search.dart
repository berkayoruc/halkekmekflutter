import 'package:flutter/material.dart';

class BuffetSearch extends SearchDelegate {
  final List searchList;

  BuffetSearch(this.searchList);

  @override
  String get searchFieldLabel => 'Büfe ara';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(icon: const Icon(Icons.clear), onPressed: () => query = '')
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (searchList.isEmpty) {
      return const Center(
        child: Text('Büfe bulunamadı'),
      );
    } else {
      final results = searchList.where((buffet) =>
          buffet.name.toLowerCase().contains(query.toLowerCase()) ||
          buffet.district.toLowerCase().contains(query.toLowerCase()) ||
          buffet.neighborhood.toLowerCase().contains(query.toLowerCase()));
      return Container(
        padding: const EdgeInsets.all(8),
        child: ListView(
            children: results
                .map<ListTile>((buffet) => ListTile(
                      title: Text(buffet.name),
                      onTap: () => close(context, buffet),
                    ))
                .toList()),
      );
    }
  }
}
