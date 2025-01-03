import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ualo/screen/add_city_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
import 'package:ualo/screen/setting.dart';
import 'package:ualo/screen/signin.dart';

class HomeScreen extends StatefulWidget {
  final List<String> favoriteCities;
  final String city;
  final lang;

  const HomeScreen(
      {Key? key,
      required this.city,
      required this.lang,
      required this.favoriteCities})
      : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

List<dynamic> timeSlots = [];
List<dynamic> timeSlots2 = [];

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    loadFavoriteCities();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _email = "";

  String get nameCity => widget.city;

  var _tocDoGio;
  var _doAm;
  var _may;
  var _mota;

  String _iconTT = 'images/weather/01d.png';
  var _nhietDo;
  var _icon;

  String get lang => widget.lang;
  String city = "London";

  List<String> _favoriteCities = [];

  List<String> get favoriteCities => _favoriteCities;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // hàm load data từ firebase cloud
  Future<void> loadFavoriteCities() async {
    final user = _auth.currentUser;
    if (user != null) {
      final docSnapshot =
          await _firestore.collection('users').doc(user.uid).get();
      if (docSnapshot.exists) {
        setState(() {
          _favoriteCities =
              List<String>.from(docSnapshot.data()?['favoriteCities'] ?? []);
          ;
        });
        print('Favorite Cities: $_favoriteCities ');
      }
    }
  }

