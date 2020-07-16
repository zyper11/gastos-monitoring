import 'package:gastos_management/event/wallet_event.dart';
import 'package:gastos_management/model/wallet.dart';

class AddWallet extends WalletEvent {
  Wallet newWallet;

  AddWallet(Wallet wallet) {
    newWallet = wallet;
  }
}
