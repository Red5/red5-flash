import com.mosesSupposes.fuse.ZigoEngine;
import com.mosesSupposes.fuse.FuseKitCommon;
/**
*
* Fuse Kit | (c) Moses Gunesch, see Fuse-Kit-License.html | http://www.mosessupposes.com/Fuse/
*
* @ignore
*
* This class is a sub-component of the public ZigoEngine class and should be considered private.
* Active engine code was broken out because non-static instance vars seem to process significantly faster.
* @author	Moses Gunesch
* @version	2.0 (Beta-Y13)
*/
class com.mosesSupposes.fuse.ZManager
{
	/**
	 * Internal 'tweenlist' object that stores all currently running tweens.
	 */ 
	public var tweens:Object;
	
	/**
	 * Couples with the tweens object to form a hash.
	 */ 
	public var numTweens:Number = 0;
	
	/**
	 * Internal storage of the current time, amalgamated per addTween and update cycle.
	 */ 
	public var now:Number;
	
	/**
	 * constructor
	 */
	public function ZManager()
	{
		tweens = {};
		numTweens = 0;
	}
	
	/**
	* Adds formatted tween objects to the engine's internal tween list for a single target 
	* @param obj			tween target object
	* @param props		list of properties to tween
	* @param endvals		corresponding list of tween end-values
	* @param seconds		duration of tween in seconds
	* @param ease			easing function for tween
	* @param delay		delay in seconds before performing tween
	* @param callback		pre-validated and formatted callback object
	* @return string		comma-delimited list of properties actually added
	*/
	public function addTween(obj:Object, props:Array, endvals:Array, seconds:Number, ease:Function, delay:Number, callback:Object):String
	{
		var skipLevel:Number =  ((callback.skipLevel==undefined) ? 0 : callback.skipLevel);
		var cycles:Number = ((callback.cycles==undefined) ? 1 : callback.cycles);
		var extra1:Object = callback.extra1;
		var extra2:Object = callback.extra2;
		// interrupted properties
		var ip:Array = []; 
		// user is responsible for import and initialization.
		var fmp:Object = _global.com.mosesSupposes.fuse.FuseFMP;
		var fmps:String = String('|'+(fmp).getAllShortcuts().join('|')+'|');
		var cts:String = FuseKitCommon._cts();
		var propsAdded:String = '';
		var valsAdded:String = '';
		var to:Object = tweens[String(obj.__zigoID__)];
		// AUTOSTOP kills all tweens running in an object
		if (to!=undefined && ZigoEngine.AUTOSTOP==true) {
			if (obj._listeners.length>0) {
				for (var j:String in to.props) ip.unshift(j);
			}
			to.numProps = 0;
			cleanUp(true);
		}
		for (var i:String in props) {
			var prop:String = props[i];
			var isCT:Boolean = ((cts.indexOf('|'+prop+'|'))>-1);
			var oldCP:String = to.colorProp;
			// overwrite properties
			if (to!=undefined) {
				// replace colorprop
				if (isCT==true && oldCP!=undefined) { 
					ip.unshift(oldCP);
					delete (to.props[oldCP]);
					delete (to.colorProp);
					to.numProps--;
				}
				else if (to.props[prop]!=undefined) {
					ip.unshift(prop);
					delete (to[prop]);
					to.numProps--;
				}
			}
			// preset notcolor/notfmp flags, updated below as needed
			var o:Object = { c:-1, fmp:-1 }; 
			var ep:Object = endvals[i];
			// if skipLevel is set, ignore delays.
			var isImmed:Boolean = ((skipLevel==0 && seconds+delay==0) || (skipLevel>0 && seconds==0)); 
			var propChanged:Boolean = false;
			var isFMP:Boolean = (fmp!=undefined && fmps.indexOf('|'+prop+'|')>-1);
			if (isFMP==true) {
				o.fmp = fmp; // flag fmp and store a reference to make it faster to access the class
				o.ps = fmp.getFilterProp(obj,prop,true);//3rd param generates filter if missing
				o.special = true;
			}
			// color. second part tests fmp/color
			if ( isCT==true || (isFMP==true && prop.indexOf('lor')>-1 && prop.charAt(2)!='l' && isImmed==false) ) {
				// Flash7 color transform (avoids using F8 code so kit can stay F6/F7 compatible)
				if (isCT==true) {	
					o.c = (new Color(obj));
					o.ps = o.c.getTransform();
					// _colorTransform is a colortransform object, all others are number or tint
					if (prop!='_colorTransform') { 
						var cp:String = (prop=='_tint' || prop=='_tintPercent' || prop=='_colorReset') ? 'tint' : prop.slice(1);
						var amt:Number = null;
						var tint:Object = null;
						if (cp=='tint') {
							// you can pass a tint as object {tint:Number/null/hexString, percent:Number/String}
							if (typeof ep=='object') { 
								// allow null, for reset
								tint = ep.tint;
								amt = (_global.isNaN(ep.percent)==true) ? 100 : ep.percent;
							}
							else if (prop=='_tintPercent' || prop=='_colorReset') {
								var curPct:Number = ZigoEngine.getColorKeysObj(obj).tintPercent;
								amt = (typeof ep=='string') ? (curPct || 0) + Number(ep) : Number(ep);
								amt = Math.max(0,Math.min(amt,100));
								if (prop=='_colorReset') amt = Math.min(curPct,100-amt);
								tint = (ZigoEngine.getColorKeysObj(obj).tint || 0x0);
							}
							else {
								tint = ep;
								amt = 100;
							}
						}
						else {
							amt = (typeof ep=='string') ? (ZigoEngine.getColorKeysObj(obj)[cp] || 0) + Number(ep) : ep;
						}
						ep = ZigoEngine.getColorTransObj(cp,amt,tint);
					}
				}
				else {
					// isFMP + color prop ( Bevel_highlightColor.. ) but not immediate update
					o.c = 1; 
					o.ps = ZigoEngine.getColorTransObj('tint',100,o.ps);
					ep = ZigoEngine.getColorTransObj('tint',100,ep);
				}
				if (isImmed==true) {
					// immediate update
					o.c.setTransform(ep); 
				}
				else {
					o.ch = {};
					for(var j:String in ep) {
						// (the first condition ensures that rb/gb/bb props are added to the change obj for fmp color props)
						if( ((o.c===1 && (j.charAt(1)=='b')) || ep[j]!=o.ps[j]) && ep[j]!=null && _global.isNaN(Number(ep[j]))==false ) {
							o.ch[j] = (typeof ep[j]=='string') ? Number(ep[j]) : ep[j] - o.ps[j];
							if (_global.isNaN(o.ch[j])==true) o.ch[j] = 0;
							else if (o.ch[j]!=0) propChanged = true;
						}
					}
				}
			}
			// bezier
			else if (prop=='_bezier_') { 
				// ep must be an object containing destination x,y and control x,y {x:,y:,controlX:controlY:}
				removeTween(obj,'_x,_y',true); 
				// overwrite any current x/y tweens
				if (isImmed==true) { 
				// immediate update
					if (ep.x!=null && _global.isNaN(Number(ep.x))==false) obj._x = ((typeof ep.x=='string') ? obj._x + Number(ep.x) : ep.x);
					if (ep.y!=null && _global.isNaN(Number(ep.y))==false) obj._y = ((typeof ep.y=='string') ? obj._y + Number(ep.y) : ep.y);
				}
				else {
					o.special = true;
					o.ps = 0;
					o.ch = 1;
					o.bz = {sx:obj._x, sy:obj._y}; // start x,y
					if (ep.x==null || _global.isNaN(Number(ep.x))) ep.x = o.bz.sx;
					if (ep.y==null || _global.isNaN(Number(ep.y))) ep.y = o.bz.sy;
					o.bz.chx = ((typeof ep.x=='string') ? Number(ep.x) : ep.x - o.bz.sx);
					if (_global.isNaN(o.bz.chx)==true) o.bx.chx = 0;
					o.bz.chy = ((typeof ep.y=='string') ? Number(ep.y) : ep.y - o.bz.sy);
					if (_global.isNaN(o.bz.chy)==true) o.bx.chy = 0;
					if (ep.controlX==null || _global.isNaN(Number(ep.controlX))) o.bz.ctrlx = o.bz.sx + (o.bz.chx/2); 
					//average if no control passed
					else o.bz.ctrlx = ((typeof ep.controlX=='string') ? o.bz.sx + Number(ep.controlX) : ep.controlX);
					if (ep.controlY==null || _global.isNaN(Number(ep.controlY))) o.bz.ctrly = o.bz.sy + (o.bz.chy/2); 
					//average if no control passed
					else o.bz.ctrly = ((typeof ep.controlY=='string') ? o.bz.sy + Number(ep.controlY) : ep.controlY);
					// precalc difference to lighten load at runtime
					o.bz.ctrlx -= o.bz.sx;
					// precalc difference to lighten load at runtime
					o.bz.ctrly -= o.bz.sy;
					propChanged = (o.bz.chx+o.bz.chy != 0);
				}
			}
			// normal single-value property
			else {
				// x or y tween overwrites bezier tween.
				if (prop=='_x' || prop=='_y') removeTween(obj,'_bezier_',true); 
				if (prop=='_frame' && typeof obj=='movieclip') {
					o.ps = obj._currentframe;
					o.special = true;
				}
				else if (isFMP==false) {
					// start val
					o.ps = obj[prop]; 
				}
				if (isImmed==true) {
					ep = ((typeof ep=='string') ? o.ps+Number(ep) : ep);
					if (isFMP==true) {
						fmp.setFilterProp(obj,prop,ep);
					}
					else obj[prop] = ep;
				}
				else {
					if (ep==null || _global.isNaN(Number(ep))) {
						ep = o.ps;
					}
					// change :: pass string for rel value
					o.ch = (typeof ep=='string') ? Number(ep) : Number(ep) - o.ps;
					if (_global.isNaN(o.ch)==true) o.ch = 0;
					propChanged = (o.ch!=0);
				}
			}
			// this conditional (plus isImmed above which factors in skipLevel) is the logic crux for determining nontween behavior.
			if ((skipLevel==0 && (propChanged==true || isImmed==false)) || (propChanged==true && isImmed==false)) {
				// start time
				o.ts = now + (delay*1000);	
				// pause time
				o.pt = -1;					
				// duration
				o.d  = seconds*1000;		
				// easing
				o.ef = ease;				
				// start-callback fired flag
				o.sf = false;				
				o.cycles = cycles;
				if (extra1!=undefined) o.e1 = extra1;
				if (extra2!=undefined) o.e2 = extra2;
				if (callback.start!=undefined)	o.scb = callback.start;		
				// note that if skipLevel>0, we don't get here if it's a non-tween, so callbacks are still okay.
				if (callback.upd!=undefined)	o.ucb = callback.upd;		
				if (callback.end!=undefined)	o.ecb = callback.end;
				// (use full query, since removeTween calls above can disrupt the 'to' var)
				if (tweens[String(obj.__zigoID__)]==undefined) { 
					to = tweens[String(obj.__zigoID__)] = {	numProps:0,
															locked:false,
															targ:obj,
															targID:String('"'+((obj._name!=undefined) ? obj._name : obj.toString()) + '"'),
															targZID:obj.__zigoID__,
															props:{} };
					numTweens++;
				}
				if (isCT==true) to.colorProp = prop;
				to.props[prop] = o;
				to.numProps++;
				propsAdded=(prop+','+propsAdded);
				valsAdded=(((typeof ep=='string') ? '"'+ep+'"' : ep)+','+valsAdded);
			}
			// (force garbage-collection)
			delete o; 
		// end props loop
		} 
		// if 'to' is ever undefined here, it would be due to removeTween calls above, which run cleanup.
		if (to==undefined || to.numProps<=0) cleanUp(); 
		if (ip.length>0 && (ZigoEngine['_listeners']).length>0) {
			(ZigoEngine['broadcastMessage'])('onTweenInterrupt', {target:obj, props:ip, __zigoID__:obj.__zigoID__});
		}
		// 0-duration+delay tweens and skipped nontweens may result in no tweens being added
		if (propsAdded=='') { 
			 // do nothing
			 if (skipLevel==2) {
				if (ZigoEngine.OUTPUT_LEVEL==2) FuseKitCommon.error('011',((obj._name!=undefined)?obj._name:(obj.toString())),props.toString());
			}
			// NonTween + Events - interlace event->callback. (callbacks are pre-validated)
			else { 
				var de:Boolean = (obj._listeners.length>0);
				if (de==true) obj.broadcastMessage('onTweenStart', {target:obj, props:props});
				if (callback.start!=undefined) callback.start.f.apply(callback.start.s, callback.start.a);
				if (de==true) obj.broadcastMessage('onTweenUpdate', {target:obj, props:props});
				if (callback.upd!=undefined) callback.upd.f.apply(callback.upd.s, callback.upd.a);
				if (de==true) obj.broadcastMessage('onTweenEnd', {target:obj, props:props});
				if (callback.end!=undefined) callback.end.f.apply(callback.end.s, callback.end.a);
			}
			cleanUp();
		}
		if (ZigoEngine.OUTPUT_LEVEL==2) {
			if (propsAdded=='') FuseKitCommon.error('012',((obj._name!=undefined)?obj._name:(obj.toString())),props.toString(),endvals.toString());
			else FuseKitCommon.error('013',((obj._name!=undefined)?obj._name:(obj.toString())),propsAdded.slice(0,-1),valsAdded.slice(0,-1));
		}
		return ((propsAdded=='') ? null : propsAdded.slice(0,-1));
	}
	
