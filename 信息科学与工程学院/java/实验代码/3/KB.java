import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
public class KB {
    static BufferedReader br=new BufferedReader(new InputStreamReader(System.in));
    public static String scan() throws IOException
    {
        // return sc.nextLine().strip();
        return br.readLine().strip();
    }
    public static int scanint() throws IOException
    {
        // return sc.nextInt();
        return Integer.parseInt(scan());
    }
}
