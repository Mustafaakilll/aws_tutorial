/*
* Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

import 'package:amplify_datastore_plugin_interface/amplify_datastore_plugin_interface.dart';
import 'package:flutter/foundation.dart';

/// This is an auto generated class representing the Todo type in your schema. */
@immutable
class Todo extends Model {
  static const classType = TodoType();
  @override
  // ignore: overridden_fields
  final String id;
  final String userId;
  final bool isComplete;
  final String title;

  @override
  TodoType getInstanceType() => classType;

  @override
  String getId() => id;

  // ignore: sort_constructors_first
  const Todo._internal(
      {@required this.id,
      @required this.userId,
      @required this.isComplete,
      @required this.title});

  // ignore: sort_unnamed_constructors_first, sort_constructors_first
  factory Todo({String id, String userId, bool isComplete, String title}) =>
      Todo._internal(
          id: id ?? UUID.getUUID(),
          userId: userId,
          isComplete: isComplete,
          title: title);

  bool equals(Object other) => this == other;

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) {
      return true;
    }
    return other is Todo &&
        id == other.id &&
        userId == other.userId &&
        isComplete == other.isComplete &&
        title == other.title;
  }

  @override
  int get hashCode => toString().hashCode;

  @override
  String toString() {
    final buffer = StringBuffer();

    buffer.write('Todo {');
    buffer.write('id=$id, ');
    buffer.write('userId=$userId, ');
    buffer.write('isComplete=' +
        (isComplete != null ? isComplete.toString() : 'null') +
        ', ');
    buffer.write('title=$title');
    buffer.write('}');

    return buffer.toString();
  }

  Todo copyWith({String id, String userId, bool isComplete, String title}) =>
      Todo(
          id: id ?? this.id,
          userId: userId ?? this.userId,
          isComplete: isComplete ?? this.isComplete,
          title: title ?? this.title);

  // ignore: sort_constructors_first
  Todo.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        userId = json['userId'],
        isComplete = json['isComplete'],
        title = json['title'];

  @override
  Map<String, dynamic> toJson() =>
      {'id': id, 'userId': userId, 'isComplete': isComplete, 'title': title};

  // ignore: constant_identifier_names
  static const QueryField ID = QueryField(fieldName: 'todo.id');
  // ignore: constant_identifier_names
  static const QueryField USERID = QueryField(fieldName: 'userId');
  // ignore: constant_identifier_names
  static const QueryField ISCOMPLETE = QueryField(fieldName: 'isComplete');
  // ignore: constant_identifier_names
  static const QueryField TITLE = QueryField(fieldName: 'title');
  static ModelSchema schema =
      Model.defineSchema(define: (modelSchemaDefinition) {
    modelSchemaDefinition
      ..name = 'Todo'
      ..pluralName = 'Todos';

    modelSchemaDefinition.authRules = [
      const AuthRule(authStrategy: AuthStrategy.PUBLIC, operations: [
        ModelOperation.CREATE,
        ModelOperation.UPDATE,
        ModelOperation.DELETE,
        ModelOperation.READ
      ])
    ];

    modelSchemaDefinition.addField(ModelFieldDefinition.id());

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: Todo.USERID,
        isRequired: true,
        ofType: const ModelFieldType(ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: Todo.ISCOMPLETE,
        isRequired: true,
        ofType: const ModelFieldType(ModelFieldTypeEnum.bool)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: Todo.TITLE,
        isRequired: true,
        ofType: const ModelFieldType(ModelFieldTypeEnum.string)));
  });
}

class TodoType extends ModelType<Todo> {
  const TodoType();

  @override
  Todo fromJson(Map<String, dynamic> jsonData) => Todo.fromJson(jsonData);
}
