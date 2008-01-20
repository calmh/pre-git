package kontoreg;
import java.io.Serializable;

class Configuration implements Serializable {
	public String url = "jdbc:postgresql:kontoreg";
	public String user = "jb";
	public String password = "foo";
	public int sorting = 0;
}
