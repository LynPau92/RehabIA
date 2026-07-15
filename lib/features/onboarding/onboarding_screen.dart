import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/app_colors.dart';
import '../../core/providers.dart';
import '../../core/database/app_database.dart';
import '../../core/widgets/mascot_avatar.dart';

/// Pantalla de Onboarding (Módulo 1 de los requerimientos).
///
/// Es un formulario de 4 pasos controlado por un PageView:
///   1. Datos personales
///   2. Selección de lesión y zona
///   3. Nivel de dolor actual
///   4. Cuestionario inicial
///
/// Al terminar, guarda todo en la tabla PatientProfiles y navega a /home.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();
  int _currentStep = 0;
  static const int _totalSteps = 4;

  // --- Datos que vamos acumulando a través de los 4 pasos ---
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _emailController = TextEditingController();
  String _weightUnit = 'kg'; // 'kg' o 'lb'

  Injury? _selectedInjury;

  int _painLevel = 3;

  bool _hasMedicalIndication = false;
  final _daysSinceInjuryController = TextEditingController();
  String _injuryDurationUnit = 'días'; // días | semanas | meses | años
  bool _hadPriorTherapy = false;

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _emailController.dispose();
    _daysSinceInjuryController.dispose();
    super.dispose();
  }

  bool get _canContinueFromStep0 =>
      _nameController.text.trim().isNotEmpty &&
      _ageController.text.trim().isNotEmpty &&
      _weightController.text.trim().isNotEmpty;

  void _goToStep(int step) {
    setState(() => _currentStep = step);
    _pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _finishOnboarding() async {
    final db = ref.read(databaseProvider);

    // El peso siempre se guarda en kg internamente, sin importar qué
    // unidad haya elegido el usuario para escribirlo.
    final rawWeight = double.tryParse(_weightController.text.trim()) ?? 0;
    final weightInKg = _weightUnit == 'lb' ? rawWeight * 0.453592 : rawWeight;

    // Igual con los días: convertimos a días totales según la unidad
    // elegida, porque la base de datos siempre guarda "daysSinceInjury".
    final rawDuration = int.tryParse(_daysSinceInjuryController.text.trim()) ?? 0;
    final daysMultiplier = switch (_injuryDurationUnit) {
      'semanas' => 7,
      'meses' => 30,
      'años' => 365,
      _ => 1,
    };
    final totalDays = rawDuration * daysMultiplier;

    await db.into(db.patientProfiles).insert(
          PatientProfilesCompanion.insert(
            name: _nameController.text.trim(),
            age: int.tryParse(_ageController.text.trim()) ?? 0,
            weightKg: weightInKg,
            email: _emailController.text.trim().isEmpty
                ? const Value.absent()
                : Value(_emailController.text.trim()),
            injuryId: _selectedInjury == null
                ? const Value.absent()
                : Value(_selectedInjury!.id),
            painLevel: Value(_painLevel),
            hasMedicalIndication: Value(_hasMedicalIndication),
            daysSinceInjury: Value(totalDays),
            hadPriorTherapy: Value(_hadPriorTherapy),
          ),
        );

    if (mounted) context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _StepProgressBar(currentStep: _currentStep, totalSteps: _totalSteps),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(), // navegación solo con botones
                onPageChanged: (i) => setState(() => _currentStep = i),
                children: [
                  _PersonalDataStep(
                    nameController: _nameController,
                    ageController: _ageController,
                    weightController: _weightController,
                    emailController: _emailController,
                    weightUnit: _weightUnit,
                    onWeightUnitChanged: (unit) => setState(() => _weightUnit = unit),
                    onChanged: () => setState(() {}),
                  ),
                  _InjurySelectionStep(
                    selectedInjury: _selectedInjury,
                    onSelected: (injury) =>
                        setState(() => _selectedInjury = injury),
                  ),
                  _PainLevelStep(
                    painLevel: _painLevel,
                    onChanged: (v) => setState(() => _painLevel = v),
                  ),
                  _QuestionnaireStep(
                    hasMedicalIndication: _hasMedicalIndication,
                    onMedicalIndicationChanged: (v) =>
                        setState(() => _hasMedicalIndication = v),
                    daysSinceInjuryController: _daysSinceInjuryController,
                    injuryDurationUnit: _injuryDurationUnit,
                    onInjuryDurationUnitChanged: (unit) =>
                        setState(() => _injuryDurationUnit = unit),
                    hadPriorTherapy: _hadPriorTherapy,
                    onPriorTherapyChanged: (v) =>
                        setState(() => _hadPriorTherapy = v),
                  ),
                ],
              ),
            ),
            _NavigationButtons(
              currentStep: _currentStep,
              totalSteps: _totalSteps,
              canContinue: _currentStep == 0 ? _canContinueFromStep0 : true,
              onBack: _currentStep > 0 ? () => _goToStep(_currentStep - 1) : null,
              onNext: _currentStep < _totalSteps - 1
                  ? () => _goToStep(_currentStep + 1)
                  : _finishOnboarding,
              isLastStep: _currentStep == _totalSteps - 1,
            ),
          ],
        ),
      ),
    );
  }
}

