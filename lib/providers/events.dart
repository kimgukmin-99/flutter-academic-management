import 'package:academic_management/providers/person.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Event {
  final String eventName;
  final String? eventImage;

  Event({
    required this.eventName,
    this.eventImage,
  });

  // JSON 데이터를 Event 객체로 변환하기 위한 factory constructor 추가
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      eventName: json['eventName'] ?? '',
    );
  }
}

// 이벤트 데이터를 서버에서 가져오는 함수
Future<List<Event>> fetchEvents() async {
  final url = Uri.parse('$server2/events');
  final headers = {"Content-Type": "application/json"};

  final response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    print('Fetch events successful');
    final responseBody = json.decode(utf8.decode(response.bodyBytes));
    print('response : $responseBody');
    final List<dynamic> jsonResponse = json.decode(response.body);

    // JSON 응답을 Event 객체 리스트로 변환
    return jsonResponse.map((eventJson) => Event.fromJson(eventJson)).toList();
  } else {
    print('Fetch events failed: ${response.statusCode}');
    print('Response body: ${response.body}');
    throw Exception('Failed to load events');
  }
}

// 이벤트 참여 상태를 서버에 업데이트하는 함수
Future<bool> updateEventParticipation(
    String eventId, bool isParticipating) async {
  final url = Uri.parse('$server2/events/$eventId/participate');
  final headers = {"Content-Type": "application/json"};
  final body = jsonEncode({"isParticipating": isParticipating});

  final response = await http.put(url, headers: headers, body: body);

  if (response.statusCode == 200) {
    print('Update event participation successful');
    return true;
  } else {
    print('Update event participation failed: ${response.statusCode}');
    print('Response body: ${response.body}');
    return false;
  }
}
