// ignore_for_file: avoid_print

import 'package:climate/screens/city_screen.dart';
import 'package:flutter/material.dart';
import 'package:climate/services/weather.dart';
//import 'package:intl/intl.dart';

class LocationScreen extends StatefulWidget {

  LocationScreen({this.locationWeather});

  final locationWeather;

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {

  WeatherModel weather = WeatherModel();
  late int temprature;
  late String cityName;
  late String weatherIcon;
  late String weatherMessage;
  late String iconID;
  late int maxTemp;
  late int minTemp;
  late int feelLikeTemp;
  late String weatherDescription;
  late int pressure;
  late int humidity;
  late int visibility;
  late int windSpeed;
  late DateTime sunRise;
  late DateTime sunSet;
  late int hourR;
  late int hourS;
  late int minuteR;
  late int minuteS;

  @override
  void initState() {
    super.initState();
    UpdateUI(widget.locationWeather);
  }

    void UpdateUI(dynamic weatherData){

      setState(() {

        if(weatherData == null){
          temprature = 0;
          weatherIcon = 'error';
          weatherMessage = 'Unable to fatch';
          cityName = '';
          return;
        }
        var condition = weatherData['weather'][0]['id'];

        double temp = double.parse(weatherData['main']['temp'].toString());
        temprature = temp.toInt();

        cityName = weatherData['name'];

        weatherDescription = weatherData['weather'][0]['description'];

        iconID = weatherData['weather'][0]['icon'];

        double max = double.parse(weatherData['main']['temp_max'].toString());
        maxTemp = max.toInt();

        double min = double.parse(weatherData['main']['temp_min'].toString());
        minTemp = min.toInt();

        double feel = double.parse(weatherData['main']['feels_like'].toString());
        feelLikeTemp = feel.toInt();

        weatherIcon = weather.getWeatherIcon(condition);

        weatherMessage = weather.getMessage(temprature);

        pressure = weatherData['main']['pressure'];

        humidity = weatherData['main']['humidity'];

        visibility = weatherData['visibility'];

        double wind = double.parse(weatherData['wind']['speed'].toString());
        windSpeed = wind.toInt();

        int sunRiseTime = weatherData['sys']['sunrise'];
        sunRise = DateTime.fromMillisecondsSinceEpoch(sunRiseTime*1000);
        hourR = sunRise.hour;
        minuteR = sunRise.minute;
        
        int sunSetTime = weatherData['sys']['sunset'];
        sunSet = DateTime.fromMillisecondsSinceEpoch(sunSetTime*1000);
        hourS = sunSet.hour;
        minuteS = sunSet.minute;
      });

    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            TextButton(onPressed: () async{
              var typedName = await Navigator.push(
                        context, 
                        MaterialPageRoute(
                          builder: (context){
                              return CityScreen();
                            }
                        )
                      );
                      if(typedName!=null) {
                        var weatherData = await weather.getCityWeather(typedName);
                        UpdateUI(weatherData);
                      }
            }, 
          child: Text('$cityName📍',
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            fontFamily: AutofillHints.location,
            color: Colors.white
          ),
          ),
          ),
          ],
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () async{
              var weatherData = await weather.getLocationWeather();
              UpdateUI(weatherData);
            },
            icon: const Icon(Icons.near_me,
              color: Colors.blue,
              size: 30,
            ),
          ),
        ],
        
      ),
      body: Container(
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage('images/location_background.jpg'),
        //     fit: BoxFit.cover,
        //     colorFilter: ColorFilter.mode(
        //         Colors.white.withOpacity(0.8), BlendMode.dstATop),
        //   ),
        // ),
        //constraints: const BoxConstraints.expand(),
        child: Expanded(
          child: Column(
            children: <Widget>[
              Card(
                //margin: const EdgeInsets.all(5),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Row(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(
                                'Max $maxTemp° ',
                                style: const TextStyle(
                                fontSize: 15,
                                ),
                              ),
                              const Icon(Icons.arrow_upward, size: 15,),
                              const Text(
                                ' • ',
                                style: TextStyle(
                                fontSize: 15,
                              ),
                              ),
                              Text(
                                'Min $minTemp° ',
                                style: const TextStyle(
                                fontSize: 15,
                              ),
                              ),
                              const Icon(Icons.arrow_downward,size: 15,),
                            ],
                          ),
                          Text(
                            '$temprature°',
                              style: const TextStyle(
                              fontSize: 100,
                            ),
                          ),
                          Text(
                            'Feels like $feelLikeTemp°',
                              style: const TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 50,),
                      Column(
                        children: <Widget>[
                          Image.network(
                            'https://openweathermap.org/img/wn/$iconID@2x.png',
                            width: 165,
                            height: 165,
                          ),
                          Text(
                            '$weatherDescription',
                              style: const TextStyle(
                              fontSize: 15,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Card(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.arrow_downward, size: 15,),
                                  Text(
                                    ' PRESSURE'
                                  ),
                                ],
                              ),
                              
                              Text(
                                '${pressure/100} Pa',
                                style: const  TextStyle(
                                  fontSize: 35
                                ),
                              )
                            ],
                          )
                          ),
                      )
                    ),
                    Expanded(
                      child: Card(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.water_drop,size: 15,),
                                  Text(
                                    ' HUMIDITY'
                                    ),
                                ],
                              ),
                              Text(
                                '$humidity',
                                style: const  TextStyle(fontSize: 35),
                              )
                            ],
                          )
                          ),
                      )
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Card(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.remove_red_eye,size: 15,),
                                  Text(
                                    ' VISIBILITY'
                                  ),
                                ],
                              ),
                              Text(
                                '${visibility/1000} Km',
                                style: const TextStyle(fontSize: 35),
                              )
                            ],
                          ),
                            
                          ),
                      )
                    ),
                    Expanded(
                      child: Card(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.wind_power, size: 15,),
                                  Text(
                                    ' WIND SPEED'
                                  ),
                                ],
                              ),
                              Text(
                                '$windSpeed Km/h',
                                style: const  TextStyle(fontSize: 35),
                              )
                            ],
                          ),
                          ),
                      )
                    ),
                  ],
                ),
              ),
               Expanded(
                child: Card(
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'SUNRISE'
                            ),
                            Text(
                              '$hourR : $minuteR',
                              style: TextStyle(fontSize: 35),
                            ),
                          ],
                        ),
                        const Icon(Icons.sunny, size: 50, color: Colors.yellow,),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'SUNSET'
                            ),
                            Text(
                              '$hourS : $minuteS',
                              style: TextStyle(fontSize: 35),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
