// $Id: Go.java,v 1.1.1.1 2003/03/01 12:55:11 jb Exp $

import java.util.*;

class Go {	
	public static void main(String argv[]) {
		koTest();
	}

	public static void koTest() {
		Board b;
		b = new Board(9);

		AI ai = new AI(b);
		UI ui = new UI();
		
		try {
			b.move(new Move(3, 5, Common.white));
			b.move(new Move(4, 6, Common.white));
			b.move(new Move(5, 5, Common.white));

			b.move(new Move(3, 4, Common.black));
			b.move(new Move(4, 3, Common.black));
			b.move(new Move(5, 4, Common.black));

//			b.move(new Move(4, 4, Common.white));
//			System.out.println(b);		
		} catch (Board.InvalidMove e) {				
			System.out.println(e);
		}

		Move m;
		
		int color = Common.white;
		int pcolor = Common.white;
		System.out.println(b);
  		while (true) {
  			try {
				if (color == pcolor)
  					m = ui.move(color);
				else
					m = ai.move(color);
  				b.move(m);
				System.out.println(b);
				color = color == Common.black ? Common.white : Common.black;
  			} catch (Board.InvalidMove e) {				
  				System.out.println(e + ". Try again.\n" + b);
  			}
		}
	}
}
