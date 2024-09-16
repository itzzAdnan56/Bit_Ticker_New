
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

const coinAPIURL = 'https://rest.coinapi.io/v1/exchangerate';
const apiKey = '7CA4D311-D3A0-4BE7-A8E4-4C59D7DA733E';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'BRL'
      'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR',
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
  'DOGE',
  'XRP',
  'BCH',
  'ADA',
  'DOT',
  'LINK',
  'BNB',
  'USDT',
  'XLM',

];

class CoinData {
  Future getCoinData(String selectedCurrency) async {
    Map<String, String> cryptoPrices = {};
    for (String crypto in cryptoList) {
      String requestURL =
          '$coinAPIURL/$crypto/$selectedCurrency?apikey=$apiKey';
      http.Response response = await http.get(Uri.parse(requestURL));
      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body);
        double lastPrice = decodedData['rate'];
        cryptoPrices[crypto] = lastPrice.toStringAsFixed(0);
      } else {
        if (kDebugMode) {
          print(response.statusCode);
        }
        throw 'Problem with the get request';
      }
    }
    return cryptoPrices;
  }

}