	/**
	* Internal removal of currently active tweens used by <code>ZigoEngine.removeTween</code>.
	* @param targs		One or more targets or the keyword 'ALL', null is rejected.
	* @param props		One or more props in any valid format, no value indicates all.
	* @param noInit		Internal flag used during addTween cycle to suppress engine reboot.
	*/
	public function removeTween(targs:Object, props:Object, noInit:Boolean):Void {
		// interrupted properties
		var ip:Object = {}; 
		// condense code then reset faster locals.
		var o:Object = paramsObj(targs,props); 
		if (o.none==true) return;
		var all:Boolean = o.all;
		var allp:Boolean = o.allprops;
		// may actually be Object or Array
		var tg:Object = ((all==true) ? tweens : Object(o.tg));
		var missing:Boolean = false;
		for (var j:String in tg) {
			var id:String = ((all==true) ? j : String((tg[j]).__zigoID__));
			var to:Object = tweens[id];
			var po:Object = (allp==true) ? to.props : o.props;
			for (var i:String in po) {
				var allcolor:Boolean = (i==FuseKitCommon.ALLCOLOR && to.colorProp!=undefined);
				if (to.props[i]!=undefined || allcolor==true) {
					if(ip[id]==null) ip[id] = [];
					(ip[id]).unshift(i);
					if (i==to.colorProp || allcolor==true) {
						delete (to.props[to.colorProp]);
						delete (to.colorProp);
					}
					else delete (to.props[i]);
					to.numProps--;
					if (to.numProps<=0) {
						missing = true;
						break;
					}
				}
			}
		}
		if ((ZigoEngine['_listeners']).length>0) {
			for (var k:String in ip) {
				// removed movieclips often query as not undefined, so check addProperty which is a base Object method in flash
				var t:Object = (tweens[k]).targ; 
				(ZigoEngine['broadcastMessage'])('onTweenInterrupt',
											   {target:((typeof t.addProperty=='function')?t:'[MISSING("'+(tweens[k]).targID+'")]'),
											    props:ip[k],
											    __zigoID__:(tweens[k]).targZID});
			}
		}
		// noInit param used during doTween so engine stays active
		if (missing==true) cleanUp(noInit); 
	}
	
