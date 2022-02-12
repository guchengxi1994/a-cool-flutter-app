import 'package:codind/providers/my_providers.dart';
import 'package:codind/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
abstract class BasePage extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  BasePage(
      {Key? key,
      required this.routeName,
      this.needLoading,
      this.leadingWidgetClick})
      : super(key: key);
  String routeName;
  bool? needLoading;
  VoidCallback? leadingWidgetClick;

  @override
  BasePageState createState() {
    // ignore: no_logic_in_create_state
    return getState();
  }

  BasePageState getState();
}

class BasePageState<T extends BasePage> extends State<T> {
  List<Widget> actions = [];
  bool needLoading = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.needLoading != null) {
      needLoading = widget.needLoading!;
    }
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      List<Widget> _actions = [
        PopupMenuButton<String>(
            tooltip: FlutterI18n.translate(context, "label.localization"),
            icon: Container(
              color: Colors.white,
              height: 20,
              width: 20,
              child: Image.asset("assets/icons/lan.png"),
            ),
            itemBuilder: (context) => <PopupMenuItem<String>>[
                  buildPopupMenuItem("中文"),
                  buildPopupMenuItem("English"),
                ]),
        IconButton(
            tooltip: FlutterI18n.translate(context, "label.settings"),
            onPressed: () {
              Navigator.pushNamed(context, Routers.pageSetting);
            },
            icon: Container(
              color: Colors.white,
              height: 20,
              width: 20,
              child: Image.asset("assets/icons/self_male.png"),
            ))
      ];

      addActions(_actions);
    });
  }

  addAction(Widget w) {
    setState(() {
      actions.add(w);
    });
  }

  addActions(List<Widget> ws) {
    setState(() {
      actions.addAll(ws);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: context.read<MenuController>().scaffoldKey,
      body: !needLoading
          ? SafeArea(
              child: baseBuild(context),
            )
          : LoadingOverlay(isLoading: isLoading, child: baseBuild(context)),
      appBar: AppBar(
        elevation: Responsive.isRoughMobile(context) ? 4 : 0,
        // backgroundColor: Responsive.isRoughMobile(context)
        //     ? context.watch<ThemeController>().savedColor['appBarColor']
        //     : Colors.grey[300],
        automaticallyImplyLeading: false,
        leading: getLeadingWidget(),
        actions: actions,
      ),
    );
  }

  Widget? getLeadingWidget() {
    if (widget.routeName == "main" && Responsive.isRoughDesktop(context)) {
      return null;
    }

    if (widget.routeName == "main" && !Responsive.isRoughDesktop(context)) {
      // print("应该到这里了");
      return IconButton(
        onPressed: () {
          context.read<MenuController>().controlMenu();
        },
        icon: const Icon(
          Icons.menu,
          color: Colors.white,
        ),
      );
    }

    if (PlatformUtils.isWeb) {
      return null;
    } else {
      if (widget.routeName != "main") {
        return IconButton(
          // ignore: prefer_const_constructors
          icon: Icon(
            Icons.chevron_left,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        );
      } else {
        return null;
      }
    }
  }

  PopupMenuItem<String> buildPopupMenuItem(String key) {
    return PopupMenuItem(
      child: Text(key),
      onTap: () async {
        String lang = reservedOptions[key]!;
        if (lang != context.read<LanguageController>().currentLang) {
          await context.read<LanguageController>().changeLanguage(lang);
          setState(() {});
        }
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(T oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void reassemble() {
    super.reassemble();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  void onCreate() {}
  void onDes() {}
  baseBuild(BuildContext context) {}

  @override
  void dispose() {
    super.dispose();
  }
}
