import 'package:cardify_flutter/responsive/mobile_screen_layout.dart';
import 'package:cardify_flutter/responsive/responsive_layout_screen.dart';
import 'package:cardify_flutter/responsive/web_screen_layout.dart';
import 'package:cardify_flutter/screens/login_screen.dart';
import 'package:cardify_flutter/utils/colors.dart';
import 'package:cardify_flutter/widgets/text_field_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cardify_flutter/resources/auth_methods.dart';
import 'package:cardify_flutter/utils/utils.dart';
import 'package:image_picker/image_picker.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  void navigateToLogin() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const LoginScreen()));
  }


  Future<Uint8List> loadDefaultImageBytes() async {
    ByteData byteData = await rootBundle.load('images/profile_picture.png');
    return byteData.buffer.asUint8List();
  }

  void navigateToReponsive() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const ResponsiveLayout(
          mobileScreenLayout: MobileScreenLayout(),
          webScreenLayout: WebScreenLayout(),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(flex: 1, child: Container()),

              // svg image
              SvgPicture.asset('./images/card_logo.svg', height: 64),
              Text(
                "Welcome To Cardify",
                style: TextStyle(fontFamily: 'PixelLetters', fontSize: 45),
              ),

              const SizedBox(height: 64),

              Stack(
                children: [
                  CircleAvatar(
                    radius: 64,
                    backgroundImage: _image != null
                        ? MemoryImage(_image!)
                        : AssetImage('images/profile_picture.png')
                              as ImageProvider,
                    backgroundColor: secondaryColor,
                  ),
                  Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                      onPressed: selectImage,
                      icon: const Icon(Icons.add_a_photo),
                      color: primaryColor,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 64),

              // text field for username
              TextFieldInput(
                hintText: 'Username',
                textInputType: TextInputType.text,
                textEditingController: _usernameController,
              ),

              const SizedBox(height: 24),

              // text field for email
              TextFieldInput(
                hintText: 'Email',
                textInputType: TextInputType.emailAddress,
                textEditingController: _emailController,
              ),

              SizedBox(height: 24),

              // text field for password
              TextFieldInput(
                hintText: 'Password',
                textInputType: TextInputType.text,
                textEditingController: _passwordController,
                isPass: true,
              ),

              SizedBox(height: 24),

              // sign up button
              InkWell(
                onTap: () async {
                  setState(() {
                    _isLoading = true;
                  });
                  _image ??= await loadDefaultImageBytes();
                  String res = await AuthMethods().signUpUser(
                    email: _emailController.text,
                    password: _passwordController.text,
                    username: _usernameController.text,
                    file: _image!,
                  );
                  setState(() {
                    _isLoading = false;
                  });
                  if (res != 'success') {
                    ShowSnackBar(res, context);
                  } else {
                    navigateToReponsive();
                  }
                },

                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    color: blueColor,
                  ),
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(color: primaryColor),
                        )
                      : const Text('Sign Up'),
                ),
              ),

              SizedBox(height: 12),
              Flexible(flex: 1, child: Container()),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(child: Text('Have an account?')),
                  GestureDetector(
                    onTap: navigateToLogin,
                    child: Center(child: Text(' Login')),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
