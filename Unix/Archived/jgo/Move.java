// $Id: Move.java,v 1.1.1.1 2003/03/01 12:55:11 jb Exp $

class Move {
	public int x;
	public int y;
	public int color;
		
	public Move(int x, int y, int color) {
		this.x = x;
		this.y = y;
		this.color = color;
	}
	
	public String toString() {
		String t = "";
		int tc;
		if (color < 0) {
			t = "-";
			tc = -color;
		} else
			tc = color;
		return t + (char) ((int) 'A' + x) + "" + (y+1) + "/" + (tc == Common.black ? "B" : "W");
	}
}
