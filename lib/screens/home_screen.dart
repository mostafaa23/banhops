import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_nav_bar.dart';

// ── Data ─────────────────────────────────────────────────────────

const Map<String, List<String>> _governorateData = {
  'Cairo': [
    'Ahmed Helmy', 'Abbasiya', 'Ramses', 'Heliopolis', 'Nasr City', 'Maadi'
  ],
  'Giza': [
    'Giza Square', 'Faisal', 'Haram', 'Dokki', 'Mohandessin'
  ],
  'Qalyubia': [
    'Shubra El Kheima', 'Qalyub', 'Kafr Shukr', 'Al-Obour'
  ],
  'Sharqia': [
    'Zagazig', 'Belbeis', '10th of Ramadan'
  ],
  'Monufia': [
    'Shebin El Kom', 'Quesna', 'Menouf'
  ],
  'Gharbia': [
    'Tanta', 'Mahalla', 'Kafr El Zayat'
  ],
  'Alexandria': [
    'Sidi Gaber', 'Moharram Bek', 'Smouha'
  ],
};

const Map<String, String> _benhaPlacesMaps = {
  'Benha Main Bus Terminal': 'https://www.google.com/maps/search/?api=1&query=Benha+Main+Bus+Terminal',
  'Benha Train Station': 'https://www.google.com/maps/search/?api=1&query=Benha+Train+Station',
  'Wabour El Thalg (Internal Terminal)': 'https://www.google.com/maps/search/?api=1&query=Wabour+El+Thalg+Benha',
  'El Eshara Square': 'https://www.google.com/maps/search/?api=1&query=El+Eshara+Square+Benha',
  'El Mansheya Tunnel': 'https://www.google.com/maps/search/?api=1&query=El+Mansheya+Tunnel+Benha',
  'Saad Zaghloul Square': 'https://www.google.com/maps/search/?api=1&query=Saad+Zaghloul+Square+Benha',
  'El Fellal (Corniche)': 'https://www.google.com/maps/search/?api=1&query=El+Fellal+Corniche+Benha',
  'El Mansheya (Commerce Faculty Street)': 'https://www.google.com/maps/search/?api=1&query=Faculty+of+Commerce+Benha+University',
  'Manshiyet El Noar': 'https://www.google.com/maps/search/?api=1&query=Manshiyet+El+Noar+Benha',
  'Kafr Manaqer': 'https://www.google.com/maps/search/?api=1&query=Kafr+Manaqer+Benha',
  'New Mansheya (El Khalwa)': 'https://www.google.com/maps/search/?api=1&query=New+Mansheya+Benha',
  'Kafr El Gazzar': 'https://www.google.com/maps/search/?api=1&query=Kafr+El+Gazzar+Benha',
  'El Ahram Street': 'https://www.google.com/maps/search/?api=1&query=El+Ahram+Street+Benha',
  'Benha University': 'https://www.google.com/maps/search/?api=1&query=Benha+University',
  'Benha University Hospital': 'https://www.google.com/maps/search/?api=1&query=Benha+University+Hospital',
};

final List<String> _benhaPlaces = _benhaPlacesMaps.keys.toList();

// ── HomeScreen ────────────────────────────────────────────────────

class HomeScreen extends StatefulWidget {
  final ValueChanged<NavTab> onNavigate;
  final void Function(String from, String to) onShowRouteDetails;

