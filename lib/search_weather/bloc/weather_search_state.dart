part of 'weather_search_bloc.dart';

@immutable
sealed class WeatherSearchState extends Equatable {}

class WeatherSearchInitial extends WeatherSearchState {
  @override
  List<Object?> get props => [];
}

class WeatherSearchLoading extends WeatherSearchState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class WeatherSearchLoaded extends WeatherSearchState {
  final WeatherModel? weather;

  WeatherSearchLoaded({this.weather});

  @override
  // TODO: implement props
  List<Object?> get props => [weather];
}

class WeatherSearchError extends WeatherSearchState {
  final String? message;

  WeatherSearchError({this.message});

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}