/// Barra superior que muestra en qué paso vas (1 de 4, 2 de 4, etc.)
class _StepProgressBar extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const _StepProgressBar({required this.currentStep, required this.totalSteps});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      child: Row(
        children: List.generate(totalSteps, (i) {
          final isActive = i <= currentStep;
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 6,
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : AppColors.border,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          );
        }),
      ),
    );
  }
}

/// Botones de navegación (Atrás / Continuar / Finalizar) en la parte inferior.
class _NavigationButtons extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final bool canContinue;
  final VoidCallback? onBack;
  final VoidCallback onNext;
  final bool isLastStep;

  const _NavigationButtons({
    required this.currentStep,
    required this.totalSteps,
    required this.canContinue,
    required this.onBack,
    required this.onNext,
    required this.isLastStep,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: Row(
        children: [
          if (onBack != null)
            TextButton(
              onPressed: onBack,
              child: const Text('Atrás'),
            ),
          const Spacer(),
          ElevatedButton(
            onPressed: canContinue ? onNext : null,
            child: Text(isLastStep ? 'Finalizar' : 'Continuar'),
          ),
        ],
      ),
    );
  }
}

/// ============ PASO 1: Datos personales ============
class _PersonalDataStep extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController ageController;
  final TextEditingController weightController;
  final TextEditingController emailController;
  final String weightUnit;
  final ValueChanged<String> onWeightUnitChanged;
  final VoidCallback onChanged;

  const _PersonalDataStep({
    required this.nameController,
    required this.ageController,
    required this.weightController,
    required this.emailController,
    required this.weightUnit,
    required this.onWeightUnitChanged,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(child: MascotAvatar(size: 96, pose: MascotPose.saludando)),
          const SizedBox(height: 16),
          Text('Cuéntanos sobre ti', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(
            'Usamos estos datos para personalizar tu plan de rehabilitación.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          TextField(
            controller: nameController,
            onChanged: (_) => onChanged(),
            decoration: const InputDecoration(labelText: 'Nombre completo'),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: ageController,
            onChanged: (_) => onChanged(),
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Edad'),
          ),
          const SizedBox(height: 16),
          // Campo de peso + selector de unidad (kg / lb) lado a lado.
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextField(
                  controller: weightController,
                  onChanged: (_) => onChanged(),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'Peso'),
                ),
              ),
              const SizedBox(width: 12),
              _UnitToggle(
                options: const ['kg', 'lb'],
                selected: weightUnit,
                onSelected: onWeightUnitChanged,
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(labelText: 'Correo electrónico (opcional)'),
          ),
        ],
      ),
    );
  }
}

/// Selector tipo "pastillas" para elegir entre 2 unidades (kg/lb, días/semanas...).
class _UnitToggle extends StatelessWidget {
  final List<String> options;
  final String selected;
  final ValueChanged<String> onSelected;

