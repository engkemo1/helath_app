import 'package:flutter/material.dart';

import '../constants/app_colors/app_colors.dart';

class CustomDropdown extends StatefulWidget {
  final String? labelText;
  final Widget? trailing;
  final bool hasSearch;
  final double itemHeight;
  final List<dynamic> items;
  final String? selectedItem;
  final String hint;
  final ValueChanged<String> onChanged;

  const CustomDropdown({
    super.key,
    required this.items,
    required this.selectedItem,
    required this.onChanged,
    required this.hint,
     this.labelText,
    this.trailing,
    required this.hasSearch,
    required this.itemHeight,
  });

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  late String dropdownValue;
  bool isDropdownOpened = false;
  TextEditingController searchController = TextEditingController();
  List<dynamic> filteredItems = [];

  @override
  void initState() {
    super.initState();
    filteredItems = widget.items; // Initialize filtered items with all items
  }

  void _filterItems(String query) {
    setState(() {
      filteredItems = widget.items.where((item) {
        return item.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if(widget.labelText!=null)
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.labelText!,
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: AppColors.lightBlackColor,
                  ),
                ),
                widget.trailing ?? const SizedBox()
              ],
            ),
            const SizedBox(height: 6,),
          ],
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              isDropdownOpened = !isDropdownOpened;
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.grayModern200),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                widget.selectedItem != null
                    ? Text(
                        widget.selectedItem!,
                        style: const TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 16),
                      )
                    : Text(
                        widget.hint,
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: AppColors.greyColor),
                      ),
                Icon(Icons.keyboard_arrow_down_rounded,
                    color: AppColors.grayModern400),
              ],
            ),
          ),
        ),
        if (isDropdownOpened)
          Container(
              height: widget.itemHeight,
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.grayModern200),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListView(children: [
                widget.hasSearch
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: TextField(
                          controller: searchController,
                          onChanged: _filterItems,
                          decoration: InputDecoration(
                            hintText: 'Search...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  BorderSide(color: AppColors.grayModern100),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  BorderSide(color: AppColors.grayModern100),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  BorderSide(color: AppColors.grayModern100),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 5),
                          ),
                        ),
                      )
                    : const SizedBox(),
                ...filteredItems.map((value) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        dropdownValue = value;
                        widget.onChanged(value);
                        isDropdownOpened = false;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        value,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  );
                }),
              ]))
      ],
    );
  }
}
