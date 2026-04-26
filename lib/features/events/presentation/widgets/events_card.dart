import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../data/models/event_model.dart';

class EventCard extends StatelessWidget {
  final EventModel event;
  final VoidCallback onTap;

  const EventCard({super.key, required this.event, required this.onTap});

  Color _categoryColor(String category) {
    switch (category) {
      case 'Music':
        return Colors.purple;
      case 'Sports':
        return Colors.blue;
      case 'Tech':
        return Colors.teal;
      case 'Food':
        return Colors.orange;
      case 'Arts':
        return Colors.pink;
      case 'Education':
        return Colors.green;
      case 'Wellness':
        return Colors.cyan;
      default:
        return Colors.indigo;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // ── Full card background image ──
            CachedNetworkImage(
              imageUrl: event.imageUrl,
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(
                color: Colors.grey.shade300,
                child: const Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (_, __, ___) => Container(
                color: Colors.grey.shade300,
                child: const Icon(Icons.broken_image,
                    size: 60, color: Colors.grey),
              ),
            ),

            // ── Gradient overlay ──
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.transparent,
                    Colors.black.withOpacity(0.5),
                    Colors.black.withOpacity(0.9),
                  ],
                  stops: const [0.0, 0.4, 0.7, 1.0],
                ),
              ),
            ),

            // ── Category chip (top left) ──
            Positioned(
              top: 16,
              left: 16,
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _categoryColor(event.category),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  event.category,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.touch_app_outlined,
                        size: 13, color: Colors.white70),
                    SizedBox(width: 4),
                    Text('View Details',
                        style:
                        TextStyle(fontSize: 11, color: Colors.white70)),
                  ],
                ),
              ),
            ),

            // ── Bottom text content ──
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title
                    Text(
                      event.title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    // Date & Time row
                    Row(
                      children: [
                        const Icon(Icons.calendar_today_outlined,
                            size: 14, color: Colors.white70),
                        const SizedBox(width: 6),
                        Text(
                          '${event.date}  •  ${event.time}',
                          style: const TextStyle(
                              fontSize: 13, color: Colors.white70),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // Location & Distance row
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined,
                            size: 14, color: Colors.white70),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            '${event.location}  •  ${event.distance}',
                            style: const TextStyle(
                                fontSize: 13, color: Colors.white70),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}