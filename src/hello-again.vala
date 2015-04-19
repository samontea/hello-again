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

namespace Hello {

	public class HelloApp : Gtk.Application {
		public Gtk.ApplicationWindow mainwindow;

		public Gtk.Grid grid;
		public Gtk.ToolButton h_b;
		public Gtk.ToolButton add;
		public Gtk.Calendar calendar;

		public Event e;

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

			e = new Event (new DateTime.now_local ());

			mainwindow.add (grid);

			mainwindow.show_all ();
		}

		private void create_h_b_popover () {
			var popover = new Gtk.Popover (h_b);


			popover.show_all ();
		}

		private void create_add_popover () {
			var label = new Gtk.Label.with_mnemonic ("Add a new event:");
			var calendar = new Gtk.Calendar ();
			var add_button = new Gtk.Button.with_label ("Add");

			var grid_add = new Gtk.Grid ();
			grid_add.margin = 6;
			grid_add.row_spacing = 6;
			grid_add.column_spacing = 12;
			grid_add.attach (label, 0, 0, 1, 1);
			grid_add.attach (calendar, 0, 1, 1, 1);
			grid_add.attach (add_button, 0, 2, 1, 1);

			var popover_add = new Gtk.Popover (add);
			popover_add.add (grid_add);
			popover_add.show_all ();
		}

	}

}


int main (string[] args) {
	Gtk.init(ref args);

	var app = new Hello.HelloApp ();

	return app.run (args);
}