  Future<void> saveFavoriteCities() async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).set({
        'favoriteCities': favoriteCities,
      });
      print(favoriteCities);
    }
  }

  // nút trái tim
  void toggleFavorite(String city) {
    setState(() {
      if (favoriteCities.contains(city)) {
        favoriteCities.remove(city);
        saveFavoriteCities();
      } else {
        favoriteCities.add(city);
        saveFavoriteCities();
      }
    });
  }

  // hàm đăng xuất tài khoản
  void _handleSignOut() async {
    try {
      await _auth.signOut();
      print("User Logged Out");
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SignIn(
                  title: 'Sign In',
                )),
      );
    } catch (e) {
      print("Error During Sign Out: $e");
    }
  }

  // hàm lấy data từ api hiện tại
  void getData() async {
    final response = await http
        .get(Uri.https('api.openweathermap.org', '/data/2.5/weather', {
      'q': nameCity,
      'units': 'metric',
      'appid': 'c739b9ae47eb31e54772f88979514356',
      'lang': lang,
      'exclude': 'minutely'
    }));

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      setState(() {
        city = jsonResponse['name'];
        _nhietDo = jsonResponse['main']['temp'].round();
        _doAm = jsonResponse['main']['humidity'];
        _tocDoGio = jsonResponse['wind']['speed'];
        _may = jsonResponse['clouds']['all'];
        _mota = jsonResponse['weather'][0]['description'];
        _icon = jsonResponse['weather'][0]['icon'];
        _iconTT = 'images/weather/' + _icon + '.png';
      });
    } else {
      throw Exception('Lỗi kết nối data');
    }
  }

  // lấy dữ liệu api 5 ngày nhưng cho trong một ngày
  void getDataTime() async {
    final response = await http.get(Uri.https(
      'api.openweathermap.org',
      '/data/2.5/forecast',
      {
        'q': nameCity,
        'units': 'metric',
        'appid': 'c739b9ae47eb31e54772f88979514356',
        'lang': lang,
      },
    ));

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      setState(() {
        timeSlots = jsonResponse['list'].sublist(0, 8);
      });
    } else {
      throw Exception('Lỗi kết nối data');
    }
  }

  // lấy dữ liệu api trong 5 ngày tiếp theo
  void getDataTime2() async {
    final response = await http.get(Uri.https(
      'api.openweathermap.org',
      '/data/2.5/forecast',
      {
        'q': nameCity,
        'units': 'metric',
        'appid': 'c739b9ae47eb31e54772f88979514356',
        'lang': lang,
      },
    ));

    if (response.statusCode == 200) {
      jsonDecode(response.body);
      setState(() {
        var jsonResponse = jsonDecode(response.body);
        var list = jsonResponse['list'] as List;
        var filteredList = list.where((item) {
          var dtTxt = item['dt_txt'] as String;
          var hour = int.parse(dtTxt.substring(11, 13));
          return hour >= 9 && hour < 10;
        }).toList();

        setState(() {
          timeSlots2 = filteredList;
        });
      });
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  int stop = 0;

  @override
  Widget build(BuildContext context) {
    if (stop <= 1) {
      stop++;
      getData();
      getDataTime();
      getDataTime2();
    }
    String today = '';
    String thu2 = '';
    String thu3 = '';
    String thu4 = '';
    String thu5 = '';
    String thu6 = '';
    String thu7 = '';
    String chunhat = '';
    // sửa lý ngôn ngữ
    if (lang == "vi") {
      today = 'Hôm nay';
      thu2 = 'Thứ 2';
      thu3 = 'Thứ 3';
      thu4 = 'Thứ 4';
      thu5 = 'Thứ 5';
      thu6 = 'Thứ 6';
      thu7 = 'Thứ 7';
      chunhat = 'Chủ nhật';
    } else if (lang == "zh_tw") {
      today = '今天';
      thu2 = '周一';
      thu3 = '周二';
      thu4 = '周三';
      thu5 = '周四';
      thu6 = '星期五';
      thu7 = '周六';
      chunhat = '星期日';
    } else if (lang == "en") {
      today = 'Today';
      thu2 = 'Monday';
      thu3 = 'Tuesday';
      thu4 = 'Wednesday';
      thu5 = 'Thursday';
      thu6 = 'Friday';
      thu7 = 'Saturday';
      chunhat = 'Sunday';
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 37, 37, 37),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: <Widget>[
                // phần header
                Container(
                  margin: const EdgeInsets.only(left: 20, top: 20),
                  alignment: Alignment.topLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: [
                          Text(
                            city,
                            style: const TextStyle(
                                color: Colors.white,
                                fontStyle: FontStyle.normal,
                                decoration: TextDecoration.none,
                                fontSize: 20),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Icon(
                            Icons.location_on,
                            color: Colors.white,
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.favorite),
                        color: favoriteCities.contains(city)
                            ? Colors.red
                            : Colors.white,
                        onPressed: () {
                          toggleFavorite(city);
                        },
                      ),
                    ],
                  ),
                ),
                // nút thành phố
                Container(
                  margin: const EdgeInsets.only(right: 20, top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      FloatingActionButton(
                        onPressed: () {
                          loadFavoriteCities();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CitySelector(
                                      lang: lang,
                                      favoriteCities: favoriteCities,
                                    )),
                          );
                        },
                        backgroundColor: Colors.transparent,
                        elevation: 0.0,
                        child: const Icon(
                          Icons.location_city,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 10),
                      // nút người dùng
                      FloatingActionButton(
                        onPressed: () {
                          final User? user = _auth.currentUser;
                          _email = user!.email!;
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Container(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      'Email: $_email',
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                    const SizedBox(height: 20),
                                    Center(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          _handleSignOut();
                                        },
                                        child: const Text('Đăng xuất'),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        backgroundColor: Colors.transparent,
                        elevation: 0.0,
                        child: const Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 10),
                      // nút cài đặt
                      FloatingActionButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SettingPage(
                                      city: city,
                                      favoriteCities: _favoriteCities,
                                    )),
                          );
                        },
                        backgroundColor: Colors.transparent,
                        elevation: 0.0,
                        child: const Icon(
                          Icons.settings,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            // thông tin hiện tại
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // căn giữa hàng
              children: <Widget>[
                // Cột 1: Hình ảnh thời tiết
                Image.asset(_iconTT),
                const SizedBox(width: 20),
                // Cột 2: Nhiệt độ
                Text(
                  _nhietDo.toString() + '°C',
                  style: const TextStyle(
                    fontSize: 50,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Container(
              child: Text(
                _mota.toString(),
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            // cột gió, độ ẩm, mây
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                // Cột 1: Hình gió và tốc độ gió
                Column(
                  children: <Widget>[
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Image.asset(
                          'images/icons/windspeed.png',
                          width: 35,
                          height: 35,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      _tocDoGio.toString() + "km/h",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ), // Tốc độ gió
                  ],
                ),

                // Cột 2: Hình mây và phần trăm mây
                Column(
                  children: <Widget>[
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Image.asset(
                          'images/icons/clouds.png',
                          width: 35,
                          height: 35,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      _may.toString() + "%",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ), // Phần trăm mây
                  ],
                ),
                // Cột 3: Hình độ ẩm và phần trăm độ ẩm
                Column(
                  children: <Widget>[
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Image.asset(
                          'images/icons/humidity.png',
                          width: 35,
                          height: 35,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      _doAm.toString() + "%",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ), // Phần trăm độ ẩm
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            Center(
              child: Text(
                today,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            // phần silder
            SizedBox(
              width: 500,
              height: 180,
              child: CarouselSlider.builder(
                itemCount: 8,
                itemBuilder:
                    (BuildContext context, int itemIndex, int pageViewIndex) =>
                        buildColumn(itemIndex),
                options: CarouselOptions(
                  scrollDirection: Axis.horizontal,
                  autoPlay: true,
                  enlargeCenterPage: false, // phòng to hơn mục khác
                  viewportFraction: 0.3, // phần trăm chiều rộng
                  aspectRatio: 1, // chiều rộng chiều cao
                  enableInfiniteScroll: false, // cuộn vô hạn
                ),
              ),
            ),
            // phần 5 ngày
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.only(
                  right: 15, top: 20, left: 35, bottom: 20),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 29, 29, 29),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: List.generate(timeSlots2.length, (index) {
                  var timeSlot = timeSlots2[index];
                  var date = DateTime.parse(timeSlot['dt_txt']);
                  var dayOfWeek = getDayOfWeek(date.weekday, thu2, thu3, thu4,
                      thu5, thu6, thu7, chunhat);
                  var icon = timeSlot['weather'][0]['icon'];
                  var maxTemp = timeSlot['main']['temp'];

                  return Column(
                    children: [
                      Row(
                        children: [
                          // Cột 1: Ngày và tháng
                          Expanded(
                            flex: 1,
                            child: Text(
                              '${date.day}/${date.month}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          // Cột 2: Thứ trong tuần
                          Expanded(
                            flex: 2,
                            child: Text(
                              dayOfWeek,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          // Cột 3: Một tấm ảnh
                          Expanded(
                            flex: 1,
                            child: Image.network(
                              'http://openweathermap.org/img/wn/$icon.png',
                              width: 30,
                              height: 30,
                            ),
                          ),
                          // Cột 4: Nhiệt độ
                          Expanded(
                            flex: 1,
                            child: Text(
                              '${maxTemp.round()}°C',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (index < timeSlots.length - 1)
                        const SizedBox(height: 10),
                    ],
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// khai báo thứ
String getDayOfWeek(
    int dayOfWeek, thu2, thu3, thu4, thu5, thu6, thu7, chunhat) {
  switch (dayOfWeek) {
    case 1:
      return thu2;
    case 2:
      return thu3;
    case 3:
      return thu4;
    case 4:
      return thu5;
    case 5:
      return thu6;
    case 6:
      return thu7;
    case 7:
      return chunhat;
    default:
      return '';
  }
}

// tạo danh sách các khung giờ
Widget buildColumn(int index) {
  var weatherData = timeSlots[index];
  var temperature = weatherData['main']['temp'].round().toString() + '°C';
  var iconCode = weatherData['weather'][0]['icon'];
  var iconUrl =
      'images/weather/$iconCode.png'; // Đường dẫn tới ảnh dựa trên mã icon
  var dateTime = DateTime.fromMillisecondsSinceEpoch(weatherData['dt'] * 1000);
  var time = DateFormat('HH:mm').format(dateTime);
  var date = DateFormat('dd/MM/yyyy').format(dateTime); // Định dạng ngày

  return Container(
    width: 100,
    margin: const EdgeInsets.all(0),
    child: Column(
      children: [
        Container(
          width: 110,
          height: 170,
          color: const Color.fromARGB(255, 29, 29, 29),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Text(
                date,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ), // Hiển thị ngày
              const SizedBox(height: 5),
              Text(
                time,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ), // Hiển thị thời gian dự báo
              const SizedBox(height: 20),
              Image.asset(iconUrl,
                  width: 50, height: 50), // Hiển thị icon thời tiết
              const SizedBox(height: 20),
              Text(
                temperature,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ), // Hiển thị nhiệt độ
            ],
          ),
        ),
      ],
    ),
  );
}
