import java.util.LinkedHashMap;

public class gradeDemo {
    // 按照添加顺序的键值对，存储班号与对应的班级对象
    static LinkedHashMap<String, gradeMath> map = new LinkedHashMap<>();
	public static void main(String[] args){
        input(new gradeMath("one",3));
        input(new gradeMath("two",2));
        input(new VIP_gradeMath("three",2));
        input(new VIP_gradeMath("four",2));
        System.out.println("班级数：" + gradeMath.classnum);
        map.values().forEach(gradeMath::input); // 输入信息
        String id = "";
        while(true)
        {
            System.out.println("输入班号进行操作，输入 N 退出：");
            id = KB.scan();
            if(id.equalsIgnoreCase("N")) break;
            var choosed = map.get(id);
            if(choosed == null)
            {
                System.out.println("未找到班级，请重新输入：");
                continue;
            }
            choosed.run();
            if(!(choosed instanceof VIP_gradeMath)) continue;   // 不是 VIP 班级，不进行学生交换询问
            ask_change_stu((VIP_gradeMath) choosed);    // 向下转型
        }
    }
    static void input(gradeMath gm)
    {
        map.put(gm.get_cnum(), gm);
    }
    static void ask_change_stu(VIP_gradeMath choosed)
    {
        System.out.println("是否交换学生？(Y/N)：");
        var temp = KB.scan();
        if(!temp.equalsIgnoreCase("Y")) return;
        String s1,s2,s3;
        // 几个 while(true) 是为了循环输入
        while(true)
        {
            System.out.println("请输入转出学生学号：");
            s1 = KB.scan();
            if(!choosed.has_student(s1))
            {
                System.out.println("未找到学生，请重新输入");
                continue;
            }
            break;
        }
        while(true)
        {
            System.out.println("请输入转入学生所在班号：");
            s2 = KB.scan();
            if(!map.containsKey(s2))
            {
                System.out.println("未找到班级，请重新输入");
                continue;
            }
            else if(s2.equals(choosed.get_cnum()))
            {
                System.out.println("不能转入自己，请重新输入");
                continue;
            }
            break;
        }
        while(true)
        {
            System.out.println("请输入转出学生学号：");
            s3 = KB.scan();
            if(!((VIP_gradeMath)map.get(s2)).has_student(s3))
            {
                System.out.println("未找到学生，请重新输入");
                continue;
            }
            break;
        }
        try{
            choosed.exchangestu(s1, s3, (VIP_gradeMath)map.get(s2));
        }catch(Exception e)
        {
            System.out.println(e.getMessage());
        }
    }
}
