/* Copyright 2015 Samuel Mercier
*
* This file is part of Hello Again.
*
* Hello Again is free software: you can redistribute it
* and/or modify it under the terms of the GNU General Public License as
* published by the Free Software Foundation, either version 3 of the
* License, or (at your option) any later version.
*
* Hello Again is distributed in the hope that it will be
* useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
* Public License for more details.
*
* You should have received a copy of the GNU General Public License along
* with Hello Again. If not, see http://www.gnu.org/licenses/.
*/

using Hello.Objects;
//using Hello.Widgets;

namespace Hello {

	public class HelloApp : Gtk.Application {
		public Gtk.ApplicationWindow mainwindow;

		public Gtk.Grid grid;
		public Gtk.ToolButton h_b;
		public Gtk.ToolButton add;
		public Gtk.Calendar calendar;

		public List<Event> events;

		protected override void activate () {

			mainwindow = new Gtk.ApplicationWindow (this);
			mainwindow.set_position (Gtk.WindowPosition.CENTER);
			mainwindow.set_default_size (900, 800);
			mainwindow.destroy.connect (Gtk.main_quit);

			h_b = new Gtk.ToolButton (null, null);
			h_b.icon_name = "face-wink-symbolic";
			h_b.clicked.connect (() => {
				create_h_b_popover ();
			});

			add = new Gtk.ToolButton (null, null);
			add.icon_name = "list-add-symbolic";
			add.clicked.connect (() => {
				create_add_popover ();
			});

			var tb = new Gtk.HeaderBar ();
			tb.pack_end (add);
			tb.pack_start (h_b);
			tb.show_close_button = true;

			tb.set_title("Wink");
			tb.set_subtitle("wink wink");

			mainwindow.set_titlebar (tb);

			grid = new Gtk.Grid ();

			grid.column_spacing = 12;
			grid.row_spacing = 12;

			mainwindow.add (grid);

			mainwindow.show_all ();
		}

		private void create_h_b_popover () {
			var popover = new Gtk.Popover (h_b);
			var grid_h_b = new Gtk.Grid ();

			grid_h_b.margin = 6;
			grid_h_b.row_spacing = 6;
			grid_h_b.column_spacing = 12;


			var t_label0 = new Gtk.Label("Name:");
			var t_label1 = new Gtk.Label("Created date: ");
			var t_label2 = new Gtk.Label("End date: ");
			var t_label3 = new Gtk.Label("Total time (days): ");
			var t_label4 = new Gtk.Label("Time elapsed (days): ");
			var t_label5 = new Gtk.Label("Percent elapsed: ");

			grid_h_b.attach (t_label0, 0, 0, 1, 1);
			grid_h_b.attach (t_label1, 1, 0, 1, 1);
			grid_h_b.attach (t_label2, 2, 0, 1, 1);
			grid_h_b.attach (t_label3, 3, 0, 1, 1);
			grid_h_b.attach (t_label4, 4, 0, 1, 1);
			grid_h_b.attach (t_label5, 5, 0, 1, 1);

			int i = 1;

			events.foreach ((entry) => {
					var label0 = new Gtk.Label (entry.name);
					var label1 = new Gtk.Label (entry.createddatetime.to_string ());
					var label2 = new Gtk.Label (entry.enddatetime.to_string ());
					var label3 = new Gtk.Label (((entry.enddatetime.difference (entry.createddatetime) + GLib.TimeSpan.HOUR * 24) / GLib.TimeSpan.DAY).to_string ());
					var current =  new DateTime.now_local ();
					var label4 = new Gtk.Label ((current.difference (entry.createddatetime)  / GLib.TimeSpan.DAY).to_string ());
					int64 elapsed_t = (int64) (current.difference (entry.createddatetime))  / GLib.TimeSpan.HOUR;
					int64 total = (int64) (entry.enddatetime.difference (entry.createddatetime)) / GLib.TimeSpan.HOUR;

					double percent = (double)  elapsed_t / total;
					var label5 = new Gtk.Label (percent.to_string ());

					grid_h_b.attach (label0, 0, i, 1, 1);
					grid_h_b.attach (label1, 1, i, 1, 1);
					grid_h_b.attach (label2, 2, i, 1, 1);
					grid_h_b.attach (label3, 3, i, 1, 1);
					grid_h_b.attach (label4, 4, i, 1, 1);
					grid_h_b.attach (label5, 5, i, 1, 1);
					i++;
				});

			popover.add (grid_h_b);

			popover.show_all ();
		}

