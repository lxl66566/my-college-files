import java.util.LinkedHashMap;
import java.util.Random;
import java.util.Scanner;

class puzzles {
    static private LinkedHashMap<String, String> map = new LinkedHashMap<>() {
        {
            put("一点一点变成了一片，一片一片变成了一团，一团一团变成了一堆，一堆一堆变成了一个，这是什么？", "雪花");
            put("不是鸟却有翅膀，不是人却有手指，不是鱼却能游泳，不是风却能飞翔，这是什么？", "风筝");
            put("有头无脚有眼无眉，有口无舌有牙无齿，有心无肺有肚无肠，这是什么？", "针");
            put("不用火就能烧，不用水就能灭，不用风就能飘，不用手就能摇，这是什么？", "香");
            put("东西南北都能走，却永远离不开自己的家，这是什么？", "门");
        }
    };
    static private Scanner sc = new Scanner(System.in, "gbk");
    static private Random r = new Random();

    public static void ask() {
        var q = get();
        System.out.println("谜面：" + q + " 请输入答案，输入 n 结束游戏：");
        var s = sc.next().trim();
        // System.out.println(s); // test
        if (s.equalsIgnoreCase("n"))
            return;
        if (s.equals(map.get(q))) {
            System.out.println("恭喜你答对了!");
        } else {
            System.out.println("很遗憾你答错了!");
        }
        System.out.println("谜面：" + q + "  谜底：" + map.get(q));
        ask();
    }

    private static String get() {
        return (String) map.keySet().toArray()[r.nextInt(map.size())];
    }
}

public class puzzle {
    public static void main(String[] args) {
        puzzles.ask();
    }
}
