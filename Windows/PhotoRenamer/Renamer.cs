using System;
using System.IO;
using System.Drawing;
using System.Drawing.Imaging;
using System.Text;
using System.Collections;

namespace PhotoRenamer
{
        public class Renamer {
                public delegate void LogDelegate(int current, int max, string oldname, string newname);
                private LogDelegate logger;

                public Renamer() {
                }

                public void AddLogger(LogDelegate d) {
                        if (logger == null)
                                logger = d;
                        else
                                logger += d;
                }

                public void Process(string directory) {
                        string[] e1 = Directory.GetFileSystemEntries(directory, "*.jpg");
                        string[] e2 = Directory.GetFileSystemEntries(directory, "*.thm");
                        string[] entries = new string[e1.Length + e2.Length];
                        e1.CopyTo(entries, 0);
                        e2.CopyTo(entries, e1.Length);
                        Process(entries);
                }

                private void rename(string oldname, string newname) {
                        NameEntry en = new NameEntry();
                        en.OldName = oldname;
                        en.NewName = newname;
                        en.When = "now";
                        //history.Add(en);
                        File.Move(oldname, newname);
                }

                private int imageNum(Image img) {
                        // "267CANON/CRW_6755.CRW" -> 16755
                        const int imageNumberProperty = 37500;
                        const int imageNumberOffset = 118;
                        try {
                                byte[] bytes = img.GetPropertyItem(imageNumberProperty).Value;
                                int num = (bytes[imageNumberOffset + 2] << 16) | (bytes[imageNumberOffset + 1] << 8) | bytes[imageNumberOffset];
                                //int shortnum = num % 10000;
                                //int highdigit = num / (int) 1e6 - 1;
                                //return highdigit * 10000 + shortnum;
                                return num;
                        } catch (Exception) {
                                return 0;
                        }
                }

                public void Process(string[] entries) {
                        if (entries == null)
                                return;
                        
                        int i = 0;
                        foreach (string entry in entries) {
                                string oldname = entry.ToLower();
                                Image img = Image.FromFile(oldname);

                                // Grundnamn: YYmmdd-HHMMSS
                                PropertyItem captureDate = img.GetPropertyItem(306);
                                string nname = ASCIIEncoding.ASCII.GetString(captureDate.Value).Substring(0, 19);
                                nname = nname.Replace(":", "").Replace(" ", "-");

                                // Extra tillägg: -xxxxx (bildnummer) om bilden innehåller sån info
                                int num = imageNum(img);
                                if (num != 0)
                                        nname = nname + "-" + num.ToString("d5");

                                // Stäng fil, etc.
                                img.Dispose();
                                img = null;

                                // Nya fullständinga namnet, inkl. katalog och extension
                                string dirname = nname.Substring(0, 8);
                                string newname = Path.GetDirectoryName(oldname) + @"\" + dirname + @"\" + nname + Path.GetExtension(oldname);

                                // Skapa katalogen om den inte finns
                                if (!Directory.Exists(Path.GetDirectoryName(oldname) + @"\" + dirname)) {
                                        if (logger != null)
                                                logger(i, entries.Length, "<new dir>", dirname);                                                
                                        Directory.CreateDirectory(Path.GetDirectoryName(oldname) + @"\" + dirname);
                                }

                                // Lägg till extrasiffra om så behövs
                                int serial = 2;
                                while (File.Exists(newname)) {
                                        newname = Path.GetDirectoryName(oldname) + @"\" + dirname + @"\" + nname + "-" + serial.ToString() + Path.GetExtension(oldname);
                                        serial++;
                                }

                                if (logger != null)
                                        logger(i++, entries.Length, Path.GetFileName(oldname), dirname + @"\" + Path.GetFileName(newname));
                                rename(oldname, newname);

                                // Om det var en .thm-fil vi döpte om, repetera med .crw
                                if (oldname.IndexOf(".thm") != -1) {
                                        oldname = oldname.Replace(".thm", ".crw");
                                        newname = newname.Replace(".thm", ".crw");
                                        if (logger != null)
                                                logger(i - 1, entries.Length, Path.GetFileName(oldname), dirname + @"\" + Path.GetFileName(newname));
                                        rename(oldname, newname);
                                }
                                GC.Collect();
                        }
                        if (logger != null)
                                logger(i, entries.Length, null, null);
                }
        }
}
