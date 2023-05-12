import javax.swing.*;
import java.awt.*;
import java.util.ArrayList;
import java.util.Random;
import java.util.function.BiFunction;

@SuppressWarnings("unchecked")
class calculator<T extends Number> {
    private T num1, num2;
    private int op;
    private ArrayList<BiFunction<T, T, T>> operations = new ArrayList<>();
    private char[] operations_char = { '+', '-', '*', '/' };
    static Random random = new Random();

    public calculator() {
        operations.add((a, b) -> (T) Integer.valueOf(a.intValue() + b.intValue())); // 加法
        operations.add((a, b) -> (T) Integer.valueOf(a.intValue() - b.intValue())); // 减法
        operations.add((a, b) -> (T) Integer.valueOf(a.intValue() * b.intValue())); // 乘法
        operations.add((a, b) -> {
            if (b.equals(0))
                throw new ArithmeticException("除数不能为0");
            return (T) Integer.valueOf(a.intValue() / b.intValue());
        });
    }

    public void generate() {
        num1 = (T) Integer.valueOf(random.nextInt(1, 100));
        num2 = (T) Integer.valueOf(random.nextInt(1, 100));
        op = random.nextInt(0, 4);
    }

    public T getNum1() {
        return num1;
    }

    public T getNum2() {
        return num2;
    }

    public char getOp_char() {
        return operations_char[op];
    }

    public Integer calculate() {
        return operations.get(op).apply(num1, num2).intValue();
    }
}

public class calc_test extends JFrame {
    private transient calculator<Integer> calc = new calculator<>();
    private JPanel pannel1 = new JPanel();
    private JPanel pannel2 = new JPanel();
    JButton create_problem = new JButton("获取题目");
    JTextField num1 = new JTextField(6);
    JLabel op = new JLabel();
    JTextField num2 = new JTextField(6);
    JLabel equals = new JLabel("=");
    JTextField ans = new JTextField(6);
    JButton calculate = new JButton("计算");
    JLabel result = new JLabel("");

    public calc_test() {
        super("calculator");
        setSize(400, 200);
        setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);

        pannel1.setLayout(new FlowLayout());
        pannel1.add(create_problem);
        pannel1.add(num1);
        pannel1.add(op);
        pannel1.add(num2);
        pannel1.add(equals);
        add(pannel1, BorderLayout.NORTH);

        create_problem.addActionListener(e -> {
            calc.generate();
            num1.setText(String.valueOf(calc.getNum1()));
            op.setText(String.valueOf(calc.getOp_char()));
            num2.setText(String.valueOf(calc.getNum2()));
        });
        create_problem.doClick();

        pannel2.setLayout(new FlowLayout());
        pannel2.add(ans);
        pannel2.add(calculate);
        pannel2.add(result);
        add(pannel2, BorderLayout.CENTER);

        calculate.addActionListener(e -> {
            Integer ans_input;
            try {
                ans_input = Integer.parseInt(ans.getText());
            } catch (NumberFormatException e1) {
                result.setText("请输入数字");
                return;
            }
            try {
                System.out.println(calc.calculate() + " " + ans_input); // test
                if (calc.calculate().equals(ans_input)) {
                    result.setText("正确");
                } else
                    result.setText("错误");
            } catch (Exception e1) {
                result.setText(e1.getMessage());
            }
        });
    }

    public static void main(String[] args) {
        var temp = new calc_test();
        temp.setVisible(true);
    }
}