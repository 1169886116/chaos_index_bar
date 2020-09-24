part of 'chaos_index_bar.dart';

//屏幕宽/高
double ScreenWidth(BuildContext context) => MediaQuery.of(context).size.width;
double ScreenHeight(BuildContext context) => MediaQuery.of(context).size.height;

class IndexBar extends StatefulWidget {
  //气泡
  Image bubbleImage;
  Function(String str) indexBarCallBack;

  IndexBar({this.indexBarCallBack, this.bubbleImage});

  @override
  _IndexBarState createState() => _IndexBarState();
}

int getIndex(BuildContext context, Offset globalPosition) {
  //拿到box
  RenderBox box = context.findRenderObject();
  //拿到y值
  double y = box.globalToLocal(globalPosition).dy;
  //算出字符高度
  var itemHeight = ScreenHeight(context) / 2 / INDEX_WORDS.length;
  //算出第几个item,并且给一个取值范围
  int index = (y ~/ itemHeight).clamp(0, INDEX_WORDS.length - 1);

//  print('现在选中的是${INDEX_WORDS[index]}');
  return index;
}

class _IndexBarState extends State<IndexBar> {
  Color _bkColor = Color.fromRGBO(1, 1, 1, 0.0);
  Color _textColor = Colors.black;
  double _indicatorY = 0.0;
  String _indicatorText = 'A';
  bool _indocatorHidden = true;

  @override
  Widget build(BuildContext context) {
    List<Widget> words = [];
    for (int i = 0; i < INDEX_WORDS.length; i++) {
      words.add(Expanded(
        child: Text(
          INDEX_WORDS[i],
          style: TextStyle(fontSize: 10, color: _textColor),
        ),
      ));
    }
    return Positioned(
        right: 0.0,
        height: ScreenHeight(context) / 2,
        top: ScreenHeight(context) / 8,
        width: 120,
        child: Row(
          children: <Widget>[
            Container(
              alignment: Alignment(0, _indicatorY),
              width: 100,
              child: _indocatorHidden
                  ? null
                  : Stack(
                      alignment: Alignment(-0.2, 0),
                      children: <Widget>[
                        Container(
                          width: 60,
                          height: 60,
                          child: widget.bubbleImage != null
                              ? widget.bubbleImage
                              : Icon(
                                  Icons.favorite,
                                  size: 80,
                                ),
                        ),
                        Text(
                          _indicatorText,
                          style: TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ), //气泡
            ), //这个是指示器
            GestureDetector(
              child: Container(
                width: 20,
                color: _bkColor,
                child: Column(
                  children: words,
                ),
              ),
              onVerticalDragUpdate: (DragUpdateDetails details) {
                int index = getIndex(context, details.globalPosition);

                setState(() {
                  _indicatorText = INDEX_WORDS[index];
                  //根据我们索引条的Alignment的Y值进行运算的.从-1.1 到 1.1
                  //整个的Y包含的值是2.2
                  _indicatorY = 2.2 / 28 * index - 1.1;
                  _indocatorHidden = false;
                });
                widget.indexBarCallBack(INDEX_WORDS[index]);
              },
              onVerticalDragDown: (DragDownDetails details) {
                int index = getIndex(context, details.globalPosition);
                _indicatorText = INDEX_WORDS[index];
                _indicatorY = 2.2 / 28 * index - 1.1;
                _indocatorHidden = false;
                widget.indexBarCallBack(INDEX_WORDS[index]);
//          print('现在点击的位置是${details.globalPosition}');
                setState(() {
                  _bkColor = Color.fromRGBO(1, 1, 1, 0.5);
                  _textColor = Colors.white;
                });
              },
              onVerticalDragEnd: (DragEndDetails details) {
                setState(() {
                  _indocatorHidden = true;
                  _bkColor = Color.fromRGBO(1, 1, 1, 0.0);
                  _textColor = Colors.black;
                });
              },
            ), //这个是索引条!
          ],
        ));
  }
}

const INDEX_WORDS = [
  '🔍',
  '☆',
  'A',
  'B',
  'C',
  'D',
  'E',
  'F',
  'G',
  'H',
  'I',
  'J',
  'K',
  'L',
  'M',
  'N',
  'O',
  'P',
  'Q',
  'R',
  'S',
  'T',
  'U',
  'V',
  'W',
  'X',
  'Y',
  'Z'
];
