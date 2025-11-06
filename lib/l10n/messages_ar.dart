// ignore_for_file: depend_on_referenced_packages

import 'package:intl/message_lookup_by_library.dart';

final MessageLookupByLibrary messages = _MessageLookup();

class _MessageLookup extends MessageLookupByLibrary {
  @override
  String get localeName => 'ar';

  static String m0(Object index) => 'خيار $index';
  static String m1(Object hours) => 'ينتهي خلال $hours ساعات';
  static String m2(Object author) => 'بواسطة $author';
  static String m3(Object hours) => 'متبقي $hoursس';
  static String m4(Object message) => 'خطأ $message';

  @override
  final Map<String, Function> messages = _notInlinedMessages();

  static Map<String, Function> _notInlinedMessages() => <String, Function>{
        'add_option': MessageLookupByLibrary.simpleMessage('إضافة خيار'),
        'allow_sharing': MessageLookupByLibrary.simpleMessage(
            'يمكن للآخرين مشاركة هذا الاستطلاع'),
        'app_title':
            MessageLookupByLibrary.simpleMessage('استطلاعات نيو بروتاليست'),
        'collect_ideas_title':
            MessageLookupByLibrary.simpleMessage('اجمع الأفكار!'),
        'collect_ideas_subtitle': MessageLookupByLibrary.simpleMessage(
            'اجمع الآراء بلمسة بروتاليست جريئة.'),
        'create_button': MessageLookupByLibrary.simpleMessage('إنشاء'),
        'create_poll_header':
            MessageLookupByLibrary.simpleMessage('إنشاء استطلاع'),
        'default_user_name':
            MessageLookupByLibrary.simpleMessage('مبدع نيو'),
        'created_by': m2,
        'created_polls':
            MessageLookupByLibrary.simpleMessage('الاستطلاعات المنشأة'),
        'done': MessageLookupByLibrary.simpleMessage('تم'),
        'duration_label': MessageLookupByLibrary.simpleMessage('المدة'),
        'error_message': m4,
        'ends_in_hours': m1,
        'enter_question_error':
            MessageLookupByLibrary.simpleMessage('يرجى إدخال سؤال'),
        'hide_participants':
            MessageLookupByLibrary.simpleMessage('إخفاء تفاصيل المشاركين'),
        'hero_badge': MessageLookupByLibrary.simpleMessage('أفكار بروتالية'),
        'hours_short': m3,
        'need_two_options_error': MessageLookupByLibrary.simpleMessage(
            'أضف خيارين على الأقل'),
        'no_polls': MessageLookupByLibrary.simpleMessage('لا توجد استطلاعات بعد'),
        'brand_label': MessageLookupByLibrary.simpleMessage('نيو'),
        'option_hint': m0,
        'option_label': MessageLookupByLibrary.simpleMessage('خيار'),
        'poll_created_success': MessageLookupByLibrary.simpleMessage(
            'تم نشر الاستطلاع بنجاح'),
        'poll_details': MessageLookupByLibrary.simpleMessage('تفاصيل الاستطلاع'),
        'poll_question_label':
            MessageLookupByLibrary.simpleMessage('سؤال الاستطلاع'),
        'poll_settings':
            MessageLookupByLibrary.simpleMessage('إعدادات الاستطلاع'),
        'poll_settings_title':
            MessageLookupByLibrary.simpleMessage('إعدادات الاستطلاع'),
        'popular_polls':
            MessageLookupByLibrary.simpleMessage('الاستطلاعات الشائعة'),
        'profile_title': MessageLookupByLibrary.simpleMessage('الملف الشخصي'),
        'publish': MessageLookupByLibrary.simpleMessage('نشر'),
        'remove': MessageLookupByLibrary.simpleMessage('حذف'),
        'reset': MessageLookupByLibrary.simpleMessage('إعادة ضبط'),
        'results': MessageLookupByLibrary.simpleMessage('النتائج'),
        'share_poll': MessageLookupByLibrary.simpleMessage('مشاركة الاستطلاع'),
        'thanks_for_response':
            MessageLookupByLibrary.simpleMessage('شكراً لمشاركتك!'),
        'untitled_poll':
            MessageLookupByLibrary.simpleMessage('استطلاع بدون عنوان'),
        'vote': MessageLookupByLibrary.simpleMessage('تصويت'),
      };
}
