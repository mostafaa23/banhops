import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'BanHops'**
  String get appName;

  /// No description provided for @appSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Smart Transportation'**
  String get appSubtitle;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get arabic;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @phoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get phoneRequired;

  /// No description provided for @forgotPasswordStep1Desc.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number and email to receive a verification code.'**
  String get forgotPasswordStep1Desc;

  /// No description provided for @forgotPasswordStep2Desc.
  ///
  /// In en, this message translates to:
  /// **'We sent a 6-digit code to your email. Enter it below.'**
  String get forgotPasswordStep2Desc;

  /// No description provided for @forgotPasswordStep3Desc.
  ///
  /// In en, this message translates to:
  /// **'Choose a strong new password for your account.'**
  String get forgotPasswordStep3Desc;

  /// No description provided for @verifyCode.
  ///
  /// In en, this message translates to:
  /// **'Verify Code'**
  String get verifyCode;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend Code'**
  String get resendCode;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @completeSixDigitCode.
  ///
  /// In en, this message translates to:
  /// **'Please enter the complete 6-digit code'**
  String get completeSixDigitCode;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @tripHistory.
  ///
  /// In en, this message translates to:
  /// **'Trip History'**
  String get tripHistory;

  /// No description provided for @myTrips.
  ///
  /// In en, this message translates to:
  /// **'My Trips'**
  String get myTrips;

  /// No description provided for @clearHistory.
  ///
  /// In en, this message translates to:
  /// **'Clear History?'**
  String get clearHistory;

  /// No description provided for @clearHistoryConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to clear all trip history?'**
  String get clearHistoryConfirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @noTripsYet.
  ///
  /// In en, this message translates to:
  /// **'No trips yet'**
  String get noTripsYet;

  /// No description provided for @startPlanning.
  ///
  /// In en, this message translates to:
  /// **'Start planning your first trip to Benha!'**
  String get startPlanning;

  /// No description provided for @line.
  ///
  /// In en, this message translates to:
  /// **'LINE'**
  String get line;

  /// No description provided for @routeDetails.
  ///
  /// In en, this message translates to:
  /// **'Route Details'**
  String get routeDetails;

  /// No description provided for @transportationOptions.
  ///
  /// In en, this message translates to:
  /// **'Transportation Options'**
  String get transportationOptions;

  /// No description provided for @smartTip.
  ///
  /// In en, this message translates to:
  /// **'BanHops Smart Tip'**
  String get smartTip;

  /// No description provided for @askNow.
  ///
  /// In en, this message translates to:
  /// **'Ask Now'**
  String get askNow;

  /// No description provided for @smartTipContent.
  ///
  /// In en, this message translates to:
  /// **'If you want to save time and money, the microbus from Moassasa is your first choice. Tap here to ask anything else!'**
  String get smartTipContent;

  /// No description provided for @chatWithAI.
  ///
  /// In en, this message translates to:
  /// **'Chat with AI Assistant'**
  String get chatWithAI;

  /// No description provided for @readyToHelp.
  ///
  /// In en, this message translates to:
  /// **'READY TO HELP YOU'**
  String get readyToHelp;

  /// No description provided for @bestMatch.
  ///
  /// In en, this message translates to:
  /// **'BEST MATCH'**
  String get bestMatch;

  /// No description provided for @pros.
  ///
  /// In en, this message translates to:
  /// **'PROS'**
  String get pros;

  /// No description provided for @cons.
  ///
  /// In en, this message translates to:
  /// **'CONS'**
  String get cons;

  /// No description provided for @welcomeTo.
  ///
  /// In en, this message translates to:
  /// **'Welcome to'**
  String get welcomeTo;

  /// No description provided for @smartRouteToBenha.
  ///
  /// In en, this message translates to:
  /// **'Smart Route to Benha'**
  String get smartRouteToBenha;

  /// No description provided for @pleaseSelectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Please select a language.'**
  String get pleaseSelectLanguage;

  /// No description provided for @arabicNative.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get arabicNative;

  /// No description provided for @englishNative.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get englishNative;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @usernameRequired.
  ///
  /// In en, this message translates to:
  /// **'Username is required'**
  String get usernameRequired;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// No description provided for @firstNameRequired.
  ///
  /// In en, this message translates to:
  /// **'First name is required'**
  String get firstNameRequired;

  /// No description provided for @lastNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Last name is required'**
  String get lastNameRequired;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailRequired;

  /// No description provided for @confirmPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Confirm password is required'**
  String get confirmPasswordRequired;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get invalidEmail;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'At least 6 characters'**
  String get passwordTooShort;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @usernameHint.
  ///
  /// In en, this message translates to:
  /// **'johndoe123'**
  String get usernameHint;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'••••••••••••'**
  String get passwordHint;

  /// No description provided for @firstNameHint.
  ///
  /// In en, this message translates to:
  /// **'John'**
  String get firstNameHint;

  /// No description provided for @lastNameHint.
  ///
  /// In en, this message translates to:
  /// **'Doe'**
  String get lastNameHint;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'johndoe@xyz.com'**
  String get emailHint;

  /// No description provided for @trainLines.
  ///
  /// In en, this message translates to:
  /// **'Train Lines'**
  String get trainLines;

  /// No description provided for @journeyToBenhaStartsHere.
  ///
  /// In en, this message translates to:
  /// **'Your journey to Benha starts here'**
  String get journeyToBenhaStartsHere;

  /// No description provided for @backToSelection.
  ///
  /// In en, this message translates to:
  /// **'Back to Selection'**
  String get backToSelection;

  /// No description provided for @trainMap.
  ///
  /// In en, this message translates to:
  /// **'Train Map'**
  String get trainMap;

  /// No description provided for @tapToZoom.
  ///
  /// In en, this message translates to:
  /// **'Tap to zoom'**
  String get tapToZoom;

  /// No description provided for @chooseYourRoute.
  ///
  /// In en, this message translates to:
  /// **'Choose your route'**
  String get chooseYourRoute;

  /// No description provided for @startingFrom.
  ///
  /// In en, this message translates to:
  /// **'Starting from {city}'**
  String startingFrom(Object city);

  /// No description provided for @allTripsEndAtBenha.
  ///
  /// In en, this message translates to:
  /// **'All trips end at Benha Station'**
  String get allTripsEndAtBenha;

  /// No description provided for @destinationBenha.
  ///
  /// In en, this message translates to:
  /// **'Destination: Benha'**
  String get destinationBenha;

  /// No description provided for @finalArrival.
  ///
  /// In en, this message translates to:
  /// **'FINAL ARRIVAL'**
  String get finalArrival;

  /// No description provided for @stationNumber.
  ///
  /// In en, this message translates to:
  /// **'STATION {number}'**
  String stationNumber(Object number);

  /// No description provided for @liveBadge.
  ///
  /// In en, this message translates to:
  /// **'LIVE'**
  String get liveBadge;

  /// No description provided for @getRoutes.
  ///
  /// In en, this message translates to:
  /// **'Get Routes'**
  String get getRoutes;

  /// No description provided for @banHopsAI.
  ///
  /// In en, this message translates to:
  /// **'BanHops AI'**
  String get banHopsAI;

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// No description provided for @typeAMessage.
  ///
  /// In en, this message translates to:
  /// **'Type a message...'**
  String get typeAMessage;

  /// No description provided for @chatIntroGeneric.
  ///
  /// In en, this message translates to:
  /// **'Hello! I\'m the BanHops AI Assistant. How can I help you today?'**
  String get chatIntroGeneric;

  /// No description provided for @chatIntroRoute.
  ///
  /// In en, this message translates to:
  /// **'Hello! I\'m here to help you with your trip from {from} to {to}. How can I help you?'**
  String chatIntroRoute(Object from, Object to);

  /// No description provided for @aiResponse1.
  ///
  /// In en, this message translates to:
  /// **'Direct microbus is currently the best choice to avoid traffic in Benha.'**
  String get aiResponse1;

  /// No description provided for @aiResponse2.
  ///
  /// In en, this message translates to:
  /// **'You can reach Benha University within 30 mins if you move now.'**
  String get aiResponse2;

  /// No description provided for @aiResponse3.
  ///
  /// In en, this message translates to:
  /// **'Trip cost from your location to Benha center is about 15-20 EGP by microbus.'**
  String get aiResponse3;

  /// No description provided for @aiResponse4.
  ///
  /// In en, this message translates to:
  /// **'Make sure to charge your phone, Benha is beautiful for photos today!'**
  String get aiResponse4;

  /// No description provided for @aiResponse5.
  ///
  /// In en, this message translates to:
  /// **'I can book a taxi for you if you prefer total comfort.'**
  String get aiResponse5;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
