import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:ciudadano/features/auth/data/auth_remote_datasource.dart';
import 'package:ciudadano/features/main/presentation/pages/homescreen.dart';
// import 'package:ciudadano/features/auth/presentation/helper/biometric_auth_helper.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({super.key});

  @override
  MyLoginPageState createState() => MyLoginPageState();
}

class MyLoginPageState extends State<MyLoginPage> {
  final AuthRemoteDatasource authRemoteDatasource = AuthRemoteDatasource();
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  
  Future<String?> _authUser(LoginData data) async {
    return await authRemoteDatasource.login(data.name, data.password);
  }

  Future<String?> _signupUser(SignupData data) async {
    try {
      final response = await authRemoteDatasource.register(
        email: data.name!,
        password: data.password!,
        firstName: data.additionalSignupData?['Nombres'] ?? '',
        lastName: data.additionalSignupData?['Apellidos'] ?? '',
        dni: data.additionalSignupData?['Dni'] ?? '',
      );

      return response;
    } catch (e) {
      return 'Error al registrarse. Intenta más tarde.';
    }
  }

  Future<String?> _signupConfirm(String verificationCode, LoginData data) async {
    if (verificationCode.isEmpty) {
      return 'Código de verificación está vacío';
    }
    return await authRemoteDatasource.verifyEmail(data.name, verificationCode);
  }

  Future<String?> _resendVerificationCode(String email) async {
    return await authRemoteDatasource.resendVerificationCode(email);
  }

  Future<String?> _recoverPassword(String email) async {
    return await authRemoteDatasource.sendRecoveryEmail(email);
  }

