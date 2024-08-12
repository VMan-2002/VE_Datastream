import flixel.FlxG;
import flixel.system.scaleModes.FillScaleMode;

/**
 * Scale mode where black borders are avoided by extending the scene size.
 */
class NoLetterboxScaleMode extends FillScaleMode {
	public function new() {
		super();

		gameSize.set(FlxG.width, FlxG.height);
	}

	override public function onMeasure(Width:Int, Height:Int):Void {
		var extendWay = (FlxG.initialWidth / Width) / (FlxG.initialHeight / Height);
		if (extendWay < 1) {
			// Extend width
			@:privateAccess
			FlxG.width = Math.round(FlxG.initialWidth / extendWay);
			@:privateAccess
			FlxG.height = FlxG.initialHeight;
		} else {
			// Extend height
			@:privateAccess
			FlxG.width = FlxG.initialWidth;
			@:privateAccess
			FlxG.height = Math.round(FlxG.initialHeight * extendWay);
		}

		updateGameSize(Width, Height);
		updateDeviceSize(Width, Height);
		updateScaleOffset();
		updateGamePosition();
	}

	/*function updateScaleOffset():Void {
		scale.x = gameSize.x / (FlxG.width * FlxG.initialZoom);
		scale.y = gameSize.y / (FlxG.height * FlxG.initialZoom);
		updateOffsetX();
		updateOffsetY();
	}*/
	override function updateGameSize(Width:Int, Height:Int):Void {
		gameSize.x = Width;
		gameSize.y = Height;

		if (FlxG.camera != null) {
			var oldWidth:Float = FlxG.camera.width;
			var oldHeight:Float = FlxG.camera.height;

			FlxG.camera.setSize(FlxG.width, FlxG.height);
			FlxG.camera.scroll.x += 0.5 * (oldWidth - FlxG.width);
			FlxG.camera.scroll.y += 0.5 * (oldHeight - FlxG.height);
		}
	}
}
