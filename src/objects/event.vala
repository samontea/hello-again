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

namespace Hello.Objects {

	public class Event : GLib.Object {

		public DateTime createddatetime;
		public DateTime enddatetime;
		public string name;
		public int id;

		public Event (string text, DateTime end) {
			name = text;
			createddatetime = new DateTime.now_local ();
			enddatetime = end;
		}

		public Event.from_existing (string name, DateTime createddatetime, DateTime enddatetime, int id) {
			this.name = name;
			this.createddatetime = createddatetime;
			this.enddatetime = enddatetime;
			this.id = id;
		}

	}

}