  Future<String?> _resetPassword(String email, String code, String newPassword) async {
    return await authRemoteDatasource.resetPassword(email, code, newPassword);
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      logo: const AssetImage('assets/splash.png'),
      theme: LoginTheme(
        cardTheme: CardTheme(
          color: Colors.white,
          elevation: 2,
          margin: const EdgeInsets.only(top: 15), 
          shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(30.0)), 
        ),
      ),
      onLogin: (loginData) {
        return _authUser(loginData);
      },
      onSignup: (signupData) {
        signupData.additionalSignupData?.forEach((key, value) {
          debugPrint('$key: $value');
        });
        return _signupUser(signupData);
      },
      onConfirmSignup: _signupConfirm,
      onRecoverPassword: (email) {
        return _recoverPassword(email);
      },
      onConfirmRecover: (code, recoverData) async {
        final email = recoverData.name; 
        final newPassword = recoverData.password; 

        return await _resetPassword(email, code, newPassword);
      },
      onResendCode: (SignupData data) async {
        final email = data.name; 
        if (email == null || email.isEmpty) {
          return 'El correo electrónico es obligatorio';
        } 
        return await _resendVerificationCode(email);
      },
      userValidator: (value) {
        final emailRegExp = RegExp(
          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
        );

        if (value == null || value.isEmpty) {
          return 'Debes ingresar un correo o un DNI';
        }

        if (RegExp(r'^\d+$').hasMatch(value)) {
          if (value.length != 8) {
            return 'El DNI debe tener exactamente 8 dígitos';
          }
        } else {
          if (!emailRegExp.hasMatch(value)) {
            return 'El formato del correo electrónico es \ninválido';
          }
        }
        return null;
      },
      passwordValidator: (value) {
        if (value == null || value.isEmpty) {
          return 'La contraseña es obligatoria';
        }

        if (value.length < 8 || value.length > 16) {
          return 'La contraseña debe tener entre 8 y\n 16 caracteres.';
        }

        final hasLetter = RegExp(r'[A-Za-z]').hasMatch(value);
        final hasNumber = RegExp(r'\d').hasMatch(value);
        final hasSpecialChar = RegExp(r'[!@#$%^&*]').hasMatch(value);

        if (!hasLetter) {
          return 'La contraseña debe incluir al menos \nuna letra.';
        }
        if (!hasNumber) {
          return 'La contraseña debe incluir al menos \nun número.';
        }
        if (!hasSpecialChar) {
          return 'La contraseña debe incluir al menos \nun carácter especial (!@#\$%^&*).';
        }

        return null; 
      },
      additionalSignupFields: [
        UserFormField(
          keyName: 'Nombres',
          userType: LoginUserType.firstName,
          fieldValidator: (value) {
            if (value == null || value.isEmpty) {
              return "Debe ingresar sus Nombres";
            }
            return null;
          },
        ),
        UserFormField(
          keyName: 'Apellidos',
          userType: LoginUserType.lastName,
          fieldValidator: (value) {
            if (value == null || value.isEmpty) {
              return "Debe ingresar sus Apellidos";
            }
            return null;
          },
          ),
        UserFormField(
          keyName: 'Dni',
          displayName: 'Dni',
          icon: const Icon(Icons.perm_identity),
          userType: LoginUserType.phone,
          fieldValidator: (value) {
            final phoneRegExp = RegExp(
              r'^\d{8}$',
            );
            if (value != null && !phoneRegExp.hasMatch(value)) {
              return "Es invalido el número ingresado";
            }
            return null;
          },
        ),
        UserFormField(
          keyName: 'Telefono',
          displayName: 'Teléfono',
          icon: const Icon(Icons.phone),
          userType: LoginUserType.phone,
          fieldValidator: (value) {
            final phoneRegExp = RegExp(
              r'^\d{9}$',
            );
            if (value != null && !phoneRegExp.hasMatch(value)) {
              return "Es invalido el número ingresado";
            }
            return null;
          },
        ),
      ],
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ));
      },
      messages: LoginMessages(
        userHint: 'Correo',
        passwordHint: 'Contraseña',
        forgotPasswordButton: 'Olvidaste tu contraseña?',
        confirmPasswordHint: 'Repetir Contraseña',
        loginButton: 'Ingresar',
        signupButton: 'Registrarse',
        recoverPasswordButton: 'Recuperar',
        recoverPasswordIntro: 'Restablece tu contraseña aquí',
        recoverCodePasswordDescription:'Ingrese su correo para recuperar contraseña!',
        goBackButton: 'Volver',
        confirmPasswordError: 'Las contraseñas no coinciden!',
        recoverPasswordSuccess: 'Código de confirmación enviado',
        confirmSignupIntro: 'Se envió un código de confirmación a su correo electrónico. Por favor ingrese el código para confirmar su cuenta',
        confirmationCodeHint: 'Código de confirmación',
        confirmationCodeValidationError: 'Código de confirmación esta vacío',
        resendCodeButton: 'Reenviaar código',
        resendCodeSuccess: 'Código de confirmación reenviado',
        confirmSignupButton: 'Confirmar',
        confirmSignupSuccess: 'Cuenta confirmada',
        confirmRecoverIntro: 'El código de recuperación para establecer una nueva contraseña fue enviado a su correo electrónico.',
        recoveryCodeHint: 'Código',
        recoveryCodeValidationError: 'Código de recuperación esta vacío',
        setPasswordButton: 'Establecer contraseña',
        confirmRecoverSuccess: 'Contraseña Recuperada',
        flushbarTitleError: 'Oh no!',
        flushbarTitleSuccess: 'Éxito!',
        signUpSuccess: 'Se ha enviado un enlace de activación',
        additionalSignUpFormDescription: 'Por favor, completa este formulario para registrarte',
        additionalSignUpSubmitButton: 'Enviar',
        providersTitleFirst: 'o ingresa con'
      ),
      // loginProviders: [
      //   LoginProvider(
      //     icon: Icons.fingerprint,
      //     label: 'Biometría',
      //     callback: () async {
      //       final token = await secureStorage.read(key: 'auth_token');

      //       if (token == null) {
      //         return 'Primero debes iniciar sesión manualmente';
      //       }

      //       final isAvailable = await LocalAuth.canAuth();
      //       if (!isAvailable) {
      //         return 'Biometría no disponible';
      //       }

      //       final isAuthenticated = await LocalAuth.authenticate();
      //       if (isAuthenticated) {
      //         if (!context.mounted) return null;
      //         Navigator.of(context).pushReplacement(
      //           MaterialPageRoute(builder: (_) => const HomeScreen()),
      //         );
      //         return null;
      //       } else {
      //         return 'Autenticación biométrica fallida';
      //       }
      //     },
      //   ),
      // ],
      footer: '©2025 Todos los derechos reservados.',
      hideForgotPasswordButton: false,
      initialIsoCode: 'PE',
      loginAfterSignUp: false,
      validateUserImmediately: true,
    );
  }
}