import 'package:bd_pick/component/background_container.dart';
import 'package:bd_pick/const/enum.dart';
import 'package:flutter/material.dart';

class AdMain extends StatefulWidget {
  const AdMain({super.key});

  @override
  State<StatefulWidget> createState() => _AdMainState();
}

class _AdMainState extends State<AdMain> with TickerProviderStateMixin {
  late final TabController _tabController;

  bool isSelectionMode = false;
  final int listLength = 30;
  late List<bool> _selected;
  bool _selectAll = false;
  bool _isGridMode = false;

  @override
  void initState() {
    super.initState();
    // _tabController = TabController(length: 3, vsync: this);
    _tabController = TabController(length: 3, vsync: this);
    initializeSelection();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void initializeSelection() {
    _selected = List<bool>.generate(listLength, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    PreferredSizeWidget bottom = TabBar(
      controller: _tabController,
      tabs: <Widget>[
        Tab(
          icon: Text(
            '전체보기',
            style: TextStyle(fontSize: 20.0),
          ),
        ),
        Tab(
          icon: Text(
            '추천광고',
            style: TextStyle(fontSize: 20.0),
          ),
        ),
        Tab(
            icon: Text(
          '내가찜한광고',
          style: TextStyle(fontSize: 20.0),
        ))
      ],
    );
    return BackGroundContainer(
        isUseAppBar: true,
        appBarType: AppBarType.isSigned,
        isUseHeight: true,
        // bottom: bottom,
        child: Column(
          // mainAxisSize: MainAxisSize.max,
          children: [
            bottom,
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  GridBuilder(
                    isSelectionMode: isSelectionMode,
                    selectedList: _selected,
                    onSelectionChange: (bool x) {
                      setState(() {
                        isSelectionMode = x;
                      });
                    },
                  ),
                  GridBuilder(
                    isSelectionMode: isSelectionMode,
                    selectedList: _selected,
                    onSelectionChange: (bool x) {
                      setState(() {
                        isSelectionMode = x;
                      });
                    },
                  ),
                  GridBuilder(
                    isSelectionMode: isSelectionMode,
                    selectedList: _selected,
                    onSelectionChange: (bool x) {
                      setState(() {
                        isSelectionMode = x;
                      });
                    },
                  )
                ],
              ),
            ),
          ],
        )

        // child: Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     Text(
        //       'ad page',
        //     )
        //   ],
        // ),
        );
  }
}

class GridBuilder extends StatefulWidget {
  const GridBuilder({
    super.key,
    required this.selectedList,
    required this.isSelectionMode,
    required this.onSelectionChange,
  });

  final bool isSelectionMode;
  final Function(bool)? onSelectionChange;
  final List<bool> selectedList;

  @override
  GridBuilderState createState() => GridBuilderState();
}

class GridBuilderState extends State<GridBuilder> {
  void _toggle(int index) {
    if (widget.isSelectionMode) {
      setState(() {
        widget.selectedList[index] = !widget.selectedList[index];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        itemCount: widget.selectedList.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (_, int index) {
          return InkWell(
            onTap: () => _toggle(index),
            onLongPress: () {
              if (!widget.isSelectionMode) {
                setState(() {
                  widget.selectedList[index] = true;
                });
                widget.onSelectionChange!(true);
              }
            },
            child: GridTile(
                child: Container(
              child: widget.isSelectionMode
                  ? Checkbox(
                      onChanged: (bool? x) => _toggle(index),
                      value: widget.selectedList[index])
                  : const Icon(Icons.image),
            )),
          );
        });
  }
}