  const HomeScreen({
    super.key,
    required this.onNavigate,
    required this.onShowRouteDetails,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedGovernorate = 'Cairo';
  late String _selectedCity;
  String? _selectedBenhaPlace; // جعلناها قابلة للحذف (null) لتبدأ فارغة حتى يختار المستخدم

  @override
  void initState() {
    super.initState();
    _selectedCity = _governorateData['Cairo']!.first;
  }

  void _onGovernorateChanged(String? value) {
    if (value == null) return;
    setState(() {
      _selectedGovernorate = value;
      _selectedCity = _governorateData[value]!.first;
    });
  }

  void _handleGetRoutes() {
    if (_selectedBenhaPlace == null) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.pleaseSelectDestination)),
      );
      return;
    }
    final from = '$_selectedCity, $_selectedGovernorate';
    final to = _selectedBenhaPlace!;
    widget.onShowRouteDetails(from, to);
  }

  void _openGoogleMaps() async {
    if (_selectedBenhaPlace == null) return;
    final urlString = _benhaPlacesMaps[_selectedBenhaPlace];
    if (urlString != null) {
      final Uri url = Uri.parse(urlString);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.couldNotLaunchMaps)),
        );
      }
    }
  }

  void _openCollegePicker() async {
    final l10n = AppLocalizations.of(context)!;
    final colleges = [
      l10n.facultyOfCommerce,
      l10n.facultyOfArts,
      l10n.facultyOfEducation,
      l10n.facultyOfSpecificEducation,
      l10n.facultyOfPhysicalEducation,
      l10n.facultyOfLaw,
      l10n.facultyOfAppliedArts,
    ];
    
    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _DestinationSheet(
        title: l10n.selectCollege,
        subtitle: l10n.benhaUniversityColleges,
        items: colleges,
        accent: Colors.orange,
        icon: Icons.school_outlined,
      ),
    );
    if (result != null) {
      setState(() => _selectedBenhaPlace = 'Benha University');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: AppColors.primary,
      extendBody: true,
      body: Column(
        children: [
          _BlueHeader(l10n: l10n),
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(36),
                topRight: Radius.circular(36),
              ),
              child: Container(
                color: Colors.white,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 28, 20, 140),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _PlanTripCard(
                        l10n: l10n,
                        selectedGovernorate: _selectedGovernorate,
                        selectedCity: _selectedCity,
                        selectedBenhaPlace: _selectedBenhaPlace,
                        cities: _governorateData[_selectedGovernorate]!,
                        onGovernorateChanged: _onGovernorateChanged,
                        onCityChanged: (v) {
                          if (v != null) setState(() => _selectedCity = v);
                        },
                        onBenhaPlaceChanged: (v) {
                          if (v != null) setState(() => _selectedBenhaPlace = v);
                        },
                        onGetRoutes: _handleGetRoutes,
                        onMapPressed: _openGoogleMaps,
                      ),

                      const SizedBox(height: 32),

                      Text(
                        l10n.popularZones,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 16),

                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 1.1,
                        children: [
                          _ZoneCard(
                            label: l10n.university,
                            emoji: '🎓',
                            bgColor: const Color(0xFFFFF7ED),
                            onTap: _openCollegePicker,
                          ),
                          _ZoneCard(
                            label: l10n.hospital,
                            emoji: '🏥',
                            bgColor: const Color(0xFFFEF2F2),
                            onTap: () {
                              setState(() => _selectedBenhaPlace = 'Benha University Hospital');
                            },
                          ),
                          _ZoneCard(
                            label: l10n.busTerminal,
                            emoji: '🚌',
                            bgColor: const Color(0xFFF0FDF4),
                            onTap: () {
                              setState(() => _selectedBenhaPlace = 'Benha Main Bus Terminal');
                            },
                          ),
                          _ZoneCard(
                            label: l10n.trainStation,
                            emoji: '🚆',
                            bgColor: const Color(0xFFFFFBEB),
                            onTap: () {
                              setState(() => _selectedBenhaPlace = 'Benha Train Station');
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        active: NavTab.home,
        onTap: widget.onNavigate,
      ),
    );
  }
}

// ── Plan Trip Card ────────────────────────────────────────────────
class _PlanTripCard extends StatelessWidget {
  final AppLocalizations l10n;
  final String selectedGovernorate;
  final String selectedCity;
  final String? selectedBenhaPlace;
  final List<String> cities;
  final ValueChanged<String?> onGovernorateChanged;
  final ValueChanged<String?> onCityChanged;
  final ValueChanged<String?> onBenhaPlaceChanged;
  final VoidCallback onGetRoutes;
  final VoidCallback onMapPressed;

  const _PlanTripCard({
    required this.l10n,
    required this.selectedGovernorate,
    required this.selectedCity,
    required this.selectedBenhaPlace,
    required this.cities,
    required this.onGovernorateChanged,
    required this.onCityChanged,
    required this.onBenhaPlaceChanged,
    required this.onGetRoutes,
    required this.onMapPressed,
  });

  @override
  Widget build(BuildContext context) {
    // التحقق مما إذا كان المستخدم قد حدد مكاناً في بنها بالفعل
    final bool hasSelection = selectedBenhaPlace != null;

    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.10),
            blurRadius: 40,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.route_rounded,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                l10n.planTrip,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF111827),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          _DropdownField(
            label: l10n.selectGovernorate,
            value: selectedGovernorate,
            items: _governorateData.keys.toList(),
            onChanged: onGovernorateChanged,
            prefixIcon: Icons.map_outlined,
          ),

          const SizedBox(height: 16),

          _DropdownField(
            label: l10n.selectCityArea,
            value: selectedCity,
            items: cities,
            onChanged: onCityChanged,
            prefixIcon: Icons.location_city_outlined,
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(child: Container(height: 1, color: const Color(0xFFE5E7EB))),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: Color(0xFFEFF6FF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_downward_rounded,
                  color: AppColors.primary,
                  size: 16,
                ),
              ),
              Expanded(child: Container(height: 1, color: const Color(0xFFE5E7EB))),
            ],
          ),

          const SizedBox(height: 16),

          // حقل بنها مع إضافة لوجو الخريطة الملون (Google Maps Pins Style) والتحكم في ظهوره
          _DropdownField(
            label: l10n.whereInBenha,
            value: selectedBenhaPlace,
            hint: l10n.chooseDestination,
            items: _benhaPlaces,
            onChanged: onBenhaPlaceChanged,
            prefixIcon: Icons.place_outlined,
            accentColor: const Color(0xFF059669),
            suffixWidget: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: hasSelection ? 1.0 : 0.0,
              child: hasSelection
                  ? Padding(
                padding: const EdgeInsets.only(right: 6.0),
                child: GestureDetector(
                  onTap: onMapPressed,
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        )
                      ],
                    ),
                    // بناء وتنسيق اللوجو ليكون شبيهاً تماماً بصورة download.png الملونة
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        const Icon(Icons.location_on_rounded, color: Color(0xFF34A853), size: 30), // الجسم الأخضر الأساسي
                        Positioned(
                          top: 7,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        // تلميحات ألوان الـ Pin العلوية (أزرق، أحمر، أصفر) لإضفاء المظهر الملون الفاخر
                        const Positioned(
                          top: 5,
                          left: 10,
                          child: Icon(Icons.brightness_1, color: Color(0xFFEA4335), size: 8),
                        ),
                        const Positioned(
                          top: 5,
                          right: 10,
                          child: Icon(Icons.brightness_1, color: Color(0xFF4285F4), size: 8),
                        ),
                      ],
                    ),
                  ),
                ),
              )
                  : const SizedBox.shrink(),
            ),
          ),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: GestureDetector(
              onTap: onGetRoutes,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0xFF4A90E2), Color(0xFF2563EB)],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF4A90E2).withValues(alpha: 0.40),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l10n.getRoutes,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 22),
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

