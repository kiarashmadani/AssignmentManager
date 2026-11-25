package org.qtproject.example;

import android.app.AlarmManager;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

public class ReminderReceiver extends BroadcastReceiver {

    @Override
    public void onReceive(Context context, Intent intent) {

        String action = intent.getAction();

        if (NotificationScheduler.ACTION_REMIND.equals(action)) {

            int notificationId = intent.getIntExtra(
                    NotificationScheduler.EXTRA_ID, -1);

            String message = intent.getStringExtra(
                    NotificationScheduler.EXTRA_MESSAGE);

            if (notificationId < 0 || message == null)
                return;

            // The one-time alarm has fired.
            NotificationScheduler.removeStored(context, notificationId);

            // Display the Android notification.
            NotificationClient.notify(
                    context,
                    notificationId,
                    message
            );

        } else if (
                Intent.ACTION_BOOT_COMPLETED.equals(action) ||
                AlarmManager.ACTION_SCHEDULE_EXACT_ALARM_PERMISSION_STATE_CHANGED
                        .equals(action)) {

            NotificationScheduler.restore(context);
        }
    }
}
