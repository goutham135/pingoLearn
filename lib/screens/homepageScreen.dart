import 'package:demo/helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/authServices.dart';
import '../services/homepageService.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {

  var homepageProvider = ChangeNotifierProvider((ref) => HomepageService());

  final User? user = Auth().currentUser;

  signOut(){
    return Auth().signOut();
  }

  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;
  var maskEmail = StateProvider((ref) => true);


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(milliseconds: 100), () async {
      await initializeRemoteConfig();
      getComments();
    },);
  }

  initializeRemoteConfig() async {
    await _remoteConfig.setDefaults(<String, dynamic>{
      'maskEmail': false, // Default value
    });
    await _remoteConfig.fetchAndActivate();
    bool isFeatureEnabled = _remoteConfig.getBool('maskEmail');
    ref.read(maskEmail.notifier).state = isFeatureEnabled;
  }

  getComments(){
    ref.read(homepageProvider).getComments();
  }

  @override
  Widget build(BuildContext context) {
    var status = ref.watch(homepageProvider).status;
    var comments = ref.watch(homepageProvider).comments;
    var _maskEmail = ref.watch(maskEmail);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: primaryColor,
          statusBarIconBrightness: Brightness.light,
        ),
        toolbarHeight: 60,
        elevation: 0,
        title: const Text('Comments'),
        leading: const SizedBox(),
        leadingWidth: 0,
        actions: [
          GestureDetector(
            onTap: (){
              signOut();
            },
            child: Padding(
              padding: EdgeInsets.only(right: getWidth(context)/24),
              child: Icon(Icons.logout, size: 26, color: Colors.white,),
            )
          )
        ],
      ),
      body: Stack(
        children: [
          ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: comments.length,
            itemBuilder: (context, index) {
              return CommentsWidget(data: comments[index], maskEmail: _maskEmail);
          },),
          if(status == ApiStatus.success && comments.isEmpty)const MyNoData(),
          if(status == ApiStatus.networkError)const MyNetworkError(),
          if(status == ApiStatus.error)const MyError(),
          if(status == ApiStatus.stable || status == ApiStatus.loading)const MyLoader()
        ],
      ),
    );
  }
}

class CommentsWidget extends StatelessWidget {
  CommentsData data;
  bool maskEmail;
  CommentsWidget({super.key, required this.data, required this.maskEmail});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey,
              radius: 20,
              child: Text('A', style: TextStyle(color: primaryColor, fontSize: 16),),
            ),
            const SizedBox(width: 10,),
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      Text('Name', style: TextStyle(color: Colors.grey.shade300, fontStyle: FontStyle.italic, fontSize: 14),),
                      Text(' : ', style: TextStyle(color: Colors.grey.shade300, fontSize: 14),),
                      Flexible(child: Text(data.name, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis,))
                    ],
                  ),
                  const SizedBox(height: 5,),
                  Row(
                    children: [
                      Text('Email', style: TextStyle(color: Colors.grey.shade300, fontStyle: FontStyle.italic, fontSize: 14),),
                      Text(' : ', style: TextStyle(color: Colors.grey.shade300, fontSize: 14),),
                      Flexible(child: Text(maskEmail ? '${data.email.split('@').first.substring(0,2)}***@${data.email.split('@').last}' : data.email, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis,))
                    ],
                  ),
                  const SizedBox(height: 5,),
                  Text(data.body, maxLines: 4, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.black, fontSize: 14),)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

