import "package:a5er_elshare3/core/utils/constants.dart";
import "package:a5er_elshare3/core/widgets/RoundedAppBar.dart";
import "package:a5er_elshare3/features/Trip/presentation/screens/PassengerTripList.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "../../../AuthService/screens/ForgotPassword.dart";
import "../../domain/models/Passenger.dart";
import "../cubits/PassengerCubit/passenger_cubit.dart";

class PassengerProfile extends StatefulWidget {
  const PassengerProfile({super.key});

  @override
  State<PassengerProfile> createState() => _PassengerProfileState();
}

class _PassengerProfileState extends State<PassengerProfile> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _mobileNumberController;
  bool _isEditing = false; // Track editing state

  @override
  void initState() {
    super.initState();
    // Fetch data when widget is initialized
    context.read<PassengerCubit>().fetchPassengerData();
  }

  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
    _nameController.dispose();
    _emailController.dispose();
    _mobileNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PassengerCubit, PassengerState>(
      listener: (context, state) {
        if (state is PassengerError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is PassengerUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Profile updated successfully!")));
        }
      },
      builder: (context, state) {
        if (state is PassengerLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is PassengerLoaded || state is PassengerUpdated) {
          final passenger = (state is PassengerLoaded)
              ? state.passenger
              : (state as PassengerUpdated).passenger;

          // Initialize controllers with fetched data
          _nameController = TextEditingController(text: passenger.name);
          _emailController = TextEditingController(text: passenger.email);
          _mobileNumberController = TextEditingController(
            text: passenger.mobileNumber,
          );

          return Scaffold(
            appBar: const RoundedAppBar(
              color: kDarkBlueColor,
              title: "Passenger Profile",
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
                              Row(
                                children: [
                                  const Icon(Icons.stars, color: Colors.yellow),
                                  const SizedBox(width: 10),
                                  Text(
                                    'Points: ${passenger.points}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),

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
                                  Passenger updatedPassenger =
                                  Passenger(
                                    uid: passenger.uid,
                                    name: _nameController.text,
                                    email: _emailController.text,
                                    mobileNumber:
                                    _mobileNumberController.text,
                                    role: passenger.role,
                                    points: passenger.points ?? 0
                                  );

                                  // Update data using the PassengerCubit
                                  context
                                      .read<PassengerCubit>()
                                      .updatePassengerData(
                                      updatedPassenger);

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
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> PassengerTripList(userEmail: passenger.email,)));
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
