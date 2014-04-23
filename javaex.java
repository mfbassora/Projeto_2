import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
 
public class javaex {


public static void main(String[] args) {
 
	// initial a Map
	Map<String, String> map = new HashMap<String, String>();
	map.put("1", "Jan");
	map.put("2", "Feb");
	map.put("3", "Mar");
	map.put("4", "Apr");
	map.put("5", "May");
	map.put("6", "Jun");
 
	System.out.println("Example 1...");
	// Map -> Set -> Iterator -> Map.Entry -> troublesome
	Iterator iterator = map.entrySet().iterator();
	while (iterator.hasNext()) {
		Map.Entry mapEntry = (Map.Entry) iterator.next();
		System.out.println("The key is: " + mapEntry.getKey()
			+ ",value is :" + mapEntry.getValue());
	}
 }
 
}

