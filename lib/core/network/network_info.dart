import 'package:connectivity_plus/connectivity_plus.dart';
import '../helpers/logging_service.dart';

class NetworkInfo {
  final Connectivity connectivity;

  NetworkInfo(this.connectivity);

  Future<bool> get isConnected async {
    final result = await connectivity.checkConnectivity();
    final isConnected = !result.contains(ConnectivityResult.none);
    
    LoggingServicePrinter.log(
      isConnected ? '🌐 Network: Connected' : '📵 Network: Disconnected',
    );
    
    return isConnected;
  }

  Stream<bool> get onConnectivityChanged {
    return connectivity.onConnectivityChanged.map((results) {
      final isConnected = !results.contains(ConnectivityResult.none);
      LoggingServicePrinter.log(
        isConnected ? '🌐 Network: Connected' : '📵 Network: Disconnected',
      );
      return isConnected;
    });
  }
}