  const _UnitToggle({required this.options, required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: options.map((option) {
          final isSelected = option == selected;
          return GestureDetector(
            onTap: () => onSelected(option),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                option,
                style: TextStyle(
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// ============ PASO 2: Selección de lesión ============
class _InjurySelectionStep extends ConsumerWidget {
  final Injury? selectedInjury;
  final ValueChanged<Injury> onSelected;

  const _InjurySelectionStep({required this.selectedInjury, required this.onSelected});

  static const Map<String, String> _regionLabels = {
    'miembro_inferior': '🦵 Miembro inferior',
    'miembro_superior': '🦾 Miembro superior',
    'tronco_columna': '🦴 Tronco y columna',
    'otras': '💥 Otras lesiones',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);

    return FutureBuilder<List<Injury>>(
      future: db.select(db.injuries).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final injuries = snapshot.data!;

        // Agrupamos por región para mostrarlas organizadas, como pide
        // tu documento ("catálogo organizado por zona corporal").
        final grouped = <String, List<Injury>>{};
        for (final injury in injuries) {
          grouped.putIfAbsent(injury.bodyRegion, () => []).add(injury);
        }

        return ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text('¿Cuál es tu lesión?', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text(
              'Selecciona la que más se parezca a tu caso.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            for (final region in _regionLabels.keys)
              if (grouped[region] != null) ...[
                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 8),
                  child: Text(
                    _regionLabels[region]!,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                for (final injury in grouped[region]!)
                  _InjuryCard(
                    injury: injury,
                    isSelected: selectedInjury?.id == injury.id,
                    onTap: () => onSelected(injury),
                  ),
              ],
          ],
        );
      },
    );
  }
}

class _InjuryCard extends StatelessWidget {
  final Injury injury;
  final bool isSelected;
  final VoidCallback onTap;

  const _InjuryCard({required this.injury, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isSelected ? AppColors.primary : AppColors.border,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: ListTile(
        onTap: onTap,
        title: Text(injury.name, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(
          injury.focusDescription,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: isSelected
            ? const Icon(Icons.check_circle, color: AppColors.success)
            : const Icon(Icons.chevron_right, color: AppColors.textSecondary),
      ),
    );
  }
}

/// ============ PASO 3: Nivel de dolor ============
class _PainLevelStep extends StatelessWidget {
  final int painLevel;
  final ValueChanged<int> onChanged;

  const _PainLevelStep({required this.painLevel, required this.onChanged});

  Color get _painColor {
    if (painLevel <= 3) return AppColors.success;
    if (painLevel <= 6) return AppColors.assistant;
    return AppColors.alert;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('¿Cuánto dolor sientes hoy?', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text('Escala de 1 (sin dolor) a 10 (dolor máximo).',
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 40),
          Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: _painColor.withValues(alpha: 0.15),
                shape: BoxShape.circle,
                border: Border.all(color: _painColor, width: 3),
              ),
              child: Center(
                child: Text(
                  '$painLevel',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: _painColor,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Slider(
            value: painLevel.toDouble(),
            min: 1,
            max: 10,
            divisions: 9,
            activeColor: _painColor,
            label: '$painLevel',
            onChanged: (v) => onChanged(v.round()),
          ),
        ],
      ),
    );
  }
}

/// ============ PASO 4: Cuestionario inicial ============
class _QuestionnaireStep extends StatelessWidget {
  final bool hasMedicalIndication;
  final ValueChanged<bool> onMedicalIndicationChanged;
  final TextEditingController daysSinceInjuryController;
  final String injuryDurationUnit;
  final ValueChanged<String> onInjuryDurationUnitChanged;
  final bool hadPriorTherapy;
  final ValueChanged<bool> onPriorTherapyChanged;

  const _QuestionnaireStep({
    required this.hasMedicalIndication,
    required this.onMedicalIndicationChanged,
    required this.daysSinceInjuryController,
    required this.injuryDurationUnit,
    required this.onInjuryDurationUnitChanged,
    required this.hadPriorTherapy,
    required this.onPriorTherapyChanged,
  });

  static const List<String> _units = ['días', 'semanas', 'meses', 'años'];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Un par de preguntas más', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 24),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('¿Tienes indicación médica para rehabilitarte?'),
            value: hasMedicalIndication,
            activeColor: AppColors.primary,
            onChanged: onMedicalIndicationChanged,
          ),
          const SizedBox(height: 16),
          Text('¿Cuánto tiempo lleva con la lesión?',
              style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 8),
          // Número + selector de unidad lado a lado, en vez de un solo
          // campo ambiguo de "días".
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 90,
                child: TextField(
                  controller: daysSinceInjuryController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(labelText: 'Cantidad'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: injuryDurationUnit,
                  decoration: const InputDecoration(labelText: 'Unidad'),
                  items: _units
                      .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) onInjuryDurationUnitChanged(value);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('¿Ya has hecho terapia antes?'),
            value: hadPriorTherapy,
            activeColor: AppColors.primary,
            onChanged: onPriorTherapyChanged,
          ),
        ],
      ),
    );
  }
}