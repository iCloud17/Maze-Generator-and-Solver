
int seeR = 3, seeC = 5;
int cols, rows;
int size = 20; //40 92
Cell grid[][], current, start, end;
ArrayList<Cell> stack, openSet, closedSet;
boolean pause, built, solve;

void setup() {
  size(920,920);
  rows = floor(height/size);
  cols = floor(width/size);
  grid = new Cell[rows][cols];
  stack = new ArrayList<Cell>();
  openSet = new ArrayList<Cell>();
  closedSet = new ArrayList<Cell>();
  for(int a = 0; a < rows; a++) {
  	for(int b = 0; b < cols; b++) {
  		grid[a][b] = new Cell(a,b);	
  	}
  }
  current = grid[0][0];
  start = grid[0][0];
  end = grid[rows-1][cols-1];
  openSet.add(start);
  //grid[seeR][seeC].visited = true;
  pause = true;
  built = false;
  solve = false;
  //frameRate(10);
}

void draw() {
  background(0);
  for(int i = 0; i < rows; i++) {
  	for(int j = 0; j < cols; j++) {
  		grid[i][j].show(255, 255, 255, 255);
  	}
  }
  current.visited = true;
  current.show(0, 175, 255, 175);
  if(!pause) {
    if(!built) {
      Cell next = null;
      next = current.checkNeighbors();
      if(next != null) {
        stack.add(current);
      	next.visited = true;
      	current = next;
      } else {
        next = backtrack(true);
        if(next == null) {
           println("MAZE COMPLETED!! :)");
           end.show(255, 0, 255, 255);
           built = true;
           noLoop();
        } else
          current = next;
      }
    } else if(solve) {
      //println(openSet.size());
    	for(int i = 0; i < openSet.size(); i++) {
    		openSet.get(i).show(0,255,0,255);
    	}
    	for(int i = 0; i < closedSet.size(); i++) {
    		closedSet.get(i).show(255,0,0,255);
    	}
    	current.show(0, 175, 255, 175);
        if(openSet.size() > 0) {
        	int lowest = 0;
        	for(int i = 0; i < openSet.size(); i++) {
        		if(openSet.get(i).f < openSet.get(lowest).f) {
        			lowest = i;
        		}
        	}
        	current = openSet.get(lowest);
          	//println(current.id + " == " + end.id);
        	if(current.id == end.id) {
        		//DONE!!
        		println("FOUND PATH!!");
        		showSolution();
        		noLoop();
        	}
        	removeFromOpenSet(current);
        	closedSet.add(current);
          	current.setNeighbors();
        	for(int i = 0; i < current.neighbors.size(); i++) {
        		Cell neighbor = current.neighbors.get(i);
        		if(neighborInSet(neighbor, false))
        			continue;
        		int temp = current.g + 1;
        		if(!neighborInSet(neighbor, true))
        			openSet.add(neighbor);
        		else if(temp >= neighbor.g)
        			continue;
        		neighbor.cameFrom = current;
        		neighbor.g = temp;
        		neighbor.f = neighbor.g + neighbor.heuristic();

        	}
        } else {
        	//NO SOLUTION
        	println("NO SOLUTION!! :(");
        	noLoop();
        }
    }
  }
}

Cell backtrack(boolean del) {
  Cell temp = null;
  if(stack.size() != 0) {
    temp = stack.get(stack.size()-1); 
    if(del)
      stack.remove(stack.size()-1);
  }
  return temp; 
}

void keyPressed() {
  if(key == 'r' || key == 'R') {
    setup();
    loop();
  }
  if(key == 'p' || key == 'P') {
    pause = !pause;
  }
  if(key == 's' || key == 'S') {
    if(built) {
      solve = true;
      loop();
    }
  }
  //if(key == CODED && keyCode == UP) {
  //  println("uP");
  //	grid[seeR][seeC].wall[0] = !grid[seeR][seeC].wall[0];
  //}
  //if(key == CODED && keyCode == RIGHT) {
  //	grid[seeR][seeC].wall[1] = !grid[seeR][seeC].wall[1];
  //}
  //if(key == CODED && keyCode == DOWN) {
  //	grid[seeR][seeC].wall[2] = !grid[seeR][seeC].wall[2];
  //}
  //if(key == CODED && keyCode == LEFT) {
  //	grid[seeR][seeC].wall[3] = !grid[seeR][seeC].wall[3];
  //}
}

int index(int i, int j) {
    return ((i)*rows) + (j);
}


void removeFromOpenSet(Cell c) {
	for(int i = openSet.size()-1; i >= 0; i--) {
		if(c.id == openSet.get(i).id) {
			openSet.remove(i);
		}
	}
}

boolean neighborInSet(Cell c, boolean b) {
	ArrayList<Cell> list = null;
	if(b) {
		list = openSet;
	} else {
		list = closedSet;
	}
	for(int i = 0; list != null && i < list.size(); i++) {
		if(c.id == list.get(i).id) {
			return true;
		}
	}
	return false;
}


void showSolution() {
	for(int i = 0; i < rows; i++) {
		for(int j = 0; j < cols; j++) {
			grid[i][j].show(255, 255, 255, 255);
		}
	}
	Cell c = end;
	while(c.cameFrom != null) {
		c.show(0,255,0,255);
		c = c.cameFrom;
	}
	start.show(0,0,255,255);
	end.show(255,0,255,255);
}
