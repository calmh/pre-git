package kontoreg;

import java.io.*;
import java.awt.*;
import javax.swing.*;

public class KontoRegister {
	// Construct the application
	public KontoRegister() {
		File conffile = new File("./kontoreg.cf");
		Configuration conf = null;

		try {
		if (conffile.exists() && conffile.canRead()) {
			ObjectInputStream os = new ObjectInputStream(new FileInputStream("./kontoreg.cf"));
			conf = (Configuration) os.readObject();
		} else {
			conf = new Configuration();
                        JPanel connectionPanel = createConnectionDialog(conf);
                        String[] ConnectOptionNames = { "OK", "Avbryt" };
			JOptionPane.showOptionDialog(null, connectionPanel, "Inställningar",
                        JOptionPane.DEFAULT_OPTION, JOptionPane.QUESTION_MESSAGE,
                                null, ConnectOptionNames, ConnectOptionNames[0]);
                        ObjectOutputStream os = new ObjectOutputStream(new FileOutputStream("./kontoreg.cf"));
			os.writeObject(conf);
		}
		} catch (Exception e) { System.out.println(e); }

		KontoFrame frame = new KontoFrame(conf);
                frame.pack();
		frame.setVisible(true);
	}

	// Main method
	static public void main(String[] args) {
		try {
                        if (args.length > 0 && args[0] != null)
			        UIManager.setLookAndFeel(args[0]);
                        else
                                UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		new KontoRegister();
	}

        /**
     * Creates the connectionPanel, which will contain all the fields for
     * the connection information.
     */
    public JPanel createConnectionDialog(Configuration conf) {
        // Create the labels and text fields.
        JLabel userNameLabel = new JLabel("Användarnamn: ", JLabel.RIGHT);
        JTextField userNameField = new JTextField(conf.user);

        JLabel passwordLabel = new JLabel("Lösenord: ", JLabel.RIGHT);
        JTextField passwordField = new JTextField(conf.password);

        JLabel serverLabel = new JLabel("Databas-URL: ", JLabel.RIGHT);
        JTextField serverField = new JTextField(conf.url);

        JPanel connectionPanel = new JPanel(false);
        connectionPanel.setLayout(new BoxLayout(connectionPanel,
                                                BoxLayout.X_AXIS));

        JPanel namePanel = new JPanel(false);
        namePanel.setLayout(new GridLayout(0, 1));
        namePanel.add(userNameLabel);
        namePanel.add(passwordLabel);
        namePanel.add(serverLabel);

        JPanel fieldPanel = new JPanel(false);
        fieldPanel.setLayout(new GridLayout(0, 1));
        fieldPanel.add(userNameField);
        fieldPanel.add(passwordField);
        fieldPanel.add(serverField);

        connectionPanel.add(namePanel);
        connectionPanel.add(fieldPanel);
        return connectionPanel;
    }
}
