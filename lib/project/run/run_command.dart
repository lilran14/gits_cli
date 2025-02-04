import 'package:gits_cli_command/constants.dart';
import 'package:gits_cli_command/dependency_manager.dart';
import 'package:gits_cli_command/extensions/extensions.dart';
import 'package:gits_cli_command/helper/helper.dart';

class RunCommand extends Command {
  RunCommand() {
    argParser.addFlagDebug(defaultsTo: true);
    argParser.addFlagProfile();
    argParser.addFlagRelease(defaultsTo: false);

    argParser.addOptionFlavor(defaultsTo: Constants.dev);
    argParser.addOptionTarget();
    argParser.addOptionGitsYaml();
  }

  @override
  String get name => 'run';

  @override
  String get description =>
      'Run your Flutter app on an attached device with flavor.';

  @override
  String get category => Constants.project;

  @override
  void run() {
    MelosHelper.format();
    final argTarget = argResults.getOptionTarget();
    final argFlavor = argResults.getOptionFlavor(defaultTo: Constants.dev);
    final argGitsYaml = argResults.getOptionGitsYaml();

    YamlHelper.validateGitsYaml(argGitsYaml);

    'gits_cli l10n --gits-yaml "$argGitsYaml"'.run;

    final flavor = FlavorHelper.byFlavor(argFlavor, argGitsYaml);

    FirebaseHelper.run(argFlavor, argGitsYaml);

    List<String> dartDefines = [];
    flavor.forEach((key, value) {
      dartDefines.add('${Constants.dartDefine} "$key=$value"');
    });
    String mode = argResults.getMode();
    FlutterHelper.run(
      'run -t $argTarget ${dartDefines.join(' ')} $mode',
      showLog: true,
    );

    StatusHelper.success('run');
  }
}
