using System;
using System.IO;
using System.Collections;
using System.Text.RegularExpressions;

namespace KeeperMkV
{
	public class Syncer
	{
		private PhotoDB db;
		private int pRoll, pFrame, pYear, pMonth, pScanID, pComment, pKeywords;
		private Regex formatA = new Regex(@"\\(a[0-9]+) - ([^\\]+)\\a[0-9]+-([0-9]+)\.jpg");
		private Regex formatB = new Regex(@"\\s([0-9]{2})([0-9]{2})-([0-9]{3})[ -]+\(([^\\]+)\)\.");
		private Regex formatC = new Regex(@"\\s([0-9]{2})([0-9]{2})-([0-9]{3})\.");

		public Syncer(PhotoDB idb)
		{
			db = idb;
			pRoll = db.PropertyID("Roll ID");
			pFrame = db.PropertyID("Frame No.");
			pYear = db.PropertyID("Year Scanned");
			pMonth = db.PropertyID("Month Scanned");
			pScanID = db.PropertyID("Scan ID");
			pComment = db.PropertyID("Comment");
			pKeywords = db.PropertyID("Keywords");
		}

		public int Sync(string directory) {
			int np = 0;
			string[] dirs = Directory.GetDirectories(directory);
			string[] files = Directory.GetFiles(directory);
			foreach (string file in files) {
				Photo p = db.FindPhoto(file);
				if (p == null) {
					p = new Photo(file);
					autoPropertyFill(p);
					db.AddPhoto(p);
					np++;
				}
			}
			foreach (string dir in dirs)
				np += Sync(dir);
			return np;
		}

		private void autoPropertyFill(Photo p) {
			Match m = formatA.Match(p.Name);
			if (m.Success) {
				p.setProperty(pRoll, m.Groups[1].Value);
				p.setProperty(pKeywords, m.Groups[2].Value);
				p.setProperty(pFrame, m.Groups[3].Value);
				return;
			}
			m = formatB.Match(p.Name);
			if (m.Success) {
				p.setProperty(pYear, "20" + m.Groups[1].Value);
				p.setProperty(pMonth, m.Groups[2].Value);
				p.setProperty(pScanID, m.Groups[3].Value);
				p.setProperty(pComment, m.Groups[4].Value);
				return;
			}
			m = formatC.Match(p.Name);
			if (m.Success) {
				p.setProperty(pYear, "20" + m.Groups[1].Value);
				p.setProperty(pMonth, m.Groups[2].Value);
				p.setProperty(pScanID, m.Groups[3].Value);
				return;
			}
		}
	}
}
