import flash.filters.*;
import com.mosesSupposes.fuse.FuseKitCommon;
/**
* Provides easy Flash8 BitmapFilter handling. Can be used in conjunction with ZigoEngine and Fuse to animate filters.
* @author	Danilo Sandner
* @author	Björn Wibben
* @author	Moses Gunesch
* @version	1.0
*/
class com.mosesSupposes.fuse.FuseFMP {
	
	/**
	 * @exclude
	 * Unique identifier used by ZigoEngine.register
	 */ 
	public static var registryKey:String = 'fuseFMP';
	
	/**
	 * Enables FuseFMP version,authors to be retrieved at runtime or when reviewing a decompiled swf.
	 */ 
	public static var VERSION:String = '1.0';
	public static var AUTHOR:String = FuseKitCommon.AUTHOR+', FuseFMP concept credited to: Danilo Sandner | Bjorn Wibben | flash-fmp.de';
	
	/**
	* Automatically extends MC, Button & TF prototypes with FuseFMP shortcuts. Also sets global references to FuseFMP and all filter classes so timeline coders can avoid using import statements.
	*/
	public static function simpleSetup() : Void {
		initialize(MovieClip.prototype, Button.prototype, TextField.prototype);
		_global.FuseFMP = FuseFMP;
		for (var i:String in $fclasses) {
			_global[i] = $fclasses[i];
		}
	}
	
	/**
	 * Internal; Ensures import
	 */ 
	private static var $fclasses:Object;
	/**
	 * Internal; memory object for shortcut methods
	 */ 
	private static var $shortcuts:Object;
	/**
	 * Internal; resolve object for shortcut getters
	 */ 
	private static var $gro:Object;
	/**
	 * Internal; resolve object for shortcut setters
	 */ 
	private static var $sro:Object;
	
	/**
	* Adds shortcuts to all target objects passed.
	*/
	public static function initialize():Void {
		if ($fclasses == undefined) {
			$shortcuts = {getFilterName:function (f:BitmapFilter):String {
				return FuseFMP.getFilterName(f);
			}, getFilterIndex:function (f:Object):Number {
				return FuseFMP.getFilterIndex(this, f);
			}, getFilter:function (f:Object, createNew:Boolean):BitmapFilter {
				return FuseFMP.getFilter(this, f, createNew);
			}, writeFilter:function (f:Object, pObj:Object):Number {
				return FuseFMP.writeFilter(this, f, pObj);
			}, removeFilter:function (f:Object):Boolean {
				return FuseFMP.removeFilter(this, f);
			}, getFilterProp:function (prop:String, createNew:Boolean) {
				return FuseFMP.getFilterProp(this, prop, createNew);
			}, setFilterProp:function (prop:String, v:Object):Void {
				FuseFMP.setFilterProp(this, prop, v);
			}, setFilterProps:function (fOrPObj:Object, pObj:Object):Void {
				FuseFMP.setFilterProps(this, fOrPObj, pObj);
			}, traceAllFilters:function ():Void {
				FuseFMP.traceAllFilters();
			}};
			$fclasses = {BevelFilter:BevelFilter, BlurFilter:BlurFilter, ColorMatrixFilter:ColorMatrixFilter, ConvolutionFilter:ConvolutionFilter, DisplacementMapFilter:DisplacementMapFilter, DropShadowFilter:DropShadowFilter, GlowFilter:GlowFilter, GradientBevelFilter:GradientBevelFilter, GradientGlowFilter:GradientGlowFilter};
			// getter function template
			$gro = {__resolve:function (name:String):Function {
				var f:Function = function ():BitmapFilter {
					var local:Object = this;
					if (local['filters'] != undefined) {
						var $splitname:Array = name.split("_");
						if ($splitname[1] == 'blur') {
							$splitname[1] = 'blurX';
						}
						// new filter not created if missing (getFilterProp can, however) 
						return FuseFMP.getFilter(this, $splitname[0]+"Filter", false)[$splitname[1]];
					}
				};
				return f;
			}};
			// setter function template
			$sro = {__resolve:function (name:String):Function {
				var f:Function = function (val:Object) {
					var local:Object = this;
					if (local['filters'] != undefined) {
						FuseFMP.setFilterProp(this, name, val);
					}
				};
				return f;
			}};
		}
		if (arguments[0] == null) {
			return;
		}
		// make sure only filterable targets are initialized! 
		var valid:Array = [MovieClip, Button, TextField];
		for (var i:String in arguments) {
			var ok:Boolean = false;
			for (var j:String in valid) {
				if (arguments[i] instanceof valid[j] || arguments[i] == Function(valid[j]).prototype) {
					ok = true;
					break;
				}
			}
			if (!ok) {
				FuseKitCommon.error('201', i);
				continue;
			}
			for (var $filtername:String in $fclasses) {
				var $f:BitmapFilter = new ($fclasses[$filtername])();
				for (var b:String in $f) {
					// excluding .clone and any other method encountered
					if (typeof $f[b] == 'function') {
						continue;
					}
					var eigenschaft:String = $filtername.substr(0, -6)+"_"+b;
					(arguments[i]).addProperty(eigenschaft, $gro[eigenschaft], $sro[eigenschaft]);
					// must remain overwritable for direct initialization of individual targets.
					_global.ASSetPropFlags(arguments[i], eigenschaft, 3, 1);
					if (b == 'blurX') {
						eigenschaft = eigenschaft.slice(0, -1);
						(arguments[i]).addProperty(eigenschaft, $gro[eigenschaft], $sro[eigenschaft]);
						_global.ASSetPropFlags(arguments[i], eigenschaft, 3, 1);
					}
				}
			}
			for (var s:String in $shortcuts) {
				(arguments[i])[s] = $shortcuts[s];
				_global.ASSetPropFlags(arguments[i], s, 7, 1);
			}
		}
	}
	
