import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bio Data',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      home: const BiodataPage(),
    );
  }
}

const Color kHeaderColor = Color(0xFF424242);

class BiodataPage extends StatefulWidget {
  const BiodataPage({super.key});

  @override
  State<BiodataPage> createState() => _BiodataPageState();
}

class _BiodataPageState extends State<BiodataPage> {
  // CONTROLLERS

  final nameController = TextEditingController();
  final maritalStatusController = TextEditingController();
  final fullNameController = TextEditingController();
  final religionController = TextEditingController();
  final dateOfBirthController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final bloodGroupController = TextEditingController();
  final nationalityController = TextEditingController();
  final genderController = TextEditingController();

  final educationLevelController = TextEditingController();
  final schoolNameController = TextEditingController();
  final educationYearController = TextEditingController();
  final courseController = TextEditingController();

  final occupationController = TextEditingController();
  final skillsController = TextEditingController();

  final fatherNameController = TextEditingController();
  final motherNameController = TextEditingController();
  final siblingsController = TextEditingController();

  final addressController = TextEditingController();
  final contactController = TextEditingController();
  final emailController = TextEditingController();

  final certificatesController = TextEditingController();

  // SUBMITTED DATA

  Map<String, String>? submittedData;

  // SUBMIT

  Future<void> submitBiodata() async {
    // Create the data that will be displayed
    final data = {
      'Name': nameController.text.trim(),
      'Marital Status': maritalStatusController.text.trim(),
      'Full Name': fullNameController.text.trim(),
      'Religion': religionController.text.trim(),
      'Date of Birth': dateOfBirthController.text.trim(),
      'Height': heightController.text.trim(),
      'Weight': weightController.text.trim(),
      'Blood Group': bloodGroupController.text.trim(),
      'Nationality': nationalityController.text.trim(),
      'Gender': genderController.text.trim(),

      'Education Level': educationLevelController.text.trim(),
      'School Name': schoolNameController.text.trim(),
      'Year': educationYearController.text.trim(),
      'Course': courseController.text.trim(),

      'Occupation': occupationController.text.trim(),
      'Skills': skillsController.text.trim(),

      "Father's Name": fatherNameController.text.trim(),
      "Mother's Name": motherNameController.text.trim(),
      'Siblings': siblingsController.text.trim(),

      'Address': addressController.text.trim(),
      'Contact No.': contactController.text.trim(),
      'Email': emailController.text.trim(),

      'Certificates': certificatesController.text.trim(),
    };

    try {
      await FirebaseFirestore.instance.collection('biodata').add({
        ...data,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      setState(() {
        submittedData = Map<String, String>.from(data);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Biodata saved to Firebase successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save biodata: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // CLEAR

  void clearForm() {
    final controllers = [
      nameController,
      maritalStatusController,
      fullNameController,
      religionController,
      dateOfBirthController,
      heightController,
      weightController,
      bloodGroupController,
      nationalityController,
      genderController,
      educationLevelController,
      schoolNameController,
      educationYearController,
      courseController,
      occupationController,
      skillsController,
      fatherNameController,
      motherNameController,
      siblingsController,
      addressController,
      contactController,
      emailController,
      certificatesController,
    ];

    for (final controller in controllers) {
      controller.clear();
    }

    setState(() {
      submittedData = null;
    });
  }

  @override
  void dispose() {
    final controllers = [
      nameController,
      maritalStatusController,
      fullNameController,
      religionController,
      dateOfBirthController,
      heightController,
      weightController,
      bloodGroupController,
      nationalityController,
      genderController,
      educationLevelController,
      schoolNameController,
      educationYearController,
      courseController,
      occupationController,
      skillsController,
      fatherNameController,
      motherNameController,
      siblingsController,
      addressController,
      contactController,
      emailController,
      certificatesController,
    ];

    for (final controller in controllers) {
      controller.dispose();
    }

    super.dispose();
  }

  // INPUT FIELD

  Widget inputField(
    String label,
    TextEditingController controller, {
    String? hint,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  // SECTION

  Widget section(String title, List<Widget> children) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: kHeaderColor,
                borderRadius: BorderRadius.circular(3),
              ),
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  // DISPLAY SUBMITTED DATA

  Widget displaySection(String title, List<MapEntry<String, String>> data) {
    return section(
      title,
      data.map((entry) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 150,
                child: Text(
                  entry.key,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const Text(': '),
              Expanded(child: Text(entry.value.isEmpty ? 'N/A' : entry.value)),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget submittedBiodata() {
    if (submittedData == null) {
      return const SizedBox();
    }

    final data = submittedData!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),

        const Text(
          'SUBMITTED BIO DATA',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,
          ),
        ),

        const SizedBox(height: 20),

        displaySection('PERSONAL DETAILS', [
          MapEntry('Name', data['Name'] ?? ''),
          MapEntry('Marital Status', data['Marital Status'] ?? ''),
          MapEntry('Full Name', data['Full Name'] ?? ''),
          MapEntry('Religion', data['Religion'] ?? ''),
          MapEntry('Date of Birth', data['Date of Birth'] ?? ''),
          MapEntry('Height', data['Height'] ?? ''),
          MapEntry('Weight', data['Weight'] ?? ''),
          MapEntry('Blood Group', data['Blood Group'] ?? ''),
          MapEntry('Nationality', data['Nationality'] ?? ''),
          MapEntry('Gender', data['Gender'] ?? ''),
        ]),

        displaySection('EDUCATION DETAILS', [
          MapEntry('Education Level', data['Education Level'] ?? ''),
          MapEntry('School Name', data['School Name'] ?? ''),
          MapEntry('Year', data['Year'] ?? ''),
          MapEntry('Course', data['Course'] ?? ''),
        ]),

        displaySection('OCCUPATION / JOB', [
          MapEntry('Occupation', data['Occupation'] ?? ''),
          MapEntry('Skills', data['Skills'] ?? ''),
        ]),

        displaySection('FAMILY BACKGROUND', [
          MapEntry("Father's Name", data["Father's Name"] ?? ''),
          MapEntry("Mother's Name", data["Mother's Name"] ?? ''),
          MapEntry('Siblings', data['Siblings'] ?? ''),
        ]),

        displaySection('RESIDENTIAL ADDRESS', [
          MapEntry('Address', data['Address'] ?? ''),
          MapEntry('Contact No.', data['Contact No.'] ?? ''),
          MapEntry('Email', data['Email'] ?? ''),
        ]),

        displaySection('CERTIFICATES', [
          MapEntry('Certificates', data['Certificates'] ?? ''),
        ]),

        const SizedBox(height: 10),

        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: clearForm,
            icon: const Icon(Icons.clear),
            label: const Text('CLEAR'),
          ),
        ),
      ],
    );
  }

  // BUILD

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Bio Data'),
        backgroundColor: kHeaderColor,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'BIO DATA INPUT',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Enter your information below.',
                    style: TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 24),

                  // PERSONAL
                  section('PERSONAL DETAILS', [
                    inputField('Name', nameController),
                    inputField('Marital Status', maritalStatusController),
                    inputField('Full Name', fullNameController),
                    inputField('Religion', religionController),
                    inputField('Date of Birth', dateOfBirthController),
                    inputField('Height', heightController),
                    inputField('Weight', weightController),
                    inputField('Blood Group', bloodGroupController),
                    inputField('Nationality', nationalityController),
                    inputField('Gender', genderController),
                  ]),

                  // EDUCATION
                  section('EDUCATION DETAILS', [
                    inputField('Education Level', educationLevelController),
                    inputField('School Name', schoolNameController),
                    inputField('Year', educationYearController),
                    inputField('Course / Education Details', courseController),
                  ]),

                  // OCCUPATION
                  section('OCCUPATION / JOB', [
                    inputField('Occupation / Status', occupationController),
                    inputField('Skills', skillsController, maxLines: 3),
                  ]),

                  // FAMILY
                  section('FAMILY BACKGROUND', [
                    inputField("Father's Name", fatherNameController),
                    inputField("Mother's Name", motherNameController),
                    inputField(
                      'Brothers / Sisters',
                      siblingsController,
                      maxLines: 2,
                    ),
                  ]),

                  // ADDRESS
                  section('RESIDENTIAL ADDRESS', [
                    inputField('Address', addressController, maxLines: 2),
                    inputField('Contact No.', contactController),
                    inputField('E-mail', emailController),
                  ]),

                  // CERTIFICATES
                  section('CERTIFICATES', [
                    inputField(
                      'Certificates',
                      certificatesController,
                      hint: 'Enter certificates separated by commas',
                      maxLines: 4,
                    ),
                  ]),

                  // SUBMIT
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: submitBiodata,
                      icon: const Icon(Icons.save),
                      label: const Text(
                        'SUBMIT BIODATA',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // DISPLAY RESULT
                  submittedBiodata(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
