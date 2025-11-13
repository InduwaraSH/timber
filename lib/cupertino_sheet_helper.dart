import 'package:flutter/cupertino.dart';

/// Reusable helper to show a Cupertino-style bottom sheet.
///
/// Example:
/// ```dart
/// showCustomCupertinoSheet(
///   context: context,
///   child: MyCustomSheetPage(),
/// );
/// ```
Future<T?> showCustomCupertinoSheet<T>({
  required BuildContext context,
  required Widget child,
  bool useNestedNavigation = true,
}) {
  return showCupertinoSheet<T>(
    context: context,
    useNestedNavigation: useNestedNavigation,
    pageBuilder: (BuildContext context) => CupertinoPageScaffold(
      child: child,
    ),
  );
}