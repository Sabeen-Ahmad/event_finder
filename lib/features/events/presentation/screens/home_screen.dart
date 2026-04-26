import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import '../../../../core/theme/theme_cubit.dart';
import '../../data/models/event_model.dart';
import '../bloc/events_bloc.dart';
import '../bloc/events_event.dart';
import '../bloc/events_state.dart';
import '../widgets/events_card.dart';
import 'event_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final CardSwiperController _swiperController = CardSwiperController();
  List<EventModel> _allEvents = [];
  List<EventModel> _filteredEvents = [];

  @override
  void initState() {
    super.initState();
    final state = context.read<EventsBloc>().state;
    if (state is EventsLoaded) {
      _allEvents = state.events;
      _filteredEvents = state.events;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _swiperController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    setState(() {
      _filteredEvents = query.isEmpty
          ? _allEvents
          : _allEvents
          .where((e) =>
      e.title.toLowerCase().contains(query.toLowerCase()) ||
          e.category.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Future<void> _refresh() async {
    context.read<EventsBloc>().add(const FetchEvents());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
      isDark ? const Color(0xFF0D0D1A) : const Color(0xFFF5F6FA),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 10,),
            // ── Header ──
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              decoration: const BoxDecoration(
                color: Color(0xFF1A1A2E),
                borderRadius:
                BorderRadius.vertical(bottom: Radius.circular(24)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Discover Events',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Swipe to explore events near you',
                            style: TextStyle(
                                fontSize: 13, color: Colors.white60),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white12,
                            child: const Icon(Icons.notifications_none,
                                color: Colors.white),
                          ),
                          const SizedBox(width: 8),
                          BlocBuilder<ThemeCubit, ThemeMode>(
                            builder: (context, themeMode) {
                              return GestureDetector(
                                onTap: () =>
                                    context.read<ThemeCubit>().toggleTheme(),
                                child: CircleAvatar(
                                  backgroundColor: Colors.white12,
                                  child: Icon(
                                    themeMode == ThemeMode.light
                                        ? Icons.dark_mode_outlined
                                        : Icons.light_mode_outlined,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Search bar
                  TextField(
                    controller: _searchController,
                    onChanged: _onSearch,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Search events, categories...',
                      hintStyle: const TextStyle(color: Colors.white54),
                      prefixIcon:
                      const Icon(Icons.search, color: Colors.white54),
                      filled: true,
                      fillColor: Colors.white12,
                      contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // ── Body ──
            Expanded(
              child: BlocConsumer<EventsBloc, EventsState>(
                listener: (context, state) {
                  if (state is EventsLoaded) {
                    setState(() {
                      _allEvents = state.events;
                      _filteredEvents = state.events;
                      _searchController.clear();
                    });
                  }
                },
                builder: (context, state) {
                  if (state is EventsLoading || state is EventsInitial) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is EventsError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.wifi_off,
                              size: 48, color: Colors.grey),
                          const SizedBox(height: 12),
                          const Text('Something went wrong',
                              style:
                              TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(state.message,
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey),
                              textAlign: TextAlign.center),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: _refresh,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (_filteredEvents.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.event_busy,
                              size: 48, color: Colors.grey),
                          SizedBox(height: 12),
                          Text('No events found',
                              style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    );
                  }

                  return Column(
                    children: [
                      // ── Swipe hint ──
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${_filteredEvents.length} Events',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? Colors.white70
                                    : const Color(0xFF1A1A2E),
                              ),
                            ),
                            Row(
                              children: const [
                                Icon(Icons.swipe,
                                    size: 16, color: Colors.grey),
                                SizedBox(width: 4),
                                Text('Swipe to explore',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey)),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // ── Card Swiper ──
                      Expanded(
                        child: CardSwiper(
                          controller: _swiperController,
                          cardsCount: _filteredEvents.length,
                          numberOfCardsDisplayed: 3,
                          backCardOffset: const Offset(0, 20),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 40),
                          onSwipe: (previousIndex, currentIndex, direction) {
                            return true;
                          },
                          cardBuilder: (context, index, _, __) {
                            final event = _filteredEvents[index];
                            return EventCard(
                              event: event,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      EventDetailScreen(event: event),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 20,)
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

