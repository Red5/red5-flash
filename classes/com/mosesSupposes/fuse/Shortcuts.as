import com.mosesSupposes.fuse.ZigoEngine;
import com.mosesSupposes.fuse.FuseKitCommon;
/**
*
* Fuse Kit | (c) Moses Gunesch, see Fuse-Kit-License.html | http://www.mosessupposes.com/Fuse/
*
* @ignore
*
* Pass this class to ZigoEngine.register() or ZigoEngine.simpleSetup() to enable tween-shortcut functionality and 'easyfunc' callback parsing.
* The methods in this class are for public use by the engine only.
** @author	Moses Gunesch
* @version	2.0 (Beta-Y13)
**/
class com.mosesSupposes.fuse.Shortcuts
{
	/**
	 * @exclude
	 * Unique identifier used by ZigoEngine.register
	 */ 
	public static var registryKey:String = 'shortcuts';
	
	/**
	 * An internal memory object that stores all shortcut methods & properties for quick access.
	 */ 
	public static var shortcuts:Object = null;
	
	/**
	 * An internal memory object that stores all MovieClip-specific shortcut methods & properties for quick access.
	 */ 
	public static var mcshortcuts:Object = null;
	
	/**
	* A relay that ensures initShortcuts has been called, also called by <code>ZigoEngine.register()</code> to ensure class is imported and retained.
	*/
	public static function initialize():Void
	{
		if (shortcuts==null) initShortcuts();
	}
	
	/**
	* Allows you to run a single shortcut-style tween on any object without having to initialize it.<br>
	* Example: <code>com.mosesSupposes.fuse.ZigoEngine.doShortcut(my_mc, 'alphaTo', 100, 1, 'easeOutQuad');</code><br>
	* (This idea thanks to Yotam Laufer)<br>
	*
	* @param obj			target of tween
	* @param methodName		method type to tween
	*/
	public static function doShortcut(obj:Object, methodName:String):String
	{
		initialize();
		var s:Function = shortcuts[methodName];
		if (s==undefined) {
			if (typeof obj=='movieclip') s = mcshortcuts[methodName];
		}
		if (s==undefined) return null;
		obj = arguments.shift();
		methodName = String(arguments.shift());
		if (!(obj instanceof Array)) obj = [obj];
		var propsAdded:String = '';
		for (var i:String in obj) {
			var pa:String = String((s.apply(obj[i], arguments)));
			if (pa!=null && pa.length>0) {
				if (propsAdded.length>0) propsAdded=(pa+'|'+propsAdded);
				else propsAdded = pa;
			}
		}
		return ((propsAdded=='') ? null : propsAdded);
	}
	
	/**
	* The ZigoEngine uses this method to graft shortcut methods and properties into one or more target objects.
	* @params		 accepts any number of target objects
	*/
	public static function addShortcutsTo():Void
	{
		initialize();
		var doadd:Function = function(o:Object,so:Object) {
			for (var j:String in so) {
				var item:Object = so[j];
				if (item.getter || item.setter) {
					o.addProperty(j, item.getter, item.setter);
					_global.ASSetPropFlags(o, j, 3, 1); // must remain overwritable for direct initialization of individual targets.
				}
				else {
					o[j] = item;
					_global.ASSetPropFlags(o, j, 7, 1);
				}
			}
		};
		for (var i:String in arguments) {
			var obj:Object = arguments[i];
			// add MovieClip-only shortcuts
			if (obj==MovieClip.prototype || typeof obj=='movieclip') {
				doadd(obj,mcshortcuts);
			}
			doadd(obj,shortcuts);
		}
	}
	
	/**
	* The ZigoEngine uses this method to strip shortcut methods and properties from one or more target objects.
	* @params		accepts any number of target objects
	*/
	public static function removeShortcutsFrom():Void
	{
		initialize();
		var doremove:Function = function(o:Object,so:Object):Void {
			for (var j:String in so) {
				_global.ASSetPropFlags(o, j, 0, 2); // 0,2 is NOT a mistake, do not change
				var item:Object = so[j];
				if (item.getter || item.setter) {
					o.addProperty(j,null,null); 
				}
				delete o[j];
			}
		};
		for (var i:String in arguments) {
			var obj:Object = arguments[i];
			// remove MovieClip-only shortcuts
			if (obj==MovieClip.prototype || typeof obj=='movieclip') {
				doremove(obj,mcshortcuts);
			}
			doremove(obj,shortcuts);
		}
	}
	
