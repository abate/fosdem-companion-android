package org.goingnowhere.companion;

import android.app.Application;
import android.preference.PreferenceManager;
import org.goingnowhere.companion.alarms.EventAlarmManager;
import org.goingnowhere.companion.db.DatabaseManager;

public class EventApplication extends Application {

	@Override
	public void onCreate() {
		super.onCreate();

		DatabaseManager.init(this);
		// Initialize settings
		PreferenceManager.setDefaultValues(this, R.xml.settings, false);
		// Alarms (requires settings)
		EventAlarmManager.init(this);
	}
}
