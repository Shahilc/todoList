import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  Stream<bool> get connectivityStream async* {
    await for (final result in _connectivity.onConnectivityChanged) {
      if (result == ConnectivityResult.none) {
        yield false;
      } else {
        yield await checkConnection();
      }
    }
  }

  Future<bool> checkConnection() async {
    try {
      final response = await http.get(
        Uri.parse("https://www.google.com"),
      ).timeout(const Duration(seconds: 3));

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
