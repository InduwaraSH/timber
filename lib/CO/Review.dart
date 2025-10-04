import 'package:flutter/material.dart';

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
  final String position;

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
    required this.position,
  });

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  final Map<int, int> _hoveredIndices = {};
  int _hoveredSummary = -1;

  IconData _getIconForField(String field) {
    if (field.contains("වර්ගය")) return Icons.nature;
    if (field.contains("උස")) return Icons.height;
    return Icons.notes;
  }

  Widget _buildSummaryCard() {
    final infoItems = [
      {"label": "Serial No:", "value": widget.serialnum},
      {"label": "Date Informed:", "value": widget.dateinformed_from_rm},
      {"label": "Area of Coupe:", "value": widget.placeofcoupe},
      {"label": "Position:", "value": widget.position},
      {"label": "Location:", "value": widget.location},
      {"label": "Section No:", "value": widget.new_sectionNumber},
      {"label": "Place of Coupe:", "value": widget.PlaceOfCoupe},
      {"label": "Letter No:", "value": widget.LetterNo},
      {"label": "Condition:", "value": widget.Condition},
      {"label": "Officer Name:", "value": widget.OfficerName},
      {"label": "Officer Position:", "value": widget.OfficerPosition},
      {"label": "Date Informed:", "value": widget.Dateinforemed},
      {"label": "Tree Count:", "value": widget.treeCount},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: infoItems.asMap().entries.map((entry) {
        int idx = entry.key;
        var item = entry.value;
        return MouseRegion(
          onEnter: (_) => setState(() => _hoveredSummary = idx),
          onExit: (_) => setState(() => _hoveredSummary = -1),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _hoveredSummary == idx
                  ? Colors.blue.shade50
                  : Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                if (_hoveredSummary == idx)
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    item["label"]!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Text(
                    item["value"]!,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTreeCard(int treeIndex) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Tree ${treeIndex + 1} of ${widget.treeControllers.length}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => widget.onEdit(treeIndex),
                  icon: const Icon(Icons.edit, color: Colors.blueAccent),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...widget.fields.map((f) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(_getIconForField(f), size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 3,
                      child: Text(
                        f,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Text(
                        widget.treeControllers[treeIndex][f]!.text.trim(),
                        textAlign: TextAlign.right,
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
      backgroundColor: const Color(0xFFFAFBFF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.blueAccent,
        elevation: 0,
        title: const Text(
          "Review Trees",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSummaryCard(),
            const SizedBox(height: 16),
            ...List.generate(
              widget.treeControllers.length,
              (i) => _buildTreeCard(i),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: widget.onConfirm,
        label: const Text("Confirm & Save"),
      ),
    );
  }
}
