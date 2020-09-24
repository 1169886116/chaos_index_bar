import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FriendsPage(),
    );
  }
}

final Color WeChatThemeColor = Color.fromRGBO(220, 220, 220, 1);

//屏幕宽/高
double ScreenWidth(BuildContext context) => MediaQuery.of(context).size.width;
double ScreenHeight(BuildContext context) => MediaQuery.of(context).size.height;

class FriendsPage extends StatefulWidget {
  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage>
    with AutomaticKeepAliveClientMixin {
  //字典里面放item和高度的对应数据
  final Map _groupOffsetMap = {
    INDEX_WORDS[0]: 0.0,
    INDEX_WORDS[1]: 0.0,
  };

  ScrollController _scrollController;

  final List<Friends> _listDatas = [];

  @override
  void initState() {
    super.initState();
//    _listDatas.addAll(datas);
//    _listDatas.addAll(datas);
    //多弄一点数据!
    _listDatas..addAll(datas)..addAll(datas);
    //排序!
    _listDatas.sort((Friends a, Friends b) {
      return a.indexLetter.compareTo(b.indexLetter);
    });

    var _groupOffset = 54.5 * 4;
    //经过循环计算,将每一个头的位置算出来.放入字典!
    for (int i = 0; i < _listDatas.length; i++) {
      if (i < 1) {
        //第一个Cell
        _groupOffsetMap.addAll({_listDatas[i].indexLetter: _groupOffset});
        //保存完了再加_groupOffset偏移
        _groupOffset += 84.5;
      } else if (_listDatas[i].indexLetter == _listDatas[i - 1].indexLetter) {
        //此时没有头部,只需要加偏移量就好了!
        _groupOffset += 54.5;
      } else {
        //这部分就是有头部的Cell了!
        _groupOffsetMap.addAll({_listDatas[i].indexLetter: _groupOffset});
        _groupOffset += 84.5;
      }
    }

    _scrollController = ScrollController();
  }

  final List<Friends> _headerData = [
    Friends(
        imageUrl:
            'https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=1601482904,1022427523&fm=26&gp=0.jpg',
        name: '新的朋友'),
    Friends(
        imageUrl:
            'https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=1601482904,1022427523&fm=26&gp=0.jpg',
        name: '群聊'),
    Friends(
        imageUrl:
            'https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=1601482904,1022427523&fm=26&gp=0.jpg',
        name: '标签'),
    Friends(
        imageUrl:
            'https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=1601482904,1022427523&fm=26&gp=0.jpg',
        name: '公众号'),
  ];

  Widget _itemForRow(BuildContext context, int index) {
    //系统图标的Cell
    if (index < _headerData.length) {
      return _FriendCell(
        imageUrl: _headerData[index].imageUrl,
        name: _headerData[index].name,
      );
    }
    //显示剩下的Cell
    //如果当前和上一个Cell的IndexLetter一样,就不显示!
    bool _hideIndexLetter = (index - 4 > 0 &&
        _listDatas[index - 4].indexLetter == _listDatas[index - 5].indexLetter);
    return _FriendCell(
      imageUrl: _listDatas[index - 4].imageUrl,
      name: _listDatas[index - 4].name,
      groupTitle: _hideIndexLetter ? null : _listDatas[index - 4].indexLetter,
    );

//    if (index - 4 > 0 &&
//        _listDatas[index - 4].indexLetter ==
//            _listDatas[index - 5].indexLetter) {
//      return _FriendCell(
//        imageUrl: _listDatas[index - 4].imageUrl,
//        name: _listDatas[index - 4].name,
//      );
//    }
//    //剩下的都显示啊!
//    return _FriendCell(
//      imageUrl: _listDatas[index - 4].imageUrl,
//      name: _listDatas[index - 4].name,
//      groupTitle: _listDatas[index - 4].indexLetter,
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: WeChatThemeColor,
        title: Text('通讯录'),
        actions: <Widget>[
          GestureDetector(
            child: Container(
              margin: EdgeInsets.only(right: 10),
              child: Image(
                image: AssetImage('images/icon_friends_add.png'),
                width: 25,
              ),
            ),
//            onTap: () {
//              Navigator.of(context).push(MaterialPageRoute(
//                  builder: (BuildContext context) => DiscoverChildPage(
//                        title: '添加朋友',
//                      )));
//            },
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          Container(
              color: WeChatThemeColor,
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _listDatas.length + _headerData.length,
                itemBuilder: _itemForRow,
              )), //列表
          IndexBar(
            indexBarCallBack: (String str) {
              if (_groupOffsetMap[str] != null) {
                _scrollController.animateTo(_groupOffsetMap[str],
                    duration: Duration(milliseconds: 1), curve: Curves.easeIn);
              }
            },
          ), //悬浮检索控件
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class _FriendCell extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String groupTitle;
  final String imageAssets;

  const _FriendCell(
      {this.imageUrl, this.name, this.groupTitle, this.imageAssets});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 10),
          height: groupTitle != null ? 30 : 0,
          color: Color.fromRGBO(1, 1, 1, 0.0),
          child: groupTitle != null
              ? Text(
                  groupTitle,
                  style: TextStyle(color: Colors.grey),
                )
              : null,
        ), //cell的头
        Container(
          color: Colors.white,
          child: Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(10),
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.0),
                    image: DecorationImage(
                      image: imageUrl != null
                          ? NetworkImage(imageUrl)
                          : AssetImage(imageAssets),
                    )),
              ), //图片
              Container(
                child: Text(
                  name,
                  style: TextStyle(fontSize: 17),
                ),
              ), //昵称
            ],
          ),
        ), //Cell内容
        Container(
          height: 0.5,
          color: WeChatThemeColor,
          child: Row(
            children: <Widget>[
              Container(
                width: 50,
                color: Colors.white,
              )
            ],
          ),
        ) //分割线
      ],
    );
  }
}

