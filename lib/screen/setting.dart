import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ualo/screen/home_screen.dart';

class SettingPage extends StatefulWidget {
  final List<String> favoriteCities;
  final String city;
  const SettingPage(
      {Key? key, required this.city, required this.favoriteCities})
      : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  String get city => widget.city;
  String temperatureUnit = 'Độ C';
  String windSpeedUnit = 'km/h';
  String dropdownValue = 'vi';
  List<String> get favoriteCities => widget.favoriteCities;

  void _applyChange() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(
          city: city,
          lang: dropdownValue,
          favoriteCities: favoriteCities,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trang cài đặt'),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 30),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Hệ thống',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 119, 119, 119)),
              ),
            ),
          ),
          Container(
            height: 90,
            margin: EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 20),
                  child: Row(
                    children: [
                      const Text('Ngôn ngữ'),
                      SizedBox(
                        width: 50,
                      ),
                      DropdownButton<String>(
                        value: dropdownValue,
                        icon: const Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        style: const TextStyle(
                            color: Color.fromARGB(255, 0, 119, 255)),
                        underline: Container(
                          height: 2,
                          color: Color.fromARGB(255, 0, 162, 255),
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValue = newValue!;
                          });
                        },
                        items: <String>['vi', 'zh_tw', 'en']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 20),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Nhiệt độ',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 119, 119, 119)),
                    ),
                  ),
                ),
                RadioListTile<String>(
                  title: const Text('Độ C'),
                  value: 'Độ C',
                  groupValue: temperatureUnit,
                  onChanged: (String? value) {
                    setState(() {
                      temperatureUnit = value!;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Độ F'),
                  value: 'Độ F',
                  groupValue: temperatureUnit,
                  onChanged: (String? value) {
                    setState(() {
                      temperatureUnit = value!;
                    });
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            padding: EdgeInsets.only(left: 20),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Tốc độ không khí',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 119, 119, 119)),
                    ),
                  ),
                ),
                RadioListTile<String>(
                  title: const Text('km/h'),
                  value: 'km/h',
                  groupValue: windSpeedUnit,
                  onChanged: (String? value) {
                    setState(() {
                      windSpeedUnit = value!;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: const Text('m/s'),
                  value: 'm/s',
                  groupValue: windSpeedUnit,
                  onChanged: (String? value) {
                    setState(() {
                      windSpeedUnit = value!;
                    });
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                _applyChange();
              },
              child: Text(
                'Áp dụng',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
