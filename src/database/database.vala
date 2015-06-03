namespace Hello.Data {

	public class DatabaseManager : GLib.Object {

		private static DatabaseManager database;
		public static DatabaseManager get_default () {
			if (database == null)
				database = new DatabaseManager ();

			return database;
		}

		//fields
		private SQLHeavy.Daatabase db;
		GLib.File db_file;

		//constructor
		private DatabaseManager () {

			database_location = Environment.get_user_data_dir () + "/hello-again";

			db_file = File.new_for_path (settings.database_location + "/events.db");

	        connect_database (!db_file.query_exists ());

		}

		//make the db
		private void connect_database (bool need_create) {

			try {
				db = new SQLHeavy.Database (db_file.get_path (),
											SQLHeavy.FileMode.READ | SQLHeavy.FileMode.WRITE | SQLHeavy.FileMode.CREATE);
				if (need_create) {
					db.execute ("CREATE VIRTUAL TABLE eventss USING fts3(name TEXT, createddatetime INT64, enddatetime INT64);");
				}
			} catch (SQLHeavy.Error e) {
				critical ("Could not create db: %s", e.message);
			}
		}

		public void add_event (Hello.Objects.Event evnt) {
			try {
				var q = db.prepare("INSERT INTO 'events' ( name, createddatetime, enddatetime) VALUES  (:name, :createddatetime, :enddatetime);");
				q.set_string (":name", evnt.name);
				q.set_int64 (":createddatetime", evnt.createddatetime.to_unix ());
				q.set_int64 (":enddatetime", evnt.enddatetime.to_unix ());
				q.execute ();
				e.id = (int)db.last_insert_id;
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

		public void delete_event (Hello.Object.Event evnt) {
			try {
				var q = db.prepare ("DELETE FROM 'events' WHERE rowid = :id;");
				q.set_int (":id", evnt.id);
				q.execute ();
			} catch (SQLHeavy.Error e) {
				critical (e.message);
			}

		}

	}

}
