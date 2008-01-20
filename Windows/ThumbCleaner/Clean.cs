using System;
using System.IO;

class Clean {
	public static void Main(string[] args) {
		CleanDir(args[0]);
	}

	public static void CleanDir(string dir) {
		foreach (string ndir in Directory.GetDirectories(dir)) {
			CleanDir(ndir);
		}

		foreach (string thumb in Directory.GetFiles(dir, "thumbs.db")) {
				Console.WriteLine("DELETE " + dir + "/" + thumb);
				try {
					File.Delete(thumb);
				} catch (Exception e) {
					Console.WriteLine(e);
				}
		}
		
		DirectoryInfo info = new DirectoryInfo(dir);
		if (info.LastWriteTime > new DateTime(2005, 7, 30)) {
			Console.WriteLine("RESET " + dir + ": " + info.LastWriteTime.ToString() + " -> " + info.CreationTime.ToString());
			try {
				info.LastWriteTime = info.CreationTime;
			} catch (Exception e) {
				Console.WriteLine(e);
			}
		}
	}

}

