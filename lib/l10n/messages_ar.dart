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
  static String m5(Object query) => 'لا توجد نتائج لـ "$query"';

  @override
  final Map<String, Function> messages = _notInlinedMessages();

  static Map<String, Function> _notInlinedMessages() => <String, Function>{
        'add_option': MessageLookupByLibrary.simpleMessage('إضافة خيار'),
        'auth_email_in_use':
            MessageLookupByLibrary.simpleMessage('هذا البريد مسجل بالفعل'),
        'auth_invalid_password':
            MessageLookupByLibrary.simpleMessage('كلمة المرور غير صحيحة'),
        'auth_user_not_found':
            MessageLookupByLibrary.simpleMessage('الحساب غير موجود'),
        'allow_sharing': MessageLookupByLibrary.simpleMessage(
            'يمكن للآخرين مشاركة هذا الاستطلاع'),
        'app_title':
            MessageLookupByLibrary.simpleMessage('استطلاعات نيو بروتاليست'),
        'back': MessageLookupByLibrary.simpleMessage('رجوع'),
        'collect_ideas_title':
            MessageLookupByLibrary.simpleMessage('اجمع الأفكار!'),
        'collect_ideas_subtitle': MessageLookupByLibrary.simpleMessage(
            'اجمع الآراء بلمسة بروتاليست جريئة.'),
        'category_all': MessageLookupByLibrary.simpleMessage('الكل'),
        'category_fun': MessageLookupByLibrary.simpleMessage('مرح'),
        'category_general': MessageLookupByLibrary.simpleMessage('عام'),
        'category_tech': MessageLookupByLibrary.simpleMessage('تقنية'),
        'category_work': MessageLookupByLibrary.simpleMessage('عمل'),
        'home_empty_subtitle': MessageLookupByLibrary.simpleMessage(
            'كن أول من ينشئ استطلاعاً بطابع نيوبروتاليستي ويبدأ الحوار.'),
        'home_empty_title':
            MessageLookupByLibrary.simpleMessage('لا توجد استطلاعات بعد'),
        'cancel': MessageLookupByLibrary.simpleMessage('إلغاء'),
        'change_language':
            MessageLookupByLibrary.simpleMessage('تغيير اللغة'),
        'create_button': MessageLookupByLibrary.simpleMessage('إنشاء'),
        'nav_home': MessageLookupByLibrary.simpleMessage('الرئيسية'),
        'nav_profile': MessageLookupByLibrary.simpleMessage('الملف الشخصي'),
        'nav_search': MessageLookupByLibrary.simpleMessage('بحث'),
        'create_poll_header':
            MessageLookupByLibrary.simpleMessage('إنشاء استطلاع'),
        'default_user_name':
            MessageLookupByLibrary.simpleMessage('مبدع نيو'),
        'continue_as_guest':
            MessageLookupByLibrary.simpleMessage('المتابعة كضيف'),
        'search_empty': m5,
        'search_hint': MessageLookupByLibrary.simpleMessage(
            'ابحث في الاستطلاعات والخيارات'),
        'search_prompt': MessageLookupByLibrary.simpleMessage(
            'ابدأ بالكتابة لاستكشاف الاستطلاعات في جميع الفئات.'),
        'search_title': MessageLookupByLibrary.simpleMessage('بحث'),
        'dark_mode': MessageLookupByLibrary.simpleMessage('الوضع الليلي'),
        'dark_mode_off':
            MessageLookupByLibrary.simpleMessage('الوضع الليلي متوقف'),
        'dark_mode_on':
            MessageLookupByLibrary.simpleMessage('الوضع الليلي مفعل'),
        'simulate_no_internet': MessageLookupByLibrary.simpleMessage(
            'محاكاة عدم الاتصال بالإنترنت'),
        'offline_mode_active': MessageLookupByLibrary.simpleMessage(
            'تم تفعيل محاكاة عدم الاتصال'),
        'offline_mode_inactive': MessageLookupByLibrary.simpleMessage(
            'تم إيقاف محاكاة عدم الاتصال'),
        'offline_action_queued': MessageLookupByLibrary.simpleMessage(
            'تمت جدولة الإجراء أثناء عدم الاتصال'),
        'offline_sync_complete': MessageLookupByLibrary.simpleMessage(
            'تمت مزامنة الإجراءات المعلقة'),
        'export_my_data': MessageLookupByLibrary.simpleMessage('تصدير بياناتي'),
        'export_data_title': MessageLookupByLibrary.simpleMessage('تصدير بياناتك'),
        'created_by': m2,
        'my_polls': MessageLookupByLibrary.simpleMessage('استطلاعاتي'),
        'done': MessageLookupByLibrary.simpleMessage('تم'),
        'duration_label': MessageLookupByLibrary.simpleMessage('المدة'),
        'email': MessageLookupByLibrary.simpleMessage('البريد الإلكتروني'),
        'error_message': m4,
        'ends_in_hours': m1,
        'enter_question_error':
            MessageLookupByLibrary.simpleMessage('يرجى إدخال سؤال'),
        'generic_error': MessageLookupByLibrary.simpleMessage('حدث خطأ ما'),
        'delete': MessageLookupByLibrary.simpleMessage('حذف'),
        'delete_poll_message': MessageLookupByLibrary.simpleMessage(
            'سيتم حذف هذا الاستطلاع وجميع الأصوات.'),
        'delete_poll_title':
            MessageLookupByLibrary.simpleMessage('حذف الاستطلاع؟'),
        'keep_poll': MessageLookupByLibrary.simpleMessage('إبقاء'),
        'poll_deleted': MessageLookupByLibrary.simpleMessage('تم حذف الاستطلاع'),
        'get_started': MessageLookupByLibrary.simpleMessage('ابدأ الآن'),
        'guest_warning': MessageLookupByLibrary.simpleMessage(
            'أنت تتصفح كضيف. سجل الدخول لإنشاء الاستطلاعات.'),
        'hide_participants':
            MessageLookupByLibrary.simpleMessage('إخفاء تفاصيل المشاركين'),
        'hero_badge': MessageLookupByLibrary.simpleMessage('أفكار بروتالية'),
        'hours_short': m3,
        'login': MessageLookupByLibrary.simpleMessage('تسجيل الدخول'),
        'login_required_message': MessageLookupByLibrary.simpleMessage(
            'يرجى تسجيل الدخول أو إنشاء حساب للمتابعة.'),
        'login_required_title':
            MessageLookupByLibrary.simpleMessage('يتطلب تسجيل الدخول'),
        'logout': MessageLookupByLibrary.simpleMessage('تسجيل الخروج'),
        'need_two_options_error': MessageLookupByLibrary.simpleMessage(
            'أضف خيارين على الأقل'),
        'medium': MessageLookupByLibrary.simpleMessage('متوسطة'),
        'name': MessageLookupByLibrary.simpleMessage('الاسم'),
        'next': MessageLookupByLibrary.simpleMessage('التالي'),
        'no_polls': MessageLookupByLibrary.simpleMessage('لا توجد استطلاعات بعد'),
        'brand_label': MessageLookupByLibrary.simpleMessage('نيو'),
        'onboarding_desc_1': MessageLookupByLibrary.simpleMessage(
            'أنشئ وشارك الاستطلاعات بسهولة مع مجتمعك.'),
        'onboarding_desc_2': MessageLookupByLibrary.simpleMessage(
            'شارك في الاستطلاعات بسرعة مع واجهة جريئة.'),
        'onboarding_desc_3': MessageLookupByLibrary.simpleMessage(
            'شاهد النتائج الحيوية تتحدّث مباشرة.'),
        'onboarding_title_1':
            MessageLookupByLibrary.simpleMessage('أنشئ استطلاعات'),
        'onboarding_title_2':
            MessageLookupByLibrary.simpleMessage('صوّت بلمسة'),
        'onboarding_title_3':
            MessageLookupByLibrary.simpleMessage('تابع النتائج'),
        'option_hint': m0,
        'option_label': MessageLookupByLibrary.simpleMessage('خيار'),
        'password': MessageLookupByLibrary.simpleMessage('كلمة المرور'),
        'password_strength_label':
            MessageLookupByLibrary.simpleMessage('قوة كلمة المرور'),
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
        'profile_guest_description': MessageLookupByLibrary.simpleMessage(
            'سجّل دخولك لتتابع الاستطلاعات التي تنشئها وتشارك بها ولتتم مزامنتها بين الجلسات.'),
        'profile_guest_login':
            MessageLookupByLibrary.simpleMessage('اذهب لتسجيل الدخول'),
        'profile_guest_title':
            MessageLookupByLibrary.simpleMessage('أنشئ ملفك الشخصي'),
        'profile_empty_title': MessageLookupByLibrary.simpleMessage(
            'لم تقم بإنشاء أي استطلاعات بعد.'),
        'profile_title': MessageLookupByLibrary.simpleMessage('الملف الشخصي'),
        'publish': MessageLookupByLibrary.simpleMessage('نشر'),
        'settings': MessageLookupByLibrary.simpleMessage('الإعدادات'),
        'signup': MessageLookupByLibrary.simpleMessage('إنشاء حساب'),
        'skip': MessageLookupByLibrary.simpleMessage('تخطي'),
        'remove': MessageLookupByLibrary.simpleMessage('حذف'),
        'reset': MessageLookupByLibrary.simpleMessage('إعادة ضبط'),
        'results': MessageLookupByLibrary.simpleMessage('النتائج'),
        'share_poll': MessageLookupByLibrary.simpleMessage('مشاركة الاستطلاع'),
        'strong': MessageLookupByLibrary.simpleMessage('قوية'),
        'tour_create': MessageLookupByLibrary.simpleMessage(
            'أنشئ استطلاعًا جديدًا من هنا.'),
        'tour_poll': MessageLookupByLibrary.simpleMessage(
            'اضغط لعرض تفاصيل الاستطلاع والتصويت.'),
        'tour_settings': MessageLookupByLibrary.simpleMessage(
            'عدّل اللغة والوضع الليلي من هنا.'),
        'thanks_for_response':
            MessageLookupByLibrary.simpleMessage('شكراً لمشاركتك!'),
        'validation_email': MessageLookupByLibrary.simpleMessage(
            'أدخل بريدًا إلكترونيًا صالحًا'),
        'validation_password_length':
            MessageLookupByLibrary.simpleMessage('استخدم 6 أحرف على الأقل'),
        'validation_required':
            MessageLookupByLibrary.simpleMessage('هذا الحقل مطلوب'),
        'untitled_poll':
            MessageLookupByLibrary.simpleMessage('استطلاع بدون عنوان'),
        'weak': MessageLookupByLibrary.simpleMessage('ضعيفة'),
        'vote': MessageLookupByLibrary.simpleMessage('تصويت'),
      };
}
