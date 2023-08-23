part of 'weather_search_bloc.dart';

@immutable
sealed class WeatherSearchEvent extends Equatable {}

class SearchWeather extends WeatherSearchEvent {
  final String locationName;

  SearchWeather(this.locationName);

  @override
  List<Object?> get props => [locationName];
}
