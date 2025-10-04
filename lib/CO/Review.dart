import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ReviewPage extends StatefulWidget {
  final List<String> fields;
  final List<Map<String, TextEditingController>> treeControllers;
  final Function(int) onEdit;
  final VoidCallback onConfirm;
  final String treeCount;
  final String new_sectionNumber;
  final String PlaceOfCoupe;
  final String LetterNo;
  final String Condition;
  final String OfficerName;
  final String OfficerPosition;
  final String Dateinforemed;
  final String location;
  final String serialnum;
  final String dateinformed_from_rm;
  final String placeofcoupe;
 

  const ReviewPage({
    super.key,
    required this.fields,
    required this.treeControllers,
    required this.onEdit,
    required this.onConfirm,
    required this.location,
    required this.treeCount,
    required this.new_sectionNumber,
    required this.PlaceOfCoupe,
    required this.LetterNo,
    required this.Condition,
    required this.OfficerName,
    required this.OfficerPosition,
    required this.Dateinforemed,
    required this.serialnum,
    required this.dateinformed_from_rm,
    required this.placeofcoupe,
    
  });

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  int _hoveredSummary = -1;

  IconData _getIconForField(String field) {
    if (field.contains("වර්ගය")) return Iconsax.tree4;
    if (field.contains("උස")) return Iconsax.arrow_up_2;
    return Iconsax.note_2;
  }

  Widget _summaryItem(String label, String value, int index) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 200),
      tween: Tween(begin: 1.0, end: _hoveredSummary == index ? 1.02 : 1.0),
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: MouseRegion(
            onEnter: (_) => setState(() => _hoveredSummary = index),
            onExit: (_) => setState(() => _hoveredSummary = -1),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(vertical: 5),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [Color(0xFFF9FBFF), Color(0xFFEFF3FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _hoveredSummary == index
                        ? Colors.blueAccent.withOpacity(0.25)
                        : Colors.grey.withOpacity(0.08),
                    blurRadius: _hoveredSummary == index ? 14 : 8,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontFamily: 'sfproRoundSemiB',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      value,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'sfproRoundSemiB',
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSummaryCard() {
    final infoItems = [
      {"label": "Serial No", "value": widget.serialnum},
      {"label": "Date Informed (RM)", "value": widget.dateinformed_from_rm},
      {"label": "Area of Coupe", "value": widget.placeofcoupe},
     
      {"label": "Location", "value": widget.location},
      {"label": "Section No", "value": widget.new_sectionNumber},
      {"label": "Place of Coupe", "value": widget.PlaceOfCoupe},
      {"label": "Letter No", "value": widget.LetterNo},
      {"label": "Condition", "value": widget.Condition},
      {"label": "Officer Name", "value": widget.OfficerName},
      {"label": "Officer Position", "value": widget.OfficerPosition},
      {"label": "Date of Inspection", "value": widget.Dateinforemed},
      {"label": "Tree Count", "value": widget.treeCount},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: infoItems
          .asMap()
          .entries
          .map(
            (entry) => _summaryItem(
              entry.value["label"]!,
              entry.value["value"]!,
              entry.key,
            ),
          )
          .toList(),
    );
  }

  Widget _buildTreeCard(int treeIndex) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 1.0, end: 1.0),
      duration: const Duration(milliseconds: 150),
      builder: (context, scale, child) =>
          Transform.scale(scale: scale, child: child),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          gradient: const LinearGradient(
            colors: [Color(0xFFF9FBFF), Color(0xFFEFF3FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Tree ${treeIndex + 1} of ${widget.treeControllers.length}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'sfproRoundSemiB',
                  ),
                ),
                const Spacer(),
                InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => widget.onEdit(treeIndex),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6C63FF),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purple.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Row(
                      children: [
                        Icon(Iconsax.edit, size: 16, color: Colors.white),
                        SizedBox(width: 6),
                        Text(
                          "Edit",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'sfproRoundSemiB',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...widget.fields.map((f) {
              final value =
                  widget.treeControllers[treeIndex][f]?.text.trim() ?? "";
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      _getIconForField(f),
                      size: 22,
                      color: const Color(0xFF2E6AFF),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 3,
                      child: Text(
                        f,
                        style: const TextStyle(
                          fontFamily: 'sfproRoundSemiB',
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Text(
                        value,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontFamily: 'sfproRoundSemiB',
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F8FF),

      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Summary",
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'sfproRoundSemiB',
                ),
              ),
              const SizedBox(height: 16),
              _buildSummaryCard(),
              const SizedBox(height: 30),
              const Text(
                "Tree Details",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'sfproRoundSemiB',
                ),
              ),
              const SizedBox(height: 16),
              ...List.generate(widget.treeControllers.length, _buildTreeCard),
              const SizedBox(height: 90),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: FloatingActionButton.extended(
          backgroundColor: const Color(0xFF6C63FF),
          elevation: 6,
          onPressed: widget.onConfirm,
          label: const Row(
            children: [
              Text(
                "Confirm & Save",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'sfproRoundSemiB',
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 8),
              Icon(Iconsax.tick_circle, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
