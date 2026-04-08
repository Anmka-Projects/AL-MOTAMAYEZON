import 'package:dio/dio.dart';
import 'package:elmotamizon/common/resources/language_manager.dart';
import 'package:elmotamizon/common/resources/strings_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'imports.dart';


const String langKey = 'lang_key';
const String prefsKeyOnBoardingScreenViewed = "PREFS_KEY_ON_BOARDING_SCREEN_VIEWED";
const String prefsKeySaveToken = "PREFS_KEY_SAVE_TOKEN";
const String prefsKeySaveUserType = "PREFS_KEY_SAVE_UserType";
const String prefsKeySaveUserName = "PREFS_KEY_SAVE_Name";
const String prefsKeySaveStudentCode = "PREFS_KEY_SAVE_StudentCode";
const String prefsKeySaveUserImage = "PREFS_KEY_SAVE_UserImage";
const String prefsKeySaveUserIsAppleReview = "prefsKeySaveUserIsAppleReview";
const String userId = "userId";



class AppPreferences {

  final SharedPreferences _sharedPreferences;

  AppPreferences(this._sharedPreferences);

  String getAppLanguage() {
    String? language = _sharedPreferences.getString(langKey);
    if(language!=null && language.isNotEmpty)
    {
      return language;
    }
    else
    {
      return LanguageType.ARABIC.getValue();
    }
  }

  Future<void> changeAppLanguage() async {
    String currentLanguage = getAppLanguage();
    if(currentLanguage == LanguageType.ENGLISH.getValue()){
      _sharedPreferences.setString(langKey, LanguageType.ARABIC.getValue());
    }else{
      _sharedPreferences.setString(langKey, LanguageType.ENGLISH.getValue());
    }
    instance<Dio>().options.headers["Accept-Language"] = getAppLanguage();
  }

  Future<Locale> getLocale() async {
    String currentLanguage = getAppLanguage();
    if(currentLanguage == LanguageType.ENGLISH.getValue()){
      return ENGLISH_LOCALE;
    }else{
      return ARABIC_LOCALE;
    }
  }

  Future<void> setOnBoardingScreenViewed() async {
    _sharedPreferences.setBool(prefsKeyOnBoardingScreenViewed, true);
  }

  bool isOnBoardingScreenViewed() {
    return _sharedPreferences.getBool(prefsKeyOnBoardingScreenViewed) ?? false;
  }

  Future<void> saveToken(String token) async {
    await _sharedPreferences.setString(prefsKeySaveToken, token);
  }

  String getToken() {
    return _sharedPreferences.getString(prefsKeySaveToken)??'';
  }

  Future<void> saveUserType(String type) async {
    await _sharedPreferences.setString(prefsKeySaveUserType, type);
  }

  String getUserType() {
    return _sharedPreferences.getString(prefsKeySaveUserType)??'';
  }

  Future<void> saveUserName(String name) async {
    await _sharedPreferences.setString(prefsKeySaveUserName, name);
  }

  String getUserName() {
    return _sharedPreferences.getString(prefsKeySaveUserName)??AppStrings.guest.tr();
  }

  Future<void> saveStudentCode(String name) async {
    await _sharedPreferences.setString(prefsKeySaveStudentCode, name);
  }

  String getStudentCode() {
    return _sharedPreferences.getString(prefsKeySaveStudentCode)??'';
  }

  Future<void> saveUserImage(String? name) async {
   if(name != null) await _sharedPreferences.setString(prefsKeySaveUserImage, name);
  }

  String? getUserImage() {
    return _sharedPreferences.getString(prefsKeySaveUserImage);
  }

  Future<void> saveUserIsAppleReview(int isAppleReview) async {
    await _sharedPreferences.setInt(prefsKeySaveUserIsAppleReview, isAppleReview);
  }

  int getUserIsAppleReview() {
    return _sharedPreferences.getInt(prefsKeySaveUserIsAppleReview)??0;
  }

  Future<void> saveUserId(int id) async {
    await _sharedPreferences.setInt(userId, id);
  }

  int getUserId() {
    return _sharedPreferences.getInt(userId)??0;
  }

   Future<void> logout() async {
    await Future.wait([
      _sharedPreferences.remove(prefsKeySaveToken),
      _sharedPreferences.remove(prefsKeySaveUserType),
      _sharedPreferences.remove(prefsKeySaveUserName),
      _sharedPreferences.remove(prefsKeySaveStudentCode),
      _sharedPreferences.remove(prefsKeySaveUserImage),
      _sharedPreferences.remove(prefsKeySaveUserIsAppleReview),
      _sharedPreferences.remove(userId),
    ]);
  }

}
