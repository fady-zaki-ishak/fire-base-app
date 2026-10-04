import 'package:chat_app_firebase/core/cubit/theme_cubit.dart';
import 'package:chat_app_firebase/core/utils/style/screen_size.dart';
import 'package:chat_app_firebase/data/chat_view_model.dart';
import 'package:chat_app_firebase/features/Home/cubit/chat_cubit.dart';
import 'package:chat_app_firebase/features/Home/data/chat_model.dart';
import 'package:chat_app_firebase/features/Home/views/chat_view.dart';
import 'package:chat_app_firebase/features/Home/widgets/chat_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});
  static String routeName = 'home-view';

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int selectedIndex = 0;

  final List<String> labels = ['Chat', 'Friends', 'Calls'];
  final List<IconData> icons = [
    Icons.home,
    Icons.person_add,
    Icons.group_add,
    Icons.settings,
  ];

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    context.select((ThemeCubit cubit) => cubit.state == ThemeMode.dark);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: TextField(
          style: Theme.of(context).textTheme.bodyMedium,
          decoration: InputDecoration(
            fillColor: const Color.fromARGB(66, 158, 158, 158),
            filled: true,
            hintText: "Search chat...",
            hintStyle: const TextStyle(
              fontSize: 15,
              color: Colors.black,
              fontFamily: "Regular",
            ),
            prefixIcon: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search, color: Colors.black),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              BlocProvider.of<ThemeCubit>(context).toggleTheme();
            },
            icon: Icon(
              Icons.fullscreen,
              color: Theme.of(context).iconTheme.color,
              size: ScreenSize.height / 30,
            ),
          ),
          SizedBox(width: ScreenSize.width / 40),
        ],
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: ScreenSize.width / 30),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(labels.length, (index) {
                  final isSelected = selectedIndex == index;
                  return GestureDetector(
                    onTap: () => onItemTapped(index),
                    child: Text(
                      labels[index],
                      style: TextStyle(
                        color: isSelected ? Colors.purple : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),
              StreamBuilder(
                stream: BlocProvider.of<ChatCubit>(
                  context,
                ).getlastTimeMessages(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasData) {
                    List<ChatModel> chatList = snapshot.data!;
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: chatList.length,
                      itemBuilder: (context, index) {
                        return ChatCardWidget(
                          chatViewModel: ChatViewModel(
                            name: chatList[index].user.name,
                            message: chatList[index].lastMessage,
                            time: DateFormat.jm().format(
                              chatList[index].lastMessageTime,
                            ),
                            avatarUrl: chatList[index].user.image!,
                            unReadMessageCount: 0,
                            isOnline: true,
                          ),
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              ChatView.routeName,
                              arguments: chatList[index].user,
                            );
                          },
                        );
                      },
                    );
                  }
                  return Container();
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: onItemTapped,
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_add),
            label: '',
          ),
          const BottomNavigationBarItem(icon: Icon(Icons.settings), label: ''),
        ],
      ),
    );
  }
}
