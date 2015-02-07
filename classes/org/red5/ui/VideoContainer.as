package org.red5.ui
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
	 
	import flash.events.Event;
	import flash.media.Video;
	
	import mx.core.UIComponent;
	
	/**
	 * Video object in Actionscript for displaying streaming video in MXML components.
	 * 
	 * @author Thijs Triemstra
	 */	
	public class VideoContainer extends UIComponent
	{
		
        /**
        * Video object instance.
        */		
        private var _video:Video;
        
		/**
		 * Display live and on-demand NetStream input. 
		 * <p>Listens for resize events.</p>
		 */        
		public function VideoContainer()
		{
			super();
			addEventListener( Event.RESIZE, resizeHandler );
		}

        /**
         * Accept a Video object as source input.
         * @param video Object displaying live or on-demand streaming video.
         */		
        public function set video( video : Video ) : void
        {
            if ( _video != null )
            {
                removeChild( _video );
            }

			_video = video;

           	if ( _video != null )
            {
	            _video.width = width;
                _video.height = height;
                addChild( _video );
            }
        }

        /**
         * Resize the <code>Video</code> object so it matches the dimensions of
         * the interface component.
         * @param event <code>Event.RESIZE</code> 
         */		
        private function resizeHandler( event : Event ) : void
        {
            if ( _video != null )
            {
               _video.width = width;
               _video.height = height;
            }
        }
        
	}
}