	/**
	* Removes shortcuts. If nothing is passed, updates MC, Button & TF prototypes.
	*/
	public static function deinitialize():Void {
		if ($fclasses == undefined) {
			return;
		}
		if (arguments.length == 0) {
			arguments.push(MovieClip.prototype, Button.prototype, TextField.prototype);
		}
		for (var i:String in arguments) {
			for (var $filtername:String in $fclasses) {
				var $f:BitmapFilter = new ($fclasses[$filtername])();
				for (var b:String in $f) {
					// excluding .clone and any other method encountered
					if (typeof $f[b] == 'function') {
						continue;
					}
					var eigenschaft:String = $filtername.substr(0, -6)+"_"+b;
					// 0,2 is NOT a mistake, do not change
					_global.ASSetPropFlags(arguments[i], eigenschaft, 0, 2);
					// safety, might be unnecessary
					(arguments[i]).addProperty(eigenschaft, null, null);
					delete (arguments[i])[eigenschaft];
				}
			}
			for (var s:String in $shortcuts) {
				// 0,2 is NOT a mistake, do not change
				_global.ASSetPropFlags(arguments[i], s, 0, 2);
				delete (arguments[i])[s];
			}
		}
	}
	
	/**
	* Quick way to get a filter instance's class name. Example: <code>for (var i:String in my_mc.filters) { trace(FuseFMP.getFilterName(my_mc.filters[i])); } // list my_mc's filters.</code>
	* @param $myFilter			BitmapFilter instance
	* @return					BitmapFilter instance name
	*/
	public static function getFilterName($myFilter:BitmapFilter):String {
		if ($fclasses == undefined) {
			initialize(null);
		}
		for (var a:String in $fclasses) {
			if ($myFilter.__proto__ == Function($fclasses[a]).prototype) {
				return a;
			}
		}
		return null;
	}
	
	/**
	* Gets current filter index.
	* @param $obj				parent object of filters
	* @param $myFilter			BitmapFilter instance, String (like "BlurFilter" or "Blur"), or class constructor
	* @return					index of filter in filters Array or -1 if filter doesn't exist.
	*/
	public static function getFilterIndex($obj:Object, $myFilter:Object):Number {
		if ($fclasses == undefined) {
			initialize(null);
		}
		$myFilter = $getInstance($myFilter);
		if ($myFilter === null) {
			return -1;
		}
		var $filters_temp:Array = $obj.filters;
		for (var i:Number = 0; i<$filters_temp.length; i++) {
			if (($filters_temp[i]).__proto__ == $myFilter.__proto__) {
				return i;
			}
		}
		return -1;
	}
	
