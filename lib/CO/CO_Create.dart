import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:timber_app/CO/TreeForm.dart';

/// Ultra-modern FormCO redesign
/// - Larger, tappable cards for easy data entry
/// - Smooth interactive animations
/// - Gradient backgrounds & soft shadows
/// - Simplified typography for premium look
/// - Better UX (tap anywhere on card to focus field + blinking cursor)

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
  final DonorController = TextEditingController();
  final PlaceOfCoupeController = TextEditingController();
  final ConditionController = TextEditingController();
  final OfficerNameController = TextEditingController();
  final OfficerPositionController = TextEditingController();
  final DateinforemedController = TextEditingController();
  final TreeCountController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String? _focusedField;

  @override
  void dispose() {
    DonorController.dispose();
    PlaceOfCoupeController.dispose();
    ConditionController.dispose();
    OfficerNameController.dispose();
    OfficerPositionController.dispose();
    DateinforemedController.dispose();
    TreeCountController.dispose();
    super.dispose();
  }

  void _clear() {
    for (var controller in [
      DonorController,
      PlaceOfCoupeController,
      ConditionController,
      OfficerNameController,
      OfficerPositionController,
      DateinforemedController,
      TreeCountController,
    ]) {
      controller.clear();
    }
    setState(() {
      _focusedField = null;
    });
  }

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse(DateinforemedController.text) ?? now,
      firstDate: DateTime(2000),
      lastDate: DateTime(now.year + 2),
      builder: (context, child) => Theme(
        data: Theme.of(
          context,
        ).copyWith(colorScheme: ColorScheme.light(primary: Color(0xFF6C63FF))),
        child: child!,
      ),
    );
    if (picked != null) {
      DateinforemedController.text =
          "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      setState(() {});
    }
  }

  void _onNextPressed() {
    if (_formKey.currentState == null) return;
    if (!_formKey.currentState!.validate()) return;

    final int treeCount = int.tryParse(TreeCountController.text.trim()) ?? 0;
    if (treeCount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Tree count must be greater than 0',
            style: TextStyle(
              fontFamily: 'sfproRoundSemiB',
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TreeQuesForm(
          treeCount: treeCount,
          sectionNumber: DonorController.text.trim(),
          PlaceOfCoupe: PlaceOfCoupeController.text.trim(),
          LetterNo: widget.LetterNo,
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

  Widget _infoCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF65B0FF), Color(0xFF4A7BFF)],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontFamily: "sfproRoundSemiB",
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                    fontFamily: "sfproRoundSemiB",
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _editableCard({
    required IconData icon,
    required String label,
    required TextEditingController controller,
    String? hint,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    final focusNode = FocusNode(); // for blinking cursor

    return GestureDetector(
      onTap: () {
        if (!readOnly) focusNode.requestFocus();
        setState(() => _focusedField = label);
      },
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(
          begin: 1.0,
          end: _focusedField == label ? 1.02 : 1.0,
        ),
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        builder: (context, scale, child) {
          return Transform.scale(scale: scale, child: child);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: _focusedField == label
                    ? Colors.blue.withOpacity(0.25)
                    : Colors.grey.withOpacity(0.08),
                blurRadius: _focusedField == label ? 18 : 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF1FF),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: Colors.blue, size: 25),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontFamily: "sfproRoundSemiB",
                        color: _focusedField == label
                            ? Colors.blue
                            : Colors.grey[600],
                        fontWeight: FontWeight.bold,
                        fontSize: _focusedField == label ? 20 : 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    TextField(
                      focusNode: focusNode,
                      controller: controller,
                      keyboardType: keyboardType,
                      readOnly: readOnly,
                      showCursor: true,
                      cursorColor: Colors.blueAccent,
                      onTap:
                          onTap ??
                          () {
                            setState(() => _focusedField = label);
                          },
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'sfproRoundSemiB',
                        color: const Color(0xFF1B1C1E),
                      ),
                      decoration: InputDecoration(
                        hintText: hint ?? '',
                        border: InputBorder.none,
                        isDense: true,
                        hintStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'sfproRoundSemiB',
                          color: Colors.grey[400],
                        ),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: NoGlowBehavior(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF9F8FF),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Details',
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'sfproRoundSemiB',
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 0),
                  Text(
                    'From: ${widget.office_location}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 15),
                  ),
                  const SizedBox(height: 26),

                  _infoCard(
                    icon: Iconsax.calendar,
                    label: 'Date Informed',
                    value: widget.DateInformed,
                  ),
                  _infoCard(
                    icon: Iconsax.document,
                    label: 'Letter No',
                    value: widget.LetterNo,
                  ),
                  _infoCard(
                    icon: Iconsax.hashtag,
                    label: 'Serial Number',
                    value: widget.SerialNum,
                  ),
                  _infoCard(
                    icon: Iconsax.location,
                    label: 'Place of Coupe',
                    value: widget.poc,
                  ),

                  const SizedBox(height: 12),
                  const Divider(height: 30, thickness: 0.6),

                  _editableCard(
                    icon: Iconsax.building_44,
                    label: 'Timber Donor (Inst./Div.)',
                    controller: DonorController,
                    hint: 'Institution & Section',
                  ),
                  _editableCard(
                    icon: Iconsax.location,
                    label: 'Location of Timber',
                    controller: PlaceOfCoupeController,
                    hint: 'Coupe Place',
                  ),
                  _editableCard(
                    icon: Iconsax.sun,
                    label: 'Condition of the Timber',
                    controller: ConditionController,
                    hint: 'Condition',
                  ),
                  _editableCard(
                    icon: Iconsax.user,
                    label: 'Name of Inspecting Officer',
                    controller: OfficerNameController,
                    hint: 'Officer Name',
                  ),
                  _editableCard(
                    icon: Iconsax.star_14,
                    label: 'Designation of Inspector',
                    controller: OfficerPositionController,
                    hint: 'Officer Position',
                  ),
                  _editableCard(
                    icon: Iconsax.calendar_1,
                    label: 'Date of Inspection',
                    controller: DateinforemedController,
                    hint: 'Select Date',
                    readOnly: true,
                    onTap: () => _pickDate(context),
                  ),
                  _editableCard(
                    icon: Iconsax.tree4,
                    label: 'Number of Trees',
                    controller: TreeCountController,
                    hint: 'Tree Count',
                    keyboardType: TextInputType.number,
                  ),

                  const SizedBox(height: 26),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: BorderSide(color: Colors.grey.shade300),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            backgroundColor: Colors.white,
                          ),
                          onPressed: _clear,
                          child: const Text(
                            'Clear',
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontFamily: "sfproRoundSemiB",
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 84),
                      Expanded(
                        child: FloatingActionButton(
                          backgroundColor: Colors.black,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          onPressed: _onNextPressed,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              SizedBox(width: 8),
                              Icon(
                                Iconsax.arrow_right_3,
                                size: 25,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
