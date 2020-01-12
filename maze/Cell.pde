class Cell {
	int x, y, f, g, h;
  	int id = -1;
  	Cell cameFrom;
	boolean[] wall = {true, true, true, true};
	boolean visited = false, setNb = false;
  	ArrayList<Cell> neighbors = new ArrayList<Cell>();
  
	Cell(int i, int j) {
		cameFrom = null;
		x = i;
		y = j;
    	id = i*cols + j;
    	f = 0;
    	g = 0;
	}

	void showWalls(int i, int j) {
	    int r = 0, g = 0, b = 0;
	    if(wall[0]) {
	      strokeWeight(2);
	      stroke(r,g,b);
	      line(i     , j     , i+size, j  );
	    }
	    if(wall[1]) {
	      strokeWeight(2);
	      stroke(r,g,b);
	      line(i+size, j     , i+size, j+size);
	    }
	    if(wall[2]) {
	      strokeWeight(2);
	      stroke(r,g,b);
	      line(i+size, j+size, i     , j+size);
	    }
	    if(wall[3]) {
	      strokeWeight(2);
	      stroke(r,g,b);
	      line(i     , j+size, i     , j  );
	    }
	}

	void show(int r, int g, int b, int a) {
		//noFill();
		//strokeWeight(5);
		int i = y * size;
		int j = x * size;
		showWalls(i, j);
		if(visited) {
			fill(r, g, b, a);
			noStroke();
			rect(i, j, size, size);
			noStroke();
			//stroke(255,0,255);
			showWalls(i, j);
			//noFill();
		}
	}

	int index(int i, int j) {
		return ((i)*cols) + (j);
	}

	Cell checkNeighbors() {
		Cell[] neighbor = {null, null, null, null}; 
		boolean added = false;
		if(x > 0) { //TOP
			neighbor[0] = grid[x-1][y];
			if(neighbor[0] != null && !neighbor[0].visited) {
				added = true;
			}
		}
		if(y < rows-1) { //RIGHT
			neighbor[1] = grid[x][y+1];
			if(neighbor[1] != null && !neighbor[1].visited) {
				added = true;
			}
		}
		if(x < cols-1) { //BOTTOM
			neighbor[2] = grid[x+1][y];
			if(neighbor[2] != null && !neighbor[2].visited) {
				added = true;
			}
		}
		if(y > 0) { //LEFT
			neighbor[3] = grid[x][y-1];
			if(neighbor[3] != null && !neighbor[3].visited) {
				added = true; 
			}				
		}
		if(added) {
			int r;
			do {
				r = floor(random(0, 4));
			} while(neighbor[r] == null || neighbor[r].visited);
    		wall[r] = false;
			switch(r) {
				case 0: //wall[3] = false;
            grid[x-1][y].wall[2] = false;
						break;
				case 1: //wall[2] = false;
            grid[x][y+1].wall[3] = false;
						break;
				case 2: //wall[1] = false;
            grid[x+1][y].wall[0] = false;
						break;
				case 3: //wall[0] = false;
            grid[x][y-1].wall[1] = false;
						break;						
			}
			return neighbor[r];
		} else {
			return null;
		}
	}

	void setNeighbors() {
		if(!setNb) {
			setNb = true;
			if(x > 0 && !wall[0]) { //TOP
				neighbors.add(grid[x-1][y]);
			}
			if(y < rows-1  && !wall[1]) { //RIGHT
				neighbors.add(grid[x][y+1]);
			}
			if(x < cols-1 && !wall[2]) { //BOTTOM
				neighbors.add(grid[x+1][y]);
			}
			if(y > 0 && !wall[3]) { //LEFT
				neighbors.add(grid[x][y-1]);
			}
		}
	}

	int heuristic() {
		return rows-1-x + cols-1-y;
	}
}
