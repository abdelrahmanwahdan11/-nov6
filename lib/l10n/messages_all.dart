// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';
import 'package:intl/src/intl_helpers.dart';

import 'messages_ar.dart' as messages_ar;
import 'messages_en.dart' as messages_en;

typedef LibraryLoader = Future<dynamic> Function();
final Map<String, LibraryLoader> _deferredLibraries = <String, LibraryLoader>{
  'ar': () async => messages_ar.messages,
  'en': () async => messages_en.messages,
};

MessageLookupByLibrary? _findExact(String localeName) {
  switch (localeName) {
    case 'ar':
      return messages_ar.messages;
    case 'en':
      return messages_en.messages;
  }
  return null;
}

Future<bool> initializeMessages(String localeName) async {
  final String locale = Intl.canonicalizedLocale(localeName);
  final LibraryLoader? loader = _deferredLibraries[locale];
  if (loader != null) {
    await loader();
  }
  initializeInternalMessageLookup(() => CompositeMessageLookup());
  messageLookup.addLocale(locale, _findGeneratedMessagesFor);
  return true;
}

bool _messagesExistFor(String locale) {
  try {
    return _findExact(locale) != null;
  } catch (e) {
    return false;
  }
}

MessageLookupByLibrary _findGeneratedMessagesFor(String locale) {
  final String actualLocale = Intl.verifiedLocale(locale, _messagesExistFor,
      onFailure: (_) => locale);
  return _findExact(actualLocale)!;
}
