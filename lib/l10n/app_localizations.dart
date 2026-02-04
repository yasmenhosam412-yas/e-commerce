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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
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

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Shop with Ease'**
  String get onboardingTitle1;

  /// No description provided for @onboardingSubtitle1.
  ///
  /// In en, this message translates to:
  /// **'Your favorite products in one tap'**
  String get onboardingSubtitle1;

  /// No description provided for @onboardingDescription1.
  ///
  /// In en, this message translates to:
  /// **'Discover thousands of products and exclusive deals, and get everything you need quickly and easily.'**
  String get onboardingDescription1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Stay Updated'**
  String get onboardingTitle2;

  /// No description provided for @onboardingSubtitle2.
  ///
  /// In en, this message translates to:
  /// **'Exclusive offers and discounts'**
  String get onboardingSubtitle2;

  /// No description provided for @onboardingDescription2.
  ///
  /// In en, this message translates to:
  /// **'Follow the latest deals and discounts on your favorite products so you never miss a great offer.'**
  String get onboardingDescription2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Shop with Confidence'**
  String get onboardingTitle3;

  /// No description provided for @onboardingSubtitle3.
  ///
  /// In en, this message translates to:
  /// **'A seamless shopping experience'**
  String get onboardingSubtitle3;

  /// No description provided for @onboardingDescription3.
  ///
  /// In en, this message translates to:
  /// **'Enjoy a secure shopping experience, multiple payment options, and fast delivery right to your door.'**
  String get onboardingDescription3;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @authLogin.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get authLogin;

  /// No description provided for @authSignup.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get authSignup;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @enterName.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get enterName;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get nameRequired;

  /// No description provided for @nameMinChars.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid name with more than 3 chars'**
  String get nameMinChars;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'example@email.com'**
  String get enterEmail;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailRequired;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get emailInvalid;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'••••••••'**
  String get enterPassword;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// No description provided for @passwordMin.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMin;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address below to receive password reset instructions.'**
  String get forgotPasswordDescription;

  /// No description provided for @sendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get sendResetLink;

  /// No description provided for @orContinueWith.
  ///
  /// In en, this message translates to:
  /// **'Or continue with'**
  String get orContinueWith;

  /// No description provided for @currentStreak.
  ///
  /// In en, this message translates to:
  /// **'Current Streak'**
  String get currentStreak;

  /// No description provided for @keepGoing.
  ///
  /// In en, this message translates to:
  /// **'Keep going! You\'re doing great'**
  String get keepGoing;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get days;

  /// No description provided for @communityPoll.
  ///
  /// In en, this message translates to:
  /// **'Community Poll'**
  String get communityPoll;

  /// No description provided for @communityPolls.
  ///
  /// In en, this message translates to:
  /// **'Community Polls'**
  String get communityPolls;

  /// No description provided for @dailyQuests.
  ///
  /// In en, this message translates to:
  /// **'Daily Quests'**
  String get dailyQuests;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @activities.
  ///
  /// In en, this message translates to:
  /// **'Activities'**
  String get activities;

  /// No description provided for @exploreAll.
  ///
  /// In en, this message translates to:
  /// **'Explore All'**
  String get exploreAll;

  /// No description provided for @challenges.
  ///
  /// In en, this message translates to:
  /// **'Challenges'**
  String get challenges;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @buyer.
  ///
  /// In en, this message translates to:
  /// **'Buyer'**
  String get buyer;

  /// No description provided for @seller.
  ///
  /// In en, this message translates to:
  /// **'Seller'**
  String get seller;

  /// No description provided for @businessName.
  ///
  /// In en, this message translates to:
  /// **'Store Name'**
  String get businessName;

  /// No description provided for @enterBusinessName.
  ///
  /// In en, this message translates to:
  /// **'Enter store name'**
  String get enterBusinessName;

  /// No description provided for @requiredBusiness.
  ///
  /// In en, this message translates to:
  /// **'Store Name is required'**
  String get requiredBusiness;

  /// No description provided for @as.
  ///
  /// In en, this message translates to:
  /// **'As'**
  String get as;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No account data found. Please sign up to continue.'**
  String get noData;

  /// No description provided for @failed.
  ///
  /// In en, this message translates to:
  /// **'Login failed. Please try again.'**
  String get failed;

  /// No description provided for @noInternet.
  ///
  /// In en, this message translates to:
  /// **'Network error. Please check your internet connection.'**
  String get noInternet;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get somethingWentWrong;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading ...'**
  String get loading;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome !!'**
  String get welcome;

  /// No description provided for @sentResetLink.
  ///
  /// In en, this message translates to:
  /// **'Password reset link sent to this email'**
  String get sentResetLink;

  /// No description provided for @neww.
  ///
  /// In en, this message translates to:
  /// **'New Store'**
  String get neww;

  /// No description provided for @discount.
  ///
  /// In en, this message translates to:
  /// **'Special Offer'**
  String get discount;

  /// No description provided for @bestSeller.
  ///
  /// In en, this message translates to:
  /// **'Most Requested'**
  String get bestSeller;

  /// No description provided for @shops.
  ///
  /// In en, this message translates to:
  /// **'Shops'**
  String get shops;

  /// No description provided for @samples.
  ///
  /// In en, this message translates to:
  /// **'Featured Picks'**
  String get samples;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'EGP'**
  String get currency;

  /// No description provided for @reviews.
  ///
  /// In en, this message translates to:
  /// **'reviews'**
  String get reviews;

  /// No description provided for @usersWantToSell.
  ///
  /// In en, this message translates to:
  /// **'Users want to sell this'**
  String get usersWantToSell;

  /// No description provided for @userBalance.
  ///
  /// In en, this message translates to:
  /// **'Based on budget'**
  String get userBalance;

  /// No description provided for @myCart.
  ///
  /// In en, this message translates to:
  /// **'My Cart'**
  String get myCart;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @checkout.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkout;

  /// No description provided for @fees.
  ///
  /// In en, this message translates to:
  /// **'Fees'**
  String get fees;

  /// No description provided for @subtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// No description provided for @totalCart.
  ///
  /// In en, this message translates to:
  /// **'All cart items total'**
  String get totalCart;

  /// No description provided for @favs.
  ///
  /// In en, this message translates to:
  /// **'Favourites'**
  String get favs;

  /// No description provided for @users.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get users;

  /// No description provided for @userCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'User created successfully'**
  String get userCreatedSuccessfully;

  /// No description provided for @userAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'User already exists. Signup aborted.'**
  String get userAlreadyExists;

  /// No description provided for @userDoesNotExist.
  ///
  /// In en, this message translates to:
  /// **'User does not exist'**
  String get userDoesNotExist;

  /// No description provided for @loginSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Login successful'**
  String get loginSuccessful;

  /// No description provided for @createStore.
  ///
  /// In en, this message translates to:
  /// **'Create Store'**
  String get createStore;

  /// No description provided for @title1.
  ///
  /// In en, this message translates to:
  /// **'Store Information'**
  String get title1;

  /// No description provided for @description1.
  ///
  /// In en, this message translates to:
  /// **'Enter the store name, description, and add the logo and cover image.'**
  String get description1;

  /// No description provided for @title2.
  ///
  /// In en, this message translates to:
  /// **'Business Details'**
  String get title2;

  /// No description provided for @description2.
  ///
  /// In en, this message translates to:
  /// **'Select the business type, country, currency, and basic legal information.'**
  String get description2;

  /// No description provided for @title3.
  ///
  /// In en, this message translates to:
  /// **'Fees & Delivery Price'**
  String get title3;

  /// No description provided for @description3.
  ///
  /// In en, this message translates to:
  /// **'Set up available payment methods and shipping and delivery options.'**
  String get description3;

  /// No description provided for @title4.
  ///
  /// In en, this message translates to:
  /// **'Review & Publish'**
  String get title4;

  /// No description provided for @description4.
  ///
  /// In en, this message translates to:
  /// **'Review all store details and make sure everything is correct before publishing.'**
  String get description4;

  /// No description provided for @storeName.
  ///
  /// In en, this message translates to:
  /// **'Store Name'**
  String get storeName;

  /// No description provided for @storeDesc.
  ///
  /// In en, this message translates to:
  /// **'Store Description'**
  String get storeDesc;

  /// No description provided for @storeCategory.
  ///
  /// In en, this message translates to:
  /// **'Store Category'**
  String get storeCategory;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @deliveryPrice.
  ///
  /// In en, this message translates to:
  /// **'Delivery Price'**
  String get deliveryPrice;

  /// No description provided for @publish.
  ///
  /// In en, this message translates to:
  /// **'Publish'**
  String get publish;

  /// No description provided for @storeCreated.
  ///
  /// In en, this message translates to:
  /// **'Store Created Successfully'**
  String get storeCreated;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get requiredField;

  /// No description provided for @imageRequired.
  ///
  /// In en, this message translates to:
  /// **'Store logo is required'**
  String get imageRequired;

  /// No description provided for @addProduct.
  ///
  /// In en, this message translates to:
  /// **'Add Product'**
  String get addProduct;

  /// No description provided for @addCollection.
  ///
  /// In en, this message translates to:
  /// **'Add Collection'**
  String get addCollection;

  /// No description provided for @viewProducts.
  ///
  /// In en, this message translates to:
  /// **'Manage Products'**
  String get viewProducts;

  /// No description provided for @addAds.
  ///
  /// In en, this message translates to:
  /// **'Create Ad'**
  String get addAds;

  /// No description provided for @addDiscount.
  ///
  /// In en, this message translates to:
  /// **'Add Discount'**
  String get addDiscount;

  /// No description provided for @addCoupon.
  ///
  /// In en, this message translates to:
  /// **'Add Coupon'**
  String get addCoupon;

  /// No description provided for @addProductImage.
  ///
  /// In en, this message translates to:
  /// **'Add Product Image'**
  String get addProductImage;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @productName.
  ///
  /// In en, this message translates to:
  /// **'Product Name'**
  String get productName;

  /// No description provided for @productDescription.
  ///
  /// In en, this message translates to:
  /// **'Product Description'**
  String get productDescription;

  /// No description provided for @productPrice.
  ///
  /// In en, this message translates to:
  /// **'Product Price'**
  String get productPrice;

  /// No description provided for @productCategory.
  ///
  /// In en, this message translates to:
  /// **'Product Category'**
  String get productCategory;

  /// No description provided for @productQuantity.
  ///
  /// In en, this message translates to:
  /// **'Product Quantity'**
  String get productQuantity;

  /// No description provided for @addButton.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get addButton;

  /// No description provided for @productAdded.
  ///
  /// In en, this message translates to:
  /// **'Product Added Successfully'**
  String get productAdded;

  /// No description provided for @enterAllData.
  ///
  /// In en, this message translates to:
  /// **'Please enter all data'**
  String get enterAllData;

  /// No description provided for @productSizes.
  ///
  /// In en, this message translates to:
  /// **'Sizes'**
  String get productSizes;

  /// No description provided for @enterSize.
  ///
  /// In en, this message translates to:
  /// **'Enter size'**
  String get enterSize;

  /// No description provided for @added.
  ///
  /// In en, this message translates to:
  /// **'Added Successfully'**
  String get added;

  /// No description provided for @collectionName.
  ///
  /// In en, this message translates to:
  /// **'Collection Name'**
  String get collectionName;

  /// No description provided for @collectionDesc.
  ///
  /// In en, this message translates to:
  /// **'Collection Description (Optional)'**
  String get collectionDesc;

  /// No description provided for @discountName.
  ///
  /// In en, this message translates to:
  /// **'Discount Name'**
  String get discountName;

  /// No description provided for @enterDiscountName.
  ///
  /// In en, this message translates to:
  /// **'Enter discount name'**
  String get enterDiscountName;

  /// No description provided for @discountValue.
  ///
  /// In en, this message translates to:
  /// **'Discount Value (%)'**
  String get discountValue;

  /// No description provided for @enterDiscountValue.
  ///
  /// In en, this message translates to:
  /// **'Enter discount value'**
  String get enterDiscountValue;

  /// No description provided for @invalidDiscountValue.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid percentage (1 - 100)'**
  String get invalidDiscountValue;

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get startDate;

  /// No description provided for @selectStartDate.
  ///
  /// In en, this message translates to:
  /// **'Select start date'**
  String get selectStartDate;

  /// No description provided for @endDate.
  ///
  /// In en, this message translates to:
  /// **'End Date'**
  String get endDate;

  /// No description provided for @selectEndDate.
  ///
  /// In en, this message translates to:
  /// **'Select end date'**
  String get selectEndDate;

  /// No description provided for @discountAddedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Discount added successfully'**
  String get discountAddedSuccess;

  /// No description provided for @featured.
  ///
  /// In en, this message translates to:
  /// **'Featured'**
  String get featured;

  /// No description provided for @max_featured_products.
  ///
  /// In en, this message translates to:
  /// **'You can select up to 3 featured products'**
  String get max_featured_products;

  /// No description provided for @products_saved_success.
  ///
  /// In en, this message translates to:
  /// **'Products saved successfully!'**
  String get products_saved_success;

  /// No description provided for @filters_title.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filters_title;

  /// No description provided for @search_placeholder.
  ///
  /// In en, this message translates to:
  /// **'Search products...'**
  String get search_placeholder;

  /// No description provided for @discount_label.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get discount_label;

  /// No description provided for @all_label.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all_label;

  /// No description provided for @collection_label.
  ///
  /// In en, this message translates to:
  /// **'Collection'**
  String get collection_label;

  /// No description provided for @show_featured_only.
  ///
  /// In en, this message translates to:
  /// **'Show Featured Only'**
  String get show_featured_only;

  /// No description provided for @nothing.
  ///
  /// In en, this message translates to:
  /// **'No Products'**
  String get nothing;

  /// No description provided for @selectImage.
  ///
  /// In en, this message translates to:
  /// **'Please select an image.'**
  String get selectImage;

  /// No description provided for @enterBadge.
  ///
  /// In en, this message translates to:
  /// **'Please enter badge text.'**
  String get enterBadge;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Ads saved successfully.'**
  String get saved;

  /// No description provided for @couponCode.
  ///
  /// In en, this message translates to:
  /// **'Coupon Code'**
  String get couponCode;

  /// No description provided for @enterCouponCode.
  ///
  /// In en, this message translates to:
  /// **'Please enter the coupon code'**
  String get enterCouponCode;

  /// No description provided for @discountType.
  ///
  /// In en, this message translates to:
  /// **'Discount Type'**
  String get discountType;

  /// No description provided for @percentage.
  ///
  /// In en, this message translates to:
  /// **'Percentage'**
  String get percentage;

  /// No description provided for @fixedAmount.
  ///
  /// In en, this message translates to:
  /// **'Fixed Amount'**
  String get fixedAmount;

  /// No description provided for @discountPercentage.
  ///
  /// In en, this message translates to:
  /// **'Discount %'**
  String get discountPercentage;

  /// No description provided for @discountAmount.
  ///
  /// In en, this message translates to:
  /// **'Discount Amount'**
  String get discountAmount;

  /// No description provided for @selectExpiryDate.
  ///
  /// In en, this message translates to:
  /// **'Select expiry date'**
  String get selectExpiryDate;

  /// No description provided for @expiryDate.
  ///
  /// In en, this message translates to:
  /// **'Expiry date'**
  String get expiryDate;

  /// No description provided for @saveCoupon.
  ///
  /// In en, this message translates to:
  /// **'Save Coupon'**
  String get saveCoupon;

  /// No description provided for @couponSaved.
  ///
  /// In en, this message translates to:
  /// **'Coupon saved successfully'**
  String get couponSaved;

  /// No description provided for @selectExpiryDateError.
  ///
  /// In en, this message translates to:
  /// **'Please select an expiry date'**
  String get selectExpiryDateError;

  /// No description provided for @editing.
  ///
  /// In en, this message translates to:
  /// **'Editing'**
  String get editing;

  /// No description provided for @products.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get products;

  /// No description provided for @ads.
  ///
  /// In en, this message translates to:
  /// **'Ads'**
  String get ads;

  /// No description provided for @discounts.
  ///
  /// In en, this message translates to:
  /// **'Discounts'**
  String get discounts;

  /// No description provided for @coupons.
  ///
  /// In en, this message translates to:
  /// **'Coupons'**
  String get coupons;

  /// No description provided for @collections.
  ///
  /// In en, this message translates to:
  /// **'Collections'**
  String get collections;

  /// No description provided for @options.
  ///
  /// In en, this message translates to:
  /// **'Edit Options'**
  String get options;

  /// No description provided for @editProduct.
  ///
  /// In en, this message translates to:
  /// **'Edit Product'**
  String get editProduct;

  /// No description provided for @productUpdated.
  ///
  /// In en, this message translates to:
  /// **'Product updated successfully'**
  String get productUpdated;

  /// No description provided for @deleteProduct.
  ///
  /// In en, this message translates to:
  /// **'Delete Product'**
  String get deleteProduct;

  /// No description provided for @deleteConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete?'**
  String get deleteConfirmation;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @noAnyData.
  ///
  /// In en, this message translates to:
  /// **'No Data Yet'**
  String get noAnyData;

  /// No description provided for @editCollection.
  ///
  /// In en, this message translates to:
  /// **'Edit Collection'**
  String get editCollection;

  /// No description provided for @collectionUpdated.
  ///
  /// In en, this message translates to:
  /// **'Collection updated successfully'**
  String get collectionUpdated;

  /// No description provided for @storeInfo.
  ///
  /// In en, this message translates to:
  /// **'About Store'**
  String get storeInfo;

  /// No description provided for @off.
  ///
  /// In en, this message translates to:
  /// **'OFF'**
  String get off;

  /// No description provided for @item.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get item;

  /// No description provided for @addToCart.
  ///
  /// In en, this message translates to:
  /// **'Add to cart'**
  String get addToCart;

  /// No description provided for @addedToCart.
  ///
  /// In en, this message translates to:
  /// **'Added to cart'**
  String get addedToCart;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
