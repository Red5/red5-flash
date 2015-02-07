/**
* RED5 Open Source Flash Server - http://www.osflash.org/red5
*
* Copyright (c) 2006-2009 by respective authors (see below). All rights reserved.
*
* This library is free software; you can redistribute it and/or modify it under the
* terms of the GNU Lesser General Public License as published by the Free Software
* Foundation; either version 2.1 of the License, or (at your option) any later
* version.
*
* This library is distributed in the hope that it will be useful, but WITHOUT ANY
* WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
* PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.
*
* You should have received a copy of the GNU Lesser General Public License along
* with this library; if not, write to the Free Software Foundation, Inc.,
* 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
*/

import com.blitzagency.data.DecodeHTML;

class org.red5.samples.livestream.videoconference.TextFilter 
{
// Constants:
	public static var CLASS_REF = org.red5.samples.livestream.videoconference.TextFilter;
	public static var initialized:Boolean = initialize();
// Public Properties:
// Private Properties:

// Public Methods:
	public static function encodeText(p_msg:String):String
	{
		p_msg = DecodeHTML.decode(p_msg);
		return p_msg;
	}
// Semi-Private Methods:
// Private Methods:
	private static function initialize():Boolean
	{
		DecodeHTML.addStrings
		(
			new Array(
				{from: ":)", to: "<b>:)</b>"},
				{from: ";)", to: "<b>;)</b>"},
				{from: ":(", to: "<b>:(</b>"},
				{from: ";(", to: "<b>;(</b>"},
				{from: ":p", to: "<b>:p</b>"},
				{from: ";p", to: "<b>;p</b>"}
			)
		)
		trace("initialized");
		return true;
	}
	
	private static function bold(p_msg):String
	{
		return null;
	}
}
