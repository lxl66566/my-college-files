import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
public class KB {
    static BufferedReader br=new BufferedReader(new InputStreamReader(System.in));
    public static String scan()
    {   
        try{
            return br.readLine().strip();
        }
        catch(IOException e) {
            return "";
        }
    }
    
}
