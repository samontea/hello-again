namespace Hello.Data {

	public class DatabaseManager : GLib.Object {

		private static DatabaseManager database;
		public static DatabaseManager get_default () {
			if (database == null)
				database = new DatabaseManager ();

			return database;
		}

		//fields
		private SQLHeavy.Database db;
		GLib.File db_file;

		//constructor
		private DatabaseManager () {

			var database_location = Environment.get_user_data_dir () + "/hello-again";

			//debug

			stdout.printf(database_location + "\n");

			db_file = File.new_for_path (database_location + "/events.db");

	        connect_database (!db_file.query_exists ());

		}

		//make the db
		private void connect_database (bool need_create) {

			try {
				//debug
				stdout.printf("connecting database\n" + "needed creation:" + need_create.to_string () + "\n");

				db = new SQLHeavy.Database (db_file.get_path (),
											SQLHeavy.FileMode.READ | SQLHeavy.FileMode.WRITE | SQLHeavy.FileMode.CREATE);
				if (need_create) {
					db.execute ("CREATE TABLE events (name TEXT, createddatetime INT64, enddatetime INT64, id INTEGER PRIMARY KEY AUTOINCREMENT);");
				}

			} catch (SQLHeavy.Error e) {
				critical ("Could not create db: %s", e.message);
			}
		}

		public void add_event (Hello.Objects.Event evnt) {
			try {
				//debug
				stdout.printf("adding things\n");
				var q = db.prepare("INSERT INTO 'events' ( name, createddatetime, enddatetime) VALUES  (:name, :createddatetime, :enddatetime);");
				q.set_string (":name", evnt.name);
				q.set_int64 (":createddatetime", evnt.createddatetime.to_unix ());
				q.set_int64 (":enddatetime", evnt.enddatetime.to_unix ());
				q.execute ();
				evnt.id = (int)db.last_insert_id;
			} catch (SQLHeavy.Error e) {
				critical (e.message);
			}
		}

		public void update_event (Hello.Objects.Event evnt) {
			try {
				var q = db.prepare ("UPDATE 'events' SET name=:name, enddatetime=:enddatetime WHERE rowid=:id");
				q.set_string (":name", evnt.name);
				q.set_int64 (":enddatetime", evnt.enddatetime.to_unix ());
				q.execute ();
				//think about an e.saved() funciton
			} catch (SQLHeavy.Error e) {
				critical (e.message);
			}
		}

		public void delete_event (Hello.Objects.Event evnt) {
			try {
				var q = db.prepare ("DELETE FROM 'events' WHERE rowid = :id;");
				q.set_int (":id", evnt.id);
				q.execute ();
			} catch (SQLHeavy.Error e) {
				critical (e.message);
			}

		}

		public List<Hello.Objects.Event> get_events () {
			var list = new List<Hello.Objects.Event> ();
			try {

				for (var res=db.execute ("SELECT name, createddatetime, enddatetime, id FROM 'events';"); !res.finished ; res.next ()) {

					var evnt = new Hello.Objects.Event.from_existing (res.fetch_string(0), datetime_converter(res, 1), datetime_converter(res, 2), res.fetch_int(3));

					list.append(evnt);

				}

			} catch (SQLHeavy.Error e) {
				warning ("Could not query the events: %s", e.message);
			}
			return list;
		}

		public DateTime datetime_converter (SQLHeavy.QueryResult res, int column_index) {
			DateTime return_value = new DateTime.now_local ();

			try {
				if (res.field_type (column_index) == typeof(string)) {
					var date_string = res.fetch_string (column_index);
					var parts = date_string.split (" ", 3);
					var hour_parts = parts[0].split (":", 2);
					var day_parts = parts[2].split (".", 3);
					var year = int.parse (day_parts[2]);
					var month = int.parse (day_parts[1]);
					var day = int.parse (day_parts[0]);
					var hours = int.parse (hour_parts[0]);
					var minutes = int.parse (hour_parts[1]);

					return_value = new DateTime.local (year, month, day, hours, minutes, 0);
				} else
					return_value = new DateTime.from_unix_local (res.fetch_int64 (column_index));
			} catch (SQLHeavy.Error e) {
				critical (e.message);
			}

			return return_value;
		}

	}

}
