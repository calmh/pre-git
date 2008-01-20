// $Id: AI.java,v 1.1.1.1 2003/03/01 12:55:11 jb Exp $

import java.util.*;

class AI implements Player {
	final int timelimit = 2000;
	final int mindepth = 2;
	final int verbose = 0;
	int maxdepth;
	long time;
	int nodes;
	private Board board;
	private int depth;
	private Stack moveStack;
		
	class MinimaxResult {
		int result;
		Stack moves;

		public MinimaxResult(int v) {
			result = v;
		}

		public void set(Stack moves)
		{
			this.moves = (Stack) moves.clone();
		}

		public boolean ge(MinimaxResult r) {
			return result >= r.result;
		}
			
		public boolean le(MinimaxResult r) {
			return result <= r.result;
		}

		public String toString() {
			return moves + " -> " +  result;
		}
	}

	class Timeout extends Exception {
	}
		
	public AI(Board board) {
		this.board = board;
	}

	public MinimaxResult minimaxAlphaBeta(int color) {
		depth = 0;
		nodes = 0;
		moveStack = new Stack();
		time = System.currentTimeMillis();
		MinimaxResult r = new MinimaxResult(0);
		try {
			maxdepth = mindepth;
			do {
				if (verbose > 1)
					System.out.print(maxdepth + " ");
				if (color == Common.black)
					r = maxValue(new MinimaxResult(Integer.MIN_VALUE), new MinimaxResult(Integer.MAX_VALUE), color);
				else
					r = minValue(new MinimaxResult(Integer.MIN_VALUE), new MinimaxResult(Integer.MAX_VALUE), color);
				if (verbose > 1)
					System.out.println(r);
				maxdepth += 2;
			} while (true);
		} catch (Timeout e) {
			if (verbose > 1)
				System.out.println("Time's up! " + nodes + " nodes searched (" + nodes * 1000.0 / timelimit + " nodes/s)");
			return r;
		}
	}
		
	public MinimaxResult maxValue(MinimaxResult alpha, MinimaxResult beta, int color)
		throws Timeout {
		if (System.currentTimeMillis() > time + timelimit) {
			while (depth-- > 0)
				board.undo();
			throw new Timeout();
		}
		nodes++;
			
		Vector moves = board.validMoves(color);
		if (depth++ == maxdepth || moves.size() == 0) {
			MinimaxResult r = new MinimaxResult(board.eval());
			r.set(moveStack);
			depth--;
			return r;
		}
		for (Enumeration e = moves.elements() ; e.hasMoreElements() ;) {
			Move move = (Move) e.nextElement();
			try {
				board.move(move);
			} catch (Board.InvalidMove ex) {
				continue;
			}
			moveStack.push(move);
			MinimaxResult result = minValue(alpha, beta, color == Common.black ? Common.white : Common.black);
			if (!result.le(alpha)) {
				alpha = result;
			}
			moveStack.pop();
			board.undo();
			if (alpha.ge(beta)) {
				depth--;
				return beta;
			}
		}
		depth--;
		return alpha;
	}
		
	public MinimaxResult minValue(MinimaxResult alpha, MinimaxResult beta, int color)
		throws Timeout {
		if (System.currentTimeMillis() > time + timelimit) {
			while (depth-- > 0)
				board.undo();
			throw new Timeout();
		}
		nodes++;
			
		if (depth++ == maxdepth) {
			MinimaxResult r = new MinimaxResult(board.eval());
			r.set(moveStack);
			depth--;
			return r;
		}
		Vector moves = board.validMoves(color);
		for (Enumeration e = moves.elements() ; e.hasMoreElements() ;) {
			Move move = (Move) e.nextElement();
			try {
				board.move(move);
			} catch (Board.InvalidMove ex) {
				continue;
			}
			moveStack.push(move);
			MinimaxResult result = maxValue(alpha, beta, color == Common.black ? Common.white : Common.black);
			if (!result.ge(beta)) {
				beta = result;
			}
			moveStack.pop();
			board.undo();
			if (beta.le(alpha)) {
				depth--;
				return alpha;
			}
		}
		depth--;
		return beta;
	}
	
	public Move move(int color) {
		MinimaxResult r = minimaxAlphaBeta(color);
		if (verbose > 0)
			System.out.println(r);
		return (Move) r.moves.firstElement();
	}
}
