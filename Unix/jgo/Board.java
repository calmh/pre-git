// $Id: Board.java,v 1.1.1.1 2003/03/01 12:55:11 jb Exp $

import java.util.*;

class Board {		
	final String repr[] = { "·", "X", "O" };
	
	Stack moveHistory;
	Vector tmpMoves;
	int board[][];
//	int neighbors[][];
	int positionValue[][];
	int size;
	int prisoners[];
	boolean beenHere[][];

	class InvalidMove extends Exception {
		Move move;
			
		public InvalidMove(Move m) {
			move = m;
		}

		public String toString() {
			return "Invalid Move: " + move;
		}
	}
	
	class Hash {
		long h[];
		
		public Hash() {
			int logd = 40;
			int n = size * size / logd + 1;
			h = new long[n];
			for (int y = 0; y < size; y++) {
				for (int x = 0, i = 0; x < size; x++, i = (size * y + x) / logd) {
					h[i] *= 3;
					h[i] += board[x][y];
				}
			}
		}
		
		public String toString() {
			StringBuffer tmp = new StringBuffer("H");
			for (int i = 0; i < h.length; i++)
				tmp.append(":" + h[i]);
			tmp.append("\n");
			return tmp.toString();
		}
		
		public boolean equals(Hash hash) {
			if (h.length != hash.h.length)
				return false;
			for (int i = 0; i < h.length; i++)
				if (h[i] != hash.h[i])
					return false;
			return true;
		}
	}
		
	public Board(int size) {
		this.size = size;
		board = new int[size][size];
//		neighbors = new int[size][size];
		positionValue = new int[size][size];
		for (int y = 0; y < size; y++) {
			for (int x = 0; x < size; x++) {
				positionValue[x][y] = 4;
				if (x == size/4 || x == size-size/4-1)
					positionValue[x][y] += 2;
				if (y == size/4 || y == size-size/4-1)
					positionValue[x][y] += 2;
				if (x < 3 || x > size - 3)
					positionValue[x][y]--;
				if (y < 3 || y > size - 3)
					positionValue[x][y]--;
			}
		}						
						
		moveHistory = new Stack();
		prisoners = new int[3];
	}

	public void move(Move m) throws InvalidMove {
		if (board[m.x][m.y] != Common.empty)
			throw new InvalidMove(m);

		board[m.x][m.y] = m.color;
		tmpMoves = new Vector();
		tmpMoves.add(m);
		
		// check for captures
		for (int d = -1; d < 2; d += 2) {
			int nx = m.x + d;
			if (nx >= 0 && nx < size) {
//				neighbors[nx][m.y]++;
				if (libertiesCapture(nx, m.y, false) == 0)
					libertiesCapture(nx, m.y, true);
			}
			int ny = m.y + d;
			if (ny >= 0 && ny < size) {
//				neighbors[m.x][ny]++;
				if (libertiesCapture(m.x, ny, false) == 0)
					libertiesCapture(m.x, ny, true);
			}
		}
		
		Hash h = new Hash();
		tmpMoves.add(h);
		moveHistory.push(tmpMoves);
		
 		// check for legality
		if (libertiesCapture(m.x, m.y, false) == 0) {
			// no liberties - illegal
			undo();
			throw new InvalidMove(m);
		}
			
 		// check for (super)ko
		for (Enumeration e = moveHistory.elements() ; e.hasMoreElements() ;) {
			Vector l = (Vector) e.nextElement();
			if (!(l.lastElement() instanceof Hash)) {
				System.err.println("Aieee!!");
				System.exit(1);
			} else {
				Hash pl = (Hash) l.lastElement();
				if (pl != h && pl.equals(h)) {
					// ko
					undo();
					throw new InvalidMove(m);
				}
			}
		}
	}