	/**
	* The "easyfunc" syntax feature of the Kit, in which a string version of a complete callback like <code>"_root.gotoAndStop('home');"</code> is parsed, is stored in the Shortcuts class. If an easyfunc string is passed when Shortcuts has not been registered, a warning message is thrown. 
	* @param callbackStr	complete version of the callback
	* @return object
	*/
	public static function parseStringTypeCallback(callbackStr:String):Object
	{
		var evaluate:Function = function(val:String):Object { 
			var first:String = val.charAt(0);
			if (first==val.slice(-1) && (first=='"' || first=="'")) return val.slice(1,-1); // retain quoted values as strings
			if (val=='true') return Object(true);
			if (val=='false') return Object(false);
			if (val=='null') return Object(null);
			if (_global.isNaN(Number(val))==false) return Object(Number(val));
			return Object(eval(val)); // otherwise assume it's an expression, use eval to convert.
		};
		var trimWhite:Function = function(str:String):String {
			while(str.charAt(0)==' ') str = str.slice(1);
			while(str.slice(-1)==' ') str = str.slice(0,-1);
			return str;
		};
		var evaluateList:Function = function(list:Array):Array {
			var newlist:Array = [];
			for (var i:Number=0; i<list.length; i++) {
				var item:String = list[i];
				item = trimWhite(item);
				var isObj:Boolean = (item.charAt(0)=='{' && (item.indexOf('}')>-1 || item.indexOf(':')>-1));
				var isArray:Boolean = (item.charAt(0)=='[');
				if ((isObj || isArray)==true) {
					var o:Object = (isObj==true) ? {} : [];
					for (var k:Number=i; k<list.length; k++) {
						if (k==i) item = item.slice(1);
						var item2:String;
						var isEnd:Boolean = (item2.slice(-1)==((isObj==true) ? '}':']') || k==list.length-1);
						if (isEnd==true) item2 = item2.slice(0,-1);
						if (isObj==true && item2.indexOf(':')>-1) {
							var oParts:Array = item2.split(':');
							o[trimWhite(oParts[0])] = evaluate(trimWhite(oParts[1]));
						}
						else if (isArray==true) {
							o.push(evaluate(trimWhite(item2)));
						}
						if (isEnd==true) {
							newlist.push(o);
							i = k; // fake out loop
							break;
						}
					}
				}
				else {
					newlist.push(evaluate(trimWhite(item)));
				}
			}
			return newlist;
		};
		var parts:Array = callbackStr.split('(');
		var p0:String = parts[0];
		var p1:String = parts[1];
		return { func:(p0.slice(p0.lastIndexOf(".")+1)),
					 scope:eval(p0.slice(0,p0.lastIndexOf("."))),
					 args:(evaluateList((p1.slice(0, p1.lastIndexOf(")"))).split(","))) };
	}
	
