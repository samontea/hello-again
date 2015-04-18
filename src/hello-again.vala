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

namespace Hello {

	public class HelloApp : Gtk.Application {
		public Gtk.ApplicationWindow mainwindow;

		public Gtk.Grid grid;
		public Gtk.ToolButton h_b;
		public Gtk.Button button;
		public Gtk.Label status;

		public Gtk.Popover popover;
		public Gtk.Grid grid_p;

		protected override void activate () {

			mainwindow = new Gtk.ApplicationWindow (this);
			mainwindow.set_position (Gtk.WindowPosition.CENTER);
			mainwindow.set_default_size (500, 400);
			mainwindow.destroy.connect (Gtk.main_quit);

			h_b = new Gtk.ToolButton (null, null);
			h_b.icon_name = "face-wink-symbolic";
/*			h_b.clicked.connect (() => {
					h_b.label = ":)";
					h_b.set_sensitive (false);
					});*/
			h_b.clicked.connect (() => {
					create_h_b_popover ();
				});

			grid_p = new Gtk.Grid ();

			popover = new Gtk.Popover (h_b);

			popover.add (grid_p);

			var tb = new Gtk.HeaderBar ();
			tb.pack_start (h_b);
			tb.show_close_button = true;

			tb.set_title("Wink");
			tb.set_subtitle("wink wink");

			mainwindow.set_titlebar (tb);

			status = new Gtk.Label ("Good bye!");

			button = new Gtk.Button.with_label ("Click me!");
			button.clicked.connect (() => {
					status.label = "Hello World!";
				});

			grid = new Gtk.Grid ();

			grid.column_spacing = 12;
			grid.row_spacing = 12;

			grid.attach (button, 0, 0, 1, 1);
			grid.attach (status, 0, 1, 1, 1);

			mainwindow.add (grid);

			mainwindow.show_all ();
		}

		private void create_h_b_popover () {

			popover.show_all();


		}

	}

}


int main (string[] args) {
	Gtk.init(ref args);

	var app = new Hello.HelloApp ();

	return app.run (args);
}
