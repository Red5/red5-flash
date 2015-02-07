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
	import flash.display.BitmapData;
	
	/**
	 * @author Thijs Triemstra (info@collab.nl)
	*/
	public class UnsupportedTest extends BaseTest
	{
		public function UnsupportedTest()
		{
			super();
			
			var bmp1:BitmapData = new BitmapData( 80, 80, false, 0xCCCCCC );
			
			// Draw a blue line in a BitmapData object
			for (var h:uint = 0; h < 80; h++)
			{
			    var blue:uint = 0x3232CD;
			    bmp1.setPixel( h, 40, blue );
			}
			tests.push(bmp1);
			
			var tmp1: Array = new Array();
			tmp1.push(bmp1);
			tmp1.push(bmp1);
			tests.push(tmp1);
		}
		
	}
}