	/**
	* Returns an existing filter from targ's filters Array or null if doesn't exist, or use <code>createNew</code> if you want a new instance to be created regardless.
	* @param $obj				target filter's parent
	* @param $myFilter			BitmapFilter instance, String (like "BlurFilter" or "Blur"), or class constructor
	* @param $createNew			Boolean variable to set whether or not to create new filter instance
	* @return					existing filter from targ's filters array or null
	*/
	public static function getFilter($obj:Object, $myFilter:Object, $createNew:Boolean):BitmapFilter {
		var $index:Number = getFilterIndex($obj, $myFilter);
		if ($index == -1) {
			if ($createNew != true) {
				return null;
			}
			$index = writeFilter($obj, $myFilter);
			if ($index == -1) {
				return null;
			}
		}
		return ($obj.filters[$index]);
	}
	
	/**
	* Applies or overwrites an existing filter. NOTE: Use setFilterProps to update existing filters. writeFilter overwrites existing.
	* @param $obj				target filter's parent
	* @param $myFilter			BitmapFilter instance, String (like "BlurFilter" or "Blur"), or class constructor
	* @param $propsObj			optional, a generic object customizing the new filter, like <code>{blurX:50,quality:1}</code>
	* @return				 	index in target's filters array (or -1 if fails)
	* @see #setFilterProps
	*/
	public static function writeFilter($obj:Object, $myFilter:Object, $propsObj:Object):Number {
		if ($fclasses == undefined) {
			initialize(null);
		}
		$myFilter = $getInstance($myFilter);
		if ($myFilter === null) {
			return -1;
		}
		var $filters_temp:Array = $obj.filters;
		var $index:Number = getFilterIndex($obj, $myFilter);
		if ($index == -1) {
			$filters_temp.push($myFilter);
		} else {
			$filters_temp[$index] = $myFilter;
		}
		$obj.filters = $filters_temp;
		if (typeof $propsObj == 'object') {
			setFilterProps($obj, $myFilter, $propsObj);
		}
		$index = getFilterIndex($obj, $myFilter);
		return ($index);
	}
	
	/**
	* Clears filter.
	* @param $obj				target filter's parent
	* @param $myFilter			BitmapFilter instance, String (like "BlurFilter" or "Blur"), or class constructor
	* @return					true or false for success.
	*/
	public static function removeFilter($obj:Object, $myFilter:Object):Boolean {
		if ($fclasses == undefined) {
			initialize(null);
		}
		$myFilter = $getInstance($myFilter);
		var $filters_temp:Array = $obj.filters;
		var $index:Number = getFilterIndex($obj, $myFilter);
		if ($index == -1) {
			return (false);
		}
		$filters_temp.splice($index, 1);
		$obj.filters = $filters_temp;
		return true;
	}
	
	/**
	* Queries properties from MovieClips that have not been initialized.
	* @param $obj				target filter's parent
	* @param $filtername		BitmapFilter instance name
	* @param $createNew			Boolean variable to set whether or not to create new filter instance
	* @return					the value of the property, usually a number
	*/
	public static function getFilterProp($obj:Object, $filtername:String, $createNew:Boolean):Object {
		var $splitname:Array = $filtername.split("_");
		if ($splitname[1] == 'blur') {
			$splitname[1] = 'blurX';
		}
		return (FuseFMP.getFilter($obj, $splitname[0]+"Filter", $createNew)[$splitname[1]]);
	}
	
