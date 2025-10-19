import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const BMICalculatorApp());
}

class BMICalculatorApp extends StatelessWidget {
  const BMICalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kalkulator BMI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.interTextTheme(),
        colorScheme: const ColorScheme.light(
          primary: Colors.black,
          onPrimary: Colors.white,
          surface: Colors.white,
          onSurface: Colors.black,
        ),
        useMaterial3: true,
      ),
      home: const BMICalculator(),
    );
  }
}

class BMICalculator extends StatefulWidget {
  const BMICalculator({super.key});

  @override
  State<BMICalculator> createState() => _BMICalculatorState();
}

class _BMICalculatorState extends State<BMICalculator>
    with TickerProviderStateMixin {
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  bool showResult = false;
  double bmi = 0;
  String gender = "Laki-laki";

  late AnimationController _inputController;
  late AnimationController _resultController;
  late AnimationController _bgController;

  late Animation<double> _inputOffset;
  late Animation<double> _inputFade;
  late Animation<double> _resultOffset;
  late Animation<double> _resultFade;
  late Animation<double> _bgFade;

  @override
  void initState() {
    super.initState();

    _inputController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _resultController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    final ease = CurvedAnimation(
      parent: _inputController,
      curve: Curves.easeInOutCubic,
    );

    _inputOffset = Tween<double>(begin: 0, end: -80).animate(ease);
    _inputFade = Tween<double>(begin: 1, end: 0).animate(ease);

    _resultOffset = Tween<double>(begin: 80, end: 0).animate(CurvedAnimation(
      parent: _resultController,
      curve: Curves.easeOutCubic,
    ));

    _resultFade = CurvedAnimation(
      parent: _resultController,
      curve: Curves.easeInOutCubic,
    );

    _bgFade = CurvedAnimation(
      parent: _bgController,
      curve: Curves.easeInOut,
    );
  }

  void calculateBMI() async {
    final height = double.tryParse(heightController.text);
    final weight = double.tryParse(weightController.text);

    if (height != null && weight != null && height > 0) {
      final newBmi = weight / ((height / 100) * (height / 100));

      await _inputController.forward();
      setState(() {
        bmi = newBmi;
        showResult = true;
      });

      _bgController.forward(from: 0);
      _resultController.forward(from: 0);
    }
  }

  void reset() async {
    await Future.wait([
      _resultController.reverse(),
      _bgController.reverse(),
    ]);

    setState(() {
      showResult = false;
    });
    _inputController.reverse();
    heightController.clear();
    weightController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // --- tempat input inputan ---
          Center(
            child: AnimatedBuilder(
              animation: _inputController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _inputOffset.value),
                  child: Opacity(
                    opacity: _inputFade.value,
                    child: child,
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Kalkulator BMI",
                      style: GoogleFonts.inter(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 30),

                    // --- milih gender bosss ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _genderButton("Laki-laki", Icons.male),
                        const SizedBox(width: 20),
                        _genderButton("Perempuan", Icons.female),
                      ],
                    ),
                    const SizedBox(height: 30),

                    // --- input inputan ngisi ini mah ---
                    TextField(
                      controller: heightController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Tinggi Badan (cm)",
                        labelStyle: GoogleFonts.inter(color: Colors.black),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: weightController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Berat Badan (kg)",
                        labelStyle: GoogleFonts.inter(color: Colors.black),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: calculateBMI,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 60, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        "Hitung",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // --- animasi buat background fadeinfadeout ---
          if (showResult)
            AnimatedBuilder(
              animation: _bgFade,
              builder: (context, child) {
                return Opacity(
                  opacity: _bgFade.value,
                  child: Container(
                    color: Colors.indigo.shade400.withOpacity(0.85),
                  ),
                );
              },
            ),

          // --- hasil make animasi ease out ---
          if (showResult)
            AnimatedBuilder(
              animation: _resultController,
              builder: (context, child) {
                return Opacity(
                  opacity: _resultFade.value,
                  child: Transform.translate(
                    offset: Offset(0, _resultOffset.value),
                    child: child,
                  ),
                );
              },
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Hasil BMI (${gender})",
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: bmi),
                      duration: const Duration(milliseconds: 1200),
                      curve: Curves.easeInOutCubic,
                      builder: (context, value, _) {
                        return Text(
                          value.toStringAsFixed(1),
                          style: GoogleFonts.inter(
                            fontSize: 72,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                offset: const Offset(0, 2),
                                blurRadius: 10,
                                color: Colors.black26,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    Text(
                      bmi < 18.5
                          ? "Kurus"
                          : (bmi < 24.9
                              ? "Normal"
                              : (bmi < 29.9 ? "Gemuk" : "Obesitas")),
                      style: GoogleFonts.inter(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: reset,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.indigo.shade700,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text("Hitung Ulang"),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _genderButton(String label, IconData icon) {
    final isSelected = gender == label;
    return GestureDetector(
      onTap: () => setState(() => gender = label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.black, width: 1.4),
          boxShadow: isSelected
              ? [BoxShadow(color: Colors.black26, blurRadius: 6, offset: const Offset(0, 2))]
              : [],
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? Colors.white : Colors.black),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 16,
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _inputController.dispose();
    _resultController.dispose();
    _bgController.dispose();
    super.dispose();
  }
}
