import java.util.ArrayList;
import java.util.Scanner;
import java.util.stream.Collectors;
import java.util.stream.IntStream;
import java.util.stream.Stream;
public class Lesson {
    static int mode = -1;
    public static void main(String[] args)  {
        Scanner scanner = new Scanner(System.in);
        while(mode != 0)
        {
            System.out.println("input mode\n0. exit\n1. calculate days in month\n2. 水仙花\n3. 数字金字塔\n4. 猴子选大王");
            mode = scanner.nextInt();
            switch (mode)
            {
                case 0:
                    break;
                case 1:
                    var temp1 = new Question1(scanner);
                    temp1.ask();
                    break;
                case 2:
                    Question2.print();
                    break;
                case 3:
                    Question3.print(5); // 金字塔层数
                    break;
                default:
                    Question4.print(10,3);  // 猴子数量，步长
            }
        }
    }
}

class Question1
{
    Scanner scanner;
    int year,month;
    public Question1(Scanner temp)
    {
        scanner = temp;
        assert run(2020);
        assert !run(2022);
        assert !run(2100);
        assert run(2400);
    }
    public void ask()
    {
        System.out.println("Input year: ");
        year = scanner.nextInt();
        System.out.println("Input month: ");
        month = scanner.nextInt();
        System.out.println("Days in month: " + calculate_days_in_month(month, year));
    }
    public int calculate_days_in_month(int month, int year)
    {
        switch(month)
        {
            case 1:
            case 3:
            case 5:
            case 7:
            case 8:
            case 10:
            case 12:
                return 31;
            case 4:
            case 6:
            case 9:
            case 11:
                return 30;
            default:
                if(run(year)) return 29;
                else return 28;
        }
    }
    boolean run(int year)
    {
        return (year % 4 == 0) && ((year % 100 != 0) || (year % 400 == 0));
    }
}

class Question2
{
    public static void print()
    {
        var temp = 0;   // 格式控制
        for(int i = 1;i <= 9;++i)   // 三位数从 1 开始
        for(int j = 0;j <= 9;++j)
        for(int k = 0;k <= 9;++k)
        {
            if (i*i*i + j*j*j + k*k*k == i * 100 + j * 10 + k)
            {
                System.out.printf("%d%d%d  ", i, j, k);
                if (++temp % 2 == 0) System.out.println();
            }
        }
    }
}

class Question3
{
    public static void print(int layer) // 根据层数打印
    {
        for (int i = 1;i <= layer;++i)
        {
            System.out.print(" ".repeat((layer - i) * 2));  // 空格占位
            var max = i * 2 - 1;
            var stream = IntStream.rangeClosed(1, max).filter(x -> x % 2 != 0).boxed();
            var stream2 = IntStream.rangeClosed(1, max).map(x -> max - x - 1).filter(x -> x % 2 != 0 && x >= 1).boxed();
            Stream.concat(stream, stream2).forEach(x -> System.out.print(x + " "));
            System.out.println();
        }
    }
}

class Question4
{
    public static void print(int monkeynum,int step)    // 猴子数，步长
    {
        var list = IntStream.rangeClosed(1,monkeynum).boxed().collect(Collectors.toCollection(ArrayList::new));
        int index = -1;
        for (int i = 0;i < monkeynum - 1;++i)
        {
            for(int j = 0;j < step;++j)
            {
                ++index;
                if (index >= list.size()) { index -= list.size(); }
                if (list.get(index) == 0)
                    j--;
            }
            System.out.print(list.get(index) + " ");
            list.set(index,0);
        }
        System.out.println();
    }
}