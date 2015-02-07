package  org.red5.samples.publisher.vo.settings
{
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
	 
	[Bindable]
	/**
	 * 
	 * @author Thijs Triemstra
	 */	
	public class VideoSettings 
	{
		/**
		* 
		*/		
		public var cameraIndex : int;
		
		/**
		* 
		*/		
		public var bandwidth : int;
		
		/**
		* 
		*/		
		public var quality : int;
		
		/**
		* 
		*/		
		public var width : int;
		
		/**
		* 
		*/		
		public var height : int;
		
		/**
		* 
		*/		
		public var keyframe : int;
		
		/**
		* 
		*/		
		public var fps : int;

		/**
		 * 
		 * @param cameraIndex
		 * @param bandwidth
		 * @param quality
		 * @param width
		 * @param height
		 * @param keyframe
		 * @param fps
		 * @return 
		 * 
		 */		
		public function VideoSettings(	cameraIndex : int = -1,
										bandwidth : int = 0,
										quality : int = 0,
										width : int = 320,
										height : int = 240,
										keyframe : int = 5,
										fps : int = 15 ) 
		{
			this.cameraIndex = cameraIndex;
			this.bandwidth = bandwidth;
			this.quality = quality;
			this.width = width;
			this.height = height;
			this.keyframe = keyframe;
			this.fps = fps;
		}
		
	}
}
