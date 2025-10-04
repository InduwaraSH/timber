// FormCO.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timber_app/CO/TreeForm.dart';

/// Removes default glow effect when scrolling
class NoGlowBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
    BuildContext context,
    Widget child,
    AxisDirection axisDirection,
  ) {
    return child;
  }
}

class FormCO extends StatefulWidget {
  // Incoming data from previous page (kept exactly as your original)
  final String office_location;
  final String SerialNum;
  final String poc;
  final String LetterNo;
  final String DateInformed;

  const FormCO({
    super.key,
    required this.office_location,
    required this.SerialNum,
    required this.poc,
    required this.LetterNo,
    required this.DateInformed,
  });

  @override
  State<FormCO> createState() => _FormCOState();
}

class _FormCOState extends State<FormCO> {
  // controllers (kept same semantics)
  final DonorController = TextEditingController();
  final PlaceOfCoupeController = TextEditingController();
  final LetterNoController = TextEditingController();
  final ConditionController = TextEditingController();
  final OfficerNameController = TextEditingController();
  final OfficerPositionController = TextEditingController();
  final DateinforemedController = TextEditingController();
  final TreeCountController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // If you want to prefill LetterNo from incoming payload, uncomment:
    // LetterNoController.text = widget.LetterNo;
    // DateinforemedController.text = widget.DateInformed;
  }

  @override
  void dispose() {
    DonorController.dispose();
    PlaceOfCoupeController.dispose();
    LetterNoController.dispose();
    ConditionController.dispose();
    OfficerNameController.dispose();
    OfficerPositionController.dispose();
    DateinforemedController.dispose();
    TreeCountController.dispose();
    super.dispose();
  }

  void _clear() {
    DonorController.clear();
    PlaceOfCoupeController.clear();
    LetterNoController.clear();
    ConditionController.clear();
    OfficerNameController.clear();
    OfficerPositionController.clear();
    DateinforemedController.clear();
    TreeCountController.clear();
  }

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse(DateinforemedController.text) ?? now,
      firstDate: DateTime(2000),
      lastDate: DateTime(now.year + 2),
    );
    if (picked != null) {
      DateinforemedController.text =
          "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
    }
  }

  void _onNextPressed() {
    // validate fields
    if (_formKey.currentState == null) return;
    if (!_formKey.currentState!.validate()) return;

    final int treeCount = int.tryParse(TreeCountController.text.trim()) ?? 0;
    if (treeCount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tree count must be greater than 0'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    // Build and push the TreeQuesForm (exact parameter mapping kept)
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TreeQuesForm(
          treeCount: treeCount,
          sectionNumber: DonorController.text.trim(),
          PlaceOfCoupe: PlaceOfCoupeController.text.trim(),
          LetterNo: LetterNoController.text.trim(),
          Condition: ConditionController.text.trim(),
          OfficerName: OfficerNameController.text.trim(),
          OfficerPosition: OfficerPositionController.text.trim(),
          Dateinforemed: DateinforemedController.text.trim(),
          office_location: widget.office_location,
          position: "pos",
          serialnum: widget.SerialNum,
          placeofcoupe: widget.poc,
          dateinformed_from_rm: widget.DateInformed,
          onDone: _clear,
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'sfpro',
        color: Color(0xFF5C50C5),
        fontWeight: FontWeight.w600,
        fontSize: 14,
      ),
    );
  }

  Widget _fieldCard({
    required String label,
    required TextEditingController controller,
    String? hint,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 240),
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label(label),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: onTap,
            child: AbsorbPointer(
              absorbing: readOnly,
              child: TextFormField(
                controller: controller,
                keyboardType: keyboardType,
                readOnly: readOnly && onTap != null,
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                decoration: InputDecoration(
                  hintText: hint ?? '',
                  border: InputBorder.none,
                  isDense: true,
                ),
                style: const TextStyle(fontSize: 16, fontFamily: 'AbhayaLibre', fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // iOS-like look: light background, soft card fields
    return ScrollConfiguration(
      behavior: NoGlowBehavior(),
      child: Scaffold(
        backgroundColor: const Color(0xFFFAFBFF),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: const Color(0xFF5C50C5),
          centerTitle: true,
          title: const Text(
            "Timber Request — FormCO",
            style: TextStyle(fontFamily: 'sfpro', fontWeight: FontWeight.w600),
          ),
        ),
        body: SafeArea(
          minimum: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 28),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Header text with incoming office location
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "From : RM Branch in ${widget.office_location}",
                      style: const TextStyle(
                        fontFamily: 'DMSerif',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF5C50C5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "To : ARM Branch",
                      style: TextStyle(
                        fontFamily: 'DMSerif',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  // Form fields
                  _fieldCard(
                    label: "දැව භාරදුන් ආයතනය හා කොට්ඨාසය",
                    controller: DonorController,
                    hint: "Enter Institution & Section",
                  ),
                  _fieldCard(
                    label: "දැව භාරදුන් ආයතනයේ ලිපි අංකය හා දිනය",
                    controller: LetterNoController,
                    hint: widget.LetterNo.isNotEmpty ? widget.LetterNo : "Enter Letter No & Date",
                  ),
                  _fieldCard(
                    label: "දැව ඇති ස්ථානය",
                    controller: PlaceOfCoupeController,
                    hint: widget.poc.isNotEmpty ? widget.poc : "Enter Location",
                  ),
                  _fieldCard(
                    label: "දැව පවතින ස්වභාවය",
                    controller: ConditionController,
                    hint: "Enter Condition",
                  ),
                  _fieldCard(
                    label: "පරික්ෂා කල නිලධාරියාගේ නම",
                    controller: OfficerNameController,
                    hint: "Enter Officer Name",
                  ),
                  _fieldCard(
                    label: "පරික්ෂා කල නිලධාරියාගේ තනතුර",
                    controller: OfficerPositionController,
                    hint: "Enter Officer Position",
                  ),

                  // Date field (read-only + picker)
                  _fieldCard(
                    label: "පරික්ෂා කල දිනය",
                    controller: DateinforemedController,
                    hint: widget.DateInformed.isNotEmpty ? widget.DateInformed : "Select Date",
                    readOnly: true,
                    onTap: () => _pickDate(context),
                  ),

                  _fieldCard(
                    label: "ගස් ගණන",
                    controller: TreeCountController,
                    hint: "Enter Tree Count (e.g. 3)",
                    keyboardType: TextInputType.number,
                  ),

                  const SizedBox(height: 20),

                  // Action row
                  Row(
                    children: [
                      Expanded(
                        child: CupertinoButton(
                          color: Colors.grey.shade200,
                          onPressed: () {
                            _clear();
                          },
                          child: const Text("Clear", style: TextStyle(color: Colors.black)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CupertinoButton.filled(
                          onPressed: _onNextPressed,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text("Next"),
                              SizedBox(width: 8),
                              Icon(Icons.double_arrow, color: Colors.white, size: 18),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}