	/**
	* Internal method used by <code>ZigoEngine.pauseTween</code>, <code>unpauseTween</code>, <code>rewTween</code>, <code>ffTween</code> methods.
	* @param type						string cuing which action is being requested by the engine class.
	* @param targs						one or more targets or the keyword 'ALL', null is rejected.
	* @param props						one or more props in any valid format, no value indicates all.
	* @param pauseFlag					whether to pause after rewind.
	* @param suppressStartEvents		if true onTweenStart and startfunc callbacks are not refired upon rewind; if false or undefined the events are refired.
	*/
	public function alterTweens(type:String, targs:Object, props:Object, pauseFlag:Boolean, suppressStartEvents:Boolean):Void
	{
		if (type=='lock') {
			(tweens[String(targs.__zigoID__)]).locked = Boolean(props==true);
			return;
		}
		// condense code then reset faster locals.
		var o:Object = paramsObj(targs,props); 
		if (o.none==true) return;
		var all:Boolean = o.all;
		var allp:Boolean = o.allprops;
		var tg:Object = (all==true) ? tweens : Object(o.tg);
		var hits:Number = 0;
		for (var j:String in tg) {
			var id:String = ((all==true) ? j : String((tg[j]).__zigoID__));
			var to:Object = tweens[id];
			var po:Object = (allp==true) ? to.props : o.props;
			if (po.ALLCOLOR==true) { // swap 'allcolor' keyword with actual colorprop.
				po[to.colorProp] = true;
				delete po.ALLCOLOR;
			}
			for (var prop:String in po) {
				hits++;
				var t:Object = to.props[prop];
				if (type=='rewind') {
					if (pauseFlag==true) t.pt = now;
					// reset start time
					t.ts = now; 
					// enable onTweenStart and startfunc to refire when rewound
					if (suppressStartEvents!=true) {
						t.sf = false;
						if (t.scb!=undefined) t.scb.fired = false;
					}
				}
				else if (type=='ff') {
					t.pt = -1;
					// back up start time so update will think it's done.
					t.ts = now - t.d; 
				}
				else if (type=='pause') {
					if(t.pt==-1) t.pt = now;
				}
				else if (type=='unpause') {
					if(t.pt!=-1) {
						// update start times 
						t.ts = now-(t.pt-t.ts); 
						t.pt = -1;
					}
				}
			}
		}
		if (type=='ff' && hits>0) update();
		else if (type=='rewind' && hits>0) update(true);
	}
	
