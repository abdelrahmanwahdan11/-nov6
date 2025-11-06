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

  String get navHome => Intl.message(
        'Home',
        name: 'nav_home',
      );

  String get navSearch => Intl.message(
        'Search',
        name: 'nav_search',
      );

  String get navProfile => Intl.message(
        'Profile',
        name: 'nav_profile',
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

  String get profileGuestTitle => Intl.message(
        'Create your profile',
        name: 'profile_guest_title',
      );

  String get profileGuestDescription => Intl.message(
        'Sign in to track the polls you create and participate in, and sync them across sessions.',
        name: 'profile_guest_description',
      );

  String get profileGuestLogin => Intl.message(
        'Go to login',
        name: 'profile_guest_login',
      );

  String get profileEmptyTitle => Intl.message(
        "You haven't created any polls yet.",
        name: 'profile_empty_title',
      );

  String get myPolls => Intl.message(
        'My Polls',
        name: 'my_polls',
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

  String get categoryAll => Intl.message(
        'All',
        name: 'category_all',
      );

  String get categoryTech => Intl.message(
        'Tech',
        name: 'category_tech',
      );

  String get categoryFun => Intl.message(
        'Fun',
        name: 'category_fun',
      );

  String get categoryWork => Intl.message(
        'Work',
        name: 'category_work',
      );

  String get categoryGeneral => Intl.message(
        'General',
        name: 'category_general',
      );

  String get homeEmptyTitle => Intl.message(
        'No polls here yet',
        name: 'home_empty_title',
      );

  String get homeEmptySubtitle => Intl.message(
        'Be the first to craft a neo-brutalist poll and spark the conversation.',
        name: 'home_empty_subtitle',
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

  String get login => Intl.message(
        'Login',
        name: 'login',
      );

  String get signup => Intl.message(
        'Sign Up',
        name: 'signup',
      );

  String get email => Intl.message(
        'Email',
        name: 'email',
      );

  String get password => Intl.message(
        'Password',
        name: 'password',
      );

  String get name => Intl.message(
        'Name',
        name: 'name',
      );

  String get continueAsGuest => Intl.message(
        'Continue as Guest',
        name: 'continue_as_guest',
      );

  String get searchTitle => Intl.message(
        'Search',
        name: 'search_title',
      );

  String get searchHint => Intl.message(
        'Search polls and options',
        name: 'search_hint',
      );

  String get searchPrompt => Intl.message(
        'Start typing to discover polls across every brutalist category.',
        name: 'search_prompt',
      );

  String searchEmpty(String query) => Intl.message(
        'No results for "{query}"',
        name: 'search_empty',
        args: <Object>[query],
        examples: const <String, Object>{'query': 'design'},
      );

  String get passwordStrengthLabel => Intl.message(
        'Password Strength',
        name: 'password_strength_label',
      );

  String get weak => Intl.message(
        'Weak',
        name: 'weak',
      );

  String get medium => Intl.message(
        'Medium',
        name: 'medium',
      );

  String get strong => Intl.message(
        'Strong',
        name: 'strong',
      );

  String get validationRequired => Intl.message(
        'This field is required',
        name: 'validation_required',
      );

  String get validationEmail => Intl.message(
        'Enter a valid email address',
        name: 'validation_email',
      );

  String get validationPasswordLength => Intl.message(
        'Use at least 6 characters',
        name: 'validation_password_length',
      );

  String get authEmailInUse => Intl.message(
        'This email is already registered',
        name: 'auth_email_in_use',
      );

  String get authUserNotFound => Intl.message(
        'Account not found',
        name: 'auth_user_not_found',
      );

  String get authInvalidPassword => Intl.message(
        'Incorrect password',
        name: 'auth_invalid_password',
      );

  String get genericError => Intl.message(
        'Something went wrong',
        name: 'generic_error',
      );

  String get delete => Intl.message(
        'Delete',
        name: 'delete',
      );

  String get deletePollTitle => Intl.message(
        'Delete poll?',
        name: 'delete_poll_title',
      );

  String get deletePollMessage => Intl.message(
        'This poll and its votes will be removed.',
        name: 'delete_poll_message',
      );

  String get keepPoll => Intl.message(
        'Keep',
        name: 'keep_poll',
      );

  String get pollDeleted => Intl.message(
        'Poll deleted',
        name: 'poll_deleted',
      );

  String get loginRequiredTitle => Intl.message(
        'Login required',
        name: 'login_required_title',
      );

  String get loginRequiredMessage => Intl.message(
        'Please login or sign up to continue.',
        name: 'login_required_message',
      );

  String get cancel => Intl.message(
        'Cancel',
        name: 'cancel',
      );

  String get guestWarning => Intl.message(
        'You are browsing as a guest. Login to create polls.',
        name: 'guest_warning',
      );

  String get settings => Intl.message(
        'Settings',
        name: 'settings',
      );

  String get changeLanguage => Intl.message(
        'Change Language',
        name: 'change_language',
      );

  String get darkMode => Intl.message(
        'Dark Mode',
        name: 'dark_mode',
      );

  String get darkModeOn => Intl.message(
        'Dark mode enabled',
        name: 'dark_mode_on',
      );

  String get darkModeOff => Intl.message(
        'Dark mode disabled',
        name: 'dark_mode_off',
      );

  String get simulateNoInternet => Intl.message(
        'Simulate No Internet',
        name: 'simulate_no_internet',
      );

  String get offlineModeActive => Intl.message(
        'Offline simulation enabled',
        name: 'offline_mode_active',
      );

  String get offlineModeInactive => Intl.message(
        'Offline simulation disabled',
        name: 'offline_mode_inactive',
      );

  String get offlineActionQueued => Intl.message(
        'Action queued while offline',
        name: 'offline_action_queued',
      );

  String get offlineSyncComplete => Intl.message(
        'Pending actions synced',
        name: 'offline_sync_complete',
      );

  String get exportMyData => Intl.message(
        'Export My Data',
        name: 'export_my_data',
      );

  String get exportDataTitle => Intl.message(
        'Your Data Export',
        name: 'export_data_title',
      );

  String get logout => Intl.message(
        'Logout',
        name: 'logout',
      );

  String get onboardingTitle1 => Intl.message(
        'Create Polls',
        name: 'onboarding_title_1',
      );

  String get onboardingDesc1 => Intl.message(
        'Easily create and share polls with your community.',
        name: 'onboarding_desc_1',
      );

  String get onboardingTitle2 => Intl.message(
        'Vote Anywhere',
        name: 'onboarding_title_2',
      );

  String get onboardingDesc2 => Intl.message(
        'Jump into polls with a bold brutalist interface.',
        name: 'onboarding_desc_2',
      );

  String get onboardingTitle3 => Intl.message(
        'Track Results',
        name: 'onboarding_title_3',
      );

  String get onboardingDesc3 => Intl.message(
        'See vibrant results update in real time.',
        name: 'onboarding_desc_3',
      );

  String get skip => Intl.message(
        'Skip',
        name: 'skip',
      );

  String get back => Intl.message(
        'Back',
        name: 'back',
      );

  String get next => Intl.message(
        'Next',
        name: 'next',
      );

  String get getStarted => Intl.message(
        'Get Started',
        name: 'get_started',
      );

  String get tourCreate => Intl.message(
        'Launch a new poll from here.',
        name: 'tour_create',
      );

  String get tourPoll => Intl.message(
        'Tap to explore poll details and vote.',
        name: 'tour_poll',
      );

  String get tourSettings => Intl.message(
        'Tweak language and dark mode here.',
        name: 'tour_settings',
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
