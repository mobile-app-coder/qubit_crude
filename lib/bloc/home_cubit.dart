import 'package:bloc/bloc.dart';
import 'package:qubit_crude/bloc/home_state.dart';
import 'package:qubit_crude/services/http_service.dart';

import '../models/user_model.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeLoadingState());

  List<RandomUser> list = [];
  int currentPage = 1;


  Future onLoadRandomUser() async {
    emit(HomeLoadingState());
    var response = await Network.GET(Network.API_RANDOM_USER_LIST,
        Network.paramsRandomUserList(currentPage));

    if (response != null) {
      var result = Network.parseRandomUserList(response).results;
      list.addAll(result);
      currentPage++;
      emit(HomeRandomUserListState(list));
    } else {
      emit(ErrorState("Could not fetch user"));
    }
  }

}
