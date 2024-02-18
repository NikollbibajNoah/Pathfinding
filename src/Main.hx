package;

import hxd.res.DefaultFont;
import h2d.Text;
import h2d.Tile;
import h2d.Bitmap;
import h2d.Graphics;
import hxd.Key;
import h2d.col.Point;
import pathfinding.*;
import grid.*;

class Main extends hxd.App {

    var grid:Grid;

    var path:Pathfinding;
    var end:Array<Int> = [];
    var gP:Graphics;

    var navAgent:Bitmap;

    var txt:Text;

    var userTxt:Text;

    static function main() {
        new Main();
    }

    override function init() {
        super.init();
        engine.backgroundColor = 0xcecece;


        gP = new Graphics(s2d);
        txt = new Text(DefaultFont.get(), s2d);
        txt.setPosition(32, 32);
        txt.text = '-:--';
        txt.font.resizeTo(30);
        txt.textColor = 0x141414;

        var w = 600;
        var h = 600;

        grid = new Grid(w, h, 32, s2d.width / 2 - w / 2, s2d.height / 2 - h / 2);


        drawGrid(grid.gridX, grid.gridY, grid.gridWidth, grid.gridHeight, grid.gridSize, true);


        path = new Pathfinding(grid, grid.getCellByIndex(1, 1), grid.getCellByIndex(8, 8));
        

        userTxt = new Text(DefaultFont.get(), s2d);
        userTxt.text = 'L-Maus = Zeichnen           R-Maus = Löschen        M-Maus = Positionieren';
        userTxt.x = 32;
        userTxt.y = s2d.height - userTxt.textHeight;
        userTxt.textColor = 0;
    }

    function checkCell(state:Bool, mouseX:Float, mouseY:Float) {
        var cell = grid.checkForCellPosition(mouseX, mouseY);

        if (cell == null || cell == path.destinationCell) return;


        cell.isOccupied = state;
    }

    function drawGrid(dx:Float, dy:Float, width:Float, height:Float, size:Int, debug:Bool = false) {
        var g = new Graphics(s2d);

        g.lineStyle(1, 0x141414);

        var cellSizeX = width / size;
        var cellSizeY = height / size;

        for (y in 0...size + 1) { ///+ 1 for the corners
            g.moveTo(dx, dy + y * cellSizeY);
            g.lineTo(dx + width, dy + y * cellSizeY);

            for (x in 0...size + 1) { ///+ 1 for the corners
                g.moveTo(dx + x * cellSizeX, dy);
                g.lineTo(dx + x * cellSizeX, dy + height);

            }
        }

        
        if (!debug) return;
/*
        function getBoxCenter():Point {
            return new Point(cellSizeX / 2, cellSizeY / 2);
        }

        g.lineStyle(0, 0);
        g.beginFill(0xFF0000);

        for (i in grid.cells) {
            var c = getBoxCenter();

            g.drawCircle(i.x + c.x, i.y + c.y, 4, 4);
        }

        ///Text
        for (i in grid.cells) {
                var t = new Text(DefaultFont.get(), s2d);
                t.scale(2);
                t.text = '${i.i_x}/${i.i_y}';
                t.x = i.x + i.width / 2;
                t.y = i.y + i.height / 2;
                t.textAlign = Center;
            }*/
    }

    override function update(dt:Float) {
        gP.clear();

        txt.text = 'fps: ${Std.int(engine.fps)}\nSize: ${grid.gridSize}x${grid.gridSize}';

        for (i in grid.cells) {
            if (!i.isOccupied) {
                gP.beginFill(0xcecece);

                gP.drawRect(i.x, i.y, i.width, i.height);    
                gP.endFill();
            } else {
                gP.beginFill(0x000000);

                gP.drawRect(i.x, i.y, i.width, i.height);    
                gP.endFill();
            }
        }


        path.findPath(false);

        ///Draw Start
        gP.beginFill(0x4460AF);
        gP.drawRect(path.startingCell.x, path.startingCell.y, path.startingCell.width, path.startingCell.height);
        gP.endFill();

        gP.beginFill(0xFF00FF);

        for (i in path.path) {

            gP.drawRect(i.x, i.y, i.width, i.height);
        }

        gP.endFill();

        ///Draw End
        gP.beginFill(0x4DA54D);
        gP.drawRect(path.destinationCell.x, path.destinationCell.y, path.destinationCell.width, path.destinationCell.height);
        gP.endFill();


        if (Key.isDown(Key.MOUSE_LEFT)) {
            var coords = new Point(s2d.mouseX, s2d.mouseY);

            checkCell(true, coords.x, coords.y);
        }

        if (Key.isDown(Key.MOUSE_MIDDLE)) {
            var coords = new Point(s2d.mouseX, s2d.mouseY);

            var cell = grid.checkForCellPosition(coords.x, coords.y);

            if (cell == null || cell == path.destinationCell || cell == path.startingCell || cell.isOccupied) return;

            path.adjustPoints(path.startingCell, cell);
        }

        if (Key.isDown(Key.MOUSE_RIGHT)) {
            var coords = new Point(s2d.mouseX, s2d.mouseY);

            checkCell(false, coords.x, coords.y);
        }
        /*
        return;

        if (Key.isPressed(Key.MOUSE_LEFT) && !isReady) {
            isReady = true;

            startX = s2d.mouseX;
            startY = s2d.mouseY;
        }

        if (Key.isDown(Key.MOUSE_LEFT) && isReady) {
            endX = s2d.mouseX - startX;
            endY = s2d.mouseY - startY;

            g.clear();

            g.beginFill(0xFF0000, .5);
            g.lineStyle(1, 0xFF0000);

            g.drawRect(startX, startY, endX, endY);
        }

        if (Key.isReleased(Key.MOUSE_LEFT) && isReady) {
            isReady = false;

            endX = s2d.mouseX;
            endY = s2d.mouseY;

            ///Set area some shit

            var areaWidth = endX - startX;
            var areaHeight = endY - startY;

            for (i in grid.cells) {
                if (i.x > startX && i.x < endX && i.y > startY && i.y < endY) {
                    trace(i.getIndex());
                }
            }
        }*/
    }
}