import 'dart:io';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:at_app/src/cli/command_status.dart';
import 'package:logger/logger.dart';

import '../flutter.dart';

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

abstract class CreateBase extends Command<CommandStatus> {
  final String name = 'create';

  final Logger _logger;

  CreateBase({Logger? logger}) : _logger = logger ?? Logger() {
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

  bool? boolArg(String name) => argResults?[name] as bool?;
  String? stringArg(String name) => argResults?[name] as String?;

  @override
  Future<CommandStatus> run() async {
    validateOutputDirectoryArg();
    bool? pub = boolArg('pub');
    bool? offline = boolArg('offline');
    bool? overwrite = boolArg('overwrite');
    String? description = stringArg('description');
    String? org = stringArg('org');
    String? projectName = stringArg('project-name');
    String? iosLang = stringArg('ios-language');
    String? androidLang = stringArg('android-language');

    await Flutter.create(
      outputDirectory,
      pub: pub,
      offline: offline,
      overwrite: overwrite,
      description: description,
      org: org,
      projectName: projectName,
      iosLanguage: iosLang,
      androidLanguage: androidLang,
    );

    return CommandStatus.success;
  }

  void validateOutputDirectoryArg() {
    if (argResults?.rest.isEmpty ?? false) {
      throw UsageException(
          'No option specified for the output directory.', usage);
    }

    if (argResults!.rest.length > 1) {
      String message = 'Multiple output directories specified.';
      for (final String arg in argResults!.rest) {
        if (arg.startsWith('-')) {
          message += '\nTry moving $arg to be immediately following $name';
          break;
        }
      }
      throw FormatException(message);
    }
  }

  Directory get outputDirectory {
    return Directory(argResults!.rest.first);
  }

  
}