		private void create_add_popover () {
			var label = new Gtk.Label ("Add a new event:");
			var name = new Gtk.Entry ();
			name.set_text("Name");
			var calendar = new Gtk.Calendar ();
			var add_button = new Gtk.Button.with_label ("Add");

			var grid_add = new Gtk.Grid ();
			grid_add.margin = 6;
			grid_add.row_spacing = 6;
			grid_add.column_spacing = 12;
			grid_add.attach (label, 0, 0, 1, 1);
			grid_add.attach (name, 0, 1, 1, 1);
			grid_add.attach (calendar, 0, 2, 1, 1);
			grid_add.attach (add_button, 0, 3, 1, 1);

			var popover_add = new Gtk.Popover (add);
			popover_add.add (grid_add);

			add_button.clicked.connect (() => {
					var d = new DateTime.local(calendar.year, calendar.month + 1,
											   calendar.day, 0, 0, 0.0);
					events.append (new Event (name.get_text(), d));
					popover_add.hide ();
					update_events ();
				});

			popover_add.hide.connect (() => {
					popover_add.destroy ();
				});

			popover_add.show_all ();
		}

		private void update_events () {

			var t_label0 = new Gtk.Label("Name:");
			var t_label1 = new Gtk.Label("Created date: ");
			var t_label2 = new Gtk.Label("End date: ");
			var t_label3 = new Gtk.Label("Total time (days): ");
			var t_label4 = new Gtk.Label("Time elapsed (days): ");
			var t_label5 = new Gtk.Label("Percent elapsed: ");

			grid.attach (t_label0, 0, 0, 1, 1);
			grid.attach (t_label1, 1, 0, 1, 1);
			grid.attach (t_label2, 2, 0, 1, 1);
			grid.attach (t_label3, 3, 0, 1, 1);
			grid.attach (t_label4, 4, 0, 1, 1);
			grid.attach (t_label5, 5, 0, 1, 1);

			var i = 1;

			events.foreach ((entry) => {
					var label0 = new Gtk.Label (entry.name);
					var label1 = new Gtk.Label (entry.createddatetime.to_string ());
					var label2 = new Gtk.Label (entry.enddatetime.to_string ());
					var label3 = new Gtk.Label (((entry.enddatetime.difference (entry.createddatetime) + GLib.TimeSpan.HOUR * 24) / GLib.TimeSpan.DAY).to_string ());
					var current =  new DateTime.now_local ();
					var label4 = new Gtk.Label ((current.difference (entry.createddatetime)  / GLib.TimeSpan.DAY).to_string ());
					int64 elapsed_t = (int64) (current.difference (entry.createddatetime))  / GLib.TimeSpan.HOUR;
					int64 total = (int64) (entry.enddatetime.difference (entry.createddatetime)) / GLib.TimeSpan.HOUR;

					double percent = (double)  elapsed_t / total;
					var label5 = new Gtk.Label (percent.to_string ());

					grid.attach (label0, 0, i, 1, 1);
					grid.attach (label1, 1, i, 1, 1);
					grid.attach (label2, 2, i, 1, 1);
					grid.attach (label3, 3, i, 1, 1);
					grid.attach (label4, 4, i, 1, 1);
					grid.attach (label5, 5, i, 1, 1);
					i++;
				});

			mainwindow.show_all ();

		}

	}

}


int main (string[] args) {
	Gtk.init(ref args);

	var app = new Hello.HelloApp ();

	return app.run (args);
}
