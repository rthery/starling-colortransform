package {

import flash.display.Sprite;
import flash.events.Event;

import starling.core.Starling;

[SWF(width="512", height="512", backgroundColor="#FFFFFF", frameRate="30")]
public class Main extends Sprite {
    public function Main() {
        addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
    }

    private function addedToStageHandler(event:Event):void {
        removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);

        var starling:Starling = new Starling(ColorTransformComparator, stage);
        starling.skipUnchangedFrames = true;
        starling.enableErrorChecking = true;
        starling.start();
    }
}
}
