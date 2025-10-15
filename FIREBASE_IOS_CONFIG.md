## Configuración de Firebase para iOS

### 1. Archivos de configuración

Descarga `GoogleService-Info.plist` desde Firebase Console y colócalo en:

```
ios/Runner/GoogleService-Info.plist
```

### 2. Configurar el proyecto iOS en Xcode

Abre `ios/Runner.xcworkspace` en Xcode y:

1. Agrega `GoogleService-Info.plist` al proyecto Runner
2. Asegúrate de que esté marcado para el target Runner

### 3. Configurar Info.plist

En `ios/Runner/Info.plist`:

```xml
<dict>
    <!-- Configuración existente -->

    <!-- Agregar para Firebase -->
    <key>FirebaseAppDelegateProxyEnabled</key>
    <false/>

    <!-- Para notificaciones en background -->
    <key>UIBackgroundModes</key>
    <array>
        <string>remote-notification</string>
        <string>background-fetch</string>
    </array>

    <!-- Permisos de notificación -->
    <key>NSUserNotificationUsageDescription</key>
    <string>Esta app necesita enviar notificaciones para alertas de emergencia</string>
</dict>
```

### 4. Configurar AppDelegate.swift

En `ios/Runner/AppDelegate.swift`:

```swift
import UIKit
import Flutter
import Firebase
import UserNotifications

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Configurar Firebase
        FirebaseApp.configure()

        // Configurar notificaciones
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self

            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()

        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    // Manejar tokens de notificación
    override func application(_ application: UIApplication,
                             didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }

    // Manejar notificaciones en foreground
    override func userNotificationCenter(_ center: UNUserNotificationCenter,
                                        willPresent notification: UNNotification,
                                        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([[.alert, .sound]])
    }

    // Manejar taps en notificaciones
    override func userNotificationCenter(_ center: UNUserNotificationCenter,
                                        didReceive response: UNNotificationResponse,
                                        withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}
```

### 5. Configurar entitlements

Crear/editar `ios/Runner/Runner.entitlements`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>aps-environment</key>
    <string>development</string>
</dict>
</plist>
```

### 6. Configurar Podfile

En `ios/Podfile`:

```ruby
platform :ios, '12.0'

target 'Runner' do
  use_frameworks!
  use_modular_headers!

  flutter_install_all_ios_pods File.dirname(File.realpath(__FILE__))

  # Firebase
  pod 'FirebaseMessaging', '>= 8.0.0'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
  end
end
```

### 7. Comandos para ejecutar

Después de la configuración:

```bash
cd ios
pod install
cd ..
```

### 8. Configuración en Firebase Console

1. Ve a Project Settings > Cloud Messaging
2. En iOS app configuration:
   - Sube tu certificado APNs (.p8 file) o
   - Sube tu certificado de desarrollo/producción (.p12 file)
3. Asegúrate de que el Bundle ID coincida

### 9. Notas importantes

- Para producción, cambia `aps-environment` a `production`
- El Bundle ID debe coincidir exactamente con Firebase
- Necesitas una cuenta de desarrollador de Apple activa
- Para testing en dispositivo físico, necesitas un certificado de desarrollo
