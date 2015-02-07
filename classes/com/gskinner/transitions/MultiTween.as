/**
* MultiTween by Grant Skinner. August 12, 2005
* Visit www.gskinner.com/blog for documentation, updates and more free code.
*
* You may distribute this class freely, provided it is not modified in any way (including
* removing this header or changing the package path).
*
* Please contact info@gskinner.com prior to distributing modified versions of this class.
*/

class com.gskinner.transitions.MultiTween {
// public properties:
	public var props:Object;
	
// private properties:
	private var _position:Number;
	private var propList:Array;
	private var startVals:Object;
	private var targetObj:Object;
	private var endVals:Object;
	
// initialization:
	public function MultiTween(p_targetObj:Object,p_endVals:Object,p_propList:Array,p_props:Object) {
		props = p_props;
		
		if (p_propList == undefined) {
			p_propList = [];
			if (p_targetObj instanceof Array) {
				var l:Number = p_endVals.length;
				for (var i:Number=0;i<l;i++) {
					p_propList.push(i.toString());
				}
			} else {
				for (var n:String in p_endVals) {
					p_propList.push(n);
				}
			}
		}
		
		targetObj = p_targetObj;
		
		startVals = {};
		endVals = {};
		var l:Number = p_propList.length;
		propList = [];
		for (var i:Number=0;i<l;i++) {
			var prop:String = p_propList[i];
			var sv:Number = (p_targetObj[prop] == undefined)?0:Number(p_targetObj[prop]);
			var ev:Number = (p_endVals[prop] == undefined)?0:Number(p_endVals[prop]);
			if (isNaN(sv) || isNaN(ev) || sv == ev) { continue; }
			startVals[prop] = sv;
			endVals[prop] = ev;
			propList.push(prop);
		}
		
		_position = 0;
	}
	
// public methods:
	public function setPosition(p_position:Number):Void {
		_position = p_position;
		// move objects to local scope to make them faster to work with:
		var targObj:Object = targetObj;
		var svs:Object = startVals;
		var evs:Object = endVals;
		var pl:Array = propList;
		
		var l:Number = propList.length;
		for (var i:Number=0;i<l;i++) {
			var prop:String = propList[i];
			var sv:Number = svs[prop];
			targObj[prop] = sv+(evs[prop]-sv)*_position;
		}
	}
	
// getter / setters:
	public function get position():Number { return _position; }
	public function set position(p_position:Number):Void { setPosition(p_position); }
}
