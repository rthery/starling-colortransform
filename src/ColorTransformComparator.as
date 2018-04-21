package {
import com.bit101.components.ColorChooser;
import com.bit101.components.Component;
import com.bit101.components.HBox;
import com.bit101.components.HUISlider;
import com.bit101.components.Label;
import com.bit101.components.PushButton;
import com.bit101.components.VBox;

import flash.display.Bitmap;
import flash.display.Stage;
import flash.events.Event;
import flash.geom.ColorTransform;

import starling.core.Starling;
import starling.display.Quad;
import starling.display.Sprite;
import starling.extensions.ColorTransformStyle;
import starling.textures.Texture;

public class ColorTransformComparator extends Sprite {
    [Embed(source="../res/red-piwi.png")]
    private const RedPiwi:Class;

    private var _colors:Vector.<Number> = new <Number>[1.0, 1.0, 1.0, 1.0, 0, 0, 0, 0];
    private var _colorTransformSliders:Vector.<HUISlider>;
    private var _alphaSlider:HUISlider;
    private var _colorChooser:ColorChooser;

    private var _bitmap:Bitmap;
    private var _quad:Quad;
    private var _bitmapColorTransform:ColorTransform;
    private var _quadColorTransform:ColorTransformStyle;

    public function ColorTransformComparator() {
        _colors.fixed = true;

        initDemoDisplayObjects();
        initGUI();
    }

    private function initDemoDisplayObjects():void {
        _quad = Quad.fromTexture(Texture.fromEmbeddedAsset(RedPiwi));
        _quadColorTransform = new ColorTransformStyle(_colors[0], _colors[1], _colors[2], _colors[3], _colors[4], _colors[5], _colors[6], _colors[7]);
        _quad.style = _quadColorTransform;
        addChild(_quad);

        _bitmap = new RedPiwi();
        _bitmap.x = _bitmap.width;
        _bitmapColorTransform = new ColorTransform(_colors[0], _colors[1], _colors[2], _colors[3], _colors[4], _colors[5], _colors[6], _colors[7]);
        _bitmap.transform.colorTransform = _bitmapColorTransform;
        Starling.current.nativeStage.addChild(_bitmap);
    }

    private function initGUI():void {
        var nativeStage:Stage = Starling.current.nativeStage;
        Component.initStage(nativeStage);

        var titles:HBox = new HBox(nativeStage, 8, 8 + 256);
        var lbl:Label = new Label(titles, 0, 0, "Quad");
        lbl.autoSize = false;
        lbl.width = 256;
        lbl = new Label(titles, 0, 0, "Bitmap");
        lbl.autoSize = false;
        lbl.width = 256;

        var hbox:HBox = new HBox(nativeStage, 16, titles.y + 32);
        var vboxLeft:VBox = new VBox(hbox);
        var vboxRight:VBox = new VBox(hbox);
        var l:int = _colors.length;
        var halfLength:int = l / 2;
        _colorTransformSliders = new Vector.<HUISlider>(l, true);
        var slidersLabel:Array = ["redMultiplier", "greenMultiplier", "blueMultiplier", "alphaMultiplier",
            "redOffset", "greenOffset", "blueOffset", "alphaOffset"];

        for (var i:int = 0; i < l; i++) {
            var isMultiplier:Boolean = i < halfLength;

            var line:HBox = new HBox(isMultiplier ? vboxLeft : vboxRight);
            var label:Label = new Label(line, 0, 0, slidersLabel[i]);
            label.autoSize = false;
            label.width = isMultiplier ? 66 : 52;
            var slider:HUISlider = new HUISlider(line, 0, 0, "", onColorTransformSlidersChange);
            slider.setSliderParams(isMultiplier ? 0 : -255, isMultiplier ? 1.0 : 255, isMultiplier ? 1.0 : 0);
            slider.labelPrecision = isMultiplier ? 1 : 0;
            slider.tick = isMultiplier ? 0.1 : 1;
            slider.width = 190;
            _colorTransformSliders[i] = slider;
        }

        var miscLine:HBox = new HBox(vboxLeft);
        _alphaSlider = new HUISlider(miscLine, 0, 0, "DisplayObject.alpha", onAlphaSliderChange);
        _alphaSlider.setSliderParams(0, 1.0, 1);
        _alphaSlider.tick = 0.1;

        new Label(miscLine, 0, 0, "color");
        _colorChooser = new ColorChooser(miscLine, 0, 0, 0x000000, onColorChooserChange);
        _colorChooser.usePopup = true;

        new PushButton(vboxRight, 128 - 16, 0, "Reset", onReset);
    }

    private function onColorChooserChange(event:Event):void {
        _bitmapColorTransform.color = _colorChooser.value;
        _bitmap.transform.colorTransform = _bitmapColorTransform;

        _quadColorTransform.color = _colorChooser.value;

        _colors[0] = _colors[1] = _colors[2] = 0;
        _colors[4] = _bitmapColorTransform.redOffset;
        _colors[5] = _bitmapColorTransform.greenOffset;
        _colors[6] = _bitmapColorTransform.blueOffset;
        var l:int = _colors.length;
        for (var i:int = 0; i < l; i++) {
            _colorTransformSliders[i].value = _colors[i];
        }
    }

    private function onColorTransformSlidersChange(event:Event):void {
        var i:int = _colorTransformSliders.indexOf(event.target as HUISlider);
        _colors[i] = _colorTransformSliders[i].value;

        updateDisplayObjects();

        _colorChooser.value = _quadColorTransform.color;
    }

    private function onAlphaSliderChange(event:Event):void {
        var alpha:Number = (event.target as HUISlider).value;
        _bitmap.alpha = alpha;
        _quad.alpha = alpha;
    }

    private function onReset(event:Event):void {
        _colors[0] = _colors[1] = _colors[2] = _colors[3] = 1;
        _colors[4] = _colors[5] = _colors[6] = _colors[7] = 0;

        var l:int = _colors.length;
        for (var i:int = 0; i < l; i++) {
            _colorTransformSliders[i].value = _colors[i];
        }

        _bitmap.alpha = 1;
        _quad.alpha = 1;
        _alphaSlider.value = 1;
        _colorChooser.value = 0x00;

        updateDisplayObjects();
    }

    private function updateDisplayObjects():void {
        _bitmapColorTransform = new ColorTransform(_colors[0], _colors[1], _colors[2], _colors[3], _colors[4], _colors[5], _colors[6], _colors[7]);
        _bitmap.transform.colorTransform = _bitmapColorTransform;

        _quadColorTransform.setTo(_colors[0], _colors[1], _colors[2], _colors[3], _colors[4], _colors[5], _colors[6], _colors[7]);
    }
}
}
