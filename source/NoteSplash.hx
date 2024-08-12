package;

import openfl.display.BlendMode;
import CoolUtil;
import flixel.FlxSprite;

using StringTools;
/*#if polymod
import polymod.format.ParseRules.TargetSignatureElement;
#end*/

class NoteSplash extends FlxSprite {
	public static var noteSplashColorsDefault:Map<String, Int> = [
		"purple" => 0xffC24B99,
		"blue" => 0xff00ffff,
		"green" => 0xff12FA05,
		"red" => 0xfff9393f,
		"yellow" => 0xffF2F20B,
		"violet" => 0xff823CFF,
		"darkred" => 0xffFF7700,
		"dark" => 0xff0033FF,
		"white" => 0xffCCCCCC,
		"13a" => 0xff76D7FF,
		"13b" => 0xff69FF3D,
		"13c" => 0xffE30000,
		"13d" => 0xffE14EFF,
		"17a" => 0xff76FFA4,
		"17b" => 0xffFF3D69,
		"17c" => 0xff5000E3,
		"17d" => 0xff4EA1FF
	];
	
	//public static var noteSplashColors:Map<String, Int>;

	public function playNoteSplash(thing:StrumNote, daNote:Note) {
		x = thing.x;
		y = thing.y;
		moves = false;
		var skinColor = Note.loadedNoteSkins.exists(thing.curStyle) ? Note.loadedNoteSkins.get(thing.curStyle).arrowColors.get(thing.parent.thisManiaInfo.arrows[daNote.noteData]) : null;
		if (skinColor != null)
			color.setRGB(skinColor[0], skinColor[1], skinColor[2]);
		else
			color = noteSplashColorsDefault.get(thing.parent.thisManiaInfo.arrows[daNote.noteData]);
		animation.play("splash" + (daNote.noteData % 4), true);
		angle = Math.random() * 45.0;
		flipX = Math.random() >= 0.5;
		animation.finishCallback = function(name:String)
			exists = false;
	}
	
	public var curStyle:String;
	public static var nStyle:String = "normal/NOTE_splashes_doki";
	public static var nScale:Float = 1.0;

	public function changeStyle(style:String) {
		if (curStyle == style) {
			trace("style is already " + style);
			return;
		}
		//todo: somehow it doesn't load the notesplash from the noteskin, why is that?
		//trace("set style to " + style);
		curStyle = style;
		var validNoteSkin = true;
		frames = Paths.getSparrowAtlas(style);
		animation.addByIndices("splash", "note splash", [0], "", 24, false);
		animation.addByPrefix("splash0", "note splash purple", 24, false);
		animation.addByPrefix("splash1", "note splash blue", 24, false);
		animation.addByPrefix("splash2", "note splash green", 24, false);
		animation.addByPrefix("splash3", "note splash red", 24, false);
		scale.x = scale.y = nScale;
		animation.play("splash0", true);
		CoolUtil.CenterOffsets(this);
		alpha = 0.75;
		blend = BlendMode.ADD;
	}

	public function new() {
		super();

		changeStyle(nStyle);
	}
}