// ── Dropdown Field ────────────────────────────────────────────────
class _DropdownField extends StatelessWidget {
  final String label;
  final String? value;
  final String? hint;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final IconData prefixIcon;
  final Color? accentColor;
  final Widget? suffixWidget;

  const _DropdownField({
    required this.label,
    this.value,
    this.hint,
    required this.items,
    required this.onChanged,
    required this.prefixIcon,
    this.accentColor,
    this.suffixWidget,
  });

  @override
  Widget build(BuildContext context) {
    final color = accentColor ?? AppColors.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF6A7282),
              letterSpacing: 1.2,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: value,
                  hint: hint != null ? Text(hint!, style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 15)) : null,
                  onChanged: onChanged,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF6A7282)),
                  isExpanded: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(prefixIcon, color: color, size: 20),
                    filled: false,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                  ),
                  dropdownColor: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  items: items
                      .map(
                        (item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Color(0xFF111827),
                        ),
                      ),
                    ),
                  )
                      .toList(),
                ),
              ),
              if (suffixWidget != null) suffixWidget!,
            ],
          ),
        ),
      ],
    );
  }
}

// ── Blue Header ───────────────────────────────────────────────────
class _BlueHeader extends StatelessWidget {
  final AppLocalizations l10n;
  
  const _BlueHeader({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.welcome,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'BanHops',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 60,
                height: 60,
                child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Positioned(
                      top: -5,
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 50,
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
}

// ── Zone Card ─────────────────────────────────────────────────────
class _ZoneCard extends StatelessWidget {
  final String label;
  final String emoji;
  final Color bgColor;
  final VoidCallback onTap;

  const _ZoneCard({
    required this.label,
    required this.emoji,
    required this.bgColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: const Color(0xFFF3F4F6)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(20),
              ),
              alignment: Alignment.center,
              child: Text(emoji, style: const TextStyle(fontSize: 28)),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Destination Sheet ─────────────────────────────────────────────
class _DestinationSheet extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<String> items;
  final Color accent;
  final IconData icon;

  const _DestinationSheet({
    required this.title,
    this.subtitle,
    required this.items,
    required this.accent,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollCtrl) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(36)),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 16, 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 40,
                            height: 4,
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          if (subtitle != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              subtitle!,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.close, size: 20),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView.separated(
                  controller: scrollCtrl,
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (_, i) {
                    final item = items[i];
                    return InkWell(
                      borderRadius: BorderRadius.circular(24),
                      onTap: () => Navigator.of(context).pop(item),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.04),
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                              child: Icon(icon, color: accent),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                            const Icon(Icons.arrow_forward, size: 18, color: AppColors.textMuted),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}