# Guía Completa de Instalación - Sistema de Notificaciones Push

## 📋 Resumen

Esta guía te ayudará a configurar completamente el sistema de notificaciones push que incluye:

- ✅ Backend con FCM (Firebase Cloud Messaging) - **COMPLETADO**
- ✅ Flutter App con Clean Architecture - **COMPLETADO**
- ⏳ Configuración de Firebase
- ⏳ Instalación de dependencias
- ⏳ Configuración de plataformas

---

## 🚀 Pasos de Instalación

### 1. Configurar Firebase Project

#### 1.1 Crear proyecto en Firebase Console

1. Ve a [Firebase Console](https://console.firebase.google.com/)
2. Crea un nuevo proyecto llamado "Ciudadano" (o usa uno existente)
3. Habilita Cloud Messaging en el menú izquierdo

#### 1.2 Agregar aplicación Android

1. En Project Overview, click "Add app" → Android
2. Package name: `com.example.ciudadano` (o tu package name)
3. Descarga `google-services.json`
4. Colócalo en: `android/app/google-services.json`

#### 1.3 Agregar aplicación iOS

1. En Project Overview, click "Add app" → iOS
2. Bundle ID: `com.example.ciudadano` (o tu bundle ID)
3. Descarga `GoogleService-Info.plist`
4. Colócalo en: `ios/Runner/GoogleService-Info.plist`

### 2. Backend - Configurar Firebase Admin

#### 2.1 Generar Service Account Key

1. Ve a Project Settings → Service Accounts
2. Click "Generate new private key"
3. Descarga el archivo JSON
4. Guárdalo como `firebase-service-account.json` en tu proyecto backend

#### 2.2 Configurar variables de entorno

Actualiza tu archivo `.env`:

```env
# Firebase Admin SDK
FIREBASE_SERVICE_ACCOUNT_PATH=./firebase-service-account.json
FIREBASE_PROJECT_ID=tu-project-id

# ... resto de variables existentes
```

#### 2.3 Ejecutar migración de base de datos

```bash
cd backend
npx prisma migrate dev --name add-push-tokens
```

### 3. Flutter - Instalar dependencias

#### 3.1 Agregar dependencias a pubspec.yaml

```yaml
dependencies:
  # Existentes...

  # Firebase
  firebase_core: ^3.8.0
  firebase_messaging: ^15.1.6

  # Notificaciones locales
  flutter_local_notifications: ^18.1.0

  # Permisos
  permission_handler: ^11.3.1
```

#### 3.2 Instalar dependencias

```bash
cd flutter_project
flutter pub get
```

### 4. Configuración Android

#### 4.1 Actualizar build.gradle (Project level)

En `android/build.gradle`:

```gradle
buildscript {
    ext.kotlin_version = '1.9.10'
    repositories {
        google()
        mavenCentral()
    }

    dependencies {
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
        classpath 'com.android.tools.build:gradle:8.1.4'
        classpath 'com.google.gms:google-services:4.4.0' // ← AGREGAR ESTA LÍNEA
    }
}
```

#### 4.2 Actualizar build.gradle (App level)

En `android/app/build.gradle`:

```gradle
// En la parte superior, después de apply plugin: 'kotlin-android'
apply plugin: 'com.google.gms.google-services' // ← AGREGAR ESTA LÍNEA

android {
    compileSdkVersion 34

    defaultConfig {
        applicationId "com.example.ciudadano"
        minSdkVersion 21  // ← CAMBIAR A 21
        targetSdkVersion 34
        multiDexEnabled true // ← AGREGAR ESTA LÍNEA
    }
}

dependencies {
    implementation 'com.google.firebase:firebase-messaging:23.4.0'
    implementation 'androidx.multidex:multidex:2.0.1'
}
```

#### 4.3 Actualizar AndroidManifest.xml

Sigue las instrucciones en `FIREBASE_ANDROID_CONFIG.md`

### 5. Configuración iOS

#### 5.1 Configurar en Xcode

1. Abre `ios/Runner.xcworkspace` en Xcode
2. Agrega `GoogleService-Info.plist` al proyecto Runner
3. Sigue las instrucciones en `FIREBASE_IOS_CONFIG.md`

#### 5.2 Instalar pods

```bash
cd ios
pod install
cd ..
```

### 6. Inicializar Firebase en Flutter

#### 6.1 Actualizar main.dart

Ya está configurado en el código generado. Verificar que se vea así:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Firebase
  await Firebase.initializeApp();

  // Configurar service locator
  await setupServiceLocator();

  runApp(const MyApp());
}
```

### 7. Testing

#### 7.1 Ejecutar la app

```bash
flutter run
```

#### 7.2 Usar la página de pruebas

- La app incluye una página de pruebas en `/notification-test`
- Puedes probar:
  - Solicitar permisos de notificación
  - Registrar token FCM
  - Ver estado de la conexión
  - Simular diferentes tipos de notificaciones

#### 7.3 Probar desde backend

Usa el endpoint para enviar notificaciones de prueba:

```bash
curl -X POST http://localhost:3000/api/notifications/test \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -d '{
    "title": "Test Notification",
    "body": "This is a test message",
    "type": "emergency_alert"
  }'
```

---

## 🔧 Troubleshooting

### Problemas comunes

#### Android

- **Error de build**: Verificar que `google-services.json` esté en `android/app/`
- **Permisos denegados**: Verificar AndroidManifest.xml
- **Token null**: Verificar configuración de Firebase

#### iOS

- **Pod install falla**: Actualizar CocoaPods (`sudo gem install cocoapods`)
- **Certificado**: Verificar configuración en Firebase Console
- **Permisos**: Verificar Info.plist

#### Firebase

- **Token inválido**: Verificar service account key
- **Proyecto no encontrado**: Verificar PROJECT_ID en .env
- **Permisos**: Verificar que Cloud Messaging esté habilitado

### Logs útiles

```bash
# Flutter logs
flutter logs

# Backend logs
npm run dev

# Firebase debugging
firebase --debug
```

---

## 📱 Estructura del Proyecto

### Backend (Completado ✅)

```
src/
├── features/
│   ├── alerts/
│   │   └── server/route.ts          # Integrado con FCM
│   └── notifications/
│       └── server/route.ts          # Nuevos endpoints
├── lib/
│   ├── firebase-admin.ts            # Configuración Firebase
│   └── push-notifications.ts       # Servicio FCM
└── server/db.ts                     # Prisma con PushToken
```

### Flutter (Completado ✅)

```
lib/
├── features/
│   └── notifications/
│       ├── domain/                  # Entities, Repositories, Use Cases
│       ├── data/                    # Implementaciones, Datasources
│       ├── presentation/            # BLoC, Pages, Widgets
│       └── notification_test_page.dart  # Página de pruebas
└── main.dart                        # Firebase inicializado
```

---

## 🎯 Siguiente Pasos

1. **Configurar Firebase Project** (15 min)
2. **Instalar dependencias Flutter** (5 min)
3. **Configurar Android** (10 min)
4. **Configurar iOS** (15 min)
5. **Testing** (10 min)

**Total estimado: ~1 hora**

¡Una vez completados estos pasos, tu sistema de notificaciones push estará funcionando completamente! 🚀
