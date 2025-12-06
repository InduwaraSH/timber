import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:iconsax/iconsax.dart';

// --- THEME COLORS ---
const Color kBgColor = Color(0xFFF9F8FF);
const Color kCardStart = Color(0xFFF9FBFF);
const Color kCardEnd = Color(0xFFEFF3FF);
const Color kTextPrimary = Colors.black87;
const Color kTextSecondary = Colors.black54;

// ---------------------------------------------------------------------------
// WIDGET: REUSABLE DATA BUBBLE
// ---------------------------------------------------------------------------
class DataBubble extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? iconColor;

  const DataBubble({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: [kCardStart, kCardEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor ?? Colors.grey.shade600, size: 24),
          const SizedBox(width: 15),
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'sfproRoundSemiB',
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: kTextSecondary,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontFamily: 'sfproRoundSemiB',
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: kTextPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// SCREEN 1: YEAR SELECTION (UNCHANGED)
// ---------------------------------------------------------------------------
class YearSelectionScreen extends StatefulWidget {
  final String rmOffice;
  final String armOffice;

  const YearSelectionScreen({
    super.key,
    required this.rmOffice,
    required this.armOffice,
  });

  @override
  State<YearSelectionScreen> createState() => _YearSelectionScreenState();
}

class _YearSelectionScreenState extends State<YearSelectionScreen> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  final ScrollController _scrollController = ScrollController();
  List<String> years = [];
  bool _isLoading = true;
  bool _showHeader = true;

  @override
  void initState() {
    super.initState();
    _fetchYears();
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_showHeader) setState(() => _showHeader = false);
      } else if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (!_showHeader) setState(() => _showHeader = true);
      }
    });
  }

  Future<void> _fetchYears() async {
    try {
      final snapshot = await _dbRef
          .child('Completed_jobs')
          .child(widget.rmOffice)
          .child(widget.armOffice)
          .get();
      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        setState(() {
          years = data.keys.map((k) => k.toString()).toList()
            ..sort((a, b) => b.compareTo(a));
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: _showHeader ? 80 : 0,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _showHeader
                  ? Row(
                      children: [
                        const Text(
                          "Archived",
                          style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'sfproRoundSemiB',
                          ),
                        ),
                      ],
                    )
                  : null,
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.only(top: 10, bottom: 50),
                      itemCount: years.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => JobListScreen(
                                rmOffice: widget.rmOffice,
                                armOffice: widget.armOffice,
                                year: years[index],
                              ),
                            ),
                          ),
                          child: DataBubble(
                            label: "Year Folder",
                            value: years[index],
                            icon: Iconsax.folder_open,
                            iconColor: Colors.amber[700],
                          ),
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

// ---------------------------------------------------------------------------
// SCREEN 2: JOB LIST (UNCHANGED)
// ---------------------------------------------------------------------------
class JobListScreen extends StatefulWidget {
  final String rmOffice;
  final String armOffice;
  final String year;

  const JobListScreen({
    super.key,
    required this.rmOffice,
    required this.armOffice,
    required this.year,
  });

  @override
  State<JobListScreen> createState() => _JobListScreenState();
}

class _JobListScreenState extends State<JobListScreen> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> jobs = [];
  bool _isLoading = true;
  bool _showHeader = true;

  @override
  void initState() {
    super.initState();
    _fetchJobs();
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_showHeader) setState(() => _showHeader = false);
      } else if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (!_showHeader) setState(() => _showHeader = true);
      }
    });
  }

  Future<void> _fetchJobs() async {
    try {
      final snapshot = await _dbRef
          .child('Completed_jobs')
          .child(widget.rmOffice)
          .child(widget.armOffice)
          .child(widget.year)
          .get();
      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        List<Map<String, dynamic>> loadedJobs = [];
        data.forEach((key, value) {
          final content = value as Map<dynamic, dynamic>;
          String poc = "Unknown";
          // Try to get POC from the new structure or fallback
          if (content.containsKey('info')) {
            poc = content['info']['poc'] ?? "Unknown";
          } else if (content.containsKey('timberReportheadlines')) {
            poc = content['timberReportheadlines']['placeofcoupe'] ?? "Unknown";
          }

          loadedJobs.add({
            "serial": key.toString(),
            "poc": poc,
            "fullData": content,
          });
        });
        setState(() {
          jobs = loadedJobs;
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: _showHeader ? 100 : 0,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _showHeader
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Jobs ${widget.year}",
                          style: const TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'sfproRoundSemiB',
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "${jobs.length}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    )
                  : null,
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.only(top: 10, bottom: 50),
                      itemCount: jobs.length,
                      itemBuilder: (context, index) {
                        final job = jobs[index];
                        return GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => JobDetailScreen(
                                serialNum: job['serial'],
                                jobData: job['fullData'],
                              ),
                            ),
                          ),
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 16,
                            ),
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(22),
                              gradient: const LinearGradient(
                                colors: [kCardStart, kCardEnd],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Iconsax.location,
                                      size: 28,
                                      color: Colors.blueAccent,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        job['poc'],
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'sfproRoundSemiB',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Serial Number",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      "#${job['serial']}",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
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

// ---------------------------------------------------------------------------
// SCREEN 3: DETAILS (MANUAL MAPPING FOR OVERVIEW)
// ---------------------------------------------------------------------------
class JobDetailScreen extends StatefulWidget {
  final String serialNum;
  final Map<dynamic, dynamic> jobData;

  const JobDetailScreen({
    super.key,
    required this.serialNum,
    required this.jobData,
  });

  @override
  State<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  bool _showHeader = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_showHeader) setState(() => _showHeader = false);
      } else if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (!_showHeader) setState(() => _showHeader = true);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // --- ICON HELPER ---
  IconData _getIcon(String label) {
    label = label.toLowerCase();
    if (label.contains('date')) return Iconsax.calendar;
    if (label.contains('money') ||
        label.contains('income') ||
        label.contains('profit')) {
      return Iconsax.money;
    }
    if (label.contains('tree')) return Iconsax.tree;
    if (label.contains('loc') || label.contains('place'))
      return Iconsax.location;
    if (label.contains('officer') || label.contains('co')) return Iconsax.user;
    if (label.contains('serial') || label.contains('id'))
      return Iconsax.hashtag;
    return Iconsax.info_circle;
  }

  @override
  Widget build(BuildContext context) {
    // 1. EXTRACT DATA FOR OVERVIEW (MANUAL MAPPING)
    // Adjusting to your structure: checking 'info' first, then fallback to 'timberReportheadlines'
    final Map<dynamic, dynamic> info =
        widget.jobData['info'] ?? widget.jobData['timberReportheadlines'] ?? {};

    final String armId = info['ARM_Id'] ?? "Not Available";
    final String RM_Office = info['RM Office'] ?? "N/A";
    final String RM_Id = info['RM_Id'] ?? "N/A";
    final String Status = info['Status'] ?? "N/A";
    final String ARM_location = info['ARM_location'] ?? widget.serialNum;
    final String coName = info['CO_name'] ?? "N/A";
    final String coId = info['CO_id'] ?? "N/A";
    final String poc = info['placeofcoupe'] ?? "N/A";
    final String placeOfCoupe = info['PlaceOfCoupe_exact_from_arm'] ?? "N/A";
    final String dateInformed = info['DateInformed'] ?? "N/A";
    final String dateinformed_from_rm = info['dateinformed_from_rm'] ?? "N/A";
    final String letterNo = info['LetterNo'] ?? "N/A";
    final String serialNo = info['serialnum'] ?? "N/A";
    final String officerName = info['OfficerName'] ?? "N/A";
    final String officerPos = info['OfficerPosition&name'] ?? "N/A";
    final String donorDetails = info['donor_details'] ?? "N/A";
    final String condition = info['Condition'] ?? "N/A";
    final String treeCount = info['TreeCount']?.toString() ?? "N/A";
    final String reject_details = info['reject_details'] ?? "N/A";

    // Monetary values (Check info, then try procurement if missing)
    final String income = info['income']?.toString() ?? "0";
    final String outcome = info['outcome']?.toString() ?? "0";
    final String profit = info['Profit']?.toString() ?? "0";

    // 2. PREPARE THE MANUAL LIST
    final List<Map<String, String>> overviewList = [
      {"label": "ARM ID", "value": armId},
      {"label": "RM Office", "value": RM_Office},
      {"label": "RM ID", "value": RM_Id},
      {"label": "Status", "value": Status},
      {"label": "ARM Location", "value": ARM_location},
      {"label": "CO Name", "value": coName},
      {"label": "CO ID", "value": coId},
      {"label": "Place of Coupe", "value": placeOfCoupe},
      {"label": "POC", "value": poc},
      {"label": "Date Informed(letter)", "value": dateInformed},
      {"label": "Date Informed (RM)", "value": dateinformed_from_rm},
      {"label": "Letter No.", "value": letterNo},
      {"label": "Serial No.", "value": serialNo},
      {"label": "Officer Name", "value": officerName},
      {"label": "Officer Position", "value": officerPos},
      {"label": "Donor Details", "value": donorDetails},
      {"label": "Condition", "value": condition},
      {"label": "Tree Count", "value": treeCount},
      {"label": "Income", "value": income},
      {"label": "Outcome", "value": outcome},
      {"label": "Profit", "value": profit},
      {"label": "Rejection Details", "value": reject_details},
    ];

    // 3. OTHER DATA
    final treesRaw = widget.jobData['allTrees'];
    final procRaw = widget.jobData['procument'];

    List<dynamic> treeList = [];
    if (treesRaw is List) {
      treeList = treesRaw;
    } else if (treesRaw is Map) {
      treeList = treesRaw.values.toList();
    }

    return Scaffold(
      backgroundColor: kBgColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // --- DYNAMIC HEADER ---
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: _showHeader ? 100 : 0,
              padding: const EdgeInsets.only(left: 30, right: 30, top: 10),
              child: _showHeader
                  ? Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Info",
                            style: const TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'sfproRoundSemiB',
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        FloatingActionButton(
                          mini: true,
                          backgroundColor: Colors.black,
                          onPressed: () => Navigator.pop(context),
                          child: const Icon(
                            Iconsax.arrow_left_2,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    )
                  : null,
            ),

            // --- SLIDING SEGMENT ---
            Container(
              height: 50,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.grey.withOpacity(0.1)),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey.shade500,
                labelStyle: const TextStyle(
                  fontFamily: 'sfproRoundSemiB',
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                tabs: const [
                  Tab(text: "Overview"),
                  Tab(text: "Trees"),
                  Tab(text: "Procument"),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // --- CONTENT AREA ---
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildOverviewTab(overviewList),
                  _buildTreesTab(treeList),
                  _buildProcurementTab(procRaw),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- TAB 1: OVERVIEW (USING MANUAL LIST) ---
  Widget _buildOverviewTab(List<Map<String, String>> dataList) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 10, bottom: 50),
      itemCount: dataList.length,
      itemBuilder: (context, index) {
        final item = dataList[index];
        final label = item['label']!;
        final value = item['value']!;

        // Skip "N/A" values if you prefer, or show them.
        // Uncomment below to hide empty fields:
        // if (value == "N/A") return const SizedBox.shrink();

        return DataBubble(
          label: label,
          value: value,
          icon: _getIcon(label),
          iconColor: Colors.blueGrey,
        );
      },
    );
  }

  // --- TAB 2: TREES (Dynamic) ---
  Widget _buildTreesTab(List<dynamic> treeList) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 10, bottom: 50),
      itemCount: treeList.length,
      itemBuilder: (context, index) {
        final tree = treeList[index] as Map;
        String title = tree['Tree Type'] ?? 'Tree #${index + 1}';
        Map<String, dynamic> details = Map.from(tree)..remove('Tree Type');

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          padding: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            gradient: const LinearGradient(colors: [kCardStart, kCardEnd]),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.12),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 25.0,
                  top: 20.0,
                  bottom: 10,
                ),
                child: Row(
                  children: [
                    const Icon(Iconsax.tree, size: 28, color: Colors.green),
                    const SizedBox(width: 10),
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'sfproRoundSemiB',
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  ],
                ),
              ),
              ...details.entries.map(
                (e) => DataBubble(
                  label: e.key.toString(),
                  value: e.value.toString(),
                  icon: Iconsax.ruler,
                  iconColor: Colors.green[700],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // --- TAB 3: PROCUREMENT (Dynamic) ---
  Widget _buildProcurementTab(dynamic procRaw) {
    if (procRaw == null || (procRaw is! Map)) {
      return const Center(child: Text("No Procurement Data"));
    }

    final Map data = procRaw;
    return ListView(
      padding: const EdgeInsets.only(top: 10, bottom: 50),
      children: data.entries.map((entry) {
        final val = entry.value;
        if (val is Map) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 30, top: 10),
                child: Text(
                  entry.key.toString().toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ),
              ...val.entries.map(
                (e) => DataBubble(
                  label: e.key.toString(),
                  value: e.value.toString(),
                  icon: Iconsax.receipt_item,
                ),
              ),
            ],
          );
        }
        return DataBubble(
          label: entry.key.toString(),
          value: val.toString(),
          icon: Iconsax.wallet_money,
        );
      }).toList(),
    );
  }
}
