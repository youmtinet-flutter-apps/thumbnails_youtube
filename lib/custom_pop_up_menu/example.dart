import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'custom_pop_up_menu.dart';

void main() {
  runApp(const MyApp());
}

class ChatModel {
  String content;
  bool isMe;

  ChatModel(this.content, {this.isMe = false});
}

class ItemModel {
  String title;
  IconData icon;

  ItemModel(this.title, this.icon);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CustomPopupMenu',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<ChatModel> messages;
  late List<ItemModel> menuItems;
  final CustomPopupMenuController _controller = CustomPopupMenuController();

  @override
  void initState() {
    messages = [
      ChatModel('在吗？'),
      ChatModel('咋了？找我有事吗？', isMe: true),
      ChatModel('没啥就像看看你在不在'),
      ChatModel('到底啥事你说啊，我还在工作呢', isMe: true),
      ChatModel('？', isMe: true),
      ChatModel('下面开始介绍Flutter'),
      ChatModel(
          'Flutter是谷歌的移动UI框架，可以快速在iOS和Android上构建高质量的原生用户界面。 Flutter可以与现有的代码一起工作。在全世界，Flutter正在被越来越多的开发者和组织使用，并且Flutter是完全免费、开源的。'),
      ChatModel('就这？？？', isMe: true),
      ChatModel('在吗？'),
      ChatModel('咋了？找我有事吗？', isMe: true),
      ChatModel('没啥就像看看你在不在'),
      ChatModel('到底啥事你说啊，我还在工作呢', isMe: true),
      ChatModel('？', isMe: true),
      ChatModel('下面开始介绍Flutter'),
      ChatModel(
          'Flutter是谷歌的移动UI框架，可以快速在iOS和Android上构建高质量的原生用户界面。 Flutter可以与现有的代码一起工作。在全世界，Flutter正在被越来越多的开发者和组织使用，并且Flutter是完全免费、开源的。'),
      ChatModel('就这？？？', isMe: true),
    ];
    menuItems = [
      ItemModel('发起群聊', Icons.chat_bubble),
      ItemModel('添加朋友', Icons.group_add),
      ItemModel('扫一扫', Icons.settings_overscan),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CustomPopupMenu'),
        actions: <Widget>[
          CustomPopupMenu(
            child: Container(
              child: const Icon(Icons.add_circle_outline, color: Colors.white),
              padding: const EdgeInsets.all(20),
            ),
            enablePassEvent: true,
            pressType: PressType.singleClick,
            verticalMargin: -10,
            controller: _controller,
            menuBuilder: () => ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Container(
                color: const Color(0xFF4C4C4C),
                child: IntrinsicWidth(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: getMenuItems(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraint) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraint.maxHeight),
              child: Column(
                children: messages
                    .map(
                      (message) => MessageContent(
                        message,
                      ),
                    )
                    .toList(),
              ),
            ),
          );
        },
      ),
    );
  }

  List<GestureDetector> getMenuItems() {
    return menuItems
        .map(
          (item) => GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              if (kDebugMode) {
                print("onTap");
              }
              _controller.hideMenu();
            },
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: <Widget>[
                  Icon(
                    item.icon,
                    size: 15,
                    color: Colors.white,
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 10),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        item.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
        .toList();
  }
}

// ignore: must_be_immutable
class MessageContent extends StatelessWidget {
  MessageContent(this.message, {Key? key}) : super(key: key);

  final ChatModel message;
  List<ItemModel> menuItems = [
    ItemModel('复制', Icons.content_copy),
    ItemModel('转发', Icons.send),
    ItemModel('收藏', Icons.collections),
    ItemModel('删除', Icons.delete),
    ItemModel('多选', Icons.playlist_add_check),
    ItemModel('引用', Icons.format_quote),
    ItemModel('提醒', Icons.add_alert),
    ItemModel('搜一搜', Icons.search),
  ];

  Widget _buildLongPressMenu() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        width: 220,
        color: const Color(0xFF4C4C4C),
        child: GridView.count(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          crossAxisCount: 5,
          crossAxisSpacing: 0,
          mainAxisSpacing: 10,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: menuItems
              .map((item) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        item.icon,
                        size: 20,
                        color: Colors.white,
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 2),
                        child: Text(
                          item.title,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ],
                  ))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildAvatar(bool isMe, double size) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        color: isMe ? Colors.blueAccent : Colors.pinkAccent,
        width: size,
        height: size,
        child: Icon(
          isMe ? Icons.face : Icons.tag_faces,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isMe = message.isMe;
    double avatarSize = 40;

    return Container(
      margin: const EdgeInsets.all(10),
      child: Row(
        textDirection: isMe ? TextDirection.rtl : TextDirection.ltr,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: isMe ? 0 : 10, left: isMe ? 10 : 0),
            child: CustomPopupMenu(
              child: _buildAvatar(isMe, avatarSize),
              menuBuilder: () => GestureDetector(
                child: _buildAvatar(isMe, 100),
                onLongPress: () {
                  if (kDebugMode) {
                    print("onLongPress");
                  }
                },
                onTap: () {
                  if (kDebugMode) {
                    print("onTap");
                  }
                },
              ),
              barrierColor: Colors.transparent,
              pressType: PressType.singleClick,
              arrowColor: isMe ? Colors.blueAccent : Colors.pinkAccent,
              position: PreferredPosition.top,
            ),
          ),
          CustomPopupMenu(
            child: Container(
              padding: const EdgeInsets.all(10),
              constraints: BoxConstraints(maxWidth: 240, minHeight: avatarSize),
              decoration: BoxDecoration(
                color: isMe ? const Color(0xff98e165) : Colors.white,
                borderRadius: BorderRadius.circular(3.0),
              ),
              child: Text(message.content),
            ),
            menuBuilder: _buildLongPressMenu,
            barrierColor: Colors.transparent,
            pressType: PressType.longPress,
          )
        ],
      ),
    );
  }
}
