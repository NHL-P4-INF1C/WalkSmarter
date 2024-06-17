import "package:flutter/material.dart";
import "profileusersettings.dart";

class ChangeUsernamePage extends StatefulWidget {
  // ChangeUsernamePage({required this.userId, required this.currentUsername});

  @override
  // ignore: library_private_types_in_public_api
  _ChangeUsernamePageState createState() => _ChangeUsernamePageState();
}

class _ChangeUsernamePageState extends State<ChangeUsernamePage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final Color greenColor = Color.fromARGB(255, 9, 106, 46);

  @override
  void initState() {
    super.initState();
    _usernameController.text = pb.authStore.model['username'];
  }

  Future<void> _changeUsername() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Save the navigator context before the async call
        final navigator = Navigator.of(context);
        await pb.collection("users").update(pb.authStore.model['id'], body: {
          "username": _usernameController.text,
        });
        navigator.pop(true);
      } catch (e) {
        print("Error updating username: $e");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error updating username")),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Change Username")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: "New Username"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a username";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: _changeUsername,
                child: Container(
                  decoration: BoxDecoration(
                    color: greenColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 7, horizontal: 30),
                  child: Text(
                    "Change Username",
                    style: TextStyle(
                        fontSize: 12,
                        color: Color.fromARGB(255, 255, 255, 255)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}