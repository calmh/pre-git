using System;
using System.IO;
using System.Runtime.Serialization;
using System.Runtime.Serialization.Formatters.Binary;

namespace ObjectStore
{
	/// <summary>
	/// Summary description for StorageArea.
	/// </summary>
	public class StorageArea
	{
		public class NoSuchObjectException : Exception {
			public NoSuchObjectException(string msg) : base(msg) {}
		}

		private string _path = null;

		public StorageArea(string path)
		{
			_path = path;
		}

		public StoredObject NewStoredObject() {
			StoredObject obj = new StoredObject();
			obj._area = this;
			return obj;
		}

		internal void save(StoredObject obj) {
			FileStream fs = new FileStream(_path + "/" + obj.ID, FileMode.Create);
			BinaryFormatter formatter = new BinaryFormatter();
			formatter.Serialize(fs, obj);
			fs.Close();
		}

		public StoredObject Load(Guid id) {
			try  {
				FileStream fs = new FileStream(_path + "/" + id, FileMode.Open);
				BinaryFormatter formatter = new BinaryFormatter();
				StoredObject obj = (StoredObject) formatter.Deserialize(fs);
				obj._area = this;
				fs.Close();
				return obj;
			} catch (IOException) {
				throw new NoSuchObjectException(id.ToString());
			}
		}

		public void Delete(Guid id) {
			try {
				System.IO.File.Delete(_path + "/" + id);
			} catch (IOException) {
				throw new NoSuchObjectException(id.ToString());
			}
		}
	}
}
