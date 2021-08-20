import 'dart:io';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:at_app/src/cli/command_status.dart';
import 'package:logger/logger.dart';

const flutterArgs = <String>[
  'pub',
  'offline',
  'overwrite',
  'decription',
  'org',
  'project-name',
  'ios-language',
  'android-language',
];

const atAppArgs = <String>[
  'overwrite', // Overwrite is part of both
  'namespace',
  'root-domain',
  'api-key',
];

abstract class FlutterCreate extends Command<CommandStatus> {
  final String name = 'create';

  final Logger _logger;

  FlutterCreate({Logger? logger}) : _logger = logger ?? Logger() {
    // Flutter Arguments
    argParser.addFlag(
      'pub',
      defaultsTo: true,
      help:
          'Whether to run "flutter pub get" after the project has been created.',
    );
    argParser.addFlag(
      'offline',
      defaultsTo: false,
      help:
          'When "flutter pub get" is run by the create command, this indicates '
          'whether to run it in offline mode or not. In offline mode, it will need to '
          'have all dependencies already available in the pub cache to succeed.',
    );
    argParser.addFlag(
      'overwrite',
      negatable: true,
      defaultsTo: false,
      help: 'When performing operations, overwrite existing files.',
    );
    argParser.addOption(
      'description',
      defaultsTo: 'A new Flutter project.',
      help:
          'The description to use for your new Flutter project. This string ends up in the pubspec.yaml file.',
    );
    argParser.addOption(
      'org',
      defaultsTo: 'com.example',
      help:
          'The organization responsible for your new Flutter project, in reverse domain name notation. '
          'This string is used in Java package names and as prefix in the iOS bundle identifier.',
    );
    argParser.addOption(
      'project-name',
      defaultsTo: null,
      help:
          'The project name for this new Flutter project. This must be a valid dart package name.',
    );
    argParser.addOption('ios-language',
        abbr: 'i',
        defaultsTo: 'swift',
        allowed: <String>['objc', 'swift'],
        help:
            'The language to use for iOS-specific code, either ObjectiveC (legacy) or Swift (recommended).');
    argParser.addOption(
      'android-language',
      abbr: 'a',
      defaultsTo: 'kotlin',
      allowed: <String>['java', 'kotlin'],
      help:
          'The language to use for Android-specific code, either Java (legacy) or Kotlin (recommended).',
    );
  }
}
