import 'package:flutter/material.dart';
import 'package:flutter_web3/flutter_web3.dart';

class MetamaskProvider extends ChangeNotifier {
  static const operatingChain = 97;
  String currentAddress = '';
  int currentChain = -1;
  bool get isEnable => ethereum != null;
  bool get isInOperatingChain => currentChain == operatingChain;
  bool get isConnected => isEnable && currentAddress.isNotEmpty;

  Future<void> connect() async {
    if (isEnable) {
      final accs = await ethereum!.requestAccount();
      if (accs.isNotEmpty) currentAddress = accs.first;
      currentChain = await ethereum!.getChainId();
      if (currentChain != operatingChain) {
        await switchChain();
      }
      notifyListeners();
    }
  }

  Future<void> switchChain() async {
    await ethereum!.walletSwitchChain(operatingChain);
    notifyListeners();
  }

  reset() {
    currentAddress = '';
    currentChain = -1;
    notifyListeners();
  }

  start() {
    if (isEnable) {
      ethereum!.onAccountsChanged((accounts) {
        reset();
      });
      ethereum!.onChainChanged((chainId) {
        reset();
      });
    }
  }
}
