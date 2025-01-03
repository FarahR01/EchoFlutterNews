import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_easy_search_bar/flutter_easy_search_bar.dart';

class SearchTopBar extends StatelessWidget implements PreferredSizeWidget {
  const SearchTopBar({super.key, required this.onSearch});

  final Function(String) onSearch;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return EasySearchBar(
      elevation: 2,
      showClearSearchIcon: false,
      iconTheme: IconThemeData(
        color: Theme.of(context).colorScheme.onSurface,
        size: 28,
      ),
      searchBackIconTheme: IconThemeData(
        color: Theme.of(context).colorScheme.onSurface,
        size: 28,
      ),
      onSearch: onSearch,
      animationDuration: const Duration(milliseconds: 220),
      backgroundColor: Theme.of(context).colorScheme.surface,
      searchTextKeyboardType: TextInputType.name,
      searchCursorColor: Theme.of(context).colorScheme.surfaceTint,
      title: Padding(
        padding: const EdgeInsets.only(right: 19),
        child: Text(
          'Echo Flutter News',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontFamily: GoogleFonts.texturina().fontFamily,
            fontSize: 28,
          ),
        ),
      ),
    );
  }
}
