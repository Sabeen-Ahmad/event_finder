import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/services/event_services.dart';
import 'events_event.dart';
import 'events_state.dart';

class EventsBloc extends Bloc<EventsEvent, EventsState> {
  final EventService _eventService;

  EventsBloc(this._eventService) : super(EventsInitial()) {
    on<FetchEvents>(_onFetchEvents);
  }

  Future<void> _onFetchEvents(
      FetchEvents event,
      Emitter<EventsState> emit,
      ) async {
    emit(EventsLoading());
    try {
      final events = await _eventService.fetchEvents();
      emit(EventsLoaded(events: events));
    } catch (e) {
      emit(EventsError(e.toString()));
    }
  }
}