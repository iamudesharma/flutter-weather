import 'dart:async';

import 'package:Weather/models/weather.dart';
import 'package:Weather/repository/weather_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'weather_search_event.dart';
part 'weather_search_state.dart';

class WeatherSearchBloc extends Bloc<WeatherSearchEvent, WeatherSearchState> {
  final WeatherRepository weatherRepository;
  WeatherSearchBloc({required this.weatherRepository})
      : super(WeatherSearchLoading()) {
    on<SearchWeather>(_onSearch);
  }

  // Future<void> _onSearch(
  //     SearchWeather event, Emitter<WeatherSearchEvent> emit) async {
  //   emit(WeatherSearchLoading());
  //   try {
  //     final WeatherModel weather =
  //         await weatherRepository.searchWeather(event.locationName);
  //     emit(WeatherSearchLoaded(weather: weather));
  //   } catch (e) {
  //     emit(WeatherSearchError(message: e.toString()));
  //   }
  // }

  FutureOr<void> _onSearch(
      SearchWeather event, Emitter<WeatherSearchState> emit) async {
    //     SearchWeather event, Emitter<WeatherSearchEvent> emit) async {
    emit(WeatherSearchLoading());
    try {
      final WeatherModel weather =
          await weatherRepository.searchWeather(event.locationName);
      emit(WeatherSearchLoaded(weather: weather));
    } catch (e) {
      emit(WeatherSearchError(message: e.toString()));
    }
  }
}

// class SimpleBlocObserver extends BlocObserver {
//   const SimpleBlocObserver();

//   @override
//   void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
//     super.onEvent(bloc, event);
//     print('${bloc.runtimeType} $event');
//   }

//   @override
//   void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
//     print('${bloc.runtimeType} $error');
//     super.onError(bloc, error, stackTrace);
//   }

//   @override
//   void onTransition(
//     Bloc<dynamic, dynamic> bloc,
//     Transition<dynamic, dynamic> transition,
//   ) {
//     super.onTransition(bloc, transition);
//     print('$transition');
//   }
// }