	/**
	* Sets properties for filter.
	* @param $obj			target filter's parent
	* @param $propname		BitmapFilter property
	* @param $val			Properties and values
	* @description			Support for multiple targets and multiple properties. There are two distinct syntaxes.<br>examples: <code>FuseFMP.setFilterProps([my_mc,my_txt], { Blur_blurX:50, Bevel_blurX:1 }); // multiple targs, multiple filters
	* 						FuseFMP.setFilterProps(my_mc, 'Blur', { blurX:50, blurY:0, quality:3 }); // write a customized blur filter to my_mc</code>
	*/
	public static function setFilterProp($obj:Object, $propname:Object, $val:Object):Void {
		// this code block avoids calling other methods for speed (it clocks 40% of setFilterProps).
		if ($fclasses == undefined) {
			initialize(null);
		}
		var $splitname:Array = $propname.split("_");
		var $fname:String = ($splitname[0]+"Filter");
		if ($fclasses[$fname] == undefined) {
			return;
		}
		var $filter:BitmapFilter = (new ($fclasses[$fname])());
		var $prop:String = $splitname[1];
		var $index:Number = ($obj.filters.length || 0);
		while (--$index>-1) {
			var $f:BitmapFilter = $obj.filters[$index];
			if ($f.__proto__ == $filter.__proto__) {
				$filter = $f;
				// use existing
				break;
			}
		}
		if ($prop == 'blur') {
			$filter['blurX'] = $val;
			$filter['blurY'] = $val;
		} else {
			if ($prop.indexOf('lor')>-1) {
				if (typeof $val == 'string' && $prop.charAt(2) != 'l') {
					if ($val.charAt(0) == '#') {
						$val = $val.slice(1);
					}
					$val = (($val.charAt(1)).toLowerCase() != 'x') ? Number('0x'+$val) : Number($val);
				}
			}
			$filter[$prop] = $val;
		}
		if ($index == -1) {
			$obj.filters = [$filter];
		} else {
			var $ftemp:Array = $obj.filters;
			$ftemp[$index] = $filter;
			$obj.filters = $ftemp;
		}
	}
	
	/**
	* Sets properties for filter. This is an additional method because ActionScript does not allow for overloading.
	* @param $obj			target filter's parent
	* @param $propname		BitmapFilter property
	* @param $val			Properties and values
	* @description			Support for multiple targets and multiple properties. There are two distinct syntaxes.<br>examples: <code>FuseFMP.setFilterProps([my_mc,my_txt], { Blur_blurX:50, Bevel_blurX:1 }); // multiple targs, multiple filters
	* 						FuseFMP.setFilterProps(my_mc, 'Blur', { blurX:50, blurY:0, quality:3 }); // write a customized blur filter to my_mc</code>
	*/
	public static function setFilterProps($obj:Object, $filterOrPropsObj:Object, $propsObj:Object):Void {
		if ($fclasses == undefined) {
			initialize(null);
		}
		if (!($obj instanceof Array)) {
			$obj = [$obj];
		}
		var $fo:Object = new Object();
		var $prop:String, $val:Object;
		if (arguments.length == 3) {
			// 2nd param filter, 3rd param short names like blur
			for (var i:String in $obj) {
				var $filter:BitmapFilter = getFilter($obj[i], $filterOrPropsObj, true);
				// param3:createNew
				if ($filter == null) {
					continue;
				}
				var $prefix:String = getFilterName($filter).substr(0, -6)+'_';
				for ($prop in $propsObj) {
					$fo[$prop] = $propsObj[$prop];
				}
				// bugfix: arrays like "alphas" wouldn't transfer, don't know why.
				for ($prop in $fo) {
					$val = $fo[$prop];
					if ($prop.indexOf($prefix) == 0) {
						$prop = $prop.slice($prefix.length);
					}
					// in case of long name 
					if ($prop == 'blur') {
						BlurFilter($filter).blurX = Number($val);
						BlurFilter($filter).blurY = Number($val);
					} else if ($prop.indexOf('lor')>-1 && $prop.charAt(2) != 'l' && typeof $val == 'string') {
						if ($val.charAt(0) == '#') {
							$val = $val.slice(1);
						}
						$val = (($val.charAt(1)).toLowerCase() != 'x') ? Number('0x'+$val) : Number($val);
					} else {
						$filter[$prop] = $val;
					}
				}
				writeFilter($obj[i], $filter);
			}
		} else if (typeof $filterOrPropsObj == 'object') {
			// 2 params. obj contains long names like Blur_blur
			$propsObj = $filterOrPropsObj;
			for ($prop in $propsObj) {
				// organize all props passed by filter class names
				var $splitname:Array = $prop.split("_");
				var $fname:String = $splitname[0]+"Filter";
				if ($fclasses[$fname] == undefined) {
					continue;
				}
				if ($fo[$fname] == undefined) {
					$fo[$fname] = {};
				}
				if ($splitname[1] == 'blur') {
					BlurFilter($fo[$fname]).blurX = $propsObj[$prop];
					BlurFilter($fo[$fname]).blurY = $propsObj[$prop];
				} else {
					($fo[$fname])[$splitname[1]] = $propsObj[$prop];
				}
			}
			for (var i:String in $obj) {
				for (var $fname:String in $fo) {
					var $filter:BitmapFilter = getFilter($obj[i], $fname, true);
					// param3:createNew
					if ($filter == null) {
						continue;
					}
					for ($prop in $fo[$fname]) {
						$val = ($fo[$fname])[$prop];
						if ($prop.indexOf('lor')>-1 && $prop.charAt(2) != 'l' && typeof $val == 'string') {
							if ($val.charAt(0) == '#') {
								$val = $val.slice(1);
							}
							$val = (($val.charAt(1)).toLowerCase() != 'x') ? Number('0x'+$val) : Number($val);
						}
						$filter[$prop] = $val;
					}
					writeFilter($obj[i], $filter);
				}
			}
		}
	}
	
