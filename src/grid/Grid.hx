package grid;

class Grid {

    public var cells:Array<Cell> = [];

    public var gridWidth:Float;
    public var gridHeight:Float;
    public var gridSize:Int;
    public var gridX:Float;
    public var gridY:Float;

    var cellSizeX:Float;
    var cellSizeY:Float;

    public function new(width:Float, height:Float, size:Int, x:Float = 0, y:Float = 0) {
        this.gridWidth = width;
        this.gridHeight = height;
        this.gridSize = size;
        this.gridX = x;
        this.gridY = y;

        var cellSize = getDimensionOfCell();
        cellSizeX = cellSize.x;
        cellSizeY = cellSize.y;

        createGrid();
    }

    function createGrid() {
        for (x in 0...gridSize) {
            for (y in 0...gridSize) {

                var cell = new Cell(x, y);

                cells.push(cell);
            }
        }

        ///Calculate Cells
        for (i in cells) {
            var pos = getPosOfCell(i);
            var area = getDimensionOfCell();

            i.setPosition(pos.x, pos.y);
            i.setArea(area.x, area.y);
        }
    }

    function getPosOfCell(cell:Cell):Vec2 {
        var dx = (gridX + cell.i_x * cellSizeX);
        var dy = (gridY + cell.i_y * cellSizeY);

        return new Vec2(dx, dy);
    }

    function getDimensionOfCell():Vec2 {
        var w = gridWidth / gridSize;
        var h = gridHeight / gridSize;

        return new Vec2(w, h);
    }

    public function checkForCellPosition(mouseX:Float, mouseY:Float):Cell {
        for (i in cells) {

            if (mouseX > i.x && mouseX < i.x + i.width && mouseY > i.y && mouseY < i.y + i.height) {
                return i;
            }
        }

        return null;
    }

    public function getCellByIndex(x:Int, y:Int):Cell {
        for (i in cells) {
            if (i.i_x == x && i.i_y == y) {
                return i;
            }
        }

        return null;
    }

    ///Returns all cell neighbors at given cell
    public function getNeighborOfCellNew(cell:Cell, corners:Bool = true):Array<Cell> {
        if (cell == null) return [];

        var neighbors:Array<Cell> = [];

        for (xoff in -1...2) {
            for (yoff in -1...2) {
                if (xoff == 0 && yoff == 0) continue;

                if (corners) {
                    var i = xoff + cell.i_x;
                    var j = yoff + cell.i_y;
    
                    if (i > -1 && i < gridSize && j > -1 && j < gridSize) {
                        var neighborCell = getCellByIndex(i, j);
    
                        neighbors.push(neighborCell);
                    }
                } else {
                    if (Math.abs(xoff) + Math.abs(yoff) > 1) continue;

                    var i = xoff + cell.i_x;
                    var j = yoff + cell.i_y;

                    if (i > -1 && i < gridSize && j > -1 && j < gridSize) {
                        var neighborCell = getCellByIndex(i, j);

                        neighbors.push(neighborCell);
                    }
                }
                
            }
        }

        return neighbors;
    }
}