import 'package:gastos_management/event/wallet_event.dart';
import 'package:gastos_management/model/wallet.dart';

class UpdateWallet extends WalletEvent {
  Wallet newWallet;
  int walletIndex;

  UpdateWallet(int index, Wallet wallet) {
    newWallet = wallet;
    walletIndex = index;
  }
}
