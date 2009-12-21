package kontoreg;

import java.awt.*;
import java.awt.event.*;
import javax.swing.*;

public class KontoFrame extends JFrame {
	JPanel contentPane;
	BorderLayout borderLayout1;
	JMenuBar jMenuBar1;
	JMenu jMenuFile;
        JMenu jMenuAccount;
	JMenuItem item;
	JLabel statusLabel;

	DatabaseCommunicator dc;
	UserTableModel tabmod;
	JTable table;
	JScrollPane pane;

	Configuration conf;

	// Construct the frame
	public KontoFrame(Configuration iconf) {
		enableEvents(AWTEvent.WINDOW_EVENT_MASK);
		try {
			conf = iconf;

			borderLayout1 = new BorderLayout();
			jMenuBar1 = new JMenuBar();
			jMenuFile = new JMenu();
                        jMenuAccount = new JMenu();
			statusLabel = new JLabel();

			dc = new DatabaseCommunicator(conf);
			tabmod = new UserTableModel(dc);
			table = new JTable(tabmod);
			pane = new JScrollPane(table);

			jbInit();
		}
		catch (Exception e) {
			e.printStackTrace();
		}
	}

	// Component initialization
	private void jbInit() throws Exception {

		contentPane = (JPanel) this.getContentPane();
		contentPane.setLayout(borderLayout1);

		this.setTitle("Kontoregister");
		this.setJMenuBar(jMenuBar1);
		this.setSize(new Dimension(400, 300));
		jMenuFile.setText("Arkiv");
                item = new JMenuItem();
		item.setText("Avsluta");
		item.addActionListener(new java.awt.event.ActionListener() {  public void actionPerformed(ActionEvent e) {
                                   quit();
                               }});
		jMenuFile.add(item);
		jMenuBar1.add(jMenuFile);

                jMenuAccount.setText("Konto");
                item = new JMenuItem();
                item.setText("Visa");
		item.addActionListener(new java.awt.event.ActionListener() {  public void actionPerformed(ActionEvent e) {
                                   account_view();
                               }});
		jMenuAccount.add(item);
                item = new JMenuItem();
                item.setText("Lägg till");
		item.addActionListener(new java.awt.event.ActionListener() {  public void actionPerformed(ActionEvent e) {
                                   account_add();
                               }});
		jMenuAccount.add(item);
                item = new JMenuItem();
                item.setText("Ta bort");
		item.addActionListener(new java.awt.event.ActionListener() {  public void actionPerformed(ActionEvent e) {
                                   account_remove();
                               }});
		jMenuAccount.add(item);
                jMenuBar1.add(jMenuAccount);

		statusLabel.setForeground(Color.black);
		statusLabel.setBorder(BorderFactory.createLoweredBevelBorder());
		statusLabel.setText("statusLabel");

        this.addWindowListener(new WindowAdapter() {
                public void windowClosing(WindowEvent e) {
                                           quit();
                               }});
		contentPane.add(pane);
	}

        private void quit() {
                System.exit(0);
        }

        private void account_view() {
        }

        private void account_add() {
                int mai = dc.getNewAccountId();

                JLabel userNameLabel = new JLabel("Användarnamn: ", JLabel.RIGHT);
                JTextField userNameField = new JTextField(conf.user);

                JLabel passwordLabel = new JLabel("Lösenord: ", JLabel.RIGHT);
                JTextField passwordField = new JTextField(conf.password);

                JLabel serverLabel = new JLabel("Kontohavare (namn): ", JLabel.RIGHT);
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
                String[] ConnectOptionNames = { "OK", "Verkställ", "Avbryt" };
                int result = JOptionPane.showOptionDialog(null, connectionPanel, "Lägg till konto",
                        JOptionPane.DEFAULT_OPTION, JOptionPane.PLAIN_MESSAGE,
                        null, ConnectOptionNames, ConnectOptionNames[0]);
                if (result == 0 || result == 1) {
                        System.out.println("add account (mai = " + mai + ")");
                }
        }

        private void account_remove() {
        }
}
