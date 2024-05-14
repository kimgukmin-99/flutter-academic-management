import 'package:flutter/material.dart';

class GraduationRequirement {
  final String requirement;
  final bool completed;

  GraduationRequirement({required this.requirement, required this.completed});
}

class GraduationScreen extends StatelessWidget {
  final List<GraduationRequirement> requirements = [
    GraduationRequirement(requirement: '필수 과목 1', completed: true),
    GraduationRequirement(requirement: '필수 과목 2', completed: false),
    GraduationRequirement(requirement: '필수 과목 3', completed: true),
    GraduationRequirement(requirement: '졸업 학점 120점 이상', completed: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: requirements.length,
          itemBuilder: (context, index) {
            final requirement = requirements[index];
            return ListTile(
              title: Text(requirement.requirement),
              trailing: Icon(
                requirement.completed ? Icons.check_circle : Icons.cancel,
                color: requirement.completed ? Colors.green : Colors.red,
              ),
            );
          },
        ),
      ),
    );
  }
}
