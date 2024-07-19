import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whether_app/components/get_location_widget.dart';
import 'package:whether_app/components/get_postal_code_widget.dart';
import 'package:whether_app/local_notifications.dart';
import 'package:whether_app/providers/default_value_provider.dart';
import 'package:whether_app/providers/location_provider.dart';
import 'package:whether_app/screens/location_page.dart';
import 'package:whether_app/screens/location_page_for_onpress.dart';
import 'package:whether_app/screens/weather_page.dart';
import 'package:whether_app/screens/weather_page_byzip.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whether_app/services/api_services.dart';
import 'package:duration_button/duration_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key); // Add a named key parameter

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ApiServicesforzip apiServicesfromzip;
  late ApiServicesforlocation apiServicesforlocations;
  late ApiServices apiServices;

  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _countryCodeController = TextEditingController();

  String? _savedLocation;
  String? _savedPostalCode;
  String? _savedCountryCode;
  String? abcd;

  @override
  void initState() {
    super.initState();
    _loadPreviousSearchValues();

    apiServicesfromzip = ApiServicesforzip();
    apiServices = ApiServices();
    apiServicesforlocations = ApiServicesforlocation();
  }

  void _loadPreviousSearchValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedLocation = prefs.getString('previousLocation');
      _savedPostalCode = prefs.getString('previousPostalCode');
      _savedCountryCode = prefs.getString('previousCountryCode');
    });
  }

  void _saveSearchValues(String a, String b, String c) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      prefs.setString('previousLocation', a);
      prefs.setString('previousPostalCode', b);
      prefs.setString('previousCountryCode', c);
    });
  }

  Future<Map<String, dynamic>> _getFuture() {
    String a = Provider.of<LocationProvider>(context).latitude.toString();
    String b = Provider.of<LocationProvider>(context).longitude.toString();
    if (_savedPostalCode == "nosearch" && _savedLocation != "nosearch") {
      return apiServices.getWeatherData(_savedLocation!);
    } else if (_savedLocation == "nosearch" && _savedPostalCode != "nosearch") {
      return apiServicesfromzip.getWeatherData(
          _savedPostalCode!, _savedCountryCode!);
    } else {
      return apiServicesforlocations.getWeatherData(a, b);
    }
  }

  Future<Map<String, dynamic>> _getFuture1() {
    int? defaultvaluenumber =
        Provider.of<DefaultValueProvider>(context).defaultvaluenumber;
    String? saveddata1 =
        Provider.of<DefaultValueProvider>(context).saveddata1.toString();
    String? saveddata2 =
        Provider.of<DefaultValueProvider>(context).saveddata2.toString();
    if (defaultvaluenumber == 1) {
      return apiServices.getWeatherData(saveddata1);
    } else if (defaultvaluenumber == 2) {
      return apiServicesfromzip.getWeatherData(saveddata1, saveddata2);
    } else {
      return apiServicesforlocations.getWeatherData(saveddata1, saveddata2);
    }
  }

  Widget _getValues() {
    if (_savedLocation == "nosearch") {
      return Text(
        'Previous Search1: $_savedLocation ,  $_savedPostalCode, $_savedCountryCode',
        style: const TextStyle(color: Colors.white, fontSize: 20),
      );
    } else {
      return Text(
        'Previous Search2: $_savedLocation, $_savedPostalCode ,  $_savedCountryCode',
        style: const TextStyle(color: Colors.white, fontSize: 20),
      );
    }
  }

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

  Future<MaterialPageRoute<dynamic>> _ontapbox() async {
    if (_savedPostalCode == "nosearch" && _savedLocation != "nosearch") {
      return MaterialPageRoute<dynamic>(
        builder: (context) => WeatherPage(location: _savedLocation!),
      );
    } else if (_savedLocation == "nosearch" && _savedPostalCode != "nosearch") {
      return MaterialPageRoute<dynamic>(
        builder: (context) => WeatherPagebyzip(
            location: _savedPostalCode!, countrycode: _savedCountryCode!),
      );
    } else {
      return MaterialPageRoute<dynamic>(
        builder: (context) => LocationPageForOnpress(
            latitude:
                Provider.of<LocationProvider>(context).latitude.toString(),
            longitude:
                Provider.of<LocationProvider>(context).longitude.toString()),
      );
    }
  }

  Future<MaterialPageRoute<dynamic>> _ontapbox2(BuildContext context) async {
    int? a = context.read<DefaultValueProvider>().defaultvaluenumber;
    if (a == 1) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => WeatherPage(
          location: context.read<DefaultValueProvider>().saveddata1.toString(),
        ),
      );
    } else if (a == 2) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => WeatherPagebyzip(
          location: context.read<DefaultValueProvider>().saveddata1.toString(),
          countrycode:
              context.read<DefaultValueProvider>().saveddata2.toString(),
        ),
      );
    } else {
      return MaterialPageRoute<dynamic>(
        builder: (context) => LocationPageForOnpress(
          latitude: context.read<DefaultValueProvider>().saveddata1.toString(),
          longitude: context.read<DefaultValueProvider>().saveddata2.toString(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 7, 7, 7),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg13.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Container(
              margin: const EdgeInsets.only(top: 0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.save_as_rounded,
                          color: Colors.white,
                          size: 25.0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Default weather data',
                              style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    FutureBuilder<Map<String, dynamic>>(
                      future: _getFuture1(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: Container(
                              margin: const EdgeInsets.only(top: 40),
                              child: const CircularProgressIndicator(),
                            ),
                          );
                        } else if (snapshot.data == null) {
                          return Column(
                            children: [
                              Container(
                                margin:
                                    const EdgeInsets.only(top: 40, bottom: 10),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 2, 18, 40),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Text(
                                  'Your default data will display here',
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
                        } else if (snapshot.hasError) {
                          return Column(
                            children: [
                              Container(
                                margin:
                                    const EdgeInsets.only(top: 350, bottom: 10),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 14, 15, 15),
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
                              (weatherData['main']['feels_like'] as num)
                                  .toDouble();

                          double celsiusTemp = kelvinTemp - 273.15;
                          double celsiusTemp1 = kelvinTemp1 - 273.15;
                          
                          return GestureDetector(
                            onTap: () async {
                              MaterialPageRoute<dynamic> route =
                                  await _ontapbox2(context);
                              Navigator.push(
                                context,
                                route,
                              );
                            },
                            child: SingleChildScrollView(
                              child: Container(
                                margin: const EdgeInsets.only(top: 10),
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color:
                                              const Color.fromARGB(255, 6, 6, 6)
                                                  .withOpacity(0.5),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.9,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            '${weatherData['name']}',
                                                            style:
                                                                const TextStyle(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      236,
                                                                      236,
                                                                      239),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 25,
                                                              fontFamily:
                                                                  'Anta', // You can replace 'Anta' with your preferred font family
                                                            ),
                                                          ),
                                                          Text(
                                                            '${celsiusTemp.toStringAsFixed(2)}°',
                                                            textAlign:
                                                                TextAlign.start,
                                                            style:
                                                                const TextStyle(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      236,
                                                                      236,
                                                                      239),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 50,
                                                              fontFamily:
                                                                  'Anta', // You can replace 'Anta' with your preferred font family
                                                            ),
                                                          ),
                                                          Text(
                                                            'feels  ${celsiusTemp1.toStringAsFixed(2)}°  ',
                                                            textAlign:
                                                                TextAlign.start,
                                                            style:
                                                                const TextStyle(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      236,
                                                                      236,
                                                                      239),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16,
                                                              fontFamily:
                                                                  'Anta',
                                                              // You can replace 'Anta' with your preferred font family
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Column(
                                                        children: [
                                                          Image.network(
                                                            'https://openweathermap.org/img/wn/${weatherData['weather'][0]['icon']}@2x.png',
                                                            width: 140,
                                                            height: 115,
                                                          ),
                                                          TextDurationButton(
                                                            coverColor: const Color
                                                                    .fromARGB(
                                                                    255,
                                                                    6,
                                                                    6,
                                                                    6)
                                                                .withOpacity(
                                                                    0),
                                                            width: 150,
                                                            height: 50,
                                                            duration:
                                                                const Duration(
                                                                    seconds: 10),
                                                            text: Text(
                                                              ' clouds ${weatherData['clouds']['all']} %',
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              style:
                                                                  const TextStyle(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        236,
                                                                        236,
                                                                        239),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 16,
                                                                fontFamily:
                                                                    'Anta',
                                                                // You can replace 'Anta' with your preferred font family
                                                              ),
                                                            ),
                                                            onPressed: () {
                                                              LocalNotifications
                                                                  .showSimpleNotification(
                                                                title: '${weatherData['name']}',
                                                                body: 
                                                                    '${weatherData['weather'][0]['description']}    Temp ${celsiusTemp.toStringAsFixed(2)}°   clouds ${weatherData['clouds']['all']} %',
                                                                payload:
                                                                    "payload",
                                                                
                                                              );
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  top: 0, bottom: 0, left: 30),
                                              child: Text(
                                                '${weatherData['weather'][0]['description']}',
                                                textAlign: TextAlign.start,
                                                style: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 236, 236, 239),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 40,
                                                  fontFamily: 'Anta',
                                                  // You can replace 'Roboto' with your preferred font family
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () {
                        _saveSearchValues("nosearch", "nosearch", "nosearch");
                        _savedLocation = "nosearch";
                        _savedPostalCode = "nosearch";
                        _savedCountryCode = "nosearch";

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LocationPage()),
                        ).then((_) {
                          // Clear text controller values after navigation
                          _locationController.clear();
                          _postalCodeController.clear();
                          _countryCodeController.clear();
                        });
                      },
                      icon: const Icon(Icons.location_on), // Location icon
                      label: const Text(
                        'Current Location',
                        style: TextStyle(
                          color: Color.fromARGB(
                              255, 238, 238, 242), // Set text color to white
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                            255, 12, 29, 58), // Dark blue color
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(8), // Square button
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    GetLocationWidget(locationController: _locationController),
                    ElevatedButton.icon(
                      onPressed: () {
                        _saveSearchValues(
                            _locationController.text, "nosearch", "nosearch");
                        _savedLocation = _locationController.text;
                        _savedPostalCode = "nosearch";
                        _savedCountryCode = "nosearch";

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WeatherPage(
                              location: _locationController.text,
                            ),
                          ),
                        ).then((_) {
                          // Clear text controller values after navigation
                          _locationController.clear();
                          _postalCodeController.clear();
                          _countryCodeController.clear();
                        });
                      },
                      icon:
                          const Icon(Icons.my_location_sharp), // Location icon
                      label: const Text(
                        'Search Location',
                        style: TextStyle(
                          color: Color.fromARGB(
                              255, 238, 238, 242), // Set text color to white
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                            255, 12, 29, 58), // Dark blue color
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(8), // Square button
                        ), // <-- Added closing parenthesis here
                      ),
                    ),

                    GetPostalCodeWidget(
                        postalCodeController: _postalCodeController,
                        countryCodeController: _countryCodeController),
                    // const Text(
                    //   'ex- Sri lanka --> Lk',
                    //   style: TextStyle(
                    //     color: Color.fromARGB(255, 222, 216, 216),
                    //   ),
                    // ),
                    // Consumer<LocationProvider>(
                    //   builder: (context, locationProvider, child) {
                    //     String latitude = locationProvider.latitude ?? 'N/A';
                    //     String longitude = locationProvider.longitude ?? 'N/A';
                    //     return Text(
                    //       ' atitude: $latitude,$longitude',
                    //       style: const TextStyle(
                    //         color: Color.fromARGB(255, 222, 216, 216),
                    //       ),
                    //     );
                    //   },
                    // ),
                    // Consumer<DefaultValueProvider>(
                    //   builder: (context, DefaultValueProvider, child) {
                    //     int defaultvaluenumber =
                    //         DefaultValueProvider.defaultvaluenumber ?? 0;
                    //     String saveddata1 =
                    //         DefaultValueProvider.saveddata1 ?? 'N/A';
                    //     String saveddata2 =
                    //         DefaultValueProvider.saveddata2 ?? 'N/A';
                    //     return Text(
                    //       ' $defaultvaluenumber, $saveddata1,$saveddata2',
                    //       style: const TextStyle(
                    //         color: Color.fromARGB(255, 222, 216, 216),
                    //       ),
                    //     );
                    //   },
                    // ),
                    // Text(
                    //   "${Provider.of<LocationProvider>(context).latitude ?? 'N/A'}, ${Provider.of<LocationProvider>(context).longitude ?? 'N/A'}",
                    //   style: const TextStyle(
                    //     color: Color.fromARGB(255, 222, 216, 216),
                    //   ),
                    // ),
                    ElevatedButton.icon(
                      onPressed: () {
                        _saveSearchValues(
                            "nosearch",
                            _postalCodeController.text,
                            _countryCodeController.text);

                        _savedLocation = "nosearch";
                        _savedPostalCode = _postalCodeController.text;
                        _savedCountryCode = _countryCodeController.text;

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WeatherPagebyzip(
                                location: _postalCodeController.text,
                                countrycode: _countryCodeController.text),
                          ),
                        ).then((_) {
                          // Clear text controller values after navigation
                          _locationController.clear();
                          _postalCodeController.clear();
                          _countryCodeController.clear();
                        });
                      },
                      icon:
                          const Icon(Icons.my_location_sharp), // Location icon
                      label: const Text(
                        'Search Location',
                        style: TextStyle(
                          color: Color.fromARGB(
                              255, 238, 238, 242), // Set text color to white
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                            255, 12, 29, 58), // Dark blue color
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(8), // Square button
                        ), // <-- Added closing parenthesis here
                      ),
                    ),
                    //_getValues(),
                    const SizedBox(height: 10),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.history,
                          color: Colors.white,
                          size: 40,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Previous Searched',
                              style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    FutureBuilder<Map<String, dynamic>>(
                      future: _getFuture(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: Container(
                              margin: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height *
                                      0.86),
                              child: const CircularProgressIndicator(),
                            ),
                          );
                        } else if (snapshot.data == null) {
                          return Column(
                            children: [
                              Container(
                                margin:
                                    const EdgeInsets.only(top: 10, bottom: 10),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 2, 18, 40),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Text(
                                  'Your previous data will display here',
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
                                  height: 800), // Add space below the Container
                            ],
                          );
                        } else if (snapshot.hasError) {
                          return Column(
                            children: [
                              Container(
                                margin:
                                    const EdgeInsets.only(top: 10, bottom: 10),
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
                                  height: 600), // Add space below the Container
                            ],
                          );
                        } else {
                          Map<String, dynamic> weatherData = snapshot.data!;
                          double kelvinTemp =
                              (weatherData['main']['temp'] as num).toDouble();
                          double kelvinTemp1 =
                              (weatherData['main']['feels_like'] as num)
                                  .toDouble();

                          double celsiusTemp = kelvinTemp - 273.15;
                          double celsiusTemp1 = kelvinTemp1 - 273.15;
                          // Convert meters to kilometers
                          // Format to display 2 decimal places

                          return GestureDetector(
                            onTap: () async {
                              MaterialPageRoute<dynamic> route =
                                  await _ontapbox();
                              Navigator.push(
                                context,
                                route,
                              );
                            },
                            child: SingleChildScrollView(
                                child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: const Color.fromARGB(255, 6, 6, 6)
                                        .withOpacity(0.5),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Row(
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '${weatherData['name']}',
                                                      style: const TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 236, 236, 239),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 25,
                                                        fontFamily:
                                                            'Anta', // You can replace 'Anta' with your preferred font family
                                                      ),
                                                    ),
                                                    Text(
                                                      '${celsiusTemp.toStringAsFixed(2)}°',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: const TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 236, 236, 239),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 50,
                                                        fontFamily:
                                                            'Anta', // You can replace 'Anta' with your preferred font family
                                                      ),
                                                    ),
                                                    Text(
                                                      'feels  ${celsiusTemp1.toStringAsFixed(2)}°  ',
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: const TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 236, 236, 239),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                        fontFamily: 'Anta',
                                                        // You can replace 'Anta' with your preferred font family
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 15,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Image.network(
                                                      'https://openweathermap.org/img/wn/${weatherData['weather'][0]['icon']}@2x.png',
                                                      width: 140,
                                                      height: 115,
                                                    ),
                                                    Text(
                                                      'clouds ${weatherData['clouds']['all']} %',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: const TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 236, 236, 239),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                        fontFamily: 'Anta',
                                                        // You can replace 'Anta' with your preferred font family
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            top: 0, bottom: 0, left: 30),
                                        child: Text(
                                          '${weatherData['weather'][0]['description']}',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: Color.fromARGB(
                                                255, 236, 236, 239),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 40,
                                            fontFamily: 'Anta',
                                            // You can replace 'Roboto' with your preferred font family
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '<Tap anywhere weather details blocks to see full details>',
                                          style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 255, 255, 255),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                )
                              ],
                            )),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
