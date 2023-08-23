part of 'weather_bloc.dart';

@immutable
sealed class WeatherEvent extends Equatable {}

class FetchWeather extends WeatherEvent {
  final double? lat;
  final double? long;

  FetchWeather({this.lat, this.long});

  @override
  List<Object?> get props => [lat, long];
}

// class SearchWeather extends WeatherEvent {
//    final String locationName;

//   SearchWeather(this.locationName);

//   @override
//   List<Object?> get props => [locationName];
// }