	/**
	* Internal method used by <code>ZigoEngine.isTweenPaused</code>, <code>isTweenLocked</code>, <code>isTweening</code> methods.
	* @param type			string cuing which status is being requested by the engine class
	* @param targ			a target to query for requested status
	* @param param			one or more props in any valid format, no value indicates all
	* @return dynamic value
	*/
	public function getStatus(type:String, targ:Object, param:Object):Object
	{
		if (targ==null) return null;
		var all:Boolean = (targ.toUpperCase()==FuseKitCommon.ALL);
		var t:Object = tweens[String(targ.__zigoID__)];
		switch (type) {
		  case 'paused':
			var props:Object = t.props;
			if (param!=null) {
				if (props[param]==undefined) return false;
				return Boolean((props[param]).pt!=-1);
			}
			for (var i:String in props) {
				if ((props[i]).pt!=-1) return true;
			}
			return false;
		  case 'active':
		  	if (param==null) return Boolean(t!=undefined);
		  	if (param.toUpperCase()==FuseKitCommon.ALLCOLOR) return Boolean(t.colorProp!=undefined);
		  	return Boolean(t.props[param]!=undefined);
		  case 'count':
			if (!all) return (t.numProps);
			var count:Number = 0;
			for (var i:String in tweens) count+=(tweens[i]).numProps;
			return count;
		  case 'locked':
			return t.locked;
		}
	}
	
