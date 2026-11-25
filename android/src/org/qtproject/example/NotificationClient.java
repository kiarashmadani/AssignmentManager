package org.qtproject.example;

import android.Manifest;
import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Build;

public class NotificationClient {

    private static final String CHANNEL_ID = "assignment_deadlines";

    public static void notify(
            Context context,
            int notificationId,
            String message) {

        // Android 13+ notification permission
        if (Build.VERSION.SDK_INT >= 33 &&
            context.checkSelfPermission(
                    Manifest.permission.POST_NOTIFICATIONS
            ) != PackageManager.PERMISSION_GRANTED) {
            return;
        }

        NotificationManager manager =
                (NotificationManager) context.getSystemService(
                        Context.NOTIFICATION_SERVICE);

        if (manager == null)
            return;

        Notification.Builder builder;

        // Create notification channel on Android 8+
        if (Build.VERSION.SDK_INT >= 26) {

            NotificationChannel channel =
                    new NotificationChannel(
                            CHANNEL_ID,
                            "Assignment Reminders",
                            NotificationManager.IMPORTANCE_HIGH
                    );

            manager.createNotificationChannel(channel);

            builder = new Notification.Builder(context, CHANNEL_ID);

        } else {
            builder = new Notification.Builder(context);
        }

        builder.setSmallIcon(android.R.drawable.ic_dialog_info)
                .setContentTitle("Assignment Manager")
                .setContentText(message)
                .setAutoCancel(true);

        // Open the application when notification is tapped.
        Intent openIntent = context.getPackageManager()
                .getLaunchIntentForPackage(context.getPackageName());

        if (openIntent != null) {
            PendingIntent openPendingIntent = PendingIntent.getActivity(
                    context,
                    notificationId,
                    openIntent,
                    PendingIntent.FLAG_UPDATE_CURRENT |
                    PendingIntent.FLAG_IMMUTABLE
            );

            builder.setContentIntent(openPendingIntent);
        }

        try {
            manager.notify(notificationId, builder.build());
        } catch (SecurityException e) {
            e.printStackTrace();
        }
    }
}