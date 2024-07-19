import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whether_app/providers/default_value_provider.dart';
import 'package:whether_app/services/api_services.dart'; // Import your ApiServices class

class WeatherPage extends StatefulWidget {
  final String location;

  const WeatherPage({Key? key, required this.location}) : super(key: key);

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final ApiServices apiServices =
      ApiServices(); // Create an instance of ApiServices
  bool isChecked = false;
  Widget _buildWeatherInfoBlock(String title, String value) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.blue.withOpacity(0.2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20, // Example font size
                    color: Color.fromARGB(234, 0, 0, 0), // Example color
                    // Example font family
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18, // Example font size
                    color: Color.fromARGB(255, 252, 244, 244), // Example color
                    fontFamily: 'Anta', // Example font family
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg3.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            FutureBuilder<Map<String, dynamic>>(
              future: apiServices.getWeatherData(
                widget.location,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.86),
                      child: const CircularProgressIndicator(),
                    ),
                  );
                } else if (snapshot.hasError || snapshot.data == null) {
                  return Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 350, bottom: 10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 2, 18, 40),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'Failed to fetch weather data, please try again...',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color.fromARGB(255, 236, 236, 239),
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            fontFamily:
                                'Anta', // You can replace 'Anta' with your preferred font family
                          ),
                        ),
                      ),
                      const SizedBox(
                          height: 20), // Add space below the Container
                    ],
                  );
                } else {
                  Map<String, dynamic> weatherData = snapshot.data!;
                  double kelvinTemp =
                      (weatherData['main']['temp'] as num).toDouble();
                  double kelvinTemp1 =
                      (weatherData['main']['feels_like'] as num).toDouble();
                  double visibilityInMeters =
                      (weatherData['visibility'] as int) / 1000;
                  double celsiusTemp = kelvinTemp - 273.15;
                  double celsiusTemp1 = kelvinTemp1 - 273.15;
// Convert meters to kilometers
                  String visibilityInKilometers = visibilityInMeters
                      .toStringAsFixed(2); // Format to display 2 decimal places

                  return Container(
                    margin: const EdgeInsets.only(top: 50),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      '${celsiusTemp.toStringAsFixed(2)}°',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 236, 236, 239),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 60,
                                        fontFamily:
                                            'Anta', // You can replace 'Anta' with your preferred font family
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Image.network(
                                      'https://openweathermap.org/img/wn/${weatherData['weather'][0]['icon']}@2x.png',
                                      width: 150,
                                      height: 150,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 0, bottom: 10),
                            child: Text(
                              '${weatherData['weather'][0]['description']}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color.fromARGB(255, 236, 236, 239),
                                fontWeight: FontWeight.bold,
                                fontSize: 40,
                                fontFamily:
                                    'Anta', // You can replace 'Roboto' with your preferred font family
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildWeatherInfoBlock(
                                      'feels like',
                                      '${celsiusTemp1.toStringAsFixed(2)}°',
                                    ),
                                    _buildWeatherInfoBlock(
                                      'Location',
                                      '${weatherData['name']}',
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildWeatherInfoBlock(
                                      'Clouds',
                                      '${weatherData['clouds']['all']} %',
                                    ),
                                    _buildWeatherInfoBlock(
                                      'Pressure',
                                      '${weatherData['main']['pressure']} kPa',
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildWeatherInfoBlock(
                                      'Humidity',
                                      '${weatherData['main']['humidity']}%',
                                    ),
                                    _buildWeatherInfoBlock(
                                      'visibility',
                                      '$visibilityInKilometers km',
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildWeatherInfoBlock(
                                      'Wind Speed',
                                      '${weatherData['wind']['speed']} m/s',
                                    ),
                                    _buildWeatherInfoBlock(
                                      'Wind direction',
                                      '${weatherData['wind']['deg']}°',
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Align(
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                          width:
                                              8), // Adjust the width as per your requirement
                                      const Flexible(
                                        child: Text(
                                          "Make default",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Color.fromARGB(
                                                255, 252, 244, 244),
                                            fontFamily: 'Anta',
                                          ),
                                        ),
                                      ),
                                      Checkbox(
                                        value: isChecked,
                                        activeColor: Colors.blue[
                                            700], // Set the fill color to blue
                                        checkColor: Colors.white,

                                        onChanged: (bool? value) {
                                          if (value != null) {
                                            setState(() {
                                              isChecked = value;
                                              Provider.of<DefaultValueProvider>(
                                                context,
                                                listen: false,
                                              ).addingDataToProvider(
                                                  1, widget.location, "");
                                            });
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