	/**
	* The primary on-pulse animation updating and event dispatching method.
	* @param force - used in rewTween to force paused tweens to update
	*/
	public function update(force:Boolean):Void
	{
		// loop through tweens
		var scb:Object = {};
		var ucb:Object = {};
		var ecb:Object = {};
		var sp:Object = {};
		var up:Object = {};
		var ep:Object = {};
		// for cleanUp()
		var missing:Boolean = false; 
		var RR:Boolean = ZigoEngine.ROUND_RESULTS;
		var i:String;
		for (i in tweens) {
			var to:Object = tweens[i]; 
			var targ:Object = to.targ;
			var props:Object = to.props;
			var evtFlag:Boolean = (targ._listeners.length>0);
			if (targ.__zigoID__==undefined) {
				missing = true;
				// removed movieclips often query as not undefined, so check addProperty which is a base Object method in flash
				if ((ZigoEngine['_listeners']).length>0) {
					var plist:Array = [];
					for (var prop:String in props) plist.unshift(prop);
					(ZigoEngine['broadcastMessage'])('onTweenInterrupt', 
						{ target:((typeof targ.addProperty=='function')?targ:'[MISSING:'+to.targID+']'), 
						  props:plist, __zigoID__:to.targZID });
				}
				continue;
			}
			for (var prop:String in props) {
				var t:Object = props[prop];
				// delayed tween waiting / skip processing paused tween
				if ((t.ts>now || t.pt!=-1) && force!=true) continue;	
				var done:Boolean = (now >= (t.ts+t.d));
				// run easing calc or set to endval if done.
				if(t.c==-1) {
					var val:Number;
					if (done==true) {
						val = (t.ps+t.ch);
						if (t.cycles>1 || t.cycles==0) {
							if (t.cycles>1) t.cycles--;
							t.ps = val;
							t.ch = -t.ch;
							t.ts = now;
							done = false;
						}
					}
					else {
						val = (t.ef((now-t.ts), t.ps, t.ch, t.d, t.e1, t.e2));
					}
					if (_global.isNaN(val)==false) {
						if (RR==true) {
							val = (Math.round(Number(val)));
						}
						if (t.special!=true) {
							// set all other single value properties
							targ[prop] = val;
						}
						else {
							if (t.fmp!=-1) {
								t.fmp.setFilterProp(targ,prop,val);
							}
							else if (prop=='_bezier_') {
								var bz:Object = t.bz;
								targ._x = (bz.sx + val*(2*(1-val)*bz.ctrlx + val*bz.chx));
								targ._y = (bz.sy + val*(2*(1-val)*bz.ctrly + val*bz.chy));
							}
							// enables frameTo if MC not extended with _frame.
							else if (prop=='_frame') { 
								MovieClip(targ).gotoAndStop(Math.round(val));
							}
						}
					}
				}
				else {
					// colortransform
					var tt:Object = {};
					var loop:Boolean = (done==true && (t.cycles>1 || t.cycles==0));
					for (var j:String in t.ch) {
						var cv:Number = t.ch[j];
						if (done==true) {
							tt[j] = (t.ps[j]+cv);
							if (loop==true) {
								t.ch[j] = -cv;
							}
						}
						else {
							tt[j] = (t.ef((now-t.ts), t.ps[j], cv, t.d, t.e1, t.e2));
						}
						
						if (_global.isNaN(tt[j])==false) {
							if (RR==true) {
								tt[j] = Math.round(tt[j]);
							}
							if (t.fmp==-1) {
								t.c.setTransform(tt);
							}
							else {
								//fmp color prop
								var rgb:Number = (tt.rb << 16 | tt.gb << 8 | tt.bb);// (rgb number built from transobj)
								t.fmp.setFilterProp(targ, prop, rgb); 
							}
						}
					}
					if (loop==true) {
						// perf.hit for this feature is very slight - slight drop (~1fps) per 200 r+g+b tweens.
						if (t.cycles>1) t.cycles--;
						done = false;
						t.ts = now;
						t.ps = tt;
					}
				}
				// start-event-fired flag; may be reset during rewind.
				if (t.sf==false) {
					if (evtFlag==true) {
						if (sp[i]==undefined) sp[i] = [];
						(sp[i]).unshift(prop);
					}
					t.sf = true;
				}
				// start-callback-fired flag; may be reset during rewind.
				if(t.scb.fired==false) {
					scb[String(t.scb.id)] = t.scb;
					t.scb.fired = true;
				}
				if (evtFlag==true) {
					if (up[i]==undefined) up[i] = [];
					(up[i]).unshift(prop);
				}
				if(t.ucb!=undefined) {
					ucb[String(t.ucb.id)] = t.ucb;
				}
				if (done==true) {
					if (evtFlag==true) {
						if (ep[i]==undefined) ep[i] = [];
						(ep[i]).unshift(prop);
					}
					if(t.ecb!=undefined) {
						ecb[String(t.ecb.id)] = t.ecb;
					}
					delete props[prop];
					if (prop==to.colorProp) delete (to.colorProp);
					to.numProps--;
					// cue cleanUp();
					if (to.numProps<=0) missing = true;
				}
				// end loop through props [prop]
			} 
		// end looop through targets [i]
		}
		// broadcast amalgamated events & execute callbacks once per target
		for (i in sp) (tweens[i]).targ.broadcastMessage('onTweenStart', {target:(tweens[i]).targ, props:sp[i]});
		for (i in scb) (scb[i]).f.apply((scb[i]).s, (scb[i]).a);
		for (i in up) (tweens[i]).targ.broadcastMessage('onTweenUpdate', {target:(tweens[i]).targ, props:up[i]});
		for (i in ucb) (ucb[i]).f.apply((ucb[i]).s, (ucb[i]).a);
		for (i in ep) (tweens[i]).targ.broadcastMessage('onTweenEnd', {target:(tweens[i]).targ, props:ep[i]});
		for (i in ecb) (ecb[i]).f.apply((ecb[i]).s, (ecb[i]).a);
		// cleanup
		if (missing) cleanUp();
		// update timer 
		now = getTimer();
	}
	
