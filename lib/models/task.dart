import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Task extends Equatable {
  final DateTime dateTime;
  final String name;
  final String description;

  Task(
      {@required this.dateTime,
      @required this.name,
      @required this.description});

  Task copyWith({DateTime dateTime, String name, String description}) {
    return Task(
        dateTime: dateTime ?? this.dateTime,
        name: name ?? this.name,
        description: description ?? this.description);
  }

  @override
  List<Object> get props => [dateTime, name];

  @override
  String toString() {
    return ''' { 
                  dateTime: $dateTime,
                  name:   $name,
                  description: $description
               }
                ''';
  }
}
