import "package:a5er_elshare3/features/Driver/presentation/cubits/DriverCubit/driver_cubit.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "../../../../core/utils/constants.dart";
import "../../../../core/widgets/RoundedAppBar.dart";
import "../../../Authentication/presentation/screens/ForgotPassword.dart";
import "../../../Trip/presentation/screens/DriverTripList.dart";
import "../../domain/models/driver.dart";
class DriverProfile extends StatefulWidget {
  const DriverProfile({super.key});

  @override
  State<DriverProfile> createState() => _DriverProfileState();
}

class _DriverProfileState extends State<DriverProfile> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _emailController = TextEditingController();
  late TextEditingController _mobileNumberController = TextEditingController();
  late TextEditingController _carPlateController = TextEditingController();
  late TextEditingController _driverLicenseController = TextEditingController();
  late TextEditingController _nameController = TextEditingController();
  late TextEditingController _carModelController = TextEditingController();
  bool _isEditing = false; // Track editing state
  @override
  void initState() {
    super.initState();
    // Fetch data when widget is initialized
    context.read<DriverCubit>().fetchDriverData();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _mobileNumberController.dispose();
    _carPlateController.dispose();
    _driverLicenseController.dispose();
    _nameController.dispose();
    _carModelController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DriverCubit, DriverState>(
      listener: (context, state) {
        if (state is DriverError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is DriverUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Profile updated successfully!")));
        }
      },
      builder: (context, state) {
        if (state is DriverLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is DriverLoaded || state is DriverUpdated) {
          final driver = (state is DriverLoaded)
              ? state.driver
              : (state as DriverUpdated).driver;

          // Initialize controllers with fetched data
          _nameController = TextEditingController(text: driver.name);
          _emailController = TextEditingController(text: driver.email);
          _mobileNumberController = TextEditingController(text: driver.mobileNumber);
          _driverLicenseController = TextEditingController(text: driver.licenseNumber);
          _carPlateController = TextEditingController(text: driver.carPlateNumber);
          _carModelController = TextEditingController(text: driver.carModel);



          return Scaffold(
            appBar: const RoundedAppBar(
              color: kDarkBlueColor,
              title: "Driver Profile",
              height: 150,
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              _buildTextField(
                                  controller: _emailController,
                                  hintText: "Email",
                                  isEnabled: _isEditing,
                                  isReadOnly: true,
                                  // Make email always readonly
                                  icon: Icons.email),
                              const SizedBox(height: 10),
                              _buildTextField(
                                  controller: _nameController,
                                  hintText: "Name",
                                  isEnabled: _isEditing,
                                  icon: Icons.person),
                              const SizedBox(height: 10),
                              _buildTextField(
                                  controller: _mobileNumberController,
                                  hintText: "Mobile Number",
                                  isEnabled: _isEditing,
                                  icon: Icons.call),
                              const SizedBox(height: 20),
                              _buildTextField(
                                  controller: _carPlateController,
                                  hintText: "Car Plate Number",
                                  isEnabled: _isEditing,
                                  icon: Icons.numbers),
                              const SizedBox(height: 20),
                              _buildTextField(
                                  controller: _driverLicenseController,
                                  hintText: "Driver License Number",
                                  isEnabled: _isEditing,
                                  icon: Icons.credit_card_rounded),
                              const SizedBox(height: 20),
                              _buildTextField(
                                  controller: _carModelController,
                                  hintText: "Car Model",
                                  isEnabled: _isEditing,
                                  icon: Icons.car_repair_sharp),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 250,
                            child: Align(
                              child: _isEditing
                                  ? TextButton(
                                onPressed: () {
                                  if (!_formKey.currentState!
                                      .validate()) return;

                                  // Create updated Passenger object
                                  Driver updatedDriver =
                                  Driver(
                                    uid: driver.uid,
                                    name: _nameController.text,
                                    email: _emailController.text,
                                    mobileNumber: _mobileNumberController.text,
                                    role: driver.role,
                                    carModel: _carModelController.text,
                                    carPlateNumber: _carPlateController.text,
                                    licenseNumber: _driverLicenseController.text,
                                  );

                                  // Update data using the PassengerCubit
                                  context
                                      .read<DriverCubit>()
                                      .updateDriverData(
                                      updatedDriver);

                                  setState(() => _isEditing =
                                  false); // Stop editing mode
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: kDarkBlueColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 15),

                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.save, color: Colors.white),
                                    SizedBox(width: 8),
                                    Text("Save Changes", style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold

                                    ),),
                                  ],
                                ),
                              )
                                  : TextButton(
                                onPressed: () {
                                  setState(() => _isEditing =
                                  true); // Enable editing mode
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: kDarkBlueColor,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),

                                    )
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.edit, color: Colors.white),
                                    SizedBox(width: 8),
                                    Text("Edit Profile", style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold

                                    ),),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 250,

                            child: TextButton(
                              style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  backgroundColor: kDarkBlueColor
                              ),
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> DriverTripList(driver: driver,)));
                              },

                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.history, color:Colors.white),
                                  SizedBox(width: 8),
                                  Text("View Trip History", style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold

                                  ),),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 250,

                            child: TextButton(
                              style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  backgroundColor: kDarkBlueColor
                              ),
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> const ResetPassword()));
                              },

                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.password, color:Colors.white),
                                  SizedBox(width: 8),
                                  Text("Reset Password", style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold

                                  ),),
                                ],
                              ),
                            ),
                          ),


                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        return const Scaffold(
            body: Center(
                child: CircularProgressIndicator(
                  color: kDarkBlueColor,
                )));
      },
    );
  }

  Widget buildTextFormField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(
              color: kDarkBlueColor
          )),
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: kDarkBlueColor))),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool isEnabled = true,
    bool isReadOnly = false,
  }) {
    return TextFormField(
      controller: controller,
      enabled: isEnabled && !isReadOnly,
      readOnly: isReadOnly,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "$hintText cannot be empty.";
        }
        return null;
      },
    );
  }
}
