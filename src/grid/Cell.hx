package grid;

class Cell {
    
    public var i_x:Int;
    public var i_y:Int;
    public var x:Float;
    public var y:Float;
    public var width:Float;
    public var height:Float;

    public var isOccupied:Bool = false;

    ///Pathfinding
    public var hCost:Int;
    public var gCost:Int;

    public var parent:Cell;


    public function new(i_x:Int, i_y:Int) {
        this.i_x = i_x;
        this.i_y = i_y;
    }

    public inline function getIndex():Array<Int> {
        return [i_x, i_y];
    }

    public inline function setPosition(dx:Float, dy:Float):Vec2 {
        x = dx;
        y = dy;

        return new Vec2(x, y);
    }

    public inline function setArea(w:Float, h:Float):Vec2 {
        width = w;
        height = h;

        return new Vec2(width, height);
    }

    ///Be Careful with this function!
    public function getfCost():Int {
        var temp = gCost + hCost;

        return temp;
    }
}