import 'package:gastos_management/event/wallet_event.dart';

class DeleteWallet extends WalletEvent {
  int walletIndex;

  DeleteWallet(int index) {
    walletIndex = index;
  }
}
