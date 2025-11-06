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
  static String m5(Object query) => 'No results for "$query"';

  @override
  final Map<String, Function> messages = _notInlinedMessages();

  static Map<String, Function> _notInlinedMessages() => <String, Function>{
        'add_option': MessageLookupByLibrary.simpleMessage('Add option'),
        'auth_email_in_use': MessageLookupByLibrary.simpleMessage(
            'This email is already registered'),
        'auth_invalid_password':
            MessageLookupByLibrary.simpleMessage('Incorrect password'),
        'auth_user_not_found':
            MessageLookupByLibrary.simpleMessage('Account not found'),
        'allow_sharing':
            MessageLookupByLibrary.simpleMessage('Others can share this poll'),
        'app_title': MessageLookupByLibrary.simpleMessage('Neo Brutalist Polls'),
        'back': MessageLookupByLibrary.simpleMessage('Back'),
        'collect_ideas_title':
            MessageLookupByLibrary.simpleMessage('Collect ideas!'),
        'collect_ideas_subtitle': MessageLookupByLibrary.simpleMessage(
            'Collect feedback with punchy brutalist polls.'),
        'category_all': MessageLookupByLibrary.simpleMessage('All'),
        'category_fun': MessageLookupByLibrary.simpleMessage('Fun'),
        'category_general': MessageLookupByLibrary.simpleMessage('General'),
        'category_tech': MessageLookupByLibrary.simpleMessage('Tech'),
        'category_work': MessageLookupByLibrary.simpleMessage('Work'),
        'home_empty_subtitle': MessageLookupByLibrary.simpleMessage(
            'Be the first to craft a neo-brutalist poll and spark the conversation.'),
        'home_empty_title':
            MessageLookupByLibrary.simpleMessage('No polls here yet'),
        'cancel': MessageLookupByLibrary.simpleMessage('Cancel'),
        'change_language':
            MessageLookupByLibrary.simpleMessage('Change Language'),
        'create_button': MessageLookupByLibrary.simpleMessage('Create'),
        'nav_home': MessageLookupByLibrary.simpleMessage('Home'),
        'nav_profile': MessageLookupByLibrary.simpleMessage('Profile'),
        'nav_search': MessageLookupByLibrary.simpleMessage('Search'),
        'create_poll_header':
            MessageLookupByLibrary.simpleMessage('Create Poll'),
        'default_user_name':
            MessageLookupByLibrary.simpleMessage('Neo Creator'),
        'continue_as_guest':
            MessageLookupByLibrary.simpleMessage('Continue as Guest'),
        'search_empty': m5,
        'search_hint':
            MessageLookupByLibrary.simpleMessage('Search polls and options'),
        'search_prompt': MessageLookupByLibrary.simpleMessage(
            'Start typing to discover polls across every brutalist category.'),
        'search_title': MessageLookupByLibrary.simpleMessage('Search'),
        'dark_mode': MessageLookupByLibrary.simpleMessage('Dark Mode'),
        'dark_mode_off':
            MessageLookupByLibrary.simpleMessage('Dark mode disabled'),
        'dark_mode_on':
            MessageLookupByLibrary.simpleMessage('Dark mode enabled'),
        'simulate_no_internet':
            MessageLookupByLibrary.simpleMessage('Simulate No Internet'),
        'offline_mode_active': MessageLookupByLibrary.simpleMessage(
            'Offline simulation enabled'),
        'offline_mode_inactive': MessageLookupByLibrary.simpleMessage(
            'Offline simulation disabled'),
        'offline_action_queued': MessageLookupByLibrary.simpleMessage(
            'Action queued while offline'),
        'offline_sync_complete': MessageLookupByLibrary.simpleMessage(
            'Pending actions synced'),
        'export_my_data':
            MessageLookupByLibrary.simpleMessage('Export My Data'),
        'export_data_title':
            MessageLookupByLibrary.simpleMessage('Your Data Export'),
        'created_by': m2,
        'my_polls': MessageLookupByLibrary.simpleMessage('My Polls'),
        'done': MessageLookupByLibrary.simpleMessage('Done'),
        'duration_label': MessageLookupByLibrary.simpleMessage('Duration'),
        'email': MessageLookupByLibrary.simpleMessage('Email'),
        'error_message': m4,
        'ends_in_hours': m1,
        'enter_question_error':
            MessageLookupByLibrary.simpleMessage('Please enter a question'),
        'generic_error':
            MessageLookupByLibrary.simpleMessage('Something went wrong'),
        'delete': MessageLookupByLibrary.simpleMessage('Delete'),
        'delete_poll_message': MessageLookupByLibrary.simpleMessage(
            'This poll and its votes will be removed.'),
        'delete_poll_title':
            MessageLookupByLibrary.simpleMessage('Delete poll?'),
        'keep_poll': MessageLookupByLibrary.simpleMessage('Keep'),
        'poll_deleted': MessageLookupByLibrary.simpleMessage('Poll deleted'),
        'get_started': MessageLookupByLibrary.simpleMessage('Get Started'),
        'guest_warning': MessageLookupByLibrary.simpleMessage(
            'You are browsing as a guest. Login to create polls.'),
        'hide_participants': MessageLookupByLibrary.simpleMessage(
            'Hide participants details'),
        'hero_badge': MessageLookupByLibrary.simpleMessage('BRUTAL IDEAS'),
        'hours_short': m3,
        'login': MessageLookupByLibrary.simpleMessage('Login'),
        'login_required_message': MessageLookupByLibrary.simpleMessage(
            'Please login or sign up to continue.'),
        'login_required_title':
            MessageLookupByLibrary.simpleMessage('Login required'),
        'logout': MessageLookupByLibrary.simpleMessage('Logout'),
        'need_two_options_error': MessageLookupByLibrary.simpleMessage(
            'Add at least two options'),
        'medium': MessageLookupByLibrary.simpleMessage('Medium'),
        'name': MessageLookupByLibrary.simpleMessage('Name'),
        'next': MessageLookupByLibrary.simpleMessage('Next'),
        'no_polls': MessageLookupByLibrary.simpleMessage('No polls yet'),
        'brand_label': MessageLookupByLibrary.simpleMessage('Neo'),
        'onboarding_desc_1': MessageLookupByLibrary.simpleMessage(
            'Easily create and share polls with your community.'),
        'onboarding_desc_2': MessageLookupByLibrary.simpleMessage(
            'Jump into polls with a bold brutalist interface.'),
        'onboarding_desc_3': MessageLookupByLibrary.simpleMessage(
            'See vibrant results update in real time.'),
        'onboarding_title_1':
            MessageLookupByLibrary.simpleMessage('Create Polls'),
        'onboarding_title_2':
            MessageLookupByLibrary.simpleMessage('Vote Anywhere'),
        'onboarding_title_3':
            MessageLookupByLibrary.simpleMessage('Track Results'),
        'option_hint': m0,
        'option_label': MessageLookupByLibrary.simpleMessage('Option'),
        'password': MessageLookupByLibrary.simpleMessage('Password'),
        'poll_created_success': MessageLookupByLibrary.simpleMessage(
            'Poll published successfully'),
        'poll_details': MessageLookupByLibrary.simpleMessage('Poll Details'),
        'poll_question_label':
            MessageLookupByLibrary.simpleMessage('Poll Question'),
        'poll_settings': MessageLookupByLibrary.simpleMessage('Poll Settings'),
        'poll_settings_title':
            MessageLookupByLibrary.simpleMessage('Poll Settings'),
        'popular_polls': MessageLookupByLibrary.simpleMessage('Popular Polls'),
        'profile_guest_description': MessageLookupByLibrary.simpleMessage(
            'Sign in to track the polls you create and participate in, and sync them across sessions.'),
        'profile_guest_login':
            MessageLookupByLibrary.simpleMessage('Go to login'),
        'profile_guest_title':
            MessageLookupByLibrary.simpleMessage('Create your profile'),
        'profile_empty_title': MessageLookupByLibrary.simpleMessage(
            "You haven't created any polls yet."),
        'profile_title': MessageLookupByLibrary.simpleMessage('Profile'),
        'publish': MessageLookupByLibrary.simpleMessage('Publish'),
        'password_strength_label':
            MessageLookupByLibrary.simpleMessage('Password Strength'),
        'settings': MessageLookupByLibrary.simpleMessage('Settings'),
        'signup': MessageLookupByLibrary.simpleMessage('Sign Up'),
        'skip': MessageLookupByLibrary.simpleMessage('Skip'),
        'remove': MessageLookupByLibrary.simpleMessage('Remove'),
        'reset': MessageLookupByLibrary.simpleMessage('Reset'),
        'results': MessageLookupByLibrary.simpleMessage('Results'),
        'share_poll': MessageLookupByLibrary.simpleMessage('Share poll'),
        'strong': MessageLookupByLibrary.simpleMessage('Strong'),
        'tour_create':
            MessageLookupByLibrary.simpleMessage('Launch a new poll from here.'),
        'tour_poll': MessageLookupByLibrary.simpleMessage(
            'Tap to explore poll details and vote.'),
        'tour_settings': MessageLookupByLibrary.simpleMessage(
            'Tweak language and dark mode here.'),
        'thanks_for_response': MessageLookupByLibrary.simpleMessage(
            'Thanks for the response!'),
        'validation_email': MessageLookupByLibrary.simpleMessage(
            'Enter a valid email address'),
        'validation_password_length': MessageLookupByLibrary.simpleMessage(
            'Use at least 6 characters'),
        'validation_required':
            MessageLookupByLibrary.simpleMessage('This field is required'),
        'untitled_poll': MessageLookupByLibrary.simpleMessage('Untitled Poll'),
        'weak': MessageLookupByLibrary.simpleMessage('Weak'),
        'vote': MessageLookupByLibrary.simpleMessage('Vote'),
      };
}
