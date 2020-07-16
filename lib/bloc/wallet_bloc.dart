import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastos_management/event/add_wallet.dart';
import 'package:gastos_management/event/clear_wallet.dart';
import 'package:gastos_management/event/delete_wallet.dart';
import 'package:gastos_management/event/set_wallet.dart';
import 'package:gastos_management/event/update_event.dart';
import 'package:gastos_management/event/wallet_event.dart';
import 'package:gastos_management/model/wallet.dart';

class WalletBloc extends Bloc<WalletEvent, List<Wallet>> {
  @override
  List<Wallet> get initialState => List<Wallet>();

  @override
  Stream<List<Wallet>> mapEventToState(WalletEvent event) async* {
    if (event is SetWallet) {
      yield event.walletList;
    } else if (event is AddWallet) {
      List<Wallet> newState = List.from(state);
      if (event.newWallet != null) {
        newState.add(event.newWallet);
      }
      yield newState;
    } else if (event is DeleteWallet) {
      List<Wallet> newState = List.from(state);
      newState.removeAt(event.walletIndex);
      yield newState;
    } else if (event is UpdateWallet) {
      List<Wallet> newState = List.from(state);
      newState[event.walletIndex] = event.newWallet;
      yield newState;
    } else if (event is ClearWallet) {
      List<Wallet> newState = List.from(state);
      newState.clear();
      yield newState;
    }
  }
}
