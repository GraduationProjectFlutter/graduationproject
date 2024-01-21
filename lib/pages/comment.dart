import 'package:flutter/material.dart';

// Yorumlar için kullanılan bir Stateless Widget.
// Her bir yorum için metin, kullanıcı adı ve zaman bilgisi gösterir.
class Comment extends StatelessWidget {
  // Yorumun metni
  final String text;
  // Yorumu yapan kullanıcının adı
  final String user;
  // Yorumun yapıldığı zaman
  final String time;

  const Comment(
      {super.key, required this.text, required this.user, required this.time});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Yorumun arka planını ve kenar yuvarlaklığını ayarlar
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(4),
      ),
      margin: const EdgeInsets.only(bottom: 5),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Yorum metnini gösterir
          Text(text),
          SizedBox(height: 10),
          // Kullanıcı adı ve zaman bilgisini satır olarak gösterir
          Row(
            children: [
              // Kullanıcı adını gösterir
              Text(
                user,
                style: TextStyle(color: Colors.grey[500]),
              ),
              Text(
                " . ",
                style: TextStyle(color: Colors.grey[500]),
              ),
              Text(
                time,
                style: TextStyle(color: Colors.grey[500]),
              ),
            ],
          )
        ],
      ),
    );
  }
}