class Friends {
  final String imageUrl;
  final String name;
  final String indexLetter;

  Friends({this.imageUrl, this.name, this.indexLetter});
}

List<Friends> datas = [
  Friends(
      imageUrl: 'https://randomuser.me/api/portraits/women/27.jpg',
      name: 'Lina',
      indexLetter: 'L'),
  Friends(
      imageUrl: 'https://randomuser.me/api/portraits/women/17.jpg',
      name: '菲儿',
      indexLetter: 'F'),
  Friends(
      imageUrl: 'https://randomuser.me/api/portraits/women/16.jpg',
      name: '安莉',
      indexLetter: 'A'),
  Friends(
      imageUrl: 'https://randomuser.me/api/portraits/men/31.jpg',
      name: '阿贵',
      indexLetter: 'A'),
  Friends(
      imageUrl: 'https://randomuser.me/api/portraits/women/22.jpg',
      name: '贝拉',
      indexLetter: 'B'),
  Friends(
      imageUrl: 'https://randomuser.me/api/portraits/women/37.jpg',
      name: 'Lina',
      indexLetter: 'L'),
  Friends(
      imageUrl: 'https://randomuser.me/api/portraits/women/18.jpg',
      name: 'Nancy',
      indexLetter: 'N'),
  Friends(
      imageUrl: 'https://randomuser.me/api/portraits/men/47.jpg',
      name: '扣扣',
      indexLetter: 'K'),
  Friends(
      imageUrl: 'https://randomuser.me/api/portraits/men/3.jpg',
      name: 'Jack',
      indexLetter: 'J'),
  Friends(
      imageUrl: 'https://randomuser.me/api/portraits/women/5.jpg',
      name: 'Emma',
      indexLetter: 'E'),
  Friends(
      imageUrl: 'https://randomuser.me/api/portraits/women/24.jpg',
      name: 'Abby',
      indexLetter: 'A'),
  Friends(
      imageUrl: 'https://randomuser.me/api/portraits/men/15.jpg',
      name: 'Betty',
      indexLetter: 'B'),
  Friends(
      imageUrl: 'https://randomuser.me/api/portraits/men/13.jpg',
      name: 'Tony',
      indexLetter: 'T'),
  Friends(
      imageUrl: 'https://randomuser.me/api/portraits/men/26.jpg',
      name: 'Jerry',
      indexLetter: 'J'),
  Friends(
      imageUrl: 'https://randomuser.me/api/portraits/men/36.jpg',
      name: 'Colin',
      indexLetter: 'C'),
  Friends(
      imageUrl: 'https://randomuser.me/api/portraits/women/12.jpg',
      name: 'Haha',
      indexLetter: 'H'),
  Friends(
      imageUrl: 'https://randomuser.me/api/portraits/women/11.jpg',
      name: 'Ketty',
      indexLetter: 'K'),
  Friends(
      imageUrl: 'https://randomuser.me/api/portraits/women/13.jpg',
      name: 'Lina',
      indexLetter: 'L'),
  Friends(
      imageUrl: 'https://randomuser.me/api/portraits/women/23.jpg',
      name: 'Lina',
      indexLetter: 'L'),
];
