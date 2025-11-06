// ignore_for_file: depend_on_referenced_packages

import 'package:intl/message_lookup_by_library.dart';

final MessageLookupByLibrary messages = _MessageLookup();

class _MessageLookup extends MessageLookupByLibrary {
  @override
  String get localeName => 'en';

  static String m0(Object index) => 'Option $index';
  static String m1(Object hours) => 'Ends in $hours hrs';
  static String m2(Object author) => 'By $author';
  static String m3(Object hours) => '$hours' 'h left';
  static String m4(Object message) => 'Error $message';

  @override
  final Map<String, Function> messages = _notInlinedMessages();

  static Map<String, Function> _notInlinedMessages() => <String, Function>{
        'add_option': MessageLookupByLibrary.simpleMessage('Add option'),
        'allow_sharing':
            MessageLookupByLibrary.simpleMessage('Others can share this poll'),
        'app_title': MessageLookupByLibrary.simpleMessage('Neo Brutalist Polls'),
        'collect_ideas_title':
            MessageLookupByLibrary.simpleMessage('Collect ideas!'),
        'collect_ideas_subtitle': MessageLookupByLibrary.simpleMessage(
            'Collect feedback with punchy brutalist polls.'),
        'create_button': MessageLookupByLibrary.simpleMessage('Create'),
        'create_poll_header':
            MessageLookupByLibrary.simpleMessage('Create Poll'),
        'default_user_name':
            MessageLookupByLibrary.simpleMessage('Neo Creator'),
        'created_by': m2,
        'created_polls': MessageLookupByLibrary.simpleMessage('Created Polls'),
        'done': MessageLookupByLibrary.simpleMessage('Done'),
        'duration_label': MessageLookupByLibrary.simpleMessage('Duration'),
        'error_message': m4,
        'ends_in_hours': m1,
        'enter_question_error':
            MessageLookupByLibrary.simpleMessage('Please enter a question'),
        'hide_participants': MessageLookupByLibrary.simpleMessage(
            'Hide participants details'),
        'hero_badge': MessageLookupByLibrary.simpleMessage('BRUTAL IDEAS'),
        'hours_short': m3,
        'need_two_options_error': MessageLookupByLibrary.simpleMessage(
            'Add at least two options'),
        'no_polls': MessageLookupByLibrary.simpleMessage('No polls yet'),
        'brand_label': MessageLookupByLibrary.simpleMessage('Neo'),
        'option_hint': m0,
        'option_label': MessageLookupByLibrary.simpleMessage('Option'),
        'poll_created_success': MessageLookupByLibrary.simpleMessage(
            'Poll published successfully'),
        'poll_details': MessageLookupByLibrary.simpleMessage('Poll Details'),
        'poll_question_label':
            MessageLookupByLibrary.simpleMessage('Poll Question'),
        'poll_settings': MessageLookupByLibrary.simpleMessage('Poll Settings'),
        'poll_settings_title':
            MessageLookupByLibrary.simpleMessage('Poll Settings'),
        'popular_polls': MessageLookupByLibrary.simpleMessage('Popular Polls'),
        'profile_title': MessageLookupByLibrary.simpleMessage('Profile'),
        'publish': MessageLookupByLibrary.simpleMessage('Publish'),
        'remove': MessageLookupByLibrary.simpleMessage('Remove'),
        'reset': MessageLookupByLibrary.simpleMessage('Reset'),
        'results': MessageLookupByLibrary.simpleMessage('Results'),
        'share_poll': MessageLookupByLibrary.simpleMessage('Share poll'),
        'thanks_for_response': MessageLookupByLibrary.simpleMessage(
            'Thanks for the response!'),
        'untitled_poll': MessageLookupByLibrary.simpleMessage('Untitled Poll'),
        'vote': MessageLookupByLibrary.simpleMessage('Vote'),
      };
}
