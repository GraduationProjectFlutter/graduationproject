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


/* YORUMLARA YANIT VERME ÖZELLİĞİ 

class Comment extends StatelessWidget {
  final String text, user, time;
  final Function onReply;

  const Comment({
    Key? key,
    required this.text,
    required this.user,
    required this.time,
    required this.onReply,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ... (Diğer widget yapılandırmaları)

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => onReply(),
          child: Text('Reply'),
        ),
      ],
    );
  }
}  */


/* YORUM BEĞENME BUTONU

class Comment extends StatelessWidget {
  final String text, user, time;
  final int likes;
  final Function onLike;

  const Comment({
    Key? key,
    required this.text,
    required this.user,
    required this.time,
    required this.likes,
    required this.onLike,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ... (Diğer widget yapılandırmaları)

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton.icon(
          onPressed: () => onLike(),
          icon: Icon(Icons.thumb_up_alt_outlined),
          label: Text(likes.toString()),
        ),
        // Diğer elemanlar
      ],
    );
  }
}  */


/* class Comment extends StatelessWidget {
  final String text, user, time;

  const Comment({
    Key? key,
    required this.text,
    required this.user,
    required this.time,
  }) : super(key: key);

  void _reportComment() {
    // Raporlama işlemleri
  }

  @override
  Widget build(BuildContext context) {
    // ... (Diğer widget yapılandırmaları)

    return PopupMenuButton(
      onSelected: (value) {
        if (value == 'report') {
          _reportComment();
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'report',
          child: Text('Report Comment'),
        ),
      ],
    );
  }
}  */
