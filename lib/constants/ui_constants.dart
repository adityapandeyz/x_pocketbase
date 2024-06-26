import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:x_pocketbase/features/tweet/widgets/tweet_list.dart';
import 'package:x_pocketbase/theme/pallete.dart';

import 'assets_constants.dart';

class UIConstants {
  static AppBar appBar() {
    return AppBar(
      title: SvgPicture.asset(
        AssetsConstants.xLogo,
        color: Pallete.whiteColor,
        height: 30,
      ),
      centerTitle: true,
    );
  }

  static const List<Widget> bottomTapBarPages = [
    TweetList(),
    Text('Search Screen'),
    Text('Notification Screen'),
  ];
}
