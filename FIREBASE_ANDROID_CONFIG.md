## Configuración de Firebase para Android

### 1. Archivos de configuración

Descarga `google-services.json` desde Firebase Console y colócalo en:

```
android/app/google-services.json
```

### 2. Configurar build.gradle (Project level)

En `android/build.gradle`:

```gradle
buildscript {
    dependencies {
        classpath 'com.google.gms:google-services:4.4.0'
    }
}
```

### 3. Configurar build.gradle (App level)

En `android/app/build.gradle`:

```gradle
// En la parte superior
apply plugin: 'com.google.gms.google-services'

android {
    defaultConfig {
        minSdkVersion 21
        multiDexEnabled true
    }
}

dependencies {
    implementation 'com.google.firebase:firebase-messaging:23.4.0'
    implementation 'androidx.multidex:multidex:2.0.1'
}
```

### 4. Configurar AndroidManifest.xml

En `android/app/src/main/AndroidManifest.xml`:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">

    <!-- Permisos -->
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.WAKE_LOCK" />
    <uses-permission android:name="android.permission.VIBRATE" />
    <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
    <uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>

    <application>

        <!-- Servicio para notificaciones en background -->
        <service
            android:name="io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingService"
            android:exported="false">
            <intent-filter>
                <action android:name="com.google.firebase.MESSAGING_EVENT" />
            </intent-filter>
        </service>

        <!-- Metadata para notificaciones -->
        <meta-data
            android:name="com.google.firebase.messaging.default_notification_icon"
            android:resource="@drawable/ic_stat_ic_notification" />

        <meta-data
            android:name="com.google.firebase.messaging.default_notification_color"
            android:resource="@color/colorAccent" />

        <meta-data
            android:name="com.google.firebase.messaging.default_notification_channel_id"
            android:value="high_importance_channel" />

    </application>
</manifest>
```

### 5. Crear iconos de notificación

Crear archivo `android/app/src/main/res/drawable/ic_stat_ic_notification.xml`:

```xml
<vector xmlns:android="http://schemas.android.com/apk/res/android"
    android:width="24dp"
    android:height="24dp"
    android:viewportWidth="24"
    android:viewportHeight="24"
    android:tint="?attr/colorOnPrimary">
  <path
      android:fillColor="@android:color/white"
      android:pathData="M12,2A10,10 0 0,0 2,12A10,10 0 0,0 12,22A10,10 0 0,0 22,12A10,10 0 0,0 12,2Z"/>
</vector>
```

### 6. Configurar colores

En `android/app/src/main/res/values/colors.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <color name="colorAccent">#FF6200EE</color>
</resources>
```

### 7. MainActivity.kt

En `android/app/src/main/kotlin/.../MainActivity.kt`:

```kotlin
package com.example.ciudadano

import android.os.Build
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Crear canal de notificación para Android 8+
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channelId = "high_importance_channel"
            val channelName = "High Importance Notifications"
            val channelDescription = "This channel is used for important notifications."
            val importance = android.app.NotificationManager.IMPORTANCE_HIGH
            val channel = android.app.NotificationChannel(channelId, channelName, importance)
            channel.description = channelDescription

            val notificationManager = getSystemService(android.app.NotificationManager::class.java)
            notificationManager.createNotificationChannel(channel)
        }
    }
}
```
