import 'package:aidex/bloc/index_cards_overview_bloc.dart';
import 'package:flutter/material.dart';

/// The state of the [SearchBar].
class CardSearchBar extends StatelessWidget {
  /// Constructor for the [CardSearchBar].
  CardSearchBar(
      {required final IndexCardOverviewBloc indexCardOverviewBloc, super.key})
      : _indexCardOverviewBloc = indexCardOverviewBloc {
    searchController.addListener(_search);
  }

  ///Key to identify the sort button (for testing).
  static const Key sortButtonKey = Key('sortButton');

  ///Icon for IconButton when indexCards are unsorted.
  static const Icon unsortedIcon = Icon(Icons.type_specimen_outlined);

  ///Icon for IconButton when indexCards are sorted.
  static const Icon sortedIcon = Icon(Icons.type_specimen);

  /// The searchController
  final SearchController searchController = SearchController();

  /// The indexCardOverviewBloc
  final IndexCardOverviewBloc _indexCardOverviewBloc;

  void _search() {
    _indexCardOverviewBloc.add(SearchIndexCards(query: searchController.text));
  }

  void _onSort(final bool sortAsc) {
    _indexCardOverviewBloc.add(SortIndexCards(sortAsc: sortAsc));
  }

  @override
  Widget build(final BuildContext context) {
    bool sortAsc = true;
    return SearchBar(
      controller: searchController,
      leading: const Icon(Icons.search),
      trailing: <Widget>[
        Tooltip(
          message: 'Toggle Sort',
          child: StatefulBuilder(
              builder: (final context, final setState) => IconButton(
                    key: sortButtonKey,
                    isSelected: sortAsc,
                    onPressed: () {
                      setState(() {
                        sortAsc = !sortAsc;
                      });
                      _onSort(sortAsc);
                    },
                    icon: unsortedIcon,
                    selectedIcon: sortedIcon,
                  )),
        )
      ],
    );
  }
}
