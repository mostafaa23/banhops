// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'BanHops';

  @override
  String get appSubtitle => 'Smart Transportation';

  @override
  String get loading => 'Loading...';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get english => 'English';

  @override
  String get arabic => 'العربية';

  @override
  String get signIn => 'Sign In';

  @override
  String get signUp => 'Sign Up';

  @override
  String get username => 'Username';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get firstName => 'First Name';

  @override
  String get lastName => 'Last Name';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get phoneRequired => 'Phone number is required';

  @override
  String get invalidPhoneNumber => 'Enter a valid phone number';

  @override
  String get phoneNumberPlaceholder => '+20 1XX XXX XXXX';

  @override
  String get accountCreatedSuccessfully => 'Account created successfully';

  @override
  String get forgotPasswordStep1Desc =>
      'Enter your phone number and email to receive a verification code.';

  @override
  String get forgotPasswordStep2Desc =>
      'We sent a 6-digit code to your email. Enter it below.';

  @override
  String get forgotPasswordStep3Desc =>
      'Choose a strong new password for your account.';

  @override
  String get verifyCode => 'Verify Code';

  @override
  String get newPassword => 'New Password';

  @override
  String get send => 'Send';

  @override
  String get verify => 'Verify';

  @override
  String get resendCode => 'Resend Code';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get completeSixDigitCode => 'Please enter the complete 6-digit code';

  @override
  String get from => 'From';

  @override
  String get to => 'To';

  @override
  String get home => 'Home';

  @override
  String get history => 'History';

  @override
  String get profile => 'Profile';

  @override
  String get chat => 'Chat';

  @override
  String get tripHistory => 'Trip History';

  @override
  String get myTrips => 'My Trips';

  @override
  String get clearHistory => 'Clear History?';

  @override
  String get clearHistoryConfirm =>
      'Are you sure you want to clear all trip history?';

  @override
  String get cancel => 'Cancel';

  @override
  String get clear => 'Clear';

  @override
  String get noTripsYet => 'No trips yet';

  @override
  String get startPlanning => 'Start planning your first trip to Benha!';

  @override
  String get line => 'LINE';

  @override
  String get routeDetails => 'Route Details';

  @override
  String get transportationOptions => 'Transportation Options';

  @override
  String get smartTip => 'BanHops Smart Tip';

  @override
  String get askNow => 'Ask Now';

  @override
  String get smartTipContent =>
      'If you want to save time and money, the microbus from Moassasa is your first choice. Tap here to ask anything else!';

  @override
  String get chatWithAI => 'Chat with AI Assistant';

  @override
  String get readyToHelp => 'READY TO HELP YOU';

  @override
  String get bestMatch => 'BEST MATCH';

  @override
  String get pros => 'PROS';

  @override
  String get cons => 'CONS';

  @override
  String get welcomeTo => 'Welcome to';

  @override
  String get smartRouteToBenha => 'Smart Route to Benha';

  @override
  String get pleaseSelectLanguage => 'Please select a language.';

  @override
  String get arabicNative => 'العربية';

  @override
  String get englishNative => 'English';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get usernameRequired => 'Username is required';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get firstNameRequired => 'First name is required';

  @override
  String get lastNameRequired => 'Last name is required';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get confirmPasswordRequired => 'Confirm password is required';

  @override
  String get invalidEmail => 'Enter a valid email';

  @override
  String get passwordTooShort => 'At least 6 characters';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get usernameHint => 'johndoe123';

  @override
  String get passwordHint => '••••••••••••';

  @override
  String get firstNameHint => 'John';

  @override
  String get lastNameHint => 'Doe';

  @override
  String get emailHint => 'johndoe@xyz.com';

  @override
  String get trainLines => 'Train Lines';

  @override
  String get journeyToBenhaStartsHere => 'Your journey to Benha starts here';

  @override
  String get backToSelection => 'Back to Selection';

  @override
  String get trainMap => 'Train Map';

  @override
  String get tapToZoom => 'Tap to Zoom';

  @override
  String get chooseYourRoute => 'Choose Your Route';

  @override
  String startingFrom(Object city) {
    return 'Starting from $city';
  }

  @override
  String get allTripsEndAtBenha => 'All trips end at Benha Station';

  @override
  String get destinationBenha => 'Destination: Benha';

  @override
  String get finalArrival => 'FINAL ARRIVAL';

  @override
  String stationNumber(Object number) {
    return 'STATION $number';
  }

  @override
  String get liveBadge => 'LIVE';

  @override
  String get getRoutes => 'Get Routes';

  @override
  String get banHopsAI => 'BanHops AI';

  @override
  String get online => 'Online';

  @override
  String get typeAMessage => 'Type a message...';

  @override
  String get chatIntroGeneric =>
      'Hello! I\'m the BanHops AI Assistant. How can I help you today?';

  @override
  String chatIntroRoute(Object from, Object to) {
    return 'Hello! I\'m here to help you with your trip from $from to $to. How can I help you?';
  }

  @override
  String get aiResponse1 =>
      'Direct microbus is currently the best choice to avoid traffic in Benha.';

  @override
  String get aiResponse2 =>
      'You can reach Benha University within 30 mins if you move now.';

  @override
  String get aiResponse3 =>
      'Trip cost from your location to Benha center is about 15-20 EGP by microbus.';

  @override
  String get aiResponse4 =>
      'Make sure to charge your phone, Benha is beautiful for photos today!';

  @override
  String get aiResponse5 =>
      'I can book a taxi for you if you prefer total comfort.';

  @override
  String get pleaseSelectDestination =>
      'Please select your destination in Benha first!';

  @override
  String get couldNotLaunchMaps => 'Could not launch Google Maps';

  @override
  String get facultyOfCommerce => 'Faculty of Commerce';

  @override
  String get facultyOfArts => 'Faculty of Arts';

  @override
  String get facultyOfEducation => 'Faculty of Education';

  @override
  String get facultyOfSpecificEducation => 'Faculty of Specific Education';

  @override
  String get facultyOfPhysicalEducation => 'Faculty of Physical Education';

  @override
  String get facultyOfLaw => 'Faculty of Law';

  @override
  String get facultyOfAppliedArts => 'Faculty of Applied Arts';

  @override
  String get selectCollege => 'Select College';

  @override
  String get benhaUniversityColleges => 'Benha University Colleges';

  @override
  String get popularZones => 'Popular Zones';

  @override
  String get university => 'University';

  @override
  String get hospital => 'Hospital';

  @override
  String get busTerminal => 'Bus Terminal';

  @override
  String get trainStation => 'Train Station';

  @override
  String get selectGovernorate => 'SELECT GOVERNORATE';

  @override
  String get selectCityArea => 'SELECT CITY / AREA';

  @override
  String get whereInBenha => 'WHERE IN BENHA?';

  @override
  String get chooseDestination => 'Choose destination...';

  @override
  String get welcome => 'Welcome';

  @override
  String get planTrip => 'Plan Trip';

  @override
  String get trainLineCairoGiza => 'Cairo / Giza — Benha Line';

  @override
  String get trainLineAlexandria => 'Alexandria / Sidi Gaber — Benha Line';

  @override
  String get trainLineDamietta => 'Damietta / Mansoura — Benha Line';

  @override
  String get trainLineCentralDelta => 'Central Delta & Menoufia — Benha Line';

  @override
  String get trainLineCanal => 'Canal & Sharqia — Benha Line';

  @override
  String get trainLineUpperEgypt => 'Upper Egypt — Benha Line';

  @override
  String get back => 'Back';

  @override
  String get railwayMap => 'Railway Map';

  @override
  String get allTripsTerminate => 'All trips terminate at Benha Station';

  @override
  String get findLiveTrips => 'Find Live Trips';
}
