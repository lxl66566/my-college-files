import javax.swing.*;
import javax.swing.text.Position;

import java.awt.*;
import java.util.ArrayList;

class PasswordWrongException extends Exception {
    PasswordWrongException(String message) {
        super(message);
    }
}

class account {
    private int id;
    private String name;
    private double money = 0;
    private String pwd;

    public account(int id, String name) {
        this.id = id;
        this.name = name;
    }

    public double add_money(double m) {
        money += m;
        return money;
    }

    public void changepwd(String old_pwd, String new_pwd) throws PasswordWrongException {
        if (!pwd.equals(old_pwd) && !pwd.isEmpty())
            throw new PasswordWrongException("旧密码错误");
        pwd = new_pwd;
    }

    public boolean checkpwd(String pwd) {
        return this.pwd.equals(pwd);
    }
}

class bank {
    private static int num = 0;
    private ArrayList<account> accounts = new ArrayList<>();

    public void add_account(String name) {
        accounts.add(new account(++num, name));
    }

}

public class bank_gui extends JFrame {
    JPanel loginPanel = new JPanel();
    JPanel operationPanel = new JPanel();
    JPanel resultPanel = new JPanel();
    JTextField account_name = new JTextField(10);
    JPasswordField pwd = new JPasswordField(10);

    public bank_gui() {
        super("银行管理系统");
        setLayout(new BorderLayout());
        setSize(500, 500);
        setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);

        loginPanel.setLayout(new FlowLayout());
        loginPanel.add(new JLabel("用户名:"));
        loginPanel.add(account_name);
        loginPanel.add(new JLabel("密码:"));
        loginPanel.add(pwd);
        add(loginPanel, BorderLayout.NORTH);
    }

    public static void main(String[] args) {
        var temp = new bank_gui();
        temp.setVisible(true);
    }
}
