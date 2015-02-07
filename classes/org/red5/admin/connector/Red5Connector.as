package org.red5.admin.connector 
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
	
	import flash.net.NetConnection;
	import flash.events.IEventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.AsyncErrorEvent;
	import flash.events.IOErrorEvent
	import flash.events.Event;

	import flash.net.ObjectEncoding;
	
	import org.red5.admin.connector.event.Red5Event;
	import org.red5.utils.Debug;
	
	/**
	 * @author Martijn van Beek
	 */
	public class Red5Connector extends NetConnection implements IEventDispatcher
	{
		public static const CONNECT		: String = 'CONNECTED';
		public static const FAILED		: String = 'FAILED';
		
		private static var _instance	: Red5Connector
		private var _client				: Object; 
		
		public function Red5Connector( singleTon:SingletonEnforcer ):void {
			//_instance = this;
			super();
		}
		
		public static function getInstance():Red5Connector {
			if ( _instance == null ) {
				_instance = new Red5Connector( new SingletonEnforcer() );
			}
			return _instance;
		}
		
		public function connectServer ():void {
			client = this;
			// objectEncoding = ObjectEncoding.AMF0
			addEventListener ( SecurityErrorEvent.SECURITY_ERROR , netSecurityError ); 
			addEventListener ( NetStatusEvent.NET_STATUS , netStatusHandler );
			addEventListener ( IOErrorEvent.IO_ERROR , netIOError );
			addEventListener ( AsyncErrorEvent.ASYNC_ERROR , asyncError );
 		}

		private function asyncError(event:AsyncErrorEvent ):void
		{
			Debug.dumpObj(event);
		}
		
		private function netIOError(event:IOErrorEvent ):void
		{
			Debug.dumpObj(event);
		}
		
		private function netSecurityError(event:NetStatusEvent):void
		{
			Debug.dumpObj(event);
		}
		
        private function netStatusHandler(event:NetStatusEvent):void
        {
        	Debug.dumpObj(event.info);
			switch ( event.info.code ) {
				case "NetConnection.Connect.Success":
					dispatchEvent( new Red5Event ( CONNECT , event.info, true  ) );
					break;
				case "NetConnection.Connect.Failed":
				default:
					dispatchEvent( new Red5Event ( FAILED , event.info, true  ) );
					break;
            }
        }
        
        public function setId(id:Number ):*{
			return "Okay";
		}
		
        private function onResult(info:Object):void{
        	Debug.dumpObj(info);
		}
		
        private function onBWDone(info:Object):void{
        	Debug.dumpObj(info);
		}
		
        private function cuePointHandler(info:Object):void{
			Debug.dumpObj(info);
		}
		
        private function metaDataHandler(info:Object):void{
			Debug.dumpObj(info);
		}
	}
}

class SingletonEnforcer {}
