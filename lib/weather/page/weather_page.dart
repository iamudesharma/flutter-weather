import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import '../../widgets/Loading.dart';
import '../../widgets/Weather.dart';
import '../bloc/weather_bloc.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  @override
  void initState() {
    Future.microtask(() async {
      final position = await _determinePosition();
      BlocProvider.of<WeatherBloc>(context).add(
          FetchWeather(lat: position?.latitude, long: position?.longitude));
    });

    super.initState();
  }

  Future<Position?> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    try {
      final position = await Geolocator.getCurrentPosition();
      return position;
    } catch (e) {
      return null;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherBloc, WeatherState>(
        buildWhen: (previous, current) => true,
        builder: (context, state) {
          return switch (state) {
            WeatherInitial() => Loading(),
            WeatherLoading() => Loading(),
            WeatherLoaded() => Weather(
                weather: state.weather,
                onRefresh: () async {
                  final position = await Geolocator.getCurrentPosition();
                  BlocProvider.of<WeatherBloc>(context).add(FetchWeather(
                      lat: position.latitude, long: position.longitude));
                },
              ),
            WeatherError() => Scaffold(
                body: Center(
                  child: Text('Something went wrong!'),
                ),
              ),
          };
        });
  }
}
