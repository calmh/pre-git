using System;

namespace ObjectStore
{
	/// <summary>
	/// Summary description for StoredObject.
	/// </summary>
	[Serializable]
	public class StoredObject
	{
		internal object _data = null;
		private Guid _id = Guid.Empty;
		
		[NonSerialized]
		internal StorageArea _area = null;

		public object Data {
			get { return _data; }
			set { _data = value; }
		}
		public Guid ID {
			get { return _id; }
		}

		public StoredObject()
		{
			_id = Guid.NewGuid();
		}

		public StoredObject(object data) {
			_id = Guid.NewGuid();
			_data = data;
		}

		public void Save() {
			_area.save(this);
		}
	}
}
