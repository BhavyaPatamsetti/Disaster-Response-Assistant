import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_hi.dart';

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
    Locale('en'),
    Locale('es'),
    Locale('hi'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Disaster Response Assistant'**
  String get appTitle;

  /// No description provided for @firstAid.
  ///
  /// In en, this message translates to:
  /// **'First Aid'**
  String get firstAid;

  /// No description provided for @survival.
  ///
  /// In en, this message translates to:
  /// **'Survival'**
  String get survival;

  /// No description provided for @communications.
  ///
  /// In en, this message translates to:
  /// **'Communications'**
  String get communications;

  /// No description provided for @supplies.
  ///
  /// In en, this message translates to:
  /// **'Supplies'**
  String get supplies;

  /// No description provided for @emergency.
  ///
  /// In en, this message translates to:
  /// **'Emergency'**
  String get emergency;

  /// No description provided for @groups.
  ///
  /// In en, this message translates to:
  /// **'Groups'**
  String get groups;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @offlineModeActive.
  ///
  /// In en, this message translates to:
  /// **'Offline Mode Active - All systems operational'**
  String get offlineModeActive;

  /// No description provided for @askQuestion.
  ///
  /// In en, this message translates to:
  /// **'Ask a Question'**
  String get askQuestion;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get lightMode;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @iUnderstand.
  ///
  /// In en, this message translates to:
  /// **'I Understand'**
  String get iUnderstand;

  /// No description provided for @bleeding.
  ///
  /// In en, this message translates to:
  /// **'Bleeding'**
  String get bleeding;

  /// No description provided for @cpr.
  ///
  /// In en, this message translates to:
  /// **'CPR'**
  String get cpr;

  /// No description provided for @burns.
  ///
  /// In en, this message translates to:
  /// **'Burns'**
  String get burns;

  /// No description provided for @choking.
  ///
  /// In en, this message translates to:
  /// **'Choking'**
  String get choking;

  /// No description provided for @fractures.
  ///
  /// In en, this message translates to:
  /// **'Fractures'**
  String get fractures;

  /// No description provided for @unconscious.
  ///
  /// In en, this message translates to:
  /// **'Unconscious'**
  String get unconscious;

  /// No description provided for @quickScenarios.
  ///
  /// In en, this message translates to:
  /// **'Quick Scenarios:'**
  String get quickScenarios;

  /// No description provided for @selectFirstAidScenario.
  ///
  /// In en, this message translates to:
  /// **'Select a first aid scenario or ask a specific question:'**
  String get selectFirstAidScenario;

  /// No description provided for @gettingResponse.
  ///
  /// In en, this message translates to:
  /// **'Getting Response...'**
  String get gettingResponse;

  /// No description provided for @getGuidance.
  ///
  /// In en, this message translates to:
  /// **'Get Guidance'**
  String get getGuidance;

  /// No description provided for @firstAidTips.
  ///
  /// In en, this message translates to:
  /// **'First Aid Tips'**
  String get firstAidTips;

  /// No description provided for @pleaseEnterQuestion.
  ///
  /// In en, this message translates to:
  /// **'Please enter a question'**
  String get pleaseEnterQuestion;

  /// No description provided for @gettingResponseFromAI.
  ///
  /// In en, this message translates to:
  /// **'Getting response from AI...'**
  String get gettingResponseFromAI;

  /// No description provided for @askYourOwnQuestion.
  ///
  /// In en, this message translates to:
  /// **'Ask Your Own Question:'**
  String get askYourOwnQuestion;

  /// No description provided for @questionHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., How do I treat a sprained ankle?'**
  String get questionHint;

  /// No description provided for @bleedingQuestion.
  ///
  /// In en, this message translates to:
  /// **'Person has heavy bleeding from [location]—what do I do first?'**
  String get bleedingQuestion;

  /// No description provided for @cprQuestion.
  ///
  /// In en, this message translates to:
  /// **'Someone is unconscious and not breathing—how do I perform CPR?'**
  String get cprQuestion;

  /// No description provided for @burnsQuestion.
  ///
  /// In en, this message translates to:
  /// **'Person has second-degree burns on hand—immediate treatment?'**
  String get burnsQuestion;

  /// No description provided for @chokingQuestion.
  ///
  /// In en, this message translates to:
  /// **'Person is choking and cannot speak—what is the Heimlich maneuver?'**
  String get chokingQuestion;

  /// No description provided for @fracturesQuestion.
  ///
  /// In en, this message translates to:
  /// **'Person has suspected broken bone in arm—first aid steps?'**
  String get fracturesQuestion;

  /// No description provided for @unconsciousQuestion.
  ///
  /// In en, this message translates to:
  /// **'Person is unconscious but breathing—what should I do?'**
  String get unconsciousQuestion;

  /// No description provided for @tipCallEmergency.
  ///
  /// In en, this message translates to:
  /// **'• Always call emergency services for serious injuries'**
  String get tipCallEmergency;

  /// No description provided for @tipKeepSupplies.
  ///
  /// In en, this message translates to:
  /// **'• Keep first aid supplies readily available'**
  String get tipKeepSupplies;

  /// No description provided for @tipStayCalm.
  ///
  /// In en, this message translates to:
  /// **'• Stay calm and assess the situation first'**
  String get tipStayCalm;

  /// No description provided for @tipDontMove.
  ///
  /// In en, this message translates to:
  /// **'• Never move someone with suspected neck/back injury'**
  String get tipDontMove;

  /// No description provided for @survivalSkills.
  ///
  /// In en, this message translates to:
  /// **'Survival Skills'**
  String get survivalSkills;

  /// No description provided for @learnEssentialSurvival.
  ///
  /// In en, this message translates to:
  /// **'Learn essential survival techniques for emergency situations:'**
  String get learnEssentialSurvival;

  /// No description provided for @essentialSkills.
  ///
  /// In en, this message translates to:
  /// **'Essential Skills:'**
  String get essentialSkills;

  /// No description provided for @water.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get water;

  /// No description provided for @shelter.
  ///
  /// In en, this message translates to:
  /// **'Shelter'**
  String get shelter;

  /// No description provided for @fire.
  ///
  /// In en, this message translates to:
  /// **'Fire'**
  String get fire;

  /// No description provided for @food.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get food;

  /// No description provided for @sanitation.
  ///
  /// In en, this message translates to:
  /// **'Sanitation'**
  String get sanitation;

  /// No description provided for @navigation.
  ///
  /// In en, this message translates to:
  /// **'Navigation'**
  String get navigation;

  /// No description provided for @waterQuestion.
  ///
  /// In en, this message translates to:
  /// **'How do I make drinking water safe after [disaster]?'**
  String get waterQuestion;

  /// No description provided for @shelterQuestion.
  ///
  /// In en, this message translates to:
  /// **'How do I build emergency shelter in [environment]?'**
  String get shelterQuestion;

  /// No description provided for @fireQuestion.
  ///
  /// In en, this message translates to:
  /// **'How do I start a fire safely in [conditions]?'**
  String get fireQuestion;

  /// No description provided for @foodQuestion.
  ///
  /// In en, this message translates to:
  /// **'What food is safe to eat in emergency situations?'**
  String get foodQuestion;

  /// No description provided for @sanitationQuestion.
  ///
  /// In en, this message translates to:
  /// **'How do I maintain hygiene without running water?'**
  String get sanitationQuestion;

  /// No description provided for @navigationQuestion.
  ///
  /// In en, this message translates to:
  /// **'How do I navigate without GPS or compass?'**
  String get navigationQuestion;

  /// No description provided for @askCustomSurvivalQuestion.
  ///
  /// In en, this message translates to:
  /// **'Or ask a custom survival question:'**
  String get askCustomSurvivalQuestion;

  /// No description provided for @survivalQuestionHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., How do I signal for help in the wilderness?'**
  String get survivalQuestionHint;

  /// No description provided for @survivalTips.
  ///
  /// In en, this message translates to:
  /// **'Survival Tips'**
  String get survivalTips;

  /// No description provided for @tipPrioritizeShelter.
  ///
  /// In en, this message translates to:
  /// **'• Always prioritize shelter, water, and fire'**
  String get tipPrioritizeShelter;

  /// No description provided for @tipStayCalmSurvival.
  ///
  /// In en, this message translates to:
  /// **'• Stay calm and assess your situation'**
  String get tipStayCalmSurvival;

  /// No description provided for @tipConserveEnergy.
  ///
  /// In en, this message translates to:
  /// **'• Conserve energy and resources'**
  String get tipConserveEnergy;

  /// No description provided for @tipSignalForHelp.
  ///
  /// In en, this message translates to:
  /// **'• Signal for help when possible'**
  String get tipSignalForHelp;

  /// No description provided for @askAnyQuestion.
  ///
  /// In en, this message translates to:
  /// **'Ask Any Question'**
  String get askAnyQuestion;

  /// No description provided for @askAnyDisasterQuestion.
  ///
  /// In en, this message translates to:
  /// **'Ask any disaster response or emergency preparedness question:'**
  String get askAnyDisasterQuestion;

  /// No description provided for @questionInputHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., How do I treat a deep cut? What should I pack in an emergency kit?'**
  String get questionInputHint;

  /// No description provided for @getAnswer.
  ///
  /// In en, this message translates to:
  /// **'Get Answer'**
  String get getAnswer;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @exampleQuestions.
  ///
  /// In en, this message translates to:
  /// **'Example Questions'**
  String get exampleQuestions;

  /// No description provided for @exampleEvacuationPlan.
  ///
  /// In en, this message translates to:
  /// **'How do I create an emergency evacuation plan?'**
  String get exampleEvacuationPlan;

  /// No description provided for @example72HourKit.
  ///
  /// In en, this message translates to:
  /// **'What should I include in a 72-hour emergency kit?'**
  String get example72HourKit;

  /// No description provided for @examplePanicAttack.
  ///
  /// In en, this message translates to:
  /// **'How do I help someone having a panic attack?'**
  String get examplePanicAttack;

  /// No description provided for @exampleHeatStroke.
  ///
  /// In en, this message translates to:
  /// **'What are the signs of heat stroke and how do I treat it?'**
  String get exampleHeatStroke;

  /// No description provided for @examplePurifyWater.
  ///
  /// In en, this message translates to:
  /// **'How do I purify water in the wilderness?'**
  String get examplePurifyWater;

  /// No description provided for @tipsForBetterAnswers.
  ///
  /// In en, this message translates to:
  /// **'Tips for Better Answers'**
  String get tipsForBetterAnswers;

  /// No description provided for @tipBeSpecific.
  ///
  /// In en, this message translates to:
  /// **'• Be specific about the emergency situation'**
  String get tipBeSpecific;

  /// No description provided for @tipMentionConditions.
  ///
  /// In en, this message translates to:
  /// **'• Mention any relevant conditions or limitations'**
  String get tipMentionConditions;

  /// No description provided for @tipAskImmediate.
  ///
  /// In en, this message translates to:
  /// **'• Ask about immediate steps first, then follow-up'**
  String get tipAskImmediate;

  /// No description provided for @tipIncludeLocation.
  ///
  /// In en, this message translates to:
  /// **'• Include location or environment if relevant'**
  String get tipIncludeLocation;

  /// No description provided for @emergencyComms.
  ///
  /// In en, this message translates to:
  /// **'📡 Emergency Communications'**
  String get emergencyComms;

  /// No description provided for @templatesGuidance.
  ///
  /// In en, this message translates to:
  /// **'Templates and guidance for emergency communications:'**
  String get templatesGuidance;

  /// No description provided for @commTemplates.
  ///
  /// In en, this message translates to:
  /// **'Communication Templates:'**
  String get commTemplates;

  /// No description provided for @checkIn.
  ///
  /// In en, this message translates to:
  /// **'Check-in'**
  String get checkIn;

  /// No description provided for @generateSMSCheckIn.
  ///
  /// In en, this message translates to:
  /// **'Generate an SMS check-in message for family'**
  String get generateSMSCheckIn;

  /// No description provided for @supplyInventory.
  ///
  /// In en, this message translates to:
  /// **'Supply Inventory'**
  String get supplyInventory;

  /// No description provided for @showExpiringItems.
  ///
  /// In en, this message translates to:
  /// **'Show expiring items'**
  String get showExpiringItems;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @expired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get expired;

  /// No description provided for @expiring.
  ///
  /// In en, this message translates to:
  /// **'Expiring'**
  String get expiring;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @noSuppliesYet.
  ///
  /// In en, this message translates to:
  /// **'No supplies added yet'**
  String get noSuppliesYet;

  /// No description provided for @noSuppliesMatch.
  ///
  /// In en, this message translates to:
  /// **'No supplies match your filters'**
  String get noSuppliesMatch;

  /// No description provided for @tapPlusButton.
  ///
  /// In en, this message translates to:
  /// **'Tap the + button to add your first supply'**
  String get tapPlusButton;

  /// No description provided for @tryAdjustingFilters.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your category or expiration filters'**
  String get tryAdjustingFilters;

  /// No description provided for @errorLoadingContacts.
  ///
  /// In en, this message translates to:
  /// **'Error loading contacts'**
  String get errorLoadingContacts;

  /// No description provided for @couldNotMakeCall.
  ///
  /// In en, this message translates to:
  /// **'Could not make phone call'**
  String get couldNotMakeCall;

  /// No description provided for @emergencyServices.
  ///
  /// In en, this message translates to:
  /// **'Emergency Services'**
  String get emergencyServices;

  /// No description provided for @poisonControl.
  ///
  /// In en, this message translates to:
  /// **'Poison Control'**
  String get poisonControl;

  /// No description provided for @emergencyContacts.
  ///
  /// In en, this message translates to:
  /// **'Emergency Contacts'**
  String get emergencyContacts;

  /// No description provided for @quickEmergencyDial.
  ///
  /// In en, this message translates to:
  /// **'Quick Emergency Dial'**
  String get quickEmergencyDial;

  /// No description provided for @groupMessaging.
  ///
  /// In en, this message translates to:
  /// **'Group Messaging'**
  String get groupMessaging;

  /// No description provided for @createGroup.
  ///
  /// In en, this message translates to:
  /// **'Create Group'**
  String get createGroup;

  /// No description provided for @emergencyAlert.
  ///
  /// In en, this message translates to:
  /// **'Emergency Alert'**
  String get emergencyAlert;

  /// No description provided for @familyEmergency.
  ///
  /// In en, this message translates to:
  /// **'Family Emergency'**
  String get familyEmergency;

  /// No description provided for @emergencyCoordination.
  ///
  /// In en, this message translates to:
  /// **'Emergency coordination with family members'**
  String get emergencyCoordination;

  /// No description provided for @emergencyResponseTeam.
  ///
  /// In en, this message translates to:
  /// **'Emergency Response Team'**
  String get emergencyResponseTeam;

  /// No description provided for @coordinateLocal.
  ///
  /// In en, this message translates to:
  /// **'Coordinate with local emergency responders'**
  String get coordinateLocal;

  /// No description provided for @members.
  ///
  /// In en, this message translates to:
  /// **'members'**
  String get members;

  /// No description provided for @locationTracking.
  ///
  /// In en, this message translates to:
  /// **'Location Tracking'**
  String get locationTracking;

  /// No description provided for @locationTrackingInactive.
  ///
  /// In en, this message translates to:
  /// **'Location Tracking Inactive'**
  String get locationTrackingInactive;

  /// No description provided for @currentLocation.
  ///
  /// In en, this message translates to:
  /// **'Current Location'**
  String get currentLocation;

  /// No description provided for @coordinates.
  ///
  /// In en, this message translates to:
  /// **'Coordinates'**
  String get coordinates;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @accuracy.
  ///
  /// In en, this message translates to:
  /// **'Accuracy'**
  String get accuracy;

  /// No description provided for @updated.
  ///
  /// In en, this message translates to:
  /// **'Updated'**
  String get updated;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @maps.
  ///
  /// In en, this message translates to:
  /// **'Maps'**
  String get maps;

  /// No description provided for @unableToGetCurrentLocation.
  ///
  /// In en, this message translates to:
  /// **'Unable to get current location'**
  String get unableToGetCurrentLocation;

  /// No description provided for @failedToStartLocationTracking.
  ///
  /// In en, this message translates to:
  /// **'Failed to start location tracking. Please check permissions.'**
  String get failedToStartLocationTracking;

  /// No description provided for @emergencyLocationMessage.
  ///
  /// In en, this message translates to:
  /// **'Emergency! I need help at this location:'**
  String get emergencyLocationMessage;

  /// No description provided for @coordinatesCopiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Coordinates copied to clipboard'**
  String get coordinatesCopiedToClipboard;

  /// No description provided for @getCurrentLocation.
  ///
  /// In en, this message translates to:
  /// **'Get Current Location'**
  String get getCurrentLocation;

  /// No description provided for @startTracking.
  ///
  /// In en, this message translates to:
  /// **'Start Tracking'**
  String get startTracking;

  /// No description provided for @disasterResponseAssistant.
  ///
  /// In en, this message translates to:
  /// **'Disaster Response Assistant'**
  String get disasterResponseAssistant;

  /// No description provided for @appInfo.
  ///
  /// In en, this message translates to:
  /// **'🚨 Disaster Response Assistant'**
  String get appInfo;

  /// No description provided for @appDescription.
  ///
  /// In en, this message translates to:
  /// **'This app provides offline-first disaster response guidance with source citations.'**
  String get appDescription;

  /// No description provided for @features.
  ///
  /// In en, this message translates to:
  /// **'Features:'**
  String get features;

  /// No description provided for @firstAidGuidance.
  ///
  /// In en, this message translates to:
  /// **'• First Aid guidance'**
  String get firstAidGuidance;

  /// No description provided for @survivalSkillsFeature.
  ///
  /// In en, this message translates to:
  /// **'• Survival skills'**
  String get survivalSkillsFeature;

  /// No description provided for @emergencyCommsFeature.
  ///
  /// In en, this message translates to:
  /// **'• Emergency communications'**
  String get emergencyCommsFeature;

  /// No description provided for @offlineOperation.
  ///
  /// In en, this message translates to:
  /// **'• Offline operation'**
  String get offlineOperation;

  /// No description provided for @sourceCitations.
  ///
  /// In en, this message translates to:
  /// **'• Source citations'**
  String get sourceCitations;

  /// No description provided for @emergencyWarning.
  ///
  /// In en, this message translates to:
  /// **'🚨 Emergency'**
  String get emergencyWarning;

  /// No description provided for @emergencyDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'This is for guidance only. In a real emergency, call your local emergency services immediately.'**
  String get emergencyDisclaimer;

  /// No description provided for @emergencyChecklist.
  ///
  /// In en, this message translates to:
  /// **'Emergency Checklist'**
  String get emergencyChecklist;

  /// No description provided for @allCategories.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allCategories;

  /// No description provided for @homePreparation.
  ///
  /// In en, this message translates to:
  /// **'Home Preparation'**
  String get homePreparation;

  /// No description provided for @emergencyKit.
  ///
  /// In en, this message translates to:
  /// **'Emergency Kit'**
  String get emergencyKit;

  /// No description provided for @communicationPlan.
  ///
  /// In en, this message translates to:
  /// **'Communication Plan'**
  String get communicationPlan;

  /// No description provided for @importantDocuments.
  ///
  /// In en, this message translates to:
  /// **'Important Documents'**
  String get importantDocuments;

  /// No description provided for @vehiclePreparation.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Preparation'**
  String get vehiclePreparation;

  /// No description provided for @familySafety.
  ///
  /// In en, this message translates to:
  /// **'Family Safety'**
  String get familySafety;

  /// No description provided for @createEmergencyPlan.
  ///
  /// In en, this message translates to:
  /// **'Create Emergency Plan'**
  String get createEmergencyPlan;

  /// No description provided for @createEmergencyPlanDesc.
  ///
  /// In en, this message translates to:
  /// **'Develop a family emergency plan with meeting points and contact information'**
  String get createEmergencyPlanDesc;

  /// No description provided for @identifySafeRooms.
  ///
  /// In en, this message translates to:
  /// **'Identify Safe Rooms'**
  String get identifySafeRooms;

  /// No description provided for @identifySafeRoomsDesc.
  ///
  /// In en, this message translates to:
  /// **'Locate the safest rooms in your home for different emergency types'**
  String get identifySafeRoomsDesc;

  /// No description provided for @installSmokeDetectors.
  ///
  /// In en, this message translates to:
  /// **'Install Smoke Detectors'**
  String get installSmokeDetectors;

  /// No description provided for @installSmokeDetectorsDesc.
  ///
  /// In en, this message translates to:
  /// **'Ensure smoke detectors are installed and batteries are fresh'**
  String get installSmokeDetectorsDesc;

  /// No description provided for @waterSupply.
  ///
  /// In en, this message translates to:
  /// **'Water Supply (1 gallon per person per day)'**
  String get waterSupply;

  /// No description provided for @waterSupplyDesc.
  ///
  /// In en, this message translates to:
  /// **'Store at least 3 days worth of water for each family member'**
  String get waterSupplyDesc;

  /// No description provided for @nonPerishableFood.
  ///
  /// In en, this message translates to:
  /// **'Non-perishable Food'**
  String get nonPerishableFood;

  /// No description provided for @nonPerishableFoodDesc.
  ///
  /// In en, this message translates to:
  /// **'Stock 3+ days of non-perishable food for each family member'**
  String get nonPerishableFoodDesc;

  /// No description provided for @firstAidKit.
  ///
  /// In en, this message translates to:
  /// **'First Aid Kit'**
  String get firstAidKit;

  /// No description provided for @firstAidKitDesc.
  ///
  /// In en, this message translates to:
  /// **'Assemble comprehensive first aid kit with medications'**
  String get firstAidKitDesc;

  /// No description provided for @flashlightsBatteries.
  ///
  /// In en, this message translates to:
  /// **'Flashlights and Batteries'**
  String get flashlightsBatteries;

  /// No description provided for @flashlightsBatteriesDesc.
  ///
  /// In en, this message translates to:
  /// **'Multiple flashlights with extra batteries for each family member'**
  String get flashlightsBatteriesDesc;

  /// No description provided for @emergencyPreparednessChecklist.
  ///
  /// In en, this message translates to:
  /// **'Emergency Preparedness Checklist'**
  String get emergencyPreparednessChecklist;

  /// No description provided for @completeTasksPrepare.
  ///
  /// In en, this message translates to:
  /// **'Complete these tasks to prepare for emergencies'**
  String get completeTasksPrepare;

  /// No description provided for @overallProgress.
  ///
  /// In en, this message translates to:
  /// **'Overall Progress'**
  String get overallProgress;

  /// No description provided for @percentComplete.
  ///
  /// In en, this message translates to:
  /// **'% Complete'**
  String get percentComplete;

  /// No description provided for @highPriority.
  ///
  /// In en, this message translates to:
  /// **'High Priority'**
  String get highPriority;

  /// No description provided for @mediumPriority.
  ///
  /// In en, this message translates to:
  /// **'Medium Priority'**
  String get mediumPriority;

  /// No description provided for @lowPriority.
  ///
  /// In en, this message translates to:
  /// **'Low Priority'**
  String get lowPriority;

  /// No description provided for @normal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get normal;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @goBack.
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get goBack;
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
      <String>['en', 'es', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
