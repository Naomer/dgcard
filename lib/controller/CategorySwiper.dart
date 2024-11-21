import 'package:flutter/material.dart';

class CategorySwiper extends StatefulWidget {
  final List<String> parentCategories;
  final Function(String) fetchSubCategories;

  const CategorySwiper({
    super.key,
    required this.parentCategories,
    required this.fetchSubCategories,
  });

  @override
  _CategorySwiperState createState() => _CategorySwiperState();
}

class _CategorySwiperState extends State<CategorySwiper> {
  int _selectedIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 1.0,
          color: Colors.grey[300],
        ),
        Container(
          padding: const EdgeInsets.all(8.0),
          height: 46,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.parentCategories.length,
            itemBuilder: (context, index) {
              final categoryName = widget.parentCategories[index];

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedIndex = index;
                    _pageController.jumpToPage(index);
                    widget.fetchSubCategories(categoryName);
                  });
                },
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border(
                          bottom: BorderSide(
                            color: _selectedIndex == index
                                ? Colors.red
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                      child: Text(
                        categoryName,
                        style: const TextStyle(fontSize: 11),
                      ),
                    ),
                    if (index < widget.parentCategories.length - 1)
                      Container(
                        width: 1,
                        height: 20,
                        color: Colors.grey[300],
                      ),
                  ],
                ),
              );
            },
          ),
        ),
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            itemCount: widget.parentCategories.length,
            itemBuilder: (context, index) {
              return Center(
                child: Text(
                  'Content for ${widget.parentCategories[index]}',
                  style: const TextStyle(fontSize: 18),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
