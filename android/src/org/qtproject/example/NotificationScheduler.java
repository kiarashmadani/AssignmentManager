package org.qtproject.example;

import android.Manifest;
import android.app.Activity;
import android.app.AlarmManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Build;
import android.provider.Settings;

import java.util.Map;

public class NotificationScheduler {

    static final String ACTION_REMIND =
            "org.qtproject.example.ACTION_REMIND";

    static final String EXTRA_ID = "notification_id";
    static final String EXTRA_MESSAGE = "message";

    private static final String PREFS = "scheduled_notifications";
    private static final String TIME_PREFIX = "time_";
    private static final String TEXT_PREFIX = "text_";

    private static boolean notificationPermissionRequested = false;

    // Called from Qt C++
    public static void schedule(
            Context context,
            int notificationId,
            long timestamp,
            String message) {

        if (notificationId < 0 ||
            timestamp <= System.currentTimeMillis() ||
            message == null || message.isEmpty()) {
            return;
        }

        requestNotificationPermission(context);

        // Save notification information for reboot recovery.
        SharedPreferences prefs = context.getSharedPreferences(
                PREFS, Context.MODE_PRIVATE);

        prefs.edit()
                .putLong(TIME_PREFIX + notificationId, timestamp)
                .putString(TEXT_PREFIX + notificationId, message)
                .apply();

        registerAlarm(context, notificationId, timestamp, message);
    }

    private static void registerAlarm(
            Context context,
            int notificationId,
            long timestamp,
            String message) {

        AlarmManager manager = (AlarmManager)
                context.getSystemService(Context.ALARM_SERVICE);

        if (manager == null)
            return;

        Intent intent = new Intent(context, ReminderReceiver.class);

        intent.setAction(ACTION_REMIND);
        intent.putExtra(EXTRA_ID, notificationId);
        intent.putExtra(EXTRA_MESSAGE, message);

        PendingIntent pendingIntent = PendingIntent.getBroadcast(
                context,
                notificationId,
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT |
                PendingIntent.FLAG_IMMUTABLE
        );

        try {
            if (Build.VERSION.SDK_INT >= 23) {

                if (Build.VERSION.SDK_INT < 31 ||
                    manager.canScheduleExactAlarms()) {

                    manager.setExactAndAllowWhileIdle(
                            AlarmManager.RTC_WAKEUP,
                            timestamp,
                            pendingIntent
                    );

                } else {

                    // Inexact fallback if exact alarms aren't permitted.
                    manager.setAndAllowWhileIdle(
                            AlarmManager.RTC_WAKEUP,
                            timestamp,
                            pendingIntent
                    );
                }

            } else {
                manager.setExact(
                        AlarmManager.RTC_WAKEUP,
                        timestamp,
                        pendingIntent
                );
            }

        } catch (SecurityException e) {
            // Exact alarm access may have been revoked.
            if (Build.VERSION.SDK_INT >= 23) {
                manager.setAndAllowWhileIdle(
                        AlarmManager.RTC_WAKEUP,
                        timestamp,
                        pendingIntent
                );
            }
        }
    }

    // Cancel a scheduled notification.
    public static void cancel(Context context, int notificationId) {

        AlarmManager manager = (AlarmManager)
                context.getSystemService(Context.ALARM_SERVICE);

        Intent intent = new Intent(context, ReminderReceiver.class);
        intent.setAction(ACTION_REMIND);

        PendingIntent pendingIntent = PendingIntent.getBroadcast(
                context,
                notificationId,
                intent,
                PendingIntent.FLAG_NO_CREATE |
                PendingIntent.FLAG_IMMUTABLE
        );

        if (pendingIntent != null) {
            if (manager != null)
                manager.cancel(pendingIntent);

            pendingIntent.cancel();
        }

        removeStored(context, notificationId);
    }

    // Remove the saved entry after firing or canceling.
    static void removeStored(Context context, int notificationId) {

        context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)
                .edit()
                .remove(TIME_PREFIX + notificationId)
                .remove(TEXT_PREFIX + notificationId)
                .apply();
    }

    // Restore pending notifications after reboot.
    public static void restore(Context context) {

        SharedPreferences prefs = context.getSharedPreferences(
                PREFS, Context.MODE_PRIVATE);

        Map<String, ?> entries = prefs.getAll();
        long now = System.currentTimeMillis();

        for (Map.Entry<String, ?> entry : entries.entrySet()) {

            String key = entry.getKey();

            if (!key.startsWith(TIME_PREFIX))
                continue;

            try {
                int id = Integer.parseInt(
                        key.substring(TIME_PREFIX.length()));

                long timestamp = (Long) entry.getValue();
                String message = prefs.getString(
                        TEXT_PREFIX + id, null);

                if (timestamp > now && message != null) {
                    registerAlarm(context, id, timestamp, message);
                } else {
                    removeStored(context, id);
                }

            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    // Ask for Android 13+ notification permission.
    public static void requestNotificationPermission(Context context) {

        if (notificationPermissionRequested)
            return;

        if (Build.VERSION.SDK_INT >= 33 &&
            context instanceof Activity &&
            context.checkSelfPermission(
                    Manifest.permission.POST_NOTIFICATIONS
            ) != PackageManager.PERMISSION_GRANTED) {

            notificationPermissionRequested = true;

            Activity activity = (Activity) context;

            activity.runOnUiThread(() ->
                    activity.requestPermissions(
                            new String[]{
                                    Manifest.permission.POST_NOTIFICATIONS
                            },
                            1001
                    )
            );
        }
    }

    // Optional: ask the user to allow precise alarm timing.
    public static void requestExactAlarmPermission(Context context) {

        if (Build.VERSION.SDK_INT < 31 ||
            !(context instanceof Activity)) {
            return;
        }

        AlarmManager manager = (AlarmManager)
                context.getSystemService(Context.ALARM_SERVICE);

        if (manager == null || manager.canScheduleExactAlarms())
            return;

        Activity activity = (Activity) context;

        activity.runOnUiThread(() -> {
            Intent intent = new Intent(
                    Settings.ACTION_REQUEST_SCHEDULE_EXACT_ALARM,
                    Uri.parse("package:" + context.getPackageName())
            );

            activity.startActivity(intent);
        });
    }
}
