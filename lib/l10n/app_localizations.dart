import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'messages_all.dart';

class AppLocalizations {
  AppLocalizations(this.localeName);

  final String localeName;

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ar'),
  ];

  static Future<AppLocalizations> load(Locale locale) {
    final String name = locale.countryCode?.isEmpty ?? true
        ? locale.languageCode
        : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      return AppLocalizations(localeName);
    });
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  String get appTitle => Intl.message(
        'Neo Brutalist Polls',
        name: 'app_title',
      );

  String get collectIdeasTitle => Intl.message(
        'Collect ideas!',
        name: 'collect_ideas_title',
      );

  String get popularPolls => Intl.message(
        'Popular Polls',
        name: 'popular_polls',
      );

  String get createButton => Intl.message(
        'Create',
        name: 'create_button',
      );

  String get pollDetails => Intl.message(
        'Poll Details',
        name: 'poll_details',
      );

  String get pollSettings => Intl.message(
        'Poll Settings',
        name: 'poll_settings',
      );

  String get pollQuestionLabel => Intl.message(
        'Poll Question',
        name: 'poll_question_label',
      );

  String optionHint(int index) => Intl.message(
        'Option {index}',
        name: 'option_hint',
        args: <Object>[index],
        examples: const <String, Object>{'index': 1},
      );

  String get addOption => Intl.message(
        'Add option',
        name: 'add_option',
      );

  String get remove => Intl.message(
        'Remove',
        name: 'remove',
      );

  String get publish => Intl.message(
        'Publish',
        name: 'publish',
      );

  String get durationLabel => Intl.message(
        'Duration',
        name: 'duration_label',
      );

  String get hideParticipants => Intl.message(
        'Hide participants details',
        name: 'hide_participants',
      );

  String get allowSharing => Intl.message(
        'Others can share this poll',
        name: 'allow_sharing',
      );

  String get reset => Intl.message(
        'Reset',
        name: 'reset',
      );

  String get done => Intl.message(
        'Done',
        name: 'done',
      );

  String endsInHours(int hours) => Intl.message(
        'Ends in {hours} hrs',
        name: 'ends_in_hours',
        args: <Object>[hours],
        examples: const <String, Object>{'hours': 6},
      );

  String get vote => Intl.message(
        'Vote',
        name: 'vote',
      );

  String get thanksForResponse => Intl.message(
        'Thanks for the response!',
        name: 'thanks_for_response',
      );

  String createdBy(String author) => Intl.message(
        'By {author}',
        name: 'created_by',
        args: <Object>[author],
        examples: const <String, Object>{'author': 'Alex'},
      );

  String get noPolls => Intl.message(
        'No polls yet',
        name: 'no_polls',
      );

  String get createPollHeader => Intl.message(
        'Create Poll',
        name: 'create_poll_header',
      );

  String get profileTitle => Intl.message(
        'Profile',
        name: 'profile_title',
      );

  String get createdPolls => Intl.message(
        'Created Polls',
        name: 'created_polls',
      );

  String get untitledPoll => Intl.message(
        'Untitled Poll',
        name: 'untitled_poll',
      );

  String get optionLabel => Intl.message(
        'Option',
        name: 'option_label',
      );

  String get results => Intl.message(
        'Results',
        name: 'results',
      );

  String get sharePoll => Intl.message(
        'Share poll',
        name: 'share_poll',
      );

  String hoursShort(int hours) => Intl.message(
        '{hours}h left',
        name: 'hours_short',
        args: <Object>[hours],
        examples: const <String, Object>{'hours': 3},
      );

  String get pollCreatedSuccess => Intl.message(
        'Poll published successfully',
        name: 'poll_created_success',
      );

  String get enterQuestionError => Intl.message(
        'Please enter a question',
        name: 'enter_question_error',
      );

  String get needTwoOptionsError => Intl.message(
        'Add at least two options',
        name: 'need_two_options_error',
      );

  String get collectIdeasSubtitle => Intl.message(
        'Collect feedback with punchy brutalist polls.',
        name: 'collect_ideas_subtitle',
      );

  String get brandLabel => Intl.message(
        'Neo',
        name: 'brand_label',
      );

  String get heroBadge => Intl.message(
        'BRUTAL IDEAS',
        name: 'hero_badge',
      );

  String errorMessage(String message) => Intl.message(
        'Error {message}',
        name: 'error_message',
        args: <Object>[message],
        examples: const <String, Object>{'message': 'unknown'},
      );

  String get defaultUserName => Intl.message(
        'Neo Creator',
        name: 'default_user_name',
      );
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      AppLocalizations.supportedLocales.contains(Locale(locale.languageCode));

  @override
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(locale);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