	public void undo() {
		Vector moves = (Vector) moveHistory.pop();
		for (Enumeration e = moves.elements() ; e.hasMoreElements() ;) {
			Object el = e.nextElement();
			if (el instanceof Hash)
				continue;
			Move move = (Move) el;
			if (move.color > 0) {
//				for (int d = -1; d < 2; d += 2) {
//					int nx = move.x + d;
//					int ny = move.y + d;
//					if (nx >= 0 && nx < size)
//						neighbors[nx][move.y]--;
//					if (ny >= 0 && ny < size)
//						neighbors[move.x][ny]--;
//				}
				board[move.x][move.y] = Common.empty;
			}
			else {
				board[move.x][move.y] = -move.color;
//				for (int d = -1; d < 2; d += 2) {
//					int nx = move.x + d;
//					int ny = move.y + d;
//					if (nx >= 0 && nx < size)
//						neighbors[nx][move.y]++;
//					if (ny >= 0 && ny < size)
//						neighbors[move.x][ny]++;
//				}
				prisoners[-move.color]--;
			}
				
		}
	}
		
	public int libertiesCapture(int x, int y, boolean capture) {
		return libertiesCapture(x, y, capture, 0);
	}
		
	public int libertiesCapture(int x, int y, boolean capture, int color) {
		if (color == 0) {
			if (board[x][y] == Common.empty)
				return -1;
			else
				color = board[x][y];
		}
			
		beenHere = new boolean[size][size];
		beenHere[x][y] = true;
		return recLiberties(x, y, color, capture);
	}

	public int recLiberties(int x, int y, int color, boolean capture) {
		int free = 0;

		for (int d = -1; d < 2; d += 2) {
			int nx = x + d;				
			if (nx >= 0 && nx < size && !beenHere[nx][y]) {
				beenHere[nx][y] = true;
				if (board[nx][y] == Common.empty)
					free++;
				else if (board[nx][y] == color)
					free += recLiberties(nx, y, color, capture);
			}
			int ny = y + d;
			if (ny >= 0 && ny < size && !beenHere[x][ny]) {
				beenHere[x][ny] = true;
				if (board[x][ny] == Common.empty)
					free++;
				else if (board[x][ny] == color)
					free += recLiberties(x, ny, color, capture);
			}
		}
			
		if (capture) {
			board[x][y] = Common.empty;
			tmpMoves.add(new Move(x, y, -color));
			prisoners[color]++;
		}
			
		return free;
	}

	public int eval() {
		int val = 10 * prisoners[Common.white] - 10 * prisoners[Common.black];
		for (int y = 0; y < size; y++)
			for(int x = 0; x < size; x++) {
				if (board[x][y] == Common.black)
					val += positionValue[x][y];
				else if (board[x][y] == Common.white)
					val -= positionValue[x][y];
			}
		return val;
	}

	public Vector validMoves(int color) {
		Vector v = new Vector();
		for (int y = 0; y < size; y++)
			for(int x = 0; x < size; x++)
				if (board[x][y] == Common.empty)
					v.add(new Move(x, y, color));
		return v;
	}
		
	public String toString() {
		int lastX = -1, lastY = -1;
		if (!moveHistory.empty()) {
			Move lastMove = (Move) ((Vector)
			moveHistory.lastElement()).firstElement();
			lastX = lastMove.x;
			lastY = lastMove.y;
		}
		StringBuffer tmp = new StringBuffer("   ");
		char c = 'A';
		for (int n = 0; n < size; n++)
			tmp.append(c++ + " ");
		tmp.append("\n");
		for (int y = 0; y < size; y++) {
			tmp.append((y+1) + "  ");
			for (int x = 0; x < size; x++) {
				tmp.append(repr[board[x][y]]);
				if (y == lastY && x == lastX - 1)
					tmp.append("(");
				else if (y == lastY && x == lastX)
					tmp.append(")");
				else
					tmp.append(" ");
			}
			tmp.append("\n");
		}
		tmp.append("Prisoners: " + prisoners[Common.black] + "B, " + prisoners[Common.white] + "W\n");
		return tmp.toString();
	}
}
