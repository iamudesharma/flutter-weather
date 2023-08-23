// ignore_for_file: public_member_api_docs, sort_constructors_first, unnecessary_import
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/weather_repository.dart';
import '../../widgets/Loading.dart';
import '../../widgets/Weather.dart';
import '../bloc/bloc.dart';

class WeatherSearchProvider extends StatelessWidget {
  const WeatherSearchProvider({
    Key? key,
    required this.city,
  }) : super(key: key);
  final String city;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WeatherSearchBloc(
        weatherRepository: WeatherRepository(),
      ),
      child: WeatherSearch(
        city: city,
      ),
    );
  }
}

class WeatherSearch extends StatefulWidget {
  const WeatherSearch({
    Key? key,
    required this.city,
  }) : super(key: key);
  final String city;

  @override
  State<WeatherSearch> createState() => _WeatherSearchState();
}

class _WeatherSearchState extends State<WeatherSearch> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    context.read<WeatherSearchBloc>().add(SearchWeather(widget.city));

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherSearchBloc, WeatherSearchState>(
        builder: (context, state) {
      return switch (state) {
        WeatherSearchInitial() => Loading(),
        WeatherSearchLoading() => Loading(),
        WeatherSearchLoaded() => Weather(
            isFromSearch: true,
            weather: state.weather,
            onRefresh: () async {
              context.read<WeatherSearchBloc>().add(SearchWeather(
                    widget.city,
                  ));
            },
          ),
        WeatherSearchError() => Scaffold(
            body: Center(
              child: Text('Something went wrong!'),
            ),
          )
      };
    });
  }
}
