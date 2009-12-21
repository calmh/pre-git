// $Id: UI.java,v 1.1.1.1 2003/03/01 12:55:11 jb Exp $

import java.io.*;

class UI implements Player {
	private LineNumberReader input;

	public UI() {
		input = new LineNumberReader(new InputStreamReader(System.in));
	}
	
	public String readLine(String prompt) {
		System.out.print(prompt);
		String line = null;
		try {
			line = input.readLine();
		} catch (IOException e) {
			System.err.println(e);
		}
		return line;
	}
	
	public void init() {
		String scolor = readLine("Choose your color[B/W]: ");
//		scor = scolor.upper();
	}
	
	public Move move(int color) {
		String ms = readLine((color == Common.black ? "Black" : "White")
		+ " move: ");
		ms = ms.toUpperCase();
		int x = Character.getNumericValue(ms.toCharArray()[0]) - Character.getNumericValue('A');
		int y = Integer.parseInt(ms.substring(1));
		return new Move(x, y - 1, color);
	}
}
