import java.io.IOException;
import java.util.HashMap;

public class gradeDemo {
    static HashMap<String, gradeMath> map = new HashMap<>();
	public static void main(String[] args) throws IOException {
        input(new gradeMath("one",3));
        input(new gradeMath("two",2));
        input(new gradeMath("three",1));
        System.out.println("班级数：" + gradeMath.classnum);
        for(var oneclass : map.values())
        {
            oneclass.inputg();
        }
        String id = "";
        while(true)
        {
            System.out.println("输入班号进行操作，输入 N 退出：");
            id = KB.scan().strip();
            if(id.equals("N")) break;
            var choosed = map.get(id);
            if(choosed == null)
            {
                System.out.println("输入错误，请重新输入：");
                continue;
            }
            choosed.run();
        }
    }
    static void input(gradeMath gm)
    {
        map.put(gm.get_cnum(), gm);
    }
}
