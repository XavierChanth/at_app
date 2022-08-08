// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:at_app_create/at_app_create.dart';
import 'package:pub_semver/pub_semver.dart';

import 'at_invitation_flutter_bundle.dart';

class AtInvitationFlutterTemplateBundle extends AtTemplateBundle<AtTemplateVars> {
  AtInvitationFlutterTemplateBundle() : super(atInvitationFlutterBundle);
}

final AtTemplateVars _vars = AtTemplateVars(
  includeBundles: {'at_invitation_flutter'},
  dependencies: [
    "at_app_flutter: ^5.0.0",
    "at_invitation_flutter: ^2.0.0",
    "cupertino_icons: ^1.0.5",
    "uni_links: ^0.5.1",
    "url_launcher: ^6.1.4"
  ],
  enableR8: true,
  kotlinVersion: Version.parse('1.5.32'),
  minSdkVersion: '24',
  flutterConfig: ["assets:", "  - .env"],
);

final AtAppTemplate atInvitationFlutterTemplate = AtAppTemplate(
  name: 'at_invitation_flutter',
  description: 'A sample of how to use the at_invitation_flutter package',
  vars: _vars,
  overrideEnv: true,
  env: {"NAMESPACE": "productive2227", "API_KEY": "477b-876u-bcez-c42z-6a3d"},
  bundles: [
    BaseTemplateBundle(),
    AndroidTemplateBundle(),
    IosTemplateBundle(),
    AtInvitationFlutterTemplateBundle(),
  ],
);
