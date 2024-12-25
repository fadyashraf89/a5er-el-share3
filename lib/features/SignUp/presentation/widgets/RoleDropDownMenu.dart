import "package:flutter/material.dart";
class RoleDropDownMenu extends StatefulWidget {
  const RoleDropDownMenu({super.key});

  @override
  State<RoleDropDownMenu> createState() => _RoleDropDownMenuState();
}

class _RoleDropDownMenuState extends State<RoleDropDownMenu> {
  String? selectedRole = 'Passenger';

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedRole,
      onChanged: (value) {
        setState(() {
          selectedRole = value!;
        });
      },
      items: const [
        DropdownMenuItem(
          value: 'Driver',
          child: Text('Driver'),
        ),
        DropdownMenuItem(
          value: 'Passenger',
          child: Text('Passenger'),
        ),
      ],
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
