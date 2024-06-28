interface istudent {

    public void setfee(int fee);

    public int getfee();
}

interface iteacher {

    public void setpay(int pay);

    public int getpay();
}

class graduate implements istudent, iteacher {
    private String name;
    private String sex;
    private int age;
    private int fee;
    private int pay;

    public graduate(String name, String sex, int age, int fee, int pay) {
        this.name = name;
        this.sex = sex;
        this.age = age;
        setfee(fee);
        setpay(pay);
    }

    public boolean need_to_loan() {
        return getpay() * 12 - getfee() < 2000;
    }

    public String info() {
        return String.format("name: %s, fee: %d, pay: %d%n", name, getfee(), getpay())
                + (need_to_loan() ? "need to loan" : "no need to loan");
    }

    @Override
    public void setfee(int fee) {
        this.fee = fee;
    }

    @Override
    public void setpay(int pay) {
        this.pay = pay;
    }

    @Override
    public int getfee() {
        return fee;
    }

    @Override
    public int getpay() {
        return pay;
    }
}

public class Lesson {
    public static void main(String[] args) {
        var zhangsan = new graduate("zhangsan", "m", 30, 5000, 400);
        System.out.println(zhangsan.info());
    }
}