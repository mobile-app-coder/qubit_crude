import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qubit_crude/bloc/home_cubit.dart';

import '../bloc/home_state.dart';
import '../models/user_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeCubit cubit;
  ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of<HomeCubit>(context);
    cubit.onLoadRandomUser();
    controller.addListener(() {
      if (controller.position.maxScrollExtent <= controller.offset) {
        cubit.onLoadRandomUser();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("State management - cubit"),
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        buildWhen: (previous, current){
          return current is HomeRandomUserListState;
        },
        builder: (BuildContext context, HomeState state) {
          if (state is ErrorState) {
            return viewOfError("Hello");
          }
          if (state is HomeRandomUserListState) {
            var userList = state.userList;
            return viewOfRandomUserList(userList);
          }
          return viewOfLoading();
        },
      ),
    );
  }

  Widget viewOfError(String err) {
    return Center(
      child: Text("Error occurred $err"),
    );
  }

  Widget viewOfLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget viewOfRandomUserList(List<RandomUser> userList) {
    return ListView.builder(
      controller: controller,
      itemCount: userList.length,
      itemBuilder: (ctx, index) {
        return _itemOfUser(userList[index], index);
      },
    );
  }

  Widget _itemOfUser(RandomUser randomUser, index) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 5),
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          CachedNetworkImage(
            height: 80,
            width: 80,
            fit: BoxFit.cover,
            imageUrl: randomUser.picture.medium,
            placeholder: (context, url) => Container(
              height: 80,
              width: 80,
              color: Colors.grey,
            ),
            errorWidget: (context, url, error) => Container(
              height: 80,
              width: 80,
              color: Colors.grey,
              child: const Icon(Icons.error),
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${index} - ${randomUser.name.first} ${randomUser.name.last}",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Text(
                randomUser.email,
                style: const TextStyle(
                    fontWeight: FontWeight.normal, fontSize: 16),
              ),
              Text(
                randomUser.cell,
                style: const TextStyle(
                    fontWeight: FontWeight.normal, fontSize: 16),
              ),
            ],
          ))
        ],
      ),
    );
  }
}
