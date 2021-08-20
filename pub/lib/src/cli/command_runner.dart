import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:at_app/src/cli/command_status.dart';
import 'package:at_app/src/cli/exceptions.dart';
import 'package:at_app/src/cli/version.dart';
import 'package:logger/logger.dart';

import 'commands/index.dart';

class AtCommandRunner extends CommandRunner<CommandStatus> {
  final Logger _logger;

  AtCommandRunner({Logger? logger})
      : _logger = logger ?? Logger(),
        super('at_app', 'The @ protocol app developer cli toolkit.') {
    argParser.addFlag(
      'version',
      negatable: false,
      help: 'Print the current version.',
    );
    addCommand(CreateCommand(logger: _logger));
  }

  @override
  Future<CommandStatus> run(Iterable<String> args) async {
    try {
      final _argResults = parse(args);
      return await runCommand(_argResults) ?? CommandStatus.success;
    } on FormatException catch (e, stackTrace) {
      _logger.e(e.message, e, stackTrace);
      _logger.i(usage);
      return CommandStatus.warning;
    } on UsageException catch (e) {
      _logger.e(e.message);
      _logger.i(usage);
      return CommandStatus.warning;
    } on PubException catch (e) {
      _logger.e(e.message);
      return CommandStatus.fail;
    } on AndroidBuildException catch (e) {
      _logger.e(e.message);
      return CommandStatus.fail;
    }
  }

  @override
  Future<CommandStatus?> runCommand(ArgResults topLevelResults) async {
    if (topLevelResults['version']) {
      print('at_app: $packageVersion');
      return CommandStatus.success;
    }
    return super.runCommand(topLevelResults);
  }
}
