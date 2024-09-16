import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'coin_data.dart';

class PriceScreen extends StatefulWidget {
  const PriceScreen({super.key});

  @override
  State<PriceScreen> createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD'; // Store the selected currency
  Map<String, String> cryptoPrices = {}; // Store the prices for each crypto
  String errorMessage = ''; // Variable to hold error messages

  // Fetch data for the selected currency
  void getData(String currency) async {
    try {
      var data = await CoinData().getCoinData(currency);
      setState(() {
        cryptoPrices = data;
        errorMessage = ''; // Clear any previous error messages
      });
    } catch (e) {
      if (e.toString().contains('429')) { // Check if the error is related to rate limiting
        setState(() {
          errorMessage = 'Too many requests. Please try again later.';
        });
      } else {
        setState(() {
          errorMessage = 'An error occurred. Please try again.';
        });
      }
    }
  }

  // Function to get the DropdownButton
  DropdownButton<String> getDropdownButton() {
    List<DropdownMenuItem<String>> menuItemList = currenciesList
        .map((currency) =>
        DropdownMenuItem(value: currency, child: Text(currency)))
        .toList();

    return DropdownButton<String>(
      value: selectedCurrency,
      items: menuItemList,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value!;
          getData(selectedCurrency); // Fetch data when selection changes
        });
      },
    );
  }

  CupertinoPicker getCupertinoPicker() {
    List<Text> pickerItems = [];
    for (String currency in currenciesList) {
      pickerItems.add(Text(currency));
    }
    return CupertinoPicker(
      backgroundColor: Colors.blueGrey,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
          getData(selectedCurrency); // Fetch data when selection changes
        });
      },
      children: pickerItems,
    );
  }

  Widget getPicker() {
    if (Platform.isIOS) {
      return getCupertinoPicker();
    } else {
      return getDropdownButton();
    }
  }

  @override
  void initState() {
    super.initState();
    getData(selectedCurrency); // Initial data fetch
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CryptoPulse'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 30,
        ),
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: ListView(
              children: cryptoPrices.entries.map(
                    (entry) {
                  // Display each cryptocurrency price
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Card(
                      color: Colors.blueGrey,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 28),
                        child: Text(
                          '1 ${entry.key} = ${entry.value} $selectedCurrency',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ).toList(),
            ),
          ),
          Container(
            height: 125,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 30),
            color: Colors.blueGrey,
            child: getCupertinoPicker(), // Dynamic picker for iOS/Android
          ),
        ],
      ),
    );
  }
}
