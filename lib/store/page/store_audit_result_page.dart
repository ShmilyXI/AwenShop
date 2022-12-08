import 'package:AwenShop/res/resources.dart';
import 'package:AwenShop/routers/fluro_navigator.dart';
import 'package:AwenShop/routers/routers.dart';
import 'package:AwenShop/widgets/base_app_bar.dart';
import 'package:AwenShop/widgets/base_button.dart';
import 'package:AwenShop/widgets/base_scroll_view.dart';
import 'package:AwenShop/widgets/load_image.dart';
import 'package:flutter/material.dart';

class StoreAuditResultPage extends StatefulWidget {
  const StoreAuditResultPage({super.key});

  @override
  _StoreAuditResultPageState createState() => _StoreAuditResultPageState();
}

class _StoreAuditResultPageState extends State<StoreAuditResultPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const BaseAppBar(title: '审核结果'),
        body: BaseScrollView(
          crossAxisAlignment: CrossAxisAlignment.center,
          padding: EdgeInsets.only(top: 100.0),
          bottomButton: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: BaseButton(
                text: '进入首页',
                onPressed: () {
                  NavigatorUtils.push(context, Routes.home, clearStack: true);
                }),
          ),
          children: [
            Gaps.vGap50,
            const LoadImage(
              'store/icon_success',
              width: 80.0,
              height: 80.0,
            ),
            Gaps.vGap12,
            const Text(
              '恭喜,店铺资料审核成功!',
              style: TextStyles.textSize16,
            ),
            Gaps.vGap8,
            Text(
              '2021-02-21 15:20:10',
              style: Theme.of(context).textTheme.subtitle2,
            ),
            Gaps.vGap8,
            Text(
              '预计完成时间：02月28日',
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ],
        ));
  }
}
