import 'package:gastos_management/event/wallet_event.dart';
import 'package:gastos_management/model/wallet.dart';

class SetWallet extends WalletEvent {
  List<Wallet> walletList;

  SetWallet(List<Wallet> transactions) {
    walletList = transactions;
  }
}
