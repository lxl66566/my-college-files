import java.io.IOException;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.stream.Collectors;
import java.util.stream.Stream;
import javax.naming.LimitExceededException;
public class gradeMath {
	int snum; //班级人数
	public static int classnum;//班级个数
	private String cnum;//班号
	ArrayList<Integer> grade;//学生成绩
	gradeMath()
    {
        ++ classnum;
        cnum = "";
        snum = 0;
    }
    gradeMath(String clanum,int snum)
    {
        ++ classnum;
        cnum = clanum;
        this.snum = snum;
    }
    static void outclassnum(){
        System.out.println("班级个数：" + classnum);
    }
	void inputg(){
        System.out.println(String.format("请输入%s学生成绩，以空格隔开：", cnum));
        try{
            grade = Stream.of(KB.scan().split(" ")).map(Integer::parseInt).collect(Collectors.toCollection(ArrayList::new));
            if(grade.size() != snum) throw new Exception("人数不匹配");
            for (var i : grade)
                if(i < 0 || i > 100) throw new LimitExceededException("错误，成绩需在0-100之间");
        }
        catch(LimitExceededException e)
        {
            System.out.println(e.getMessage() + "，请重新输入：");
            inputg();
        }
        catch(Exception e)
        {
            System.out.println(e.getMessage() + "，请重新输入：");
            inputg();
        }
    }
    int maxgrade(){
        return grade.stream().mapToInt(Integer::intValue).max().getAsInt();
	}
	int mingrade(){
		return grade.stream().mapToInt(Integer::intValue).min().getAsInt();
	}
	double avggrade(){
		return grade.stream().mapToInt(Integer::intValue).average().getAsDouble();
	}
	int search(){
        return snum;
	}
	String get_cnum(){
		return cnum;
	}
    void gradeorder()
    {
        System.out.print("学生成绩从高到低排序：");
        grade.stream().sorted(Comparator.reverseOrder()).forEach(i -> System.out.print(i + " "));
        System.out.println();
    }
	void run() throws IOException{
		var id = -1;
        while(id < 6)
        {
            System.out.println("1.求最高分 2.求最低分 3.求平均成绩 4.查询 5.输出排序 6. exit");
            id = KB.scanint();
            switch(id)
            {
                case 1:
                    System.out.println("最高分：" + maxgrade());
                    break;
                case 2:
                    System.out.println("最低分：" + mingrade());
                    break;
                case 3:
                    System.out.println("平均成绩：" + avggrade());
                    break;
                case 4:
                    System.out.println("班级人数：" + search());
                    break;
                case 5:
                    gradeorder();
                    break;
                default:
                    System.out.println("退出！");
                    break;
            }
        }
	}
}
