import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../helper.dart';

class CommentsData{
  final String postId, id, name, email, body;
  CommentsData({
    required this.postId,
    required this.id,
    required this.name,
    required this.email,
    required this.body,
  });
}

class HomepageService extends ChangeNotifier{

  ApiStatus status = ApiStatus.stable;
  List comments = [];

  getComments() async {
    comments.clear();
    var url = Uri.parse('https://jsonplaceholder.typicode.com/comments');
    var response = await http.get(url);
    if(response.statusCode == 200){
      status = ApiStatus.success;
      var body = jsonDecode(response.body);
      if(body.runtimeType.toString() == 'List<dynamic>'){
        List data = body;
        for (var element in data) {
          comments.add(
            CommentsData(
              postId: element['postId'].toString(),
              id: element['id'].toString(),
              name: element['name'].toString(),
              email: element['email'].toString(),
              body: element['body'].toString()
            )
          );
        }
      }
      notifyListeners();
    }
    else if (response.statusCode == 'No Connection') {
      status = ApiStatus.networkError;
      notifyListeners();
    }
    else {
      status = ApiStatus.error;
      notifyListeners();
    }
  }


}