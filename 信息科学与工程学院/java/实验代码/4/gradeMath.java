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
	public gradeMath()
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
	public void inputg() {
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
    public void input() // 用于子类重写
    {
        inputg();
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
	void search(){
        System.out.println("班级 " + get_cnum() + " 共有 " + snum + " 位学生");
        System.out.print("最高分：" + maxgrade());
        System.out.print(" 最低分：" + mingrade());
        System.out.println(" 平均分：" + avggrade());
	}
	public String get_cnum(){  // cnum 班号为 private，因此通过函数访问
		return cnum;
	}
    void gradeorder()
    {
        System.out.print("学生成绩从高到低排序：");
        grade.stream().sorted(Comparator.reverseOrder()).forEach(i -> System.out.print(i + " "));
        System.out.println();
    }
	void run(){ // 本次实验，此函数只需要输出，不需要响应询问
        search();
	}
}
