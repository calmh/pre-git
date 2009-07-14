package kontoreg;

import java.io.*;
import java.sql.*;

public class TestConnection {
	public static void main(String argv[]) {
		Connection db;        // The connection to the database
		Statement  st;        // Our statement to run queries with
		
		String url = argv[0];
		String usr = argv[1];
		String pwd = argv[2];

		try {
		// Load the driver
		Class.forName("org.postgresql.Driver");
		
		// Connect to database
		System.out.println("Connecting to Database URL = " + url);
		db = DriverManager.getConnection(url, usr, pwd);
		
		System.out.println("Connected...Now creating a statement");
		st = db.createStatement();

		//		st.executeUpdate("create table foo ( a int, b int )");
		st.executeUpdate("insert into foo values (1, 2)");
		
		System.out.println("Now closing the connection");
		st.close();
		db.close();
		} catch (Exception e) { System.out.println(e); }
	}
}

