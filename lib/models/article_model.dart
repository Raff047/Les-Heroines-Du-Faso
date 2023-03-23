import 'dart:convert';
import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import '../core/constants/constants.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Article extends Equatable {
  final String id;
  final String title;
  final String category;
  final String content;
  final String imageUrl;
  final String authorId;
  final String authorName;
  final String authorImageUrl;
  final int views;
  final DateTime createdAt;

  Article({
    required this.id,
    required this.title,
    required this.category,
    required this.content,
    required this.imageUrl,
    required this.authorId,
    required this.authorName,
    required this.authorImageUrl,
    required this.views,
    required this.createdAt,
  });

  //Newly added functions
  factory Article.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return Article(
      id: snapshot.id,
      title: data['title'] as String,
      category: data['category'] as String,
      content: data['content'] as String,
      imageUrl: data['imageUrl'] as String,
      authorId: data['authorId'] as String,
      authorName: data['authorName'] as String,
      authorImageUrl: data['authorImageUrl'] as String,
      views: data['views'] as int,
      createdAt: DateTime.fromMillisecondsSinceEpoch(data['createdAt'] as int),
    );
  }

  Map<String, dynamic> toFirestore() {
    return <String, dynamic>{
      'title': title,
      'category': category,
      'content': content,
      'imageUrl': imageUrl,
      'authorId': authorId,
      'authorName': authorName,
      'authorImageUrl': authorImageUrl,
      'views': views,
      'createdAt': Timestamp.fromDate(createdAt).toDate(),
    };
  }

  Article copyWith({
    String? id,
    String? title,
    String? category,
    String? content,
    String? imageUrl,
    String? authorId,
    String? authorName,
    String? authorImageUrl,
    int? views,
    DateTime? createdAt,
  }) {
    return Article(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      authorImageUrl: authorImageUrl ?? this.authorImageUrl,
      views: views ?? this.views,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'category': category,
      'content': content,
      'imageUrl': imageUrl,
      'authorId': authorId,
      'authorName': authorName,
      'authorImageUrl': authorImageUrl,
      'views': views,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory Article.fromMap(Map<String, dynamic> map) {
    return Article(
      id: map['id'] as String,
      title: map['title'] as String,
      category: map['category'] as String,
      content: map['content'] as String,
      imageUrl: map['imageUrl'] as String,
      authorId: map['authorId'] as String,
      authorName: map['authorName'] as String,
      authorImageUrl: map['authorImageUrl'] as String,
      views: map['views'] as int,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory Article.fromJson(String source) =>
      Article.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Article(id: $id, title: $title, category: $category, content: $content, imageUrl: $imageUrl, authorId: $authorId, authorName: $authorName, authorImageUrl: $authorImageUrl, views: $views, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant Article other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.category == category &&
        other.content == content &&
        other.imageUrl == imageUrl &&
        other.authorId == authorId &&
        other.authorName == authorName &&
        other.authorImageUrl == authorImageUrl &&
        other.views == views &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        category.hashCode ^
        content.hashCode ^
        imageUrl.hashCode ^
        authorId.hashCode ^
        authorName.hashCode ^
        authorImageUrl.hashCode ^
        views.hashCode ^
        createdAt.hashCode;
  }

  @override
  List<Object?> get props => [];

// DUMMY ARTICLE DATA

  static final List<Article> dummyArticles = [
    Article(
      id: '1',
      title:
          '5 Reasons Why You Should Talk to Your Partner About Your Sexual Health',
      category: 'Santé sexuelle',
      content:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis lacus augue, volutpat lacinia nunc non, congue interdum lorem. Donec dapibus pellentesque dui, quis commodo dolor ornare in. Integer interdum luctus arcu, vitae lobortis sem gravida at. Mauris laoreet, orci in sagittis placerat, risus lorem bibendum eros, sit amet interdum orci est in augue. Nunc in molestie diam. Vivamus elementum lorem ac efficitur vehicula. Proin vel elit ut tellus pulvinar scelerisque ac vitae leo.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis lacus augue, volutpat lacinia nunc non, congue interdum lorem. Donec dapibus pellentesque dui, quis commodo dolor ornare in. Integer interdum luctus arcu, vitae lobortis sem gravida at. Mauris laoreet, orci in sagittis placerat, risus lorem bibendum eros, sit amet interdum orci est in augue. Nunc in molestie diam. Vivamus elementum lorem ac efficitur vehicula. Proin vel elit ut tellus pulvinar scelerisque ac vitae leo.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis lacus augue, volutpat lacinia nunc non, congue interdum lorem. Donec dapibus pellentesque dui, quis commodo dolor ornare in. Integer interdum luctus arcu, vitae lobortis sem gravida at. Mauris laoreet, orci in sagittis placerat, risus lorem bibendum eros, sit amet interdum orci est in augue. Nunc in molestie diam. Vivamus elementum lorem ac efficitur vehicula. Proin vel elit ut tellus pulvinar scelerisque ac vitae leo.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis lacus augue, volutpat lacinia nunc non, congue interdum lorem. Donec dapibus pellentesque dui, quis commodo dolor ornare in. Integer interdum luctus arcu, vitae lobortis sem gravida at. Mauris laoreet, orci in sagittis placerat, risus lorem bibendum eros, sit amet interdum orci est in augue. Nunc in molestie diam. Vivamus elementum lorem ac efficitur vehicula. Proin vel elit ut tellus pulvinar scelerisque ac vitae leo.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis lacus augue, volutpat lacinia nunc non, congue interdum lorem. Donec dapibus pellentesque dui, quis commodo dolor ornare in. Integer interdum luctus arcu, vitae lobortis sem gravida at. Mauris laoreet, orci in sagittis placerat, risus lorem bibendum eros, sit amet interdum orci est in augue. Nunc in molestie diam. Vivamus elementum lorem ac efficitur vehicula. Proin vel elit ut tellus pulvinar scelerisque ac vitae leo.',
      imageUrl:
          'https://images.unsplash.com/photo-1519699047748-de8e457a634e?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NTJ8fHdvbWFufGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=400&q=60',
      authorId: 'professional1',
      authorName: 'Dr.Jessica Williams',
      authorImageUrl: Constants.doctorAvatar,
      views: 88,
      createdAt: DateTime.now().subtract(Duration(hours: 1)),
    ),
    Article(
      id: '2',
      title: 'Understanding Female Anatomy',
      category: 'Santé sexuelle',
      content:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis lacus augue, volutpat lacinia nunc non, congue interdum lorem. Donec dapibus pellentesque dui, quis commodo dolor ornare in. Integer interdum luctus arcu, vitae lobortis sem gravida at. Mauris laoreet, orci in sagittis placerat, risus lorem bibendum eros, sit amet interdum orci est in augue. Nunc in molestie diam. Vivamus elementum lorem ac efficitur vehicula. Proin vel elit ut tellus pulvinar scelerisque ac vitae leo.',
      imageUrl:
          'https://images.unsplash.com/photo-1589156280159-27698a70f29e?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Nnx8YmxhY2slMjB3b21lbnxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=400&q=60',
      authorId: 'professional1',
      authorName: 'Dr.Jane Doe',
      authorImageUrl: Constants.doctorAvatar,
      views: 105,
      createdAt: DateTime.now().subtract(Duration(hours: 2)),
    ),
    Article(
      id: '3',
      title: 'Common Sexual Health Problems and Solutions',
      category: 'Santé sexuelle',
      content:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis lacus augue, volutpat lacinia nunc non, congue interdum lorem. Donec dapibus pellentesque dui, quis commodo dolor ornare in. Integer interdum luctus arcu, vitae lobortis sem gravida at. Mauris laoreet, orci in sagittis placerat, risus lorem bibendum eros, sit amet interdum orci est in augue. Nunc in molestie diam. Vivamus elementum lorem ac efficitur vehicula. Proin vel elit ut tellus pulvinar scelerisque ac vitae leo..',
      imageUrl:
          'https://images.unsplash.com/photo-1539701938214-0d9736e1c16b?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8YmxhY2slMjB3b21lbnxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=400&q=60',
      authorId: 'professional2',
      authorName: 'Dr.John Smith',
      authorImageUrl: Constants.doctorAvatar,
      views: 231,
      createdAt: DateTime.now().subtract(Duration(hours: 4)),
    ),
    Article(
      id: '4',
      title: 'The Benefits of Masturbation for Women',
      category: 'Santé générale',
      content: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit...',
      imageUrl:
          'https://images.unsplash.com/photo-1607868894064-2b6e7ed1b324?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NXx8YmxhY2slMjB3b21lbnxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=400&q=60',
      authorId: 'professional3',
      authorName: 'Dr.Samantha Lee',
      authorImageUrl: Constants.doctorAvatar,
      views: 67,
      createdAt: DateTime.now().subtract(Duration(hours: 6)),
    ),
    Article(
      id: '5',
      title: 'Tips for Better Sexual Communication',
      category: 'Santé générale',
      content: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit...',
      imageUrl:
          'https://plus.unsplash.com/premium_photo-1664868295100-a0dcaf97b72f?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTN8fGJsYWNrJTIwd29tZW58ZW58MHx8MHx8&auto=format&fit=crop&w=400&q=60',
      authorId: 'professional1',
      authorName: 'Dr.Jane Doe',
      authorImageUrl: Constants.doctorAvatar,
      views: 158,
      createdAt: DateTime.now().subtract(Duration(hours: 12)),
    ),
    Article(
      id: '6',
      title: 'Understanding Your Sexual Health Rights',
      category: 'Santé générale',
      content: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit...',
      imageUrl: 'https://source.unsplash.com/800x600/?woman',
      authorId: 'professional2',
      authorName: 'Dr.John Smith',
      authorImageUrl: Constants.doctorAvatar,
      views: 92,
      createdAt: DateTime.now(),
    ),
    Article(
      id: '7',
      title: 'The Benefits of Kegel Exercises',
      category: 'Mental Health',
      content: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit...',
      imageUrl: 'https://source.unsplash.com/800x600/?woman',
      authorId: 'professional1',
      authorName: 'Dr.Jane Doe',
      authorImageUrl: Constants.doctorAvatar,
      views: 105,
      createdAt: DateTime.now().subtract(Duration(days: 7)),
    ),
    Article(
      id: '8',
      title: 'The Benefits of Regular Pelvic Floor Exercises',
      category: 'Mental Health',
      content:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
      imageUrl: 'https://source.unsplash.com/800x600/?pelvic',
      authorId: 'professional1',
      authorName: 'Dr.Jane Doe',
      authorImageUrl: Constants.doctorAvatar,
      views: 98,
      createdAt: DateTime.now().subtract(Duration(days: 1)),
    ),
    Article(
      id: '9',
      title: 'How to Manage Hormonal Imbalances Naturally',
      category: 'Women\'s Health',
      content:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
      imageUrl: 'https://unsplash.com/photos/vYpbBtkDhNE',
      authorId: 'professional2',
      authorName: 'Dr.John Smith',
      authorImageUrl: Constants.doctorAvatar,
      views: 145,
      createdAt: DateTime.now().subtract(Duration(hours: 18)),
    ),
    Article(
      id: '10',
      title: 'The Truth About Vaginal Discharge',
      category: 'Mental Health',
      content:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
      imageUrl: 'https://source.unsplash.com/800x600/?discharge',
      authorId: 'professional4',
      authorName: 'Dr.Emily Davis',
      authorImageUrl: Constants.doctorAvatar,
      views: 64,
      createdAt: DateTime.now().subtract(Duration(hours: 6)),
    ),
    Article(
      id: '11',
      title: 'new article',
      category: 'Women\'s Health',
      content:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
      imageUrl: 'https://source.unsplash.com/800x600/?hormonal',
      authorId: 'Dr.professional2',
      authorName: 'Dr.John Smith',
      authorImageUrl: Constants.doctorAvatar,
      views: 145,
      createdAt: DateTime.now().subtract(Duration(hours: 18)),
    ),
  ];
}
