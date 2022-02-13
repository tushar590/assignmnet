
import 'package:flutterassement/provider/country_controller_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CountrySearch extends StatefulWidget {
  const CountrySearch({Key? key}) : super(key: key);

  @override
  _CountrySearchState createState() => _CountrySearchState();
}

class _CountrySearchState extends State<CountrySearch> {
  late CountryControllerProvider _countryProviderController;
  final TextEditingController _searchTextController = TextEditingController();
  String? _countryName;
  bool isLoading  = false;

  @override
  void dispose() {
    _searchTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _countryProviderController = Provider.of<CountryControllerProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          controller: _searchTextController,
          decoration: const InputDecoration(
            hintText:  'Enter Country Code',
            hintStyle: TextStyle(color: Colors.white)
          ),
          onChanged: (text)async{
            if(text.isNotEmpty && text.length >1){
              setState(() {
                isLoading =  true;
              });
              _countryName = await (_countryProviderController.getCountryNameByCode(context,
                  code: _searchTextController.text.trim().toUpperCase()));
              setState(() {
                isLoading =  false;
              });
            }
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            isLoading?
               const Center(child: CircularProgressIndicator(),):_countryName != null ? ListTile(
    title: Text(_countryName!),
    ):const SizedBox(),
          ],
        ),
      ),
    );
  }
}
