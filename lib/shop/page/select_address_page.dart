import 'package:flutter/material.dart';
import 'package:flutter_2d_amap/flutter_2d_amap.dart';
import 'package:AwenShop/routers/fluro_navigator.dart';
import 'package:AwenShop/util/other_utils.dart';
import 'package:AwenShop/util/toast_utils.dart';
import 'package:AwenShop/widgets/base_button.dart';
import 'package:AwenShop/widgets/search_bar.dart';

class AddressSelectPage extends StatefulWidget {
  const AddressSelectPage({super.key});

  @override
  _AddressSelectPageState createState() => _AddressSelectPageState();
}

class _AddressSelectPageState extends State<AddressSelectPage> {
  List<PoiSearch> _list = [];
  int _index = 0;
  final ScrollController _controller = ScrollController();
  AMap2DController? _aMap2DController;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Flutter2dAMap.updatePrivacy(true);

    /// 配置key
    Flutter2dAMap.setApiKey(
      iOSKey: '5184c26733ac9c641d499f89f749a4a9',
      webKey: 'e74a61bda8fec48de68f217a8f2ca8eb',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: SearchBar(
        hintText: '搜索地址',
        onPressed: (text) {
          _controller.animateTo(0.0, duration: const Duration(milliseconds: 10), curve: Curves.ease);
          _index = 0;
          _aMap2DController?.search(text);
        },
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 9,
              child: AMap2DView(
                onPoiSearched: (result) {
                  _controller.animateTo(0.0, duration: const Duration(milliseconds: 10), curve: Curves.ease);
                  _index = 0;
                  _list = result;
                  setState(() {});
                },
                onAMap2DViewCreated: (controller) {
                  _aMap2DController = controller;
                },
              ),
            ),
            Expanded(
              flex: 11,
              child:
//            _list.isEmpty ?
//              Container(
//                alignment: Alignment.center,
//                child: CircularProgressIndicator(),
//              ) :
                  ListView.separated(
                controller: _controller,
                itemCount: _list.length,
                separatorBuilder: (_, index) => const Divider(),
                itemBuilder: (_, index) {
                  return _AddressItem(
                    isSelected: _index == index,
                    date: _list[index],
                    onTap: () {
                      _index = index;
                      _aMap2DController?.move(_list[index].latitude.nullSafe, _list[index].longitude.nullSafe);
                      setState(() {});
                    },
                  );
                },
              ),
            ),
            BaseButton(
              onPressed: () {
                if (_list.isEmpty) {
                  Toast.show('未选择地址！');
                  return;
                }
                NavigatorUtils.goBackWithParams(context, _list[_index]);
              },
              text: '确认选择地址',
            )
          ],
        ),
      ),
    );
  }
}

class _AddressItem extends StatelessWidget {
  const _AddressItem({
    required this.date,
    this.isSelected = false,
    this.onTap,
  });

  final PoiSearch date;
  final bool isSelected;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        height: 50.0,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                '${date.provinceName.nullSafe} ${date.cityName.nullSafe} ${date.adName.nullSafe} ${date.title.nullSafe}',
              ),
            ),
            Visibility(
              visible: isSelected,
              child: const Icon(Icons.done, color: Colors.blue),
            )
          ],
        ),
      ),
    );
  }
}
