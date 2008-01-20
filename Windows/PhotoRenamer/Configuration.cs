using Microsoft.Win32;
using System;

namespace PhotoRenamer
{
	/// <summary>
	/// 
	/// </summary>
        public class Configuration {
                private static Configuration instance;

                private RegistryKey key;
                private Configuration() {
                        key = Registry.CurrentUser.CreateSubKey(@"Software\Jakob Borg\Photo Renamer");
                }

                public static Configuration Instance {
                        get {
                                if (instance == null)
                                        instance = new Configuration();
                                return instance;
                        }
                }

                public object this[string index] {
                        set {
                                key.SetValue(index, value);
                        }
                        get {
                                return (string) key.GetValue(index);
                        }
                }
	}
}
