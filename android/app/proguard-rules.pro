###-keep class org.slf4j.impl.StaticLoggerBinder { *; }
-dontwarn org.slf4j.impl.StaticLoggerBinder











##
## If dio_http_cache needs specific classes to be kept for caching
## Try keeping the relevant parts of dio_http_cache
#-keep class com.jakchan... { *; } # Example: If the error points to jakchan's classes
#-keep class com.path.to.dio_http_cache.** { *; } # Replace with actual path if known
#
## If the error persists, it might be that dio_http_cache's default cache
## requires a storage mechanism R8 is removing.
## The original error mentioned com.sslwireless.sslcommerz.FlutterSslcommerzPlugin
## and org.slf4j.impl.StaticLoggerBinder. Let's ensure those are NOT being kept
## if you are no longer using SSLCommerz or SLF4j.
#
## IF YOU ARE NOT USING SSLCOMMERZ ANYMORE AT ALL:
## Remove ALL SSLCommerz keep rules if you are sure they are not needed.
## This might resolve conflicts if they were the only thing causing R8 issues.
#
## IF YOU ARE STILL USING SSLCOMMERZ:
## Re-add ONLY the *essential* SSLCommerz keep rules.
## For example:
## -keep public class com.sslwireless.sslcommerz.FlutterSslcommerzPlugin { *; }
## And CHECK the missing_rules.txt from the previous build failure.
## If missing_rules.txt listed org.slf4j.impl.StaticLoggerBinder, then you NEED that rule.
## -keep class org.slf4j.impl.StaticLoggerBinder { *; }
#
## Default Flutter rules
#-keep class io.flutter.app.FlutterApplication { *; }
#-keep class io.flutter.embedding.android.FlutterActivity { *; }
#-keep class io.flutter.embedding.engine.FlutterEngine { *; }
#-keep class io.flutter.plugin.common.GeneratedParameterTransformer { *; }
#-keep class io.flutter.plugins.GeneratedPluginRegistrant { *; }
#
## Keep Activity and Services
#-keep class * extends android.app.Activity
#-keep class * extends android.app.Service
#-keep class * extends android.content.BroadcastReceiver
#-keep class * extends android.content.ContentProvider
#-keep class * extends android.app.Application
#
#-dontwarn org.slf4j.impl.StaticLoggerBinder