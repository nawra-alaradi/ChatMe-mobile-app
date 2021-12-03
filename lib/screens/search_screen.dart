import 'package:chat_me/components/custom_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../business_logic/models/user_model.dart';
import '../business_logic/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:chat_me/screens/chat_screen.dart';

User? loggedInUser;

class SearchScreen extends StatefulWidget {
  static const String id = 'SearchScreen';
  const SearchScreen({Key? key}) : super(key: key);
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _auth = FirebaseAuth.instance;
  List<ChatUser> chatUsers = [];
  String query = "";
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    didChangeDependencies();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    User? currentUser = Provider.of<AuthProvider>(context, listen: false).user;
    if (currentUser != null) {
      print(currentUser.email);
    }
    List<ChatUser> lst = await Provider.of<AuthProvider>(context, listen: false)
        .fetchAllUsers(currentUser!);
    setState(() {
      chatUsers = lst;
    });
  }
  //
  // void getCurrentUser() {
  //   try {
  //     final user = _auth.currentUser;
  //     if (user != null) {
  //       loggedInUser = user;
  //       print(loggedInUser!.email);
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  searchAppBar(BuildContext context) {
    return NewGradientAppBar(
      automaticallyImplyLeading: false,
      gradient: const LinearGradient(colors: [
        Color(0xff00b6f3),
        Color(0xff062731),
      ]),
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(kTextTabBarHeight),
        child: Padding(
          padding: EdgeInsets.only(left: 20.w),
          child: TextField(
            maxLength: 35,
            controller: searchController,
            onChanged: (val) {
              setState(() {
                query = val;
              });
            },
            cursorColor: const Color(0xff19191b),
            autofocus: true,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 35.sp,
            ),
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 25.w,
                ),
                onPressed: () {
                  if (WidgetsBinding.instance != null) {
                    WidgetsBinding.instance!
                        .addPostFrameCallback((_) => searchController.clear());
                  }
                },
              ),
              border: InputBorder.none,
              hintText: "Search",
              hintStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30.sp,
                color: const Color(0x88ffffff),
              ),
            ),
          ),
        ),
      ),
    );
  }

  buildSuggestions(String query) {
    final List<ChatUser> suggestionList = query.isEmpty
        ? []
        : chatUsers.where((ChatUser user) {
            String _getUsername =
                user.name == null ? "" : user.name!.toLowerCase();
            String _query = query.toLowerCase();
            String _getName = user.name == null ? "" : user.name!.toLowerCase();
            bool matchesUsername = _getUsername.contains(_query);
            bool matchesName = _getName.contains(_query);

            return (matchesUsername || matchesName);
          }).toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: ((context, index) {
        ChatUser searchedUser = ChatUser(
          uid: suggestionList[index].uid,
          // profilePhoto: suggestionList[index].profilePhoto,
          name: suggestionList[index].name,
          gender: suggestionList[index].gender,
          email: suggestionList[index].email,
          // username: suggestionList[index].username
        );
        print(searchedUser.uid);
        return CustomTile(
            mini: false,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChatScreen(
                            receiver: searchedUser,
                          )));
            },
            leading: CircleAvatar(
              radius: 30.r,
              child: Text(
                searchedUser.name == null
                    ? ""
                    : searchedUser.name![0].toUpperCase(),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 40.sp,
                    fontFamily: 'Judson',
                    fontWeight: FontWeight.w700),
              ),
              // backgroundImage: NetworkImage(searchedUser.profilePhoto ?? ""),
              backgroundColor: Colors.amber,
            ),
            title: Text(
              searchedUser.name != null ? searchedUser.name!.toUpperCase() : "",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 25.sp,
                  fontFamily: 'Work Sans'),
            ),
            subtitle: null);
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE1E2E1),
      appBar: searchAppBar(context),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: buildSuggestions(query),
      ),
    );
  }
  // @override
  // Widget build(BuildContext context) {
  //   return const Scaffold(
  //     backgroundColor: Color(0xFFE1E2E1),
  //   );
  // }
}
