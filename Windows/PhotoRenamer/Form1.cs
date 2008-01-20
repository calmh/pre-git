using System;
using System.Drawing;
using System.Drawing.Imaging;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;
using System.Data;
using System.Text;
using System.IO;

namespace PhotoRenamer {
        /// <summary>
        /// Summary description for Form1.
        /// </summary>
        public class MainForm : System.Windows.Forms.Form {
                private System.Windows.Forms.Button bBrowse;
                private System.Windows.Forms.Button bProcess;
                private System.Windows.Forms.StatusBar sb;
                private System.Windows.Forms.ListView nameList;
                private System.Windows.Forms.ColumnHeader on;
                private System.Windows.Forms.ColumnHeader nn;
                private System.ComponentModel.IContainer components;
                private string[] entries;
                private OpenFileDialog openFileDialog1;
                private Configuration config;

                public MainForm() {
                        //
                        // Required for Windows Form Designer support
                        //
                        InitializeComponent();
                        config = Configuration.Instance;
                        config["VMajor"] = 0;
                        config["VMinor"] = 1;

                        this.Text += " " + Application.ProductVersion.ToString();

                        openFileDialog1 = new OpenFileDialog();
                        openFileDialog1.CheckFileExists = true;
                        openFileDialog1.CheckPathExists = true;
                        openFileDialog1.Multiselect = true;
                        openFileDialog1.DereferenceLinks = true;
                        openFileDialog1.Filter = "Photos (*.jpg, *.thm)|*.JPG;*.THM|All files (*.*)|*.*";
                        openFileDialog1.InitialDirectory = (string) config["LastDirectory"];
                        openFileDialog1.FileOk += new CancelEventHandler(OkHandler);
                }

                /// <summary>
                /// Clean up any resources being used.
                /// </summary>
                protected override void Dispose( bool disposing ) {
                        if( disposing ) {
                                if (components != null) {
                                        components.Dispose();
                                }
                        }
                        base.Dispose( disposing );
                }

		#region Windows Form Designer generated code
                /// <summary>
                /// Required method for Designer support - do not modify
                /// the contents of this method with the code editor.
                /// </summary>
                private void InitializeComponent() {
                        this.bBrowse = new System.Windows.Forms.Button();
                        this.bProcess = new System.Windows.Forms.Button();
                        this.sb = new System.Windows.Forms.StatusBar();
                        this.nameList = new System.Windows.Forms.ListView();
                        this.on = new System.Windows.Forms.ColumnHeader();
                        this.nn = new System.Windows.Forms.ColumnHeader();
                        this.SuspendLayout();
                        // 
                        // bBrowse
                        // 
                        this.bBrowse.Location = new System.Drawing.Point(8, 176);
                        this.bBrowse.Name = "bBrowse";
                        this.bBrowse.Size = new System.Drawing.Size(72, 24);
                        this.bBrowse.TabIndex = 1;
                        this.bBrowse.Text = "Select...";
                        this.bBrowse.Click += new System.EventHandler(this.bBrowse_Click);
                        // 
                        // bProcess
                        // 
                        this.bProcess.Location = new System.Drawing.Point(344, 176);
                        this.bProcess.Name = "bProcess";
                        this.bProcess.Size = new System.Drawing.Size(72, 24);
                        this.bProcess.TabIndex = 3;
                        this.bProcess.Text = "Process";
                        this.bProcess.Click += new System.EventHandler(this.bProcess_Click);
                        // 
                        // sb
                        // 
                        this.sb.Location = new System.Drawing.Point(0, 208);
                        this.sb.Name = "sb";
                        this.sb.Size = new System.Drawing.Size(424, 22);
                        this.sb.TabIndex = 5;
                        // 
                        // nameList
                        // 
                        this.nameList.Columns.AddRange(new System.Windows.Forms.ColumnHeader[] {
                                                                                                       this.on,
                                                                                                       this.nn});
                        this.nameList.Location = new System.Drawing.Point(8, 8);
                        this.nameList.Name = "nameList";
                        this.nameList.Size = new System.Drawing.Size(408, 160);
                        this.nameList.TabIndex = 6;
                        this.nameList.View = System.Windows.Forms.View.Details;
                        // 
                        // on
                        // 
                        this.on.Text = "Old name";
                        this.on.Width = 191;
                        // 
                        // nn
                        // 
                        this.nn.Text = "New name";
                        this.nn.Width = 191;
                        // 
                        // MainForm
                        // 
                        this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
                        this.ClientSize = new System.Drawing.Size(424, 230);
                        this.Controls.AddRange(new System.Windows.Forms.Control[] {
                                                                                          this.nameList,
                                                                                          this.sb,
                                                                                          this.bProcess,
                                                                                          this.bBrowse});
                        this.Name = "MainForm";
                        this.Text = "PhotoRenamer";
                        this.ResumeLayout(false);

                }
		#endregion

                /// <summary>
                /// The main entry point for the application.
                /// </summary>
                [STAThread]
                static void Main(string[] argv) {
                        if (argv.Length >= 1) {
                                Renamer r = new Renamer();
                                r.Process(argv[0]);
                        } else {
                                Application.Run(new MainForm());
                        }
                }

                private void bBrowse_Click(object sender, System.EventArgs e) {
                        openFileDialog1.ShowDialog();
                }

                private void bProcess_Click(object sender, System.EventArgs e) {
                        Renamer r = new Renamer();
                        r.AddLogger(new Renamer.LogDelegate(Progress));
                        r.Process(entries);
                }

                public void Progress(int current, int max, string oldname, string newname) {
                        if (current == max)
                                sb.Text = "Done.";
                        else {
                                sb.Text = (100 * current / max).ToString() + " % complete.";
                        }
                        if (oldname != null && newname != null) {
                                string[] pair = { oldname, newname };
                                ListViewItem it = new ListViewItem(pair);
                                nameList.Items.Add(it);
                                nameList.Update();
                        }
                }

                void OkHandler(object sender, CancelEventArgs e) {
                        OpenFileDialog d = (OpenFileDialog) sender;
                        entries = d.FileNames;
                        if (entries.Length > 1)
                                sb.Text = entries.Length.ToString() + " files selected.";
                        else
                                sb.Text = "1 file selected.";
                        sb.Update();
                        config["LastDirectory"] = Path.GetDirectoryName(entries[0]);
                }
        }
}
