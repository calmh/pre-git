using System;
using System.Collections;
using System.Runtime.Serialization;
using System.Xml.Serialization;
using System.IO;

namespace PhotoRenamer
{
	/// <summary>
	/// 
	/// </summary>
	public class NameHistory
	{
                private Hashtable forwardCache, reverseCache;
                private bool needsRebuild;
                public ArrayList entries;
		
                public NameHistory()
		{
                        forwardCache = new Hashtable();
                        reverseCache = new Hashtable();
                        entries = new ArrayList();
                        needsRebuild = true;
		}

                public void Add(NameEntry entry) {
                        if (needsRebuild)
                                rebuildCache();
                        entries.Add(entry);
                        forwardCache[entry.OldName] = entry;
                        reverseCache[entry.NewName] = entry;
                }

/*                public void Save(string filename) {
                        XmlSerializer serializer = new XmlSerializer(typeof(NameEntry[]));
                        FileStream fs = new FileStream(filename, FileMode.Create);
                        serializer.Serialize(fs, entries.ToArray(typeof(NameEntry)));
                        fs.Close();
                }

                public void Load(string filename) {
                        XmlSerializer serializer = new XmlSerializer(typeof(NameEntry[]));
                        FileStream fs = new FileStream(filename, FileMode.Open);
                        NameEntry[] ents = (NameEntry[]) serializer.Deserialize(fs);
                        entries = new ArrayList(ents);
                        needsRebuild = true;
                        fs.Close();
                }*/

                private void rebuildCache() {
                        foreach (NameEntry entry in entries) {
                                forwardCache[entry.OldName] = entry;
                                reverseCache[entry.NewName] = entry;
                        }
                        needsRebuild = false;
                }
	}
}
