import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';

import '../../providers/my_providers.dart';
import '../_styles.dart';

class CoolCollapsWidget extends StatelessWidget {
  final String cardName;
  const CoolCollapsWidget({Key? key, required this.cardName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding:
              const EdgeInsets.only(left: 24, right: 24, top: 0, bottom: 0),
          child: Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: ReservedAppTheme.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        bottomLeft: Radius.circular(8.0),
                        bottomRight: Radius.circular(8.0),
                        topRight: Radius.circular(8.0)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: ReservedAppTheme.grey.withOpacity(0.4),
                          offset: Offset(1.1, 1.1),
                          blurRadius: 10.0),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.topLeft,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        child: SizedBox(
                          height: 74,
                          child: AspectRatio(
                            aspectRatio: 1.714,
                            child: Image.asset("assets/images/back.png"),
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 100,
                                  right: 16,
                                  top: 16,
                                ),
                                child: Text(
                                  FlutterI18n.translate(context, cardName),
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontFamily: ReservedAppTheme.fontName,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    letterSpacing: 0.0,
                                    color: ReservedAppTheme.nearlyDarkBlue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 100,
                              bottom: 12,
                              top: 4,
                              right: 16,
                            ),
                            child: Text(
                              context
                                  .read<MainPageCardController>()
                                  .getContent(cardName),
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontFamily: ReservedAppTheme.fontName,
                                fontWeight: FontWeight.w500,
                                fontSize: 10,
                                letterSpacing: 0.0,
                                color: ReservedAppTheme.grey.withOpacity(0.5),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: -16,
                right: 20,
                child: SizedBox(
                  width: 80,
                  height: 80,
                  child: context
                              .read<MainPageCardController>()
                              .getImgPath(cardName) !=
                          null
                      ? Image.asset(
                          context
                              .read<MainPageCardController>()
                              .getImgPath(cardName)!,
                        )
                      : Image.asset(
                          "assets/images/smile_face.png",
                        ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}