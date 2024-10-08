import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_innovations/network/network_state.dart';

class NetworkProvider extends StateNotifier<NetworkState> {
  NetworkProvider() : super(const NetworkInitial());

  StreamSubscription<ConnectivityResult>? subscription;

  void disposeState() {
    subscription?.cancel();
    state = const NetworkInitial();
  }

  void subscribe() {
    subscription = Connectivity().onConnectivityChanged.listen((result) {
      final connectivityResult = result.isNotEmpty ? result.first : null;
      if (connectivityResult != null) {
        state = state.copyWith(connectivityResult: connectivityResult);
      }
    }) as StreamSubscription<ConnectivityResult>?;
  }
}
