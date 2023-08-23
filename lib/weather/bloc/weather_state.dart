part of 'weather_bloc.dart';

@immutable
sealed class WeatherState extends Equatable {}

class WeatherInitial extends WeatherState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class WeatherLoading extends WeatherState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class WeatherLoaded extends WeatherState {
  final WeatherModel? weather;

  WeatherLoaded({this.weather});

  @override
  // TODO: implement props
  List<Object?> get props => [weather];
}

class WeatherError extends WeatherState {
  final String? message;

  WeatherError({this.message});

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}
