// Web-only ad banner using Google AdSense.
// Replace client and slot with your own when going to production.
// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:html' as html;
import 'dart:ui_web' as ui; // for platformViewRegistry on web
import 'package:flutter/widgets.dart';

class AdBanner extends StatefulWidget {
  const AdBanner({super.key});

  @override
  State<AdBanner> createState() => _AdBannerState();
}

class _AdBannerState extends State<AdBanner> {
  static const String _viewType = 'adsense-banner';
  // Placeholder IDs; replace with real ones for production.
  static const String _client = 'ca-pub-0000000000000000';
  static const String _slot = '0000000000';

  @override
  void initState() {
    super.initState();
    // Only register the AdSense view when real IDs are provided
    if (!(_client.startsWith('ca-pub-000') || _slot == '0000000000')) {
      ui.platformViewRegistry.registerViewFactory(_viewType, (int viewId) {
        final container = html.DivElement();

        final ins = html.Element.tag('ins')
          ..classes.add('adsbygoogle')
          ..setAttribute('style', 'display:block; text-align:center;')
          ..setAttribute('data-ad-layout', 'in-article')
          ..setAttribute('data-ad-format', 'fluid')
          ..setAttribute('data-ad-client', _client)
          ..setAttribute('data-ad-slot', _slot)
          ..setAttribute('data-adtest', 'on');

        container.children.add(ins);

        final push = html.ScriptElement()
          ..type = 'text/javascript'
          ..text = '(adsbygoogle = window.adsbygoogle || []).push({});';
        container.children.add(push);

        return container;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // If IDs are defaults, show a clear test placeholder so the user sees something immediately.
    if (_client.startsWith('ca-pub-000') || _slot == '0000000000') {
      return Container(
        height: 100,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFFEFEFEF),
          border: Border.all(color: const Color(0xFFCCCCCC)),
        ),
        child: const Text('Реклама (тест, web)'),
      );
    }

    return const SizedBox(
      height: 100,
      child: HtmlElementView(viewType: _viewType),
    );
  }
}
