import 'dart:convert';
import 'dart:developer';
import 'package:flutterassement/data_model/country_model.dart';
import 'package:flutterassement/services/graphql_helper.dart';
import 'package:flutter/material.dart';


class CountryControllerProvider extends ChangeNotifier {
  final GraphqlApiHelper _apiHelper = GraphqlApiHelper();
  List<Countries>? _countries = [];
  final List<Languages> _languages = [];
  Countries? _country;

  List<Countries>? get countries => _countries;
  List<Languages> get languages => _languages;

  Countries? get country => _country;

  Future refreshScreen() async {
    notifyListeners();
  }

  Future getCountryName() async {
    final result = await _apiHelper.getCountry();
    final decode = jsonDecode(result);
    final parse = Data.fromJson(decode);
    _countries = parse.countries;
    _countries!.sort((a, b) => a.name!.compareTo(b.name!));

    notifyListeners();
  }

  Future getLanguages() async {
    final result = await _apiHelper.getLanguages();
    final decode = jsonDecode(result);
    for(var l in decode) {
      languages.add(Languages.fromJson(l));
    }

    notifyListeners();
  }

  Future getCountryNameByCode(context, {String? code}) async {
    final result = await _apiHelper.getCountryByCode(context, code: code);
    if (result != null) {
      final decode = jsonDecode(result);
      if (decode['country'] == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content:Text("Country Code doesn't exists"),
          backgroundColor: Colors.red,
        ));
        return;
      }
      final parse = Countries.fromJson(decode['country']);
      log('parse :- $parse');
      _country = parse;

      notifyListeners();
      return parse.name;
    }
  }
}
