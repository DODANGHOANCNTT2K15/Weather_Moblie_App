import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ualo/screen/home_screen.dart';

class CitySelector extends StatefulWidget {
  final List<String> favoriteCities;
  final String lang;

  const CitySelector(
      {Key? key, required this.lang, required this.favoriteCities})
      : super(key: key);

  @override
  _CitySelectorState createState() => _CitySelectorState();
}

class _CitySelectorState extends State<CitySelector> {
  @override
  void initState() {
    super.initState();
    saveFavoriteCities();
  }

  String get lang => widget.lang;
  List<String> get favoriteCities => widget.favoriteCities;

  final vietnamCities = [
    'Hà Nội',
    'Đà Nẵng',
    'Hải Phòng',
    'Thành phố Hồ Chí Minh',
    'Thái Nguyên'
  ];
  final worldCities = [
    'London',
    'New York',
    'Paris',
    'Tokyo',
    'Sydney',
  ];

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> saveFavoriteCities() async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).set({
        'favoriteCities': favoriteCities,
      });
      print(favoriteCities);
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        await saveFavoriteCities();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Chọn thành phố'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(
                    context: context,
                    delegate: CitySearch(lang, favoriteCities));
              },
            ),
            IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                saveFavoriteCities();
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Text('Thành phố hàng đầu', style: TextStyle(fontSize: 24)),
              SizedBox(
                height: 15,
              ),
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: vietnamCities
                    .map((city) => ElevatedButton(
                          child: Text(city),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeScreen(
                                  city: city,
                                  lang: lang,
                                  favoriteCities: favoriteCities,
                                ),
                              ),
                            );
                          },
                        ))
                    .toList(),
              ),
              SizedBox(height: 20), // Add some spacing
              Text(
                'Thành phố hàng đầu thế giới',
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Wrap(
                spacing: 8.0, // gap between adjacent chips
                runSpacing: 4.0, // gap between lines
                children: worldCities
                    .map((city) => ElevatedButton(
                          child: Text(city),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeScreen(
                                  city: city,
                                  lang: lang,
                                  favoriteCities: favoriteCities,
                                ),
                              ),
                            );
                          },
                        ))
                    .toList(),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                'Thành phố yêu thích',
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              favoriteCities.isEmpty
                  ? Text(
                      'Chưa có thành phố yêu thích',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    )
                  : Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: favoriteCities
                          .map((city) => ElevatedButton(
                                child: Text(city),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HomeScreen(
                                        city: city,
                                        lang: lang,
                                        favoriteCities: favoriteCities,
                                      ),
                                    ),
                                  );
                                },
                              ))
                          .toList(),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class CitySearch extends SearchDelegate<String> {
  final String lang;
  final List<String> favoriteCities;
  CitySearch(this.lang, this.favoriteCities);

  final cities = [
    'Hà Nội',
    'Đà Nẵng',
    'Hải Phòng',
    'Thành phố Hồ Chí Minh',
    'Thái Nguyên',
    'Cần Thơ',
    'Đà Lạt',
    'Huế',
    'Nha Trang',
    'Vũng Tàu',
    'Cà Mau',
    'Phan Thiết',
    'Quy Nhơn',
    'Vinh',
    'Bắc Ninh',
    'Hạ Long',
    'Biên Hòa',
    'Bảo Lộc',
    'Buôn Ma Thuột',
    'Cẩm Phả',
    'Cao Bằng',
    'Cao Lãnh',
    'Châu Đốc',
    'Điện Biên Phủ',
    'Đông Hà',
    'Đồng Hới',
    'Gia Nghĩa',
    'Hà Giang',
    'Hà Tiên',
    'Hà Tĩnh',
    'Hòa Bình',
    'Hội An',
    'Hưng Yên',
    'Kon Tum',
    'Lai Châu',
    'Lạng Sơn',
    'Long Xuyên',
    'Mỹ Tho',
    'Nam Định',
    'Ninh Bình',
    'Phủ Lý',
    'Phúc Yên',
    'Pleiku',
    'Quảng Ngãi',
    'Rạch Giá',
    'Sóc Trăng',
    'Sơn La',
    'Tam Kỳ',
    'Tân An',
    'Tây Ninh',
    'Thái Bình',
    'Thái Nguyên',
    'Thanh Hóa',
    'Trà Vinh',
    'Tuy Hòa',
    'Tuyên Quang',
    'Uông Bí',
    'Vĩnh Long',
    'Vĩnh Yên',
    'Yên Bái',
    'London',
    'Japan',
    'Indonesia',
    'India',
    'Philippines',
    'China',
    'India',
    'USA',
    'China',
    'Brazil',
    'Mexico',
    'China',
    'Bangladesh',
    'Egypt',
    'Thailand',
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? cities
        : cities.where((p) => p.startsWith(query)).toList();

    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(
                city: suggestionList[index],
                lang: lang,
                favoriteCities: favoriteCities,
              ),
            ),
          );
        },
        title: RichText(
          text: TextSpan(
            text: suggestionList[index].substring(0, query.length),
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            children: [
              TextSpan(
                text: suggestionList[index].substring(query.length),
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
      itemCount: suggestionList.length,
    );
  }
}
