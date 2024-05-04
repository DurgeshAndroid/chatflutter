# Add project specific ProGuard rules here.
# You can control the set of applied configuration files using the
# proguardFiles setting in build.gradle.
#
# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html

# If your project uses WebView with JS, uncomment the following
# and specify the fully qualified class name to the JavaScript interface
# class:
#-keepclassmembers class fqcn.of.javascript.interface.for.webview {
#   public *;
#}

# Uncomment this to preserve the line number information for
# debugging stack traces.
#-keepattributes SourceFile,LineNumberTable

# If you keep the line number information, uncomment this to
# hide the original source file name.
#-renamesourcefileattribute SourceFile
#-dontwarn com.google.**
# Add any classes/packages you want to keep here
# Firebase
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.firebase.**
-dontwarn com.google.android.gms.**
-keepattributes Signature

# For Firebase Analytics
-keep class com.google.android.gms.measurement.** { *; }
-dontwarn com.google.android.gms.measurement.**

# For Firebase Crashlytics
-keep class com.google.firebase.crashlytics.** { *; }
-dontwarn com.google.firebase.crashlytics.**



# FirebaseFirestore
# Keep the model classes if you're using Firebase Firestore
-keepclassmembers class com.yourpackage.models.** {
  *;
}

# If using custom adapters or converters, keep them
-keep class com.yourpackage.adapter.** { *; }
-keep class com.yourpackage.converter.** { *; }

# If you're using any callbacks or listeners, keep them
#-keep class * implements com.zego.zegoliveroom.callback.** { *; }
#-keep class * extends com.zego.zegoliveroom.entity.** { *; }

# If using Zego Live Room features, additional rules may be needed
# -keep class com.zego.** { *; }
# -dontwarn com.zego.**