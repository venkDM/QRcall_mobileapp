
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_innovations/network/network_provider.dart';

final networkProvider =
    StateNotifierProvider<NetworkProvider, NetworkState>((ref) {
  return NetworkProvider();
});

class NetworkState {
  const NetworkState({
    required this.connectivityResult,
  });

  final ConnectivityResult connectivityResult;

  NetworkState copyWith({
    ConnectivityResult? connectivityResult,
  }) =>
      NetworkState(
        connectivityResult: connectivityResult ?? this.connectivityResult,
      );
}

class NetworkInitial extends NetworkState {
  const NetworkInitial()
      : super(
          connectivityResult: ConnectivityResult.none,
        );
}
