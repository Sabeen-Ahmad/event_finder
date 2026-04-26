import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../data/models/event_model.dart';

class EventDetailScreen extends StatefulWidget {
  final EventModel event;

  const EventDetailScreen({super.key, required this.event});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  bool _isSaved = false;

  Color _categoryColor(String category) {
    switch (category) {
      case 'Music':
        return Colors.purple;
      case 'Sports':
        return Colors.blue;
      case 'Tech':
        return const Color(0xFF7B2FBE);
      case 'Food':
        return Colors.orange;
      case 'Arts':
        return Colors.pink;
      case 'Education':
        return Colors.green;
      case 'Wellness':
        return Colors.cyan;
      default:
        return const Color(0xFF7B2FBE);
    }
  }

  String _addMinutes(String time, int minutes) {
    try {
      final parts = time.replaceAll(RegExp(r'[APM\s]'), '').split(':');
      final isPM = time.toUpperCase().contains('PM');
      int hour = int.parse(parts[0]) + (isPM && int.parse(parts[0]) != 12 ? 12 : 0);
      int minute = int.parse(parts[1]);
      final total = hour * 60 + minute + minutes;
      final h = (total ~/ 60) % 24;
      final m = total % 60;
      final suffix = h >= 12 ? 'PM' : 'AM';
      final displayH = h > 12 ? h - 12 : (h == 0 ? 12 : h);
      return '${displayH.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')} $suffix';
    } catch (_) {
      return time;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0D0D1A) : const Color(0xFFF5F6FA);
    final cardColor = isDark ? const Color(0xFF1E1E2E) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF1A1A2E);
    final accent = isDark ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // ── Collapsing Image AppBar ──
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                backgroundColor: const Color(0xFF1A1A2E),
                leading: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: CircleAvatar(
                      backgroundColor: Colors.black45,
                      child: Icon(Icons.arrow_back, color: Colors.white, size: 18),
                    ),
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: GestureDetector(
                      onTap: () => setState(() => _isSaved = !_isSaved),
                      child: CircleAvatar(
                        backgroundColor: Colors.black45,
                        child: Icon(
                          _isSaved ? Icons.favorite : Icons.favorite_border,
                          color: _isSaved ? Colors.redAccent : Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: widget.event.imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(color: Colors.grey.shade300),
                        errorWidget: (_, __, ___) => Container(color: Colors.grey.shade300),
                      ),
                      // Category badge + title overlaid at bottom of image
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.6),
                            ],
                            stops: const [0.5, 1.0],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 20,
                        right: 20,
                        bottom: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                              decoration: BoxDecoration(
                                color: accent.withOpacity(0.25),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: accent.withOpacity(0.5), width: 1),
                              ),
                              child: Text(
                                widget.event.category.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: accent,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.event.title,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                height: 1.25,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),

                      // ── Info pills row ──
                      Row(
                        children: [
                          _InfoPill(
                            icon: Icons.calendar_today_outlined,
                            text: widget.event.date,
                            color: accent,
                            cardColor: cardColor,
                            textColor: textColor,
                          ),
                          const SizedBox(width: 10),
                          _InfoPill(
                            icon: Icons.access_time_outlined,
                            text: widget.event.time,
                            color: accent,
                            cardColor: cardColor,
                            textColor: textColor,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      _InfoPill(
                        icon: Icons.location_on_outlined,
                        text: '${widget.event.location}  ·  ${widget.event.distance} away',
                        color: accent,
                        cardColor: cardColor,
                        textColor: textColor,
                        fullWidth: true,
                      ),

                      const SizedBox(height: 20),

                      // ── Organizer row ──
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: accent.withOpacity(0.2),
                              child: Icon(Icons.groups_outlined, size: 20, color: accent),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Organizer',
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey.shade500)),
                                Text(
                                  'EventFinder Team',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: textColor,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                              decoration: BoxDecoration(
                                color: accent.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'Follow',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: accent),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // ── Stats row ──
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _StatItem(
                              icon: Icons.people_outline,
                              value: '+500',
                              label: 'Attendees',
                              color: accent,
                              textColor: textColor,
                            ),
                            Container(width: 1, height: 40, color: Colors.grey.withOpacity(0.2)),
                            _StatItem(
                              icon: Icons.near_me_outlined,
                              value: widget.event.distance,
                              label: 'From you',
                              color: accent,
                              textColor: textColor,
                            ),
                            Container(width: 1, height: 40, color: Colors.grey.withOpacity(0.2)),
                            _StatItem(
                              icon: Icons.confirmation_number_outlined,
                              value: 'Free',
                              label: 'Entry',
                              color: accent,
                              textColor: textColor,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // ── About card ──
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('About',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: textColor)),
                            const SizedBox(height: 12),
                            Text(
                              widget.event.description,
                              style: const TextStyle(
                                  fontSize: 14, height: 1.7, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // ── Agenda card ──
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Agenda',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: textColor)),
                            const SizedBox(height: 16),
                            _AgendaItem(time: widget.event.time, title: 'Registration Opens', color: accent, textColor: textColor),
                            _AgendaItem(time: _addMinutes(widget.event.time, 30), title: 'Opening Ceremony', color: accent, textColor: textColor),
                            _AgendaItem(time: _addMinutes(widget.event.time, 90), title: 'Main Program Begins', color: accent, textColor: textColor),
                            _AgendaItem(time: _addMinutes(widget.event.time, 180), title: 'Closing & Networking', color: accent, textColor: textColor, isLast: true),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // ── Ticket card ──
                      Container(
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(widget.event.title,
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: textColor),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis),
                                        const SizedBox(height: 6),
                                        Text(
                                          '${widget.event.date} · ${widget.event.time}',
                                          style: TextStyle(fontSize: 12, color: accent),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: accent.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text('Free',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: accent)),
                                  ),
                                ],
                              ),
                            ),
                            // Dashed tear line
                            _DashedDivider(color: Colors.grey.withOpacity(0.3)),
                            // Barcode
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 52,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: List.generate(42, (i) {
                                        const heights = [
                                          1.0, 0.6, 1.0, 0.8, 0.5, 1.0, 0.7, 0.9,
                                          0.6, 1.0, 0.5, 0.8, 1.0, 0.6, 0.9, 0.7,
                                          1.0, 0.5, 0.8, 0.6, 1.0, 0.9, 0.7, 0.5,
                                          1.0, 0.6, 0.8, 1.0, 0.7, 0.9, 0.5, 1.0,
                                          0.6, 0.8, 0.7, 1.0, 0.5, 0.9, 0.6, 1.0,
                                          0.8, 0.7,
                                        ];
                                        return Container(
                                          width: i % 3 == 0 ? 3 : 1.5,
                                          height: 52 * heights[i % heights.length],
                                          margin: const EdgeInsets.symmetric(horizontal: 1),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.withOpacity(0.6),
                                            borderRadius: BorderRadius.circular(1),
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'SCAN AT REGISTRATION',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey.shade500,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // ── CTA Button ──
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
              decoration: BoxDecoration(
                color: cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Redirecting to tickets...')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.confirmation_number_outlined, size: 18),
                    SizedBox(width: 8),
                    Text('Get a Ticket',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.black)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Helper Widgets ──

class _InfoPill extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  final Color cardColor;
  final Color textColor;
  final bool fullWidth;

  const _InfoPill({
    required this.icon,
    required this.text,
    required this.color,
    required this.cardColor,
    required this.textColor,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: color),
          const SizedBox(width: 8),
          Text(text,
              style: TextStyle(
                  fontSize: 13, color: textColor, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  final Color textColor;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(height: 6),
        Text(value,
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold, color: textColor)),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }
}

class _AgendaItem extends StatelessWidget {
  final String time;
  final String title;
  final Color color;
  final Color textColor;
  final bool isLast;

  const _AgendaItem({
    required this.time,
    required this.title,
    required this.color,
    required this.textColor,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              if (!isLast)
                Expanded(
                  child: Container(width: 1, color: Colors.grey.withOpacity(0.2)),
                ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: Row(
                children: [
                  Text(time,
                      style: TextStyle(
                          fontSize: 12,
                          color: color,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(title,
                        style: TextStyle(
                            fontSize: 13,
                            color: textColor,
                            fontWeight: FontWeight.w500)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DashedDivider extends StatelessWidget {
  final Color color;
  const _DashedDivider({required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      child: Row(
        children: [
          Transform.translate(
            offset: const Offset(-10, 0),
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Expanded(child: CustomPaint(painter: _DashPainter(color: color))),
          Transform.translate(
            offset: const Offset(10, 0),
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DashPainter extends CustomPainter {
  final Color color;
  const _DashPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..strokeWidth = 1;
    const dashWidth = 6.0;
    const dashSpace = 4.0;
    double x = 0;
    while (x < size.width) {
      canvas.drawLine(
          Offset(x, size.height / 2), Offset(x + dashWidth, size.height / 2), paint);
      x += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(_) => false;
}