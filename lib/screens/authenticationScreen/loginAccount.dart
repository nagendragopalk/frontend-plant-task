import 'package:flutter/material.dart';
import 'package:plant_task/helper/generalWidgets/editBoxWidget.dart';
import 'package:plant_task/helper/generalWidgets/widgets.dart';
import 'package:plant_task/helper/provider/userLoginProvider.dart';
import 'package:plant_task/helper/styles/colorsRes.dart';
import 'package:plant_task/helper/styles/designConfig.dart';
import 'package:plant_task/helper/utils/constant.dart';
import 'package:plant_task/helper/utils/generalMethods.dart';
import 'package:plant_task/helper/utils/routeGenerator.dart';
import 'package:plant_task/helper/utils/sessionManager.dart';
import 'package:provider/provider.dart';

class LoginAccount extends StatefulWidget {
  final String? from;

  const LoginAccount({Key? key, this.from}) : super(key: key);

  @override
  State<LoginAccount> createState() => _LoginAccountState();
}

class _LoginAccountState extends State<LoginAccount> {
  bool isLoading = false, isAcceptedTerms = false, isPasswordVisible = false;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController edtUsername = TextEditingController();
  late TextEditingController edtPassword = TextEditingController();

  bool isDark = Constant.session.getBoolData(SessionManager.isDarkTheme);

  String userName = "";

  @override
  void initState() {
    // edtUsername = TextEditingController(text: "gopal");
    // edtPassword = TextEditingController(text: "123456");
    super.initState();
    // Future.delayed(Duration.zero).then((value) async {
    //   context.read<UserLoginProvider>().getInitialData(
    //         context: context,
    //       );
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              Center(
                child: Card(
                  color: Theme.of(context).cardColor,
                  surfaceTintColor: Theme.of(context).cardColor,
                  shape: DesignConfig.setRoundedBorderSpecific(
                    10,
                    istop: true,
                    isbtm: true,
                  ),
                  margin: EdgeInsets.symmetric(
                    horizontal: Constant.size5,
                    vertical: Constant.size5,
                  ),
                  elevation: 8.0,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: loginWidgets(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  proceedBtn() {
    return Consumer<UserLoginProvider>(
      builder: (context, userLoginProvider, _) {
        return userLoginProvider.userLoginState == LoginProfileState.loading
            ? const Center(child: CircularProgressIndicator())
            : gradientBtnWidget(
              context,
              10,
              title: "Login",
              callback: () {
                loginWithUser();
              },
            );
      },
    );
  }

  loginWidgets() {
    return Container(
      color: Theme.of(context).cardColor,
     
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              "Plant Task",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
                fontSize: 28,
                color: ColorsRes.mainTextColor,
              ),
            ),
            subtitle: Text(
              "Enter your username and password to log in.",
              style: TextStyle(color: ColorsRes.grey),
            ),
          ),
          getSizedBox(height: Constant.size40),
          Container(
            decoration: DesignConfig.boxDecoration(
              Theme.of(context).scaffoldBackgroundColor,
              10,
            ),
            child: userLoginInfoWidget(),
          ),
          getSizedBox(height: Constant.size40),
          proceedBtn(),
          getSizedBox(height: Constant.size40),
        ],
      ),
    );
  }

  userLoginInfoWidget() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          editBoxWidget(
            context,
            edtUsername,
            maxLines: 1,
            leadingIcon: Icon(Icons.person, color: ColorsRes.mainTextColor),
            GeneralMethods.emptyValidation,
            "Username",
            "Enter Username",
            TextInputType.text,
          ),
          SizedBox(height: Constant.size15),
          editBoxWidget(
            context,
            edtPassword,
            isObscureText: !isPasswordVisible,
            maxLines: 1,
            leadingIcon: GestureDetector(
              onTap: () {
                setState(() {
                  isPasswordVisible = !isPasswordVisible;
                });
              },
              child: Icon(
                isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: ColorsRes.mainTextColor,
              ),
            ),
            GeneralMethods.emptyValidation,
            "Password",
            "Enter Password",
            TextInputType.text,
          ),
        ],
      ),
    );
  }

  getRedirection() async {
    if (Constant.session.getBoolData(SessionManager.isUserLogin)) {
      if (Constant.session.getData(SessionManager.keyUserName).isNotEmpty) {
        Navigator.pushReplacementNamed(
          context,
          mainHomeScreen,
        );
      } else {
        Navigator.pushNamedAndRemoveUntil(
          context,
          mainHomeScreen,
          (route) => false,
        );
      }
    }
  }

  Future<bool> checkValidation() async {
    bool checkInternet = await GeneralMethods.checkInternet();

    if (!checkInternet) {
      GeneralMethods.showMessage(
        context,
        "check_internet",
        MessageType.warning,
      );
      return false;
    } else {
      return true;
    }
  }

  loginWithUser() async {
    try {
      _formKey.currentState!.save();
      if (_formKey.currentState!.validate()) {
        var validation = await checkValidation();
        if (validation) {
          if (isLoading) return;
          setState(() {
            isLoading = true;
          });
          Map<String, String> params = {};
          params["username"] = edtUsername.text.trim();
          params["password"] = edtPassword.text.trim();
          context
              .read<UserLoginProvider>()
              .loginApi(context: context, params: params)
              .then((value) => {
                    setState(() {
                      isLoading = false;
                    }),
                    getRedirection()
                  });
        }
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      GeneralMethods.showMessage(context, e.toString(), MessageType.error);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
