import 'package:academic_management/providers/person.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Post {
  final String title;
  final String content;
  final UserProfile author;
  final DateTime createdAt;
  final String? imagePath;

  Post({
    required this.title,
    required this.content,
    required this.author,
    required this.createdAt,
    this.imagePath,
  });

  // JSON 데이터를 Post 객체로 변환하기 위한 factory constructor 추가
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      author: UserProfile.fromJson(json['author'] ?? {}),
      createdAt: DateTime.parse(json['createdAt']),
      imagePath: json['imagePath'],
    );
  }
}

// 게시물 데이터를 서버에서 가져오는 함수
Future<List<Post>> fetchPosts() async {
  final url = Uri.parse('$server2/posts');
  final headers = {"Content-Type": "application/json"};

  final response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    print('Fetch posts successful');
    final responseBody = json.decode(utf8.decode(response.bodyBytes));
    print('response : $responseBody');
    final List<dynamic> jsonResponse = json.decode(response.body);

    // JSON 응답을 Post 객체 리스트로 변환
    return jsonResponse.map((postJson) => Post.fromJson(postJson)).toList();
  } else {
    print('Fetch posts failed: ${response.statusCode}');
    print('Response body: ${response.body}');
    throw Exception('Failed to load posts');
  }
}
