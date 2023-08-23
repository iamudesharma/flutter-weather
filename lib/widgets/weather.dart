import 'package:country_state_city/models/city.dart';
import 'package:country_state_city/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';

import '../models/weather.dart';
import '../search_weather/page/page.dart';

class Weather extends StatefulWidget {
  final WeatherModel? weather;
  final Future<void> Function()? onRefresh;
  final bool isFromSearch;

  const Weather(
      {super.key, this.weather, this.onRefresh, this.isFromSearch = false});

  @override
  _WeatherState createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {
  late WeatherModel weather;
  // SimpleLocationResult selectedLocation;
  final searchController = SearchController();
  @override
  void initState() {
    weather = widget.weather!;
    setState(() {});

    searchController.addListener(() {
      if (searchController.text.isNotEmpty) {
        setState(() {});
      }
    });
    super.initState();
  }

  Future<List<City>> getSearch(String query) async {
    final countries = await getCountryCities("IN");

    if (query.isNotEmpty) {
      final city = countries
          .where((element) =>
              element.name.toLowerCase().contains(query.toLowerCase()))
          .toList();

      return city;
    } else {
      return [];
    }

    // var result = await searchController.getSearch(query);
    // print(result);
  }

  @override
  Widget build(BuildContext context) {
    // Map arguments = ModalRoute.of(context).settings.arguments;
    // weather = arguments['weatherData'];
    // selectedLocation = arguments['selectedLocation'];

    return Scaffold(
        body: RefreshIndicator(
      onRefresh: () {
        return widget.onRefresh!();
      },
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(0),
          child: ListView(
            children: [
              ClipPath(
                clipper: OvalBottomBorderClipper(),
                child: Container(
                  padding: EdgeInsets.all(12),
                  color: Theme.of(context).primaryColor,
                  child: Column(
                    children: [
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            if (widget.isFromSearch)
                              IconButton(
                                icon: Icon(
                                  Icons.arrow_back,
                                  size: 30,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    weather.name,
                                    style: GoogleFonts.lato(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    DateFormat("EEE, d LLL")
                                        .format(DateTime.now()),
                                    style: GoogleFonts.lato(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Spacer(),
                            SearchAnchor(
                              viewHintText: "Search the city",
                              searchController: searchController,
                              viewLeading: IconButton(
                                icon: Icon(
                                  Icons.arrow_back,
                                ),
                                onPressed: () {
                                  searchController.closeView("");
                                },
                              ),
                              suggestionsBuilder: (context, controller) async {
                                // Get all countries
                                final city =
                                    await getSearch(searchController.text);

                                // Filter countries by search text

                                return [
                                  city.isEmpty
                                      ? SizedBox()
                                      : searchController.text.isNotEmpty &&
                                              city.isEmpty
                                          ? Text("No Found")
                                          : SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.6,
                                              child: ListView.builder(
                                                itemCount: city.length,
                                                itemBuilder: (context, index) {
                                                  return ListTile(
                                                    title:
                                                        Text(city[index].name),
                                                    onTap: () {
                                                      searchController
                                                          .closeView(
                                                              city[index].name);

                                                      Navigator.of(context)
                                                          .push(
                                                              MaterialPageRoute(
                                                        builder: (_) =>
                                                            WeatherSearchProvider(
                                                          city:
                                                              city[index].name,
                                                        ),
                                                      ));
                                                      // Navigator.pushReplacementNamed(context, '/loading', arguments: countries[index]);
                                                    },
                                                  );
                                                },
                                              ),
                                            )
                                ];
                              },
                              isFullScreen: true,
                              builder: (context, controller) {
                                return IconButton(
                                  icon: Icon(
                                    Icons.search,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    searchController.openView();
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 30, 0, 30),
                        child: Column(children: [
                          Transform.scale(
                              scale: 1.6,
                              child: SvgPicture.asset(
                                  "assets/svgs/${weather.icon}.svg")),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                weather.temperature.toString(),
                                style: GoogleFonts.lato(
                                  fontSize: 65,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "°C",
                                style: GoogleFonts.lato(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                          Text(
                            weather.condition,
                            style: GoogleFonts.lato(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Feels like ${weather.feelsLike}°C",
                            style: GoogleFonts.lato(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                        ]),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Theme.of(context).primaryColor,
                        ),
                        padding: EdgeInsets.all(15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(3.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.white),
                                padding: EdgeInsets.all(10.0),
                                child: Icon(
                                  FontAwesome.eye,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(3.0),
                              child: Text("Visibility",
                                  style: GoogleFonts.lato(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  )),
                            ),
                            Padding(
                              padding: EdgeInsets.all(3.0),
                              child: Text(
                                "${weather.visibility} km",
                                style: GoogleFonts.lato(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Theme.of(context).primaryColor,
                        ),
                        padding: EdgeInsets.all(15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(3.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.white),
                                padding: EdgeInsets.all(10.0),
                                child: Icon(
                                  IonIcons.water,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(3.0),
                              child: Text("Humidity",
                                  style: GoogleFonts.lato(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  )),
                            ),
                            Padding(
                              padding: EdgeInsets.all(3.0),
                              child: Text(
                                "${weather.humidity}%",
                                style: GoogleFonts.lato(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Theme.of(context).primaryColor,
                        ),
                        padding: EdgeInsets.all(15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(3.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.white),
                                padding: EdgeInsets.all(10.0),
                                child: Icon(
                                  FontAwesome.wind,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(3.0),
                              child: Text("Wind Speed",
                                  style: GoogleFonts.lato(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  )),
                            ),
                            Padding(
                              padding: EdgeInsets.all(3.0),
                              child: Text(
                                "${weather.windSpeed.floor()} km/hr",
                                style: GoogleFonts.lato(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ))
            ],
          ),
        ),
      ),
    ));
  }
}
