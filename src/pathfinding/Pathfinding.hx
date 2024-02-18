package pathfinding;

import grid.*;

class Pathfinding {

    public var grid:Grid;

    public var path:Array<Cell> = [];
    public var startingCell:Cell;
    public var destinationCell:Cell;

    public function new(grid:Grid, startingCell:Cell, destinationCell:Cell) {
        this.grid = grid;
        this.startingCell = startingCell;
        this.destinationCell = destinationCell;
    }
    
    public function findPath(smooth:Bool = false) {
        var openSet:Array<Cell> = [];
        var closedSet:Array<Cell> = [];

        openSet.push(startingCell);

        while(openSet.length > 0) {
            var currentCell = openSet[0];

            for (i in 0...openSet.length) {

                ///Be Careful with the 'getfCost()'!!
                if (openSet[i].getfCost() < currentCell.getfCost() || openSet[i].getfCost() == currentCell.getfCost() && openSet[i].hCost < currentCell.hCost) {
                    currentCell = openSet[i];
                }
            }

            openSet.remove(currentCell);
            closedSet.push(currentCell);

            if (currentCell == destinationCell) {
                reTracePath(startingCell, destinationCell);
                return;
                ///Path found!!
            }

            for (i in grid.getNeighborOfCellNew(currentCell, smooth)) {
                if (i.isOccupied || closedSet.contains(i)) continue;

                var movementCostToNeighbor = currentCell.gCost + heuristic(currentCell, i);

                if (movementCostToNeighbor < i.gCost || !openSet.contains(i)) {
                    i.gCost = movementCostToNeighbor;

                    i.hCost = heuristic(currentCell, destinationCell);

                    i.parent = currentCell;

                    if (!openSet.contains(i)) {
                        openSet.push(i);
                    }
                }
            }
        }

        ///Dead End
        if (openSet.length < 1) {
            path = [];
        }
    }

    public function adjustPoints(startingCell:Cell, destinationCell:Cell):Void {
        this.startingCell = startingCell;
        this.destinationCell = destinationCell;
    }

    function reTracePath(startCell:Cell, endCell:Cell) {
        var path:Array<Cell> = [];
        var currentCell = endCell;

        while (currentCell != startCell) {
            path.push(currentCell);

            currentCell = currentCell.parent;
        }

        path.reverse();

        this.path = path;
    }

    function heuristic(cellA:Cell, cellB:Cell):Int {
        if (cellA == null || cellB == null) return 0;
        //var d = Math.abs(cellA.x - cellB.x) + Math.abs(cellA.y - cellB.y);

        var dx = cellA.x - cellB.x;
        var dy = cellA.y - cellB.y;

        var d = Math.sqrt(dx * dx + dy * dy);

        return Std.int(d);
    }
}