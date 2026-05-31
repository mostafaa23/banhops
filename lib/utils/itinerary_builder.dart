/// Builds a detailed trip itinerary string based on route type and language.
String buildItinerary({
  required String from,
  required String to,
  required String routeType, // 'microbus' or 'train'
  required String lang,      // 'ar' or 'en'
}) {
  if (lang == 'ar') {
    return _buildAr(from: from, to: to, routeType: routeType);
  }
  return _buildEn(from: from, to: to, routeType: routeType);
}

String _buildAr({
  required String from,
  required String to,
  required String routeType,
}) {
  if (routeType == 'microbus') {
    return '''🚐 رحلتك بالميكروباص من $from إلى $to:

🚶 من $from لأقرب موقف ميكروباص
⏱ 5-10 دقائق  |  💰 مجاناً

🚐 ميكروباص للمؤسسة (لو محتاج تبديل)
⏱ 15-20 دقيقة  |  💰 5-8 جنيه

🚐 ميكروباص مباشر من المؤسسة لبنها
⏱ 45-60 دقيقة  |  💰 15-20 جنيه

🚶 من موقف بنها لـ $to
⏱ 5-10 دقائق  |  💰 5 جنيه

📊 الإجمالي التقريبي:
⏱ 70-100 دقيقة  |  💰 25-33 جنيه''';
  }

  // train
  return '''🚆 رحلتك بالقطار من $from إلى $to:

🚖 من $from لأقرب محطة قطار (تاكسي / مواصلة)
⏱ 15-20 دقيقة  |  💰 20-30 جنيه

🚆 ركوب القطار لمحطة بنها
⏱ 50 دقيقة  |  💰 50-120 جنيه (حسب الدرجة)

🚶 من محطة بنها لـ $to
⏱ 10 دقائق  |  💰 5-10 جنيه

📊 الإجمالي التقريبي:
⏱ 75-80 دقيقة  |  💰 75-160 جنيه''';
}

String _buildEn({
  required String from,
  required String to,
  required String routeType,
}) {
  if (routeType == 'microbus') {
    return '''🚐 Your microbus trip from $from to $to:

🚶 Walk from $from to nearest microbus stop
⏱ 5-10 min  |  💰 Free

🚐 Microbus to Moassasa (if transfer needed)
⏱ 15-20 min  |  💰 5-8 EGP

🚐 Direct microbus from Moassasa to Benha
⏱ 45-60 min  |  💰 15-20 EGP

🚶 Walk from Benha stop to $to
⏱ 5-10 min  |  💰 5 EGP

📊 Estimated total:
⏱ 70-100 min  |  💰 25-33 EGP''';
  }

  // train
  return '''🚆 Your train trip from $from to $to:

🚖 From $from to nearest train station (taxi/transit)
⏱ 15-20 min  |  💰 20-30 EGP

🚆 Train to Benha Station
⏱ 50 min  |  💰 50-120 EGP (depends on class)

🚶 Walk from Benha Station to $to
⏱ 10 min  |  💰 5-10 EGP

📊 Estimated total:
⏱ 75-80 min  |  💰 75-160 EGP''';
}