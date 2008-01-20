package kontoreg;

import javax.swing.JTable;
import javax.swing.table.AbstractTableModel;
import javax.swing.JScrollPane;
import javax.swing.JFrame;
import javax.swing.SwingUtilities;
import javax.swing.JOptionPane;
import java.awt.*;
import java.awt.event.*;

class UserTableModel extends AbstractTableModel {
	DatabaseCommunicator dc;
	Object[] data;
	final String[] types = { "<unspecified>", "Unix login", "NT login", "SQL user", "POP3/IMAP user" };

	public UserTableModel(DatabaseCommunicator idc) {
		dc = idc;
		data = dc.getData();
	}

        public int getColumnCount() {
		return dc.columnNames.length;
        }

        public int getRowCount() {
		return data.length;
        }

        public String getColumnName(int col) {
		return dc.columnNames[col];
        }

        public Object getValueAt(int row, int col) {
                if (col == 0)
                        return types[((Integer) ((Account) data[row]).getArray()[col]).intValue()];
                else
        		return ((Account) data[row]).getArray()[col];
        }

        public Class getColumnClass(int c) {
		return getValueAt(0, c).getClass();
        }

        public boolean isCellEditable(int row, int col) {
                return true;
        }

        public void setValueAt(Object value, int row, int col) {
                System.out.println(value + " -> " + row + ", " + col);
        }
}

