import 'dart:io';

import 'package:args/args.dart';
import 'package:flavored_packages/src/exceptions.dart';
import 'package:yaml/yaml.dart';
import 'package:path/path.dart' as path;

import 'json2yaml.dart';

String get _cwdPath => Directory.current.path;
void _setCwd(String path) {
  Directory.current = path;
}

ArgParser getAppParser() {
  final parser = ArgParser();

  parser
    ..addFlag('help', abbr: 'h')
    ..addOption(
      'flavor',
      mandatory: true,
      abbr: 'f',
      help: 'Required to register plugins with correct flavor',
    )
    ..addOption(
      'path',
      defaultsTo: '.',
      abbr: 'p',
      help: 'Path of the main pubspec.yaml that contains a flavored_packages entry',
    );

  return parser;
}

void runApp(ArgParser parser, List<String> providedArgs) {
  print('');

  try {
    final args = parser.parse(providedArgs);

    if (args.wasParsed('help')) {
      print(parser.usage);
      exit(0);
    }

    if (args.wasParsed('path')) {
      _setCwd(args['path'] as String);
    }

    final flavor = args['flavor'] as String;
    final mainPubspecYaml = _loadMainPubspec();

    if (mainPubspecYaml['flavored_packages'] is! Map) {
      throw const MissingFlavoredPackagesInPubspecException(
        'flavored_packages not found in pubspec',
      );
    }

    final flavoredPackagesMap = mainPubspecYaml['flavored_packages'] as Map;

    // _deleteDartToolFolder(_cwdPath);

    for (final package in flavoredPackagesMap.keys) {
      final packageFlavors = flavoredPackagesMap[package]['flavors'] as Map;
      final implForFlavor = packageFlavors[flavor] as String;
      _processPackage(package: package, implForFlavor: implForFlavor);
    }

    _appLog('Running "flutter pub get" for ${mainPubspecYaml['name']}');
    _flutterPubGet(_cwdPath);
    _appLog('Done ✅');
  } on Exception catch (e) {
    print('$e\n');
    print(parser.usage);
    exit(1);
  }
}

YamlMap _loadMainPubspec() {
  return _loadPackagePubspec(path.join(_cwdPath, 'pubspec.yaml'));
}

YamlMap _loadPackagePubspec(String path) {
  final pubspec = File(path).readAsStringSync();
  return loadYaml(pubspec) as YamlMap;
}

void _processPackage({
  required String package,
  required String implForFlavor,
}) {
  final packagePath = path.join(_cwdPath, 'packages', package);

  _appLog('Current working directory "$packagePath"');
  _appLog('Updating package "$package"');

  final packagePubspec = _loadPackagePubspec(path.join(packagePath, 'pubspec.base.yaml'));
  final modifiablePackagePubspec = _createModifiableVariantFromMap(packagePubspec);

  // _deletePubspec(packagePath);
  // _deleteDartToolFolder(packagePath);

  _appLog('Registering with implementation "$implForFlavor"');
  modifiablePackagePubspec['flutter'] = <String, dynamic>{
    'plugin': <String, dynamic>{
      'platforms': <String, dynamic>{
        'android': <String, dynamic>{
          'default_package': implForFlavor,
        },
        'ios': <String, dynamic>{
          'default_package': implForFlavor,
        },
      },
    },
  };
  modifiablePackagePubspec['dependencies'][implForFlavor] = {'path': implForFlavor};

  _appLog('Creating "pubspec.yaml"');
  final pubspecYamlString = Json2YamlEncoder().convert(modifiablePackagePubspec);
  File(path.join(packagePath, 'pubspec.yaml')).writeAsStringSync(
    '# GENERATED DO NOT MODIFY\n'
    '$pubspecYamlString',
  );

  _appLog('Running "flutter pub get"');
  _flutterPubGet(packagePath);
  _appLog('Done ✅\n');
}

Map<dynamic, dynamic> _createModifiableVariantFromMap(Map<dynamic, dynamic> map) {
  final modifiable = <dynamic, dynamic>{};

  for (final key in map.keys) {
    if (map[key] is Map) {
      modifiable[key] = _createModifiableVariantFromMap(map[key]);
    } else {
      modifiable[key] = map[key];
    }
  }

  return modifiable;
}

bool _flutterPubGet(String directoryPath) {
  return Process.runSync('flutter', ['pub', 'get'], workingDirectory: directoryPath).exitCode == 0;
}

void _appLog(Object? object) {
  print('\u2022 $object');
}

void _deleteDartToolFolder(String basePath) {
  _appLog('Deleting "${path.join(basePath, '.dart_tool')}"');
  try {
    Directory(path.join(basePath, '.dart_tool')).deleteSync(recursive: true);
  } on FileSystemException catch (e) {
    _appLog(e.message);
  }
}

void _deletePubspec(String basePath) {
  final files = <File>[
    File(path.join(basePath, 'pubspec.yaml')),
    File(path.join(basePath, 'pubspec.lock')),
  ];

  final filesBeingDeleted = files.map((file) => '"${file.path}"').join(' & ');
  _appLog('Deleting $filesBeingDeleted');

  try {
    for (final file in files) {
      file.deleteSync();
    }
  } on FileSystemException catch (e) {
    _appLog(e.message);
  }
}
