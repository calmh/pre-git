package kontoreg;

import java.util.*;
import java.io.*;
import java.sql.*;

class DatabaseCommunicator {
	Configuration conf;
	final String[] columnNames = { "Kontotyp", "Avändarnamn", "Plats", "Kontohavare" };
	Vector data;
	Connection db;
	Statement st;

	public DatabaseCommunicator(Configuration iconf) {
		conf = iconf;
		try {
			Class.forName("org.postgresql.Driver");
			db = DriverManager.getConnection(conf.url, conf.user, conf.password);
			st = db.createStatement();
		} catch (Exception e) { System.out.println(e); }

		update();
	}

	public void update() {
		try{
			ResultSet rs = st.executeQuery("select * from users");
			data = new Vector();
			while (rs.next()) {
				data.add(new Account(Integer.parseInt(rs.getString(1)), Integer.parseInt(rs.getString(2)), rs.getString(3), rs.getString(4),
                                        rs.getString(5), rs.getString(6), rs.getString(7), rs.getString(8), rs.getString(9)));
			}
		} catch (Exception e) { System.out.println(e); }
	}

        public int getNewAccountId() {
                int na = -1;
                try {
                        System.out.println("foo " + st);
			ResultSet rs = st.executeQuery("select max(account_id)+1 as max_account_id from users");
                        if (rs == null)
                                System.out.println("rs is null");
                        else
                                System.out.println("rs is ok");
                        System.out.println(rs.getString(1));
		        na = Integer.parseInt(rs.getString(1));
		} catch (Exception e) { System.out.println(e); }
                return na;
	}


        public Object[] getData() {
		return data.toArray();
	}
}
