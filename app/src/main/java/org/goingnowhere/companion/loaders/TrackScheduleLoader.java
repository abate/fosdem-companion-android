package org.goingnowhere.companion.loaders;

import android.content.Context;
import android.database.Cursor;
import org.goingnowhere.companion.db.DatabaseManager;
import org.goingnowhere.companion.model.Day;
import org.goingnowhere.companion.model.Track;

public class TrackScheduleLoader extends SimpleCursorLoader {

	private final Day day;
	private final Track track;

	public TrackScheduleLoader(Context context, Day day, Track track) {
		super(context);
		this.day = day;
		this.track = track;
	}

	@Override
	protected Cursor getCursor() {
		return DatabaseManager.getInstance().getEvents(day, track);
	}
}
