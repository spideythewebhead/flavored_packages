## This is an experimental way of introducing flavored packages in your app

### About

A scripting tool that let's you register different implementation of packages based on flavors.

### How it works

This tool is based on the [endorsed federated plugins](https://docs.flutter.dev/development/packages-and-plugins/developing-packages#federated-plugins) structure that is already provided by Flutter.

Each flavor implemention must follow/endorse a contract (interface) described by the inteface package.
The interface package must provide a pubspec.base.yaml, that has the same entries as a normal pubspec.yaml but the tool create a pubspec.yaml file registering the default implementation based on the flavor.

_Note: All packages described in the app's pubspec.yaml must be under the root_of_project/packages folder._

The main pubspec.yaml must have a new entry with the following fields.

```yaml
flavored_packages:
    package1:
        flavors:
            flavor_name: package_with_impl
            flavor_name: package_with_impl
            flavor_name: package_with_impl
    package2:
        flavors:
            flavor_name: package_with_impl
            flavor_name: package_with_impl
            flavor_name: package_with_impl
```

Example of the command `dart pub global run flavored_packages -f free` that generates a pubspec.yaml for each package

See example folder for a better understanding.

### Recommendations

1. You should add each interface's package pubspec.yaml under .gitignore as it will create a new one each time you run the CLI.
2. You should add the app's pubspec.lock under .gitignore as it will change based on the flavor when you run the CLI, that means your dependencies on pubspec.yaml should have scrict versions (meaning no ^ >= <= symbols in the [dev_]dependencies)

```yaml
dependencies:
    a_package_for_my_app: 1.0.0 ✅
    a_package_for_my_app: ^1.0.0 ❌
```
