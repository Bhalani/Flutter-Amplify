# Keep Amplify Framework classes
-keep class com.amplifyframework.** { *; }
-keep class com.amazonaws.** { *; }
-dontwarn com.amplifyframework.**
-dontwarn com.amazonaws.**

# Keep AWS SDK classes
-keep class software.amazon.awssdk.** { *; }
-dontwarn software.amazon.awssdk.**

# Keep Cognito specific classes
-keep class com.amazonaws.services.cognitoidentityprovider.** { *; }
-keep class com.amazonaws.auth.** { *; }

# Keep JSON serialization classes
-keepattributes Signature
-keepattributes *Annotation*
-keep class com.google.gson.** { *; }
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep HTTP client classes for API Gateway calls
-dontwarn okhttp3.**
-dontwarn okio.**
-keep class okhttp3.** { *; }
-keep class okio.** { *; }

# Keep HTTP package classes
-keep class dart.http.** { *; }
-keep class io.flutter.plugins.** { *; }

# Keep networking classes
-keep class java.net.** { *; }
-keep class javax.net.** { *; }
-keep class java.security.cert.** { *; }
