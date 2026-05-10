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
  String get tapToZoom => 'Tap to zoom';

  @override
  String get chooseYourRoute => 'Choose your route';

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
}