	/**
	* Grabs an array of supported property shortcuts. Similar to traceAllFilters.
	* @return				array of supported property shortcuts
	* @see #traceAllFilters
	*/
	public static function getAllShortcuts():Array {
		if ($fclasses == undefined) {
			initialize(null);
		}
		var fa:Array = [];
		for (var $filtername:String in $fclasses) {
			var $f:BitmapFilter = new ($fclasses[$filtername])();
			for (var b:String in $f) {
				if (typeof $f[b] == 'function') {
					continue;
				}
				fa.push($filtername.substr(0, -6)+'_'+b);
				if (b == 'blurX') {
					fa.push($filtername.substr(0, -6)+'_blur');
				}
			}
		}
		return fa;
	}
	
	/**
	* Lists all filters and shortcut properties (Bevel_blurX, etc.) to the Output panel for reference.
	*/
	public static function traceAllFilters():Void {
		if ($fclasses == undefined) {
			initialize(null);
		}
		var s:String = "------ FuseFMP filter properties ------"+newline;
		for (var $filtername:String in $fclasses) {
			s += ($filtername);
			var $f:BitmapFilter = new ($fclasses[$filtername])();
			for (var b:String in $f) {
				if (typeof $f[b] == 'function') {
					continue;
				}
				// excluding .clone and any other method encountered 
				s += ('	- '+$filtername.substr(0, -6)+'_'+b);
				if (b == 'blurX') {
					s += ('	- '+$filtername.substr(0, -6)+'_blur');
				}
				// show "_blur" props 
			}
			s += newline;
		}
		FuseKitCommon.output(s);
	}
	
	/**
	* Internal - generates or returns existing BitmapFilter based on input type: constructor, instance, long/short-name string
	*/
	private static function $getInstance($myFilter:Object):BitmapFilter {
		if ($myFilter instanceof BitmapFilter) {
			return BitmapFilter($myFilter);
		}
		if (typeof $myFilter == "function") {
			for (var j:String in $fclasses) {
				if ($myFilter == $fclasses[j]) {
					return (new ($fclasses[j])());
				}
			}
		}
		if (typeof $myFilter == "string") {
			var $filterStr:String = String($myFilter);
			if ($filterStr.substr(-6) != 'Filter') {
				$filterStr += 'Filter';
			}
			// allow string to omit 'Filter'. 
			for (var j:String in $fclasses) {
				if (j == $filterStr) {
					return (new ($fclasses[j])());
				}
			}
		}
		return null;
	}
}

