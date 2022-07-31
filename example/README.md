An example app how you create use flavored packages for your app

Check packages/analytics to see how you set up an interface and
packages/analytics_a & packages/analytics_b how to set up your interfaces

Note: this is one of the possible scenarios that you might need to follow

All implementors need to register a `dartPluginClass` in pubspec.yaml in flutter -> plugin -> platforms entries
and the class needs to create a `static void registerWith() {}` method that can be as an entry point

Example

```yaml
plugin:
  implements: analytics
  platforms:
    android:
      package: app.flavored_packages.analytics_b
      pluginClass: Analytics_bPlugin
      dartPluginClass: AnalyticsBPlugin
    ios:
      pluginClass: Analytics_bPlugin
      dartPluginClass: AnalyticsBPlugin
```
