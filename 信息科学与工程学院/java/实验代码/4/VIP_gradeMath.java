import java.util.ArrayList;
import java.util.HashSet;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class VIP_gradeMath extends gradeMath{
    ArrayList<String> sno = new ArrayList<>();//学生学号

	public VIP_gradeMath(String clanum,int snum){
		super(clanum,snum);
	}

	public void inputs(){
		System.out.println("输入 " + get_cnum() + " 学生学号，以空格隔开：");
        try{
            sno = Stream.of(KB.scan().split(" ")).collect(Collectors.toCollection(ArrayList::new));
            if(sno.size() != snum) throw new Exception("人数不匹配");
			if(new HashSet<>(sno).size() != sno.size()) throw new Exception("学生学号重复");
        }
        catch(Exception e)
        {
            System.out.println(e.getMessage() + "，请重新输入：");
            inputs();
        }
	}
	@Override
	public void input() // 重写 input 使其可以输入学号与成绩
	{
		inputs();
		inputg();
	}
	@Override
	int maxgrade(){	// 重写使其返回位置而非值
		var temp = 0;
		for(var i = 1; i < snum; i++) if(grade.get(i) > grade.get(temp)) temp = i;
		return temp;
	}
	@Override
	int mingrade(){	// 重写使其返回位置而非值
		var temp = 0;
		for(var i = 1; i < snum; i++) if(grade.get(i) < grade.get(temp)) temp = i;
		return temp;
	}
	@Override
	void search(){
		System.out.println("班级"+ get_cnum() + "共有" + snum + "位学生");
		var temp = maxgrade();
		System.out.println("最高分："+ sno.get(temp) +" 号，学生成绩为 " + grade.get(temp));
		temp = mingrade();
		System.out.println("最低分："+ sno.get(temp) +" 号，学生成绩为 " + grade.get(temp));
		System.out.println("平均分:" + avggrade());
	}
	@Override
	void run(){
		search();
	}
	public boolean has_student(String student_number)	// 判断班级内是否含有学生
	{
		return sno.indexOf(student_number) != -1;
	}
	void add_stu(String student_number,int student_grade){	// 添加学生，底层实现
		sno.add(student_number);
		grade.add(student_grade);
	}
	void movestu(VIP_gradeMath to_gm, String student_number) throws Exception{	// 移动学生（包含检测，添加与删除）
		var index = sno.indexOf(student_number);
		if(index == -1)
		{
			throw new Exception("班级 " + get_cnum() + " 无此学生。");
		}
		to_gm.add_stu(student_number, grade.get(index));
		grade.remove(index);
		sno.remove(index);
	}
	void print_exchange_info(String s){	// 交换成功后打印信息
		System.out.print("学生 " + s + " 已交换到班级 " + get_cnum() + "，此班级学生学号：");
		sno.forEach(s1 -> System.out.print(s1 + " "));
		System.out.println();
	}
	public void exchangestu(String from_number,String to_number,VIP_gradeMath to_gm){	// 交换学生
		try
		{
			movestu(to_gm, from_number);
			to_gm.movestu(this,to_number);
			to_gm.print_exchange_info(from_number);
			print_exchange_info(to_number);
		}catch (Exception e)
		{
			System.out.println(e.getMessage());
		}
	}
}