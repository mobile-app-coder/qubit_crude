import 'package:equatable/equatable.dart';

import '../models/user_model.dart';

abstract class HomeState extends  Equatable{}

class InitialState extends HomeState{
  @override
  List<Object?> get props => [];

}

class HomeLoadingState extends HomeState{
  @override
  List<Object?> get props =>  [];
}

class ErrorState extends HomeState{
  final String error_message;

  ErrorState(this.error_message);

  @override
  List<Object?> get props =>  [error_message];
}


class HomeRandomUserListState extends HomeState{
  final List<RandomUser> userList;

  HomeRandomUserListState(this.userList);

  @override
  List<Object?> get props => [userList];

}