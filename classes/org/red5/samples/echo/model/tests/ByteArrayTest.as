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
	import flash.utils.ByteArray;
	
	import org.red5.utils.PNGEnc;
	
	/**
	 * @author Thijs Triemstra (info@collab.nl)
	*/
	public class ByteArrayTest extends BaseTest
	{
		public function ByteArrayTest()
		{
			super();
			
			var bmp1:BitmapData = new BitmapData( 80, 80, false, 0xCCCCCC );
			
			// Draw a red line in a BitmapData object
			for (var g:uint = 0; g < 80; g++) {
			    var red:uint = 0xFF0000;
			    bmp1.setPixel( g, 40, red );
			}
			
			// Create ByteArray with PNG data
			var temp1: ByteArray = PNGEnc.encode( bmp1 );
			temp1.compress();
			tests.push(temp1);
			
			var tmp2: Array = new Array();
			tmp2.push(temp1);
			tmp2.push(temp1);
			tests.push(tmp2);
		}
		
	}
}
