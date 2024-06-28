import java.util.ArrayList;
import java.util.Scanner;
public class AreaAndLength {
    static Triangle t = new Triangle();
    static Circle circle = new Circle();
    static Scanner input = new Scanner(System.in);
    public static void main(String[] args) {
        Scanner input = new Scanner(System.in);
        int id = -1;
        while(id != 0)
            {
            System.out.println("输入数据，0: exit, 1: Triangle, 2: Circle");
            id = input.nextInt();
            if (id == 1)
            {
                t.input(input);
                t.print();
            }
            else if (id == 2)
            {
                circle.input(input);
                circle.print();
            }
        }
    }
}
class Triangle
{
    int a,b,c;
    public Triangle(){}
    public Triangle(int a1,int b1,int c1)
    {
        a = a1;b = b1;c = c1;
    }
    public Triangle(ArrayList<Integer> list)
    {
        a = list.get(0);
        b = list.get(1);
        c = list.get(2);
    }
    public boolean isTriangle()
    {
        if(a+b>c && a+c>b && b+c>a)
            return true;
        else
            return false;
    }
    public int getTriangleLength()
    {
        return a + b + c;
    }
    public double getTriangleArea()
    {
        double s = (a+b+c)/2.0;
        return Math.sqrt(s*(s-a)*(s-b)*(s-c));
    }
    public void input(Scanner input)
    {
        ArrayList<Integer> list = new ArrayList<Integer>();
        System.out.print("请输入第一个边长:");
        list.add(input.nextInt());
        System.out.print("请输入第二个边长:");
        list.add(input.nextInt());
        System.out.print("请输入第三个边长:");
        list.add(input.nextInt());
        a = list.get(0);b = list.get(1);c = list.get(2);
    }
    public void print()
    {
        if(!isTriangle()){
            System.out.println("不能构成三角形！");
            return;
        }
        System.out.println("三角形的长度为:"+getTriangleLength());
        System.out.println("三角形的面积为:"+getTriangleArea());
    }
}

class Circle {
    double radius;
    static final double PI = 3.14;
    public Circle() {}
    public Circle(double r) {
        radius = r;
    }
    double area() {
        return PI * radius * radius;
    }
    double circumference(){
        return 2*PI*radius;
    }
    public void print() {
        System.out.println("圆的半径为:"+radius);
        System.out.println("圆的面积为:"+area());
        System.out.println("圆的周长为:"+circumference());
    }
    public void input(Scanner input) {
        System.out.print("请输入圆的半径:");
        radius = input.nextDouble();
    }
}