	/**
	 * Clean up tweens when targets go missing, this method helps reboot the manager when 're-testing' a published swf
	 * @param noInit	prevents engine deinit call during addTween
	 */
	public function cleanUp(noInit:Boolean):Void {
		for (var i:String in tweens) {
			var targ:Object = (tweens[i]).targ;
			if ((tweens[i]).numProps<=0 || targ.__zigoID__==undefined) {
				if (targ!=undefined && targ.tween==undefined && noInit!=true) {// If object was not initialized with shortcuts, clear its tweenable status.
					ZigoEngine.deinitializeTargets(targ);
				}
				delete (tweens[i]);
				numTweens--;
			}
		}
		if(numTweens<=0) {
			numTweens = 0;
			delete tweens;
			tweens = {};
			// last tween removed, turn off the updater
			if (noInit!=true) ZigoEngine.__mgrRelay(this,'setup',[true]); 
		}
	}
	
	/**
	 * helper for alterTweens, removeTween, and ZigoEngine.doTween to process & consolidate properties.
	 * @param targs		targets as passed by user
	 * @param props		props as passed by user
	 * @param endVals	end-values as passed to ZigoEngine.doTween
	 * @return			a custom object formatted for internal use
	 */
	public function paramsObj(targs:Object, props:Object, endvals:Object):Object { 
		var o:Object = {};
		o.all = (targs.toUpperCase()==FuseKitCommon.ALL);
		o.none = Boolean(targs==null);
		if (o.all==true) {
			// return a single fake target to accomodate for-in 'targs' loops
			o.tg = [null];
		} 
		else {
			o.tg = ((targs instanceof Array) ? targs:[targs]);
			for (var i:String in o.tg) {
				var t:Object = o.tg[i];
				if (t==null || !(typeof t=='object' || typeof t=='movieclip')) {
					// clean out dud targets
					o.tg.splice(Number(i),1); 
				}
			}
		}
		o.allprops = (props==null);
		var pa:Array;
		var va:Array;
		var pobj:Object = {};
		
		if (o.allprops==false) {
			if (typeof props=='string' && (String(props).indexOf(' ')>-1 || String(props).indexOf(',')>-1)) {
				// enable multiple comma-delimited string-relative end-values
				props = (String(((props).split(' ')).join('')).split(','));
			}
			pa = (props instanceof Array) ? ((props).slice()) : [props];
			
			// end-value proceessing for ZigoEngine class
			// (moved here to accompany complex props changes due to overlaps/conflicts/redundancy.)
			if (endvals!=undefined) {
				if (typeof endvals=='string' && (String(endvals).indexOf(' ')>-1 || String(endvals).indexOf(',')>-1)) {
					// enable multiple comma-delimited string-relative end-values
					endvals = (String(((endvals).split(' ')).join('')).split(','));
				}
				va = (endvals instanceof Array) ? ((endvals).slice()) : [endvals];
				// too few endvalues passed
				while (va.length<pa.length) va.push(va[va.length-1]);
				// too many endvalues passed
				va.splice(pa.length, (va.length-pa.length));
			}
			// process props for duplicates or psuedo-prop keys.
			for (var i:String in pa) {
				var insert:Number = Number(i);
				if (pa[i]!='_scale' && pa[i]!='_size') {
					if (pobj[pa[i]]==undefined) {
						if ((String(pa[i]).toUpperCase())==FuseKitCommon.ALLCOLOR) {
							// normalize case for special allcolor keyword (removeTween & alterTweens)
							pa[i] = FuseKitCommon.ALLCOLOR;
						}
						pobj[pa[i]] = true;
					}
					else {
						// strip duplicate prop/value
						pa.splice(insert,1);
						va.splice(insert,1);
					}
				}
				else {
					// split _scale & _size, avoiding duplicates.
					var prop:String = String((pa.splice(insert,1))[0]);
					var val:Object = (va.splice(insert,1))[0];
					if (prop=='_scale') {
						if (pobj._xscale==undefined) {
							pa.splice(insert,0,'_xscale');
							va.splice(insert,0,val);
							pobj._xscale = true;
							insert++;
						}
						if (pobj._yscale==undefined) {
							pa.splice(insert,0,'_yscale');
							va.splice(insert,0,val);
							pobj._yscale = true;
						}
						
					}
					if (prop=='_size') {
						if (pobj._width==undefined) {
							pa.splice(insert,0,'_width');
							va.splice(insert,0,val);
							pobj._width = true;
							insert++;
						}
						if (pobj._yscale==undefined) {
							pa.splice(insert,0,'_height');
							va.splice(insert,0,val);
							pobj._height = true;
						}
					}
				}
			}
			// lastly, remove overlapping scale / size props. Size props take precedence as in FuseItem.
			for (var i:String in pa) {
				if ((pa[i]=='_xscale' && pobj._width==true) || (pa[i]=='_yscale' && pobj._height==true)) {
					pa.splice(Number(i),1);
					va.splice(Number(i),1);
					delete (pobj[pa[i]]);
				}
			}
		}
		o.pa = pa;
		o.va = va;
		o.props = pobj;
		return o;
	}
}

