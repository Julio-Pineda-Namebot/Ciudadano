import "package:ciudadano/features/auth/domain/params/auth_login_params.dart";
import "package:ciudadano/features/auth/domain/params/auth_register_params.dart";
import "package:ciudadano/features/auth/domain/params/auth_reset_password_params.dart";
import "package:ciudadano/features/auth/domain/params/auth_verify_email_params.dart";
import "package:ciudadano/features/auth/domain/usecases/auth_login_use_case.dart";
import "package:ciudadano/features/auth/domain/usecases/auth_register_use_case.dart";
import "package:ciudadano/features/auth/domain/usecases/auth_resend_verification_email_use_case.dart";
import "package:ciudadano/features/auth/domain/usecases/auth_reset_password_use_case.dart";
import "package:ciudadano/features/auth/domain/usecases/auth_send_reset_password_email_use_case.dart";
import "package:ciudadano/features/auth/domain/usecases/auth_verify_email_use_case.dart";
import "package:ciudadano/service_locator.dart";
import "package:flutter/material.dart";
import "package:flutter_login/flutter_login.dart";

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final _authRegisterUseCase = sl<AuthRegisterUseCase>();
  final _authLoginUseCase = sl<AuthLoginUseCase>();
  final _authSendResetPasswordEmailUseCase =
      sl<AuthSendResetPasswordEmailUseCase>();
  final _authResetPasswordUseCase = sl<AuthResetPasswordUseCase>();
  final _authResendVerificationEmailUseCase =
      sl<AuthResendVerificationEmailUseCase>();
  final _authVerifyEmailUseCase = sl<AuthVerifyEmailUseCase>();

  Future<String?> _onLogin(LoginData data) async {
    final response = await _authLoginUseCase(
      AuthLoginParams(email: data.name, password: data.password),
    );
    return response.fold((failure) {
      if (failure == "El correo electrónico no ha sido verificado.") {
        return "email_not_verified";
      }
      return failure;
    }, (success) => null);
  }

  Future<String?> _onSignup(SignupData data) async {
    final response = await _authRegisterUseCase(
      AuthRegisterParams(
        email: data.name ?? "",
        password: data.password ?? "",
        firstName: data.additionalSignupData?["Nombre"] ?? "",
        lastName: data.additionalSignupData?["Apellido"] ?? "",
        dni: data.additionalSignupData?["Dni"] ?? "",
        phone: data.additionalSignupData?["Teléfono"] ?? "",
      ),
    );

    return response.fold((failure) => failure, (success) => null);
  }

  Future<String?> _onConfirmSignup(
    String verificationData,
    LoginData loginData,
  ) async {
    if (verificationData.isEmpty) {
      return "El código de confirmación no puede estar vacío";
    }

    final response = await _authVerifyEmailUseCase(
      AuthVerifyEmailParams(email: loginData.name, code: verificationData),
    );

    return response.fold((failure) => failure, (success) => null);
  }

  Future<String?> _onRecoverPassword(String email) async {
    final response = await _authSendResetPasswordEmailUseCase.call(email);

    return response.fold((failure) => failure, (success) => null);
  }

  Future<String?> _onConfirmRecover(String code, LoginData loginData) async {
    if (code.isEmpty) {
      return "El código de recuperación no puede estar vacío";
    }

    final response = await _authResetPasswordUseCase(
      AuthResetPasswordParams(
        code: code,
        password: loginData.password,
        email: loginData.name,
      ),
    );

    return response.fold((failure) => failure, (success) => null);
  }

  Future<String?> _onResendCode(SignupData data) async {
    if (data.name == null || data.name!.isEmpty) {
      return "El correo electrónico no puede estar vacío";
    }

    final response = await _authResendVerificationEmailUseCase.call(data.name!);

    return response.fold((failure) => failure, (success) => null);
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      key: const Key("login_page"),
      logo: const AssetImage("assets/splash.png"),
      theme: LoginTheme(
        cardTheme: CardTheme(
          color: Colors.white,
          elevation: 2,
          margin: const EdgeInsets.only(top: 15),
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        footerTextStyle: const TextStyle(color: Colors.white),
        footerBottomPadding: 25,
      ),
      onLogin: _onLogin,
      onSignup: _onSignup,
      onConfirmSignup: _onConfirmSignup,
      onRecoverPassword: _onRecoverPassword,
      onConfirmRecover: _onConfirmRecover,
      onResendCode: _onResendCode,
      confirmSignupRequired: (data) async {
        return true;
      },
      userValidator: (value) {
        final emailRegExp = RegExp(
          r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
        );

        if (value == null || value.isEmpty) {
          return "Debes ingresar un correo válido";
        }

        // if (RegExp(r"^\d+$").hasMatch(value)) {
        //   if (value.length != 8) {
        //     return "El DNI debe tener exactamente 8 dígitos";
        //   }
        // } else {
        if (!emailRegExp.hasMatch(value)) {
          return "El formato del correo electrónico es \ninválido";
        }
        // }
        return null;
      },
      userType: LoginUserType.email,
      passwordValidator: (value) {
        if (value == null || value.isEmpty) {
          return "La contraseña es obligatoria";
        }

        if (value.length < 8 || value.length > 16) {
          return "La contraseña debe tener entre 8 y\n 16 caracteres.";
        }

        final hasLetter = RegExp(r"[A-Za-z]").hasMatch(value);
        final hasNumber = RegExp(r"\d").hasMatch(value);

        if (!hasLetter) {
          return "La contraseña debe incluir al menos \nuna letra.";
        }
        if (!hasNumber) {
          return "La contraseña debe incluir al menos \nun número.";
        }
        return null;
      },
      messages: LoginMessages(
        userHint: "Correo",
        passwordHint: "Contraseña",
        forgotPasswordButton: "Olvidaste tu contraseña?",
        confirmPasswordHint: "Repetir Contraseña",
        loginButton: "Ingresar",
        signupButton: "Registrarse",
        recoverPasswordButton: "Recuperar",
        recoverPasswordIntro: "Restablece tu contraseña aquí",
        recoverCodePasswordDescription:
            "Ingrese su correo para recuperar contraseña!",
        goBackButton: "Volver",
        confirmPasswordError: "Las contraseñas no coinciden!",
        recoverPasswordSuccess: "Código de confirmación enviado",
        confirmSignupIntro:
            "Se envió un código de confirmación a su correo electrónico. Por favor ingrese el código para confirmar su cuenta",
        confirmationCodeHint: "Código de confirmación",
        confirmationCodeValidationError: "Código de confirmación esta vacío",
        resendCodeButton: "Reenviaar código",
        resendCodeSuccess: "Código de confirmación reenviado",
        confirmSignupButton: "Confirmar",
        confirmSignupSuccess: "Cuenta confirmada",
        confirmRecoverIntro:
            "El código de recuperación para establecer una nueva contraseña fue enviado a su correo electrónico.",
        recoveryCodeHint: "Código",
        recoveryCodeValidationError: "Código de recuperación esta vacío",
        setPasswordButton: "Establecer contraseña",
        confirmRecoverSuccess: "Contraseña Recuperada",
        flushbarTitleError: "Oh no!",
        flushbarTitleSuccess: "Éxito!",
        signUpSuccess: "Se ha enviado un enlace de activación",
        additionalSignUpFormDescription:
            "Por favor, completa este formulario para registrarte",
        additionalSignUpSubmitButton: "Enviar",
        providersTitleFirst: "o ingresa con",
      ),
      footer: "©2025 Todos los derechos reservados.",
      hideForgotPasswordButton: false,
      initialIsoCode: "PE",
      loginAfterSignUp: false,
      validateUserImmediately: true,
      additionalSignupFields: [
        UserFormField(
          keyName: "Nombre",
          userType: LoginUserType.firstName,
          fieldValidator: (value) {
            if (value == null || value.isEmpty) {
              return "Debe ingresar su nombre";
            }
            return null;
          },
        ),
        UserFormField(
          keyName: "Apellido",
          userType: LoginUserType.lastName,
          fieldValidator: (value) {
            if (value == null || value.isEmpty) {
              return "Debe ingresar su apellido";
            }
            return null;
          },
        ),
        UserFormField(
          keyName: "Dni",
          displayName: "Dni",
          icon: const Icon(Icons.perm_identity),
          userType: LoginUserType.phone,
          fieldValidator: (value) {
            final dniRegExp = RegExp(r"^\d{8}$");
            if (value != null && !dniRegExp.hasMatch(value)) {
              return "Es invalido el dni ingresado";
            }
            return null;
          },
        ),
        UserFormField(
          keyName: "Teléfono",
          displayName: "Teléfono",
          icon: const Icon(Icons.phone),
          userType: LoginUserType.phone,
          fieldValidator: (value) {
            final phoneRegExp = RegExp(r"^\d{9}$");
            if (value != null && !phoneRegExp.hasMatch(value)) {
              return "Es invalido el número ingresado";
            }
            return null;
          },
        ),
      ],
    );
  }
}
