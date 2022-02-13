
import 'package:flutterassement/data_model/country_model.dart';
import 'package:flutterassement/provider/country_controller_provider.dart';
import 'package:flutterassement/pages/search_country.dart';
import 'package:flutterassement/widgets/countiest_list_vew.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CountryLandingScreen extends StatefulWidget {
  const CountryLandingScreen({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _CountryLandingScreenState createState() => _CountryLandingScreenState();
}

class _CountryLandingScreenState extends State<CountryLandingScreen> {
  late CountryControllerProvider countryProvider;
  final List<Countries> _filterCountries = [];
  String? lanName;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      await countryProvider.getCountryName();
      await countryProvider.getLanguages();
    });
  }

  @override
  void dispose() {
    countryProvider.countries!.clear();
    countryProvider.languages.clear();
    _filterCountries.clear();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    countryProvider = Provider.of<CountryControllerProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
        actions: [
          IconButton(
            onPressed: () {
              Route route = MaterialPageRoute(builder: (_) => const CountrySearch());
              Navigator.push(context, route);
            },
            icon:const Icon(Icons.search),
          ),
          _filterCountries.isEmpty
              ? IconButton(
                  onPressed: () {
                    showBottomSheet();
                  },
                  icon:const Icon(Icons.filter_alt_outlined),
                )
              : IconButton(
                  onPressed: () {
                    _filterCountries.clear();
                    countryProvider.refreshScreen();
                  },
                  icon:const Icon(Icons.close),
                ),
        ],
      ),
      body: countryProvider.countries!.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : _filterCountries.isEmpty
          ? CountriesListView(countryList:countryProvider.countries! ,)
          : CountriesListView(countryList: _filterCountries,languageName: lanName,),
    );
  }


  showBottomSheet() {
    showDialog(context: context, builder: (context)=>Material(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text("Select Language to filter",style: TextStyle(fontWeight: FontWeight.bold),),
            Expanded(
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: countryProvider.languages.length,
                  itemBuilder: (context, index) {
                    final name = countryProvider.languages[index].name!;
                    return ListTile(
                      onTap: () {
                        lanName  = name;
                        filter(name);
                        countryProvider.refreshScreen();
                        Navigator.of(context).pop();
                      },
                      title: Text(name),);
                  }),
            ),
            const SizedBox(
              height: 16,
            ),
            InkWell(
              onTap: (){
                Navigator.of(context).pop();
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                height: 50,
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.red
                ),
                child:const Center(child:  Text('Cancel',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)) ,
              ),
            ),
          ],
        ),
      ),
    ));
  }

  void filter(languageName) {
    List<Countries> _tempCountries = [];
    _tempCountries.addAll(countryProvider.countries!);
    for (var v in _tempCountries) {
      for (var l in v.languages!) {
        if (l.name!
            .toLowerCase()
            .contains(languageName.toLowerCase())) {
          _filterCountries.add(v);
        }
      }
    }
  }
}
