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
package org.red5.samples.echo.model.tests
{
	/**
	 * @author Thijs Triemstra (info@collab.nl)
	*/
	public class StringTest extends BaseTest
	{
		public function StringTest()
		{
			super();
			
			tests.push("");
			tests.push("Hello world!");
			
			var strings: Array = new Array();
			strings.push("test1");
			strings.push("test2");
			strings.push("test3");
			strings.push("test4");
			tests.push(strings);
			
			// long Strings
			var i: Number;
			var longString: String = "";
			
			// 10,000 chars
			for (i=0; i<1000; i++)
				longString = longString + "0123456789";
			tests.push(longString);
			
			// 100,000 chars
			var reallyLongString: String = "";
			for (i=0; i<10000; i++)
				reallyLongString = reallyLongString + "0123456789";
			tests.push(reallyLongString);
			
			// 1,000,000 chars
			var giganticString: String = "";
			for (i=0; i<100000; i++)
				giganticString = giganticString + "0123456789";
			tests.push(giganticString);
		}
		
	}
}