	/**
	* Internal method that writes all shortcuts into a memory object, creating fast access for copying the set or locating a specific method for a <code>ZigoEngine.doShortcuts</code> call.
	*/
	private static function initShortcuts():Void
	{
		shortcuts = (new Object());
		var methods:Object = {	alphaTo:'_alpha',scaleTo:'_scale',sizeTo:'_size',rotateTo:'_rotation',brightnessTo:'_brightness',
								brightOffsetTo:'_brightOffset',contrastTo:'_contrast',colorTo:'_tint',tintPercentTo:'_tintPercent',
								colorResetTo:'_colorReset',invertColorTo:'_invertColor' };
		var fmethods:Array = _global.com.mosesSupposes.fuse.FuseFMP.getAllShortcuts(); // if FMP exists, graft a bunch more shortcuts.
		var okFmethods:Object = {blur:1,blurX:1,blurY:1,strength:1,shadowAlpha:1,highlightAlpha:1,angle:1,distance:1,alpha:1,color:1};
		for (var i:String in fmethods) if (okFmethods[(fmethods[i]).split('_')[1]]===1) methods[fmethods[i]+'To'] = fmethods[i];
		var ro:Object = {
			__resolve:function(name:String):Function {
				var propName:String = methods[name];
				return (function():String {
					var rs:String = (_global.com.mosesSupposes.fuse.ZigoEngine.doTween.apply(ZigoEngine, ((new Array(this, propName)).concat(arguments))));
					return rs;
				});
			}
		};
		var ro2:Object = {
			__resolve:function(name:String):Object {
				var prop:String = name.slice(1);
				var returnObj:Object = { getter:function():Object { return (_global.com.mosesSupposes.fuse.ZigoEngine.getColorKeysObj(this))[prop]; }};
				if (prop=='tintString' || prop=='tint') returnObj.setter = function(v:Object){ _global.com.mosesSupposes.fuse.ZigoEngine.setColorByKey(this,'tint',(_global.com.mosesSupposes.fuse.ZigoEngine.getColorKeysObj(this).tintPercent || 100),v); };
				else if (prop=='tintPercent') returnObj.setter = function(v:Number){ _global.com.mosesSupposes.fuse.ZigoEngine.setColorByKey(this,'tint',v,_global.com.mosesSupposes.fuse.ZigoEngine.getColorKeysObj(this).tint); };
				else if (prop=='colorReset') returnObj.setter = function(v:Number){ var co:Object = _global.com.mosesSupposes.fuse.ZigoEngine.getColorKeysObj(this); _global.com.mosesSupposes.fuse.ZigoEngine.setColorByKey(this,'tint',Math.min(100,Math.max(0,Math.min(co.tintPercent,100-v))),co.tint); };
				else returnObj.setter = function(v:Number){ _global.com.mosesSupposes.fuse.ZigoEngine.setColorByKey(this,prop,v); };
				return returnObj;
			}
		};
		for (var i:String in methods) {
			shortcuts[i] = ro[i];
			if (i=='colorTo') shortcuts._tintString = ro2['_tintString'];
			if (i.indexOf('bright')==0 || i=='contrastTo' || i=='colorTo' || i=='invertColor' || i=='tintPercentTo' || i=='colorResetTo') {
				shortcuts[methods[i]] = ro2[methods[i]];
			}
		}
		
		shortcuts.tween = function(props:Object, endVals:Object, seconds:Number, ease:Object, delay:Number, callback:Object):String { // references the method.
			if (arguments.length==1 && typeof props=='object') {
				return (ZigoEngine.doTween({ target:this, action:props }));
			}
			return (ZigoEngine.doTween(this, props, endVals, seconds, ease, delay, callback));
		};
		
		shortcuts.stopTween = function(props:Object):Void {
			com.mosesSupposes.fuse.ZigoEngine.removeTween(this,props);
		};
		
		shortcuts.isTweening = function(prop:String):Boolean {
			return ZigoEngine.isTweening(this, prop);
		};
		
		shortcuts.getTweens = function():Number {
			return ZigoEngine.getTweens(this);
		};
		
		shortcuts.lockTween = function():Void {
			com.mosesSupposes.fuse.ZigoEngine.lockTween(this, true);
		};
		
		shortcuts.unlockTween = function():Void {
			com.mosesSupposes.fuse.ZigoEngine.lockTween(this, false);
		};
		
		shortcuts.isTweenLocked = function():Boolean {
			return ZigoEngine.isTweenLocked(this);
		};
		
		shortcuts.isTweenPaused = function(prop:String):Boolean { 
			return ZigoEngine.isTweenPaused(this, prop);
		};
		
		shortcuts.pauseTween = function(props:Object):Void { 
			com.mosesSupposes.fuse.ZigoEngine.pauseTween(this,props);
		};
		
		shortcuts.unpauseTween = function(props:Object):Void {
			com.mosesSupposes.fuse.ZigoEngine.unpauseTween(this,props);
		};
		
		shortcuts.pauseAllTweens = function():Void { // globally pause all tweens from a clip
			com.mosesSupposes.fuse.ZigoEngine.pauseTween('ALL');
		};
		
		shortcuts.unpauseAllTweens = function():Void { // globally unpause all tweens from a clip
			com.mosesSupposes.fuse.ZigoEngine.unpauseTween('ALL');
		};
		
		shortcuts.stopAllTweens = function():Void { // globally remove all tweens from a clip
			com.mosesSupposes.fuse.ZigoEngine.removeTween('ALL');
		};
		
		shortcuts.ffTween = function(props:Object):Void {
			com.mosesSupposes.fuse.ZigoEngine.ffTween(this,props);
		};
		
		shortcuts.rewTween = function(props:Object,suppressStartEvents:Boolean):Void {
			com.mosesSupposes.fuse.ZigoEngine.rewTween(this,props,false,suppressStartEvents);
		};
		
		shortcuts.rewAndPauseTween = function(props:Object,suppressStartEvents:Boolean):Void {
			com.mosesSupposes.fuse.ZigoEngine.rewTween(this,props,true,suppressStartEvents);
		};
		
		// Special fadeIn & fadeOut shortcuts toggle the target's _visible property when alpha is at 0.
		shortcuts.fadeIn = function(seconds:Number, ease:Object, delay:Number, callback:Object):String {
			(this)._visible = true;
			return (ZigoEngine.doTween(this, '_alpha', 100, seconds, ease, delay));
		};
		
		shortcuts.fadeOut = function(seconds:Number, ease:Object, delay:Number, callback:Object):String {
			// create a hidden listener object instead of blocking out the callback.
			ZigoEngine.removeTween(this,'_alpha');
			if ((this).__zigoID__==null) ZigoEngine.initializeTargets(this);
			if ((this).__fadeOutEnd==undefined) {
				var end:Object = (this).__fadeOutEnd = {};
				end.__owner = this;
				end.onTweenEnd = function(o:Object):Void {
					if (String((o.props).join(',')).indexOf('_alpha')>-1) {
						((o.target)._visible = false);
						(this).onTweenInterrupt(o);
					}
				};
				end.onTweenInterrupt = function(o:Object):Void {
					if (o.target!=(this).__owner) return;
					(this).__owner.removeListener((this).__owner.__fadeOutEnd);
					com.mosesSupposes.fuse.ZigoEngine.removeListener((this).__owner.__fadeOutEnd);
				};
				_global.ASSetPropFlags((this), '__fadeOutEnd', 7, 1);
			}
			(this).addListener((this).__fadeOutEnd);
			ZigoEngine.addListener((this).__fadeOutEnd);
			return (ZigoEngine.doTween(this, '_alpha', 0, seconds, ease, delay, callback));
		};
		
		shortcuts.bezierTo = function(destX:Object, destY:Object, controlX:Object, controlY:Object, seconds:Number, ease:Object, delay:Number, callback:Object):String {
			return (ZigoEngine.doTween(this, '_bezier_', {x:destX,y:destY,controlX:controlX,controlY:controlY}, seconds, ease, delay, callback));
		};
		
		shortcuts.colorTransformTo = function(ra:Object, rb:Object, ga:Object, gb:Object, ba:Object, bb:Object, aa:Object, ab:Object, seconds:Number, ease:Object, delay:Number, callback:Object):String {
			return (ZigoEngine.doTween(this, '_colorTransform',{ra:ra, rb:rb, ga:ga, gb:gb, ba:ba, bb:bb, aa:aa, ab:ab}, seconds, ease, delay, callback));
		};
		
		shortcuts.tintTo = function(rgb:Object, percent:Object, seconds:Number, ease:Object, delay:Number, callback:Object):String {
			var o:Object = {};
			o.rgb = arguments.shift();
			o.percent = arguments.shift();
			return (ZigoEngine.doTween(this, '_tint', {tint:rgb,percent:percent}, seconds, ease, delay, callback));
		};
		
		shortcuts.slideTo = function(destX:Object, destY:Object, seconds:Number, ease:Object, delay:Number, callback:Object):String {
			return (ZigoEngine.doTween(this, '_x,_y', [destX,destY], seconds, ease, delay, callback));
		};
		
		shortcuts._size = {
			getter:function():Number { return (((this)._width==(this)._height) ? (this)._width : null); },
			setter:function(v:Number):Void { com.mosesSupposes.fuse.ZigoEngine.doTween((this),'_size',v,0); }
		};
		
		shortcuts._scale = {
			getter:function():Number { return (((this)._xscale==(this)._yscale) ? (this)._xscale : null); },
			setter:function(v:Number):Void { com.mosesSupposes.fuse.ZigoEngine.doTween((this),'_scale',v,0); }
		};
		
		mcshortcuts = (new Object());
		
		mcshortcuts._frame = {
			getter:function():Number { return (this)._currentframe; },
			setter:function(v:Number) { (this).gotoAndStop(Math.round(v)); }
		};
		
		mcshortcuts.frameTo = function(endframe:Object, seconds:Number, ease:Object, delay:Number, callback:Object):String {
			return (ZigoEngine.doTween((this), "_frame", ((endframe!=undefined) ? endframe : (this)._totalframes), seconds, ease, delay, callback));
		};
	}
}
