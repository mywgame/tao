import 'dart:convert';
import 'package:http/http.dart' as http;

class TAOPriceService {
  // CoinGecko की सिंपल और फ्री API का इस्तेमाल कर रहे हैं भाई
  static const String _apiUrl = 
      "https://api.coingecko.com/api/v3/simple/price?ids=bittensor&vs_currencies=usd";

  /// लाइव TAO प्राइस USD में लाकर देगा
  static Future<double> fetchLiveTAOPrice() async {
    try {
      final response = await http.get(Uri.parse(_apiUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // API से bittensor -> usd का भाव निकाला
        double price = (data['bittensor']['usd'] as num).toDouble();
        return price;
      } else {
        throw Exception("Failed to load TAO price");
      }
    } catch (e) {
      // अगर नेट बंद हो या API फेल हो जाए, तो एक सेफ डिफॉल्ट प्राइस ($350) भेज देंगे
      print("Error fetching TAO price: $e");
      return 350.0; 
    }
  }
}