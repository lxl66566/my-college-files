import javax.naming.*;
import javax.swing.*;
import java.awt.*;
import java.nio.file.AccessDeniedException;
import java.util.ArrayList;
import java.util.Optional;

class account {
    private static int num = 0;
    private int id;
    private String name = "";
    private double money = 0;
    private String pwd = "";

    public account(String name) {
        this.id = ++num;
        this.name = name;
    }

    public double add_money(double m) throws LimitExceededException {
        if (money + m < 0)
            throw new LimitExceededException("余额不足");
        money += m;
        return money;
    }

    public void changepwd(String old_pwd, String new_pwd) throws AccessDeniedException {
        if (!pwd.equals(old_pwd) && !pwd.isEmpty())
            throw new AccessDeniedException("旧密码错误");
        pwd = new_pwd;
    }

    public boolean checkpwd(String pwd) {
        return this.pwd.equals(pwd);
    }

    public String getname() {
        return name;
    }

    public double getmoey() {
        return money;
    }
}

class Bank {
    private ArrayList<account> accounts = new ArrayList<>();

    public void add_account(String name, String pwd) throws AccessDeniedException {
        var temp = new account(name);
        accounts.add(temp);
        temp.changepwd("", pwd);
    }

    public Optional<account> login(String name, String pwd) throws AccessDeniedException {
        var temp = get_account(name);
        if (temp.isEmpty())
            return Optional.empty();
        if (temp.get().checkpwd(pwd)) {
            return temp;
        } else
            throw new AccessDeniedException("密码错误");
    }

    void add_money(account me, double money) throws LimitExceededException {
        if (money < 0)
            throw new LimitExceededException("金额不可为负数");
        me.add_money(money);
    }

    void withdraw_money(account me, double money) throws LimitExceededException {
        if (money < 0)
            throw new LimitExceededException("金额不可为负数");
        me.add_money(-1 * money);
    }

    void transfer_money(account me, String to, double money) throws Exception {
        var to_opt = get_account(to);
        if (to_opt.isEmpty())
            throw new NameNotFoundException("没有此用户");
        if (to_opt.get() == me)
            throw new AccessDeniedException("不能转账给自己");
        var to_account = to_opt.get();
        withdraw_money(me, money);
        add_money(to_account, money);
    }

    Optional<account> get_account(String name) {
        for (var i = 0; i < accounts.size(); i++) {
            if (accounts.get(i).getname().equals(name))
                return Optional.of(accounts.get(i));
        }
        return Optional.empty();
    }
}

public class bank_gui extends JFrame {
    final static String MONEY_MESSAGE = "请输入正确的金额";
    transient Bank bank = new Bank();
    transient Optional<account> now_account = Optional.empty();

    JPanel northPanel = new JPanel();
    JPanel loginPanel = new JPanel();
    JTextField account_name = new JTextField(8);
    JPasswordField pwd = new JPasswordField(8);
    JButton login = new JButton("登录");

    JPanel logoutpanel = new JPanel();
    JLabel logoutinfo = new JLabel("登录成功");
    JButton logout = new JButton("退出");

    JPanel operationPanel = new JPanel();
    JButton checkmoney = new JButton("查询");
    JButton savemoney = new JButton("存款");
    JButton withdrawmoney = new JButton("取款");
    JButton transfermoney = new JButton("转账");

    JPanel resultPanel = new JPanel();
    JLabel result = new JLabel("请登录");
    JTextArea input = new JTextArea(10, 20);

    public bank_gui() {
        super("银行管理系统");
        setLayout(new BorderLayout());
        setSize(400, 200);
        setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
        add(northPanel, BorderLayout.NORTH);

        loginPanel.setLayout(new FlowLayout());
        loginPanel.add(new JLabel("用户名:"));
        loginPanel.add(account_name);
        loginPanel.add(new JLabel("密码:"));
        loginPanel.add(pwd);
        loginPanel.add(login);
        northPanel.add(loginPanel, BorderLayout.NORTH);

        logoutpanel.setLayout(new FlowLayout());
        logoutpanel.add(logoutinfo);
        logoutpanel.add(logout);

        operationPanel.setLayout(new BoxLayout(operationPanel, BoxLayout.Y_AXIS));
        operationPanel.add(checkmoney);
        operationPanel.add(savemoney);
        operationPanel.add(withdrawmoney);
        operationPanel.add(transfermoney);
        add(operationPanel, BorderLayout.WEST);

        resultPanel.setLayout(new BorderLayout());
        resultPanel.add(result, BorderLayout.NORTH);
        resultPanel.add(input, BorderLayout.CENTER);
        add(resultPanel, BorderLayout.CENTER);

        login.addActionListener(e -> {
            try {
                now_account = bank.login(account_name.getText(), pwd.getText());
            } catch (AccessDeniedException e1) {
                result.setText(e1.getMessage());
            }
            if (now_account.isPresent()) {
                logoutinfo.setText("welcome, " + now_account.get().getname());
                result.setText("登录成功，请选择操作");
                account_name.setText("");
                pwd.setText("");
                northPanel.remove(loginPanel);
                northPanel.add(logoutpanel);
                northPanel.revalidate();
                northPanel.repaint();
            } else {
                result.setText("用户名或密码错误");
            }
        });

        logout.addActionListener(e -> {
            result.setText("");
            now_account = Optional.empty();
            northPanel.remove(logoutpanel);
            northPanel.add(loginPanel);
            northPanel.revalidate();
            northPanel.repaint();
            result.setText("退出成功");
        });

        checkmoney.addActionListener(e -> {
            if (now_account.isEmpty())
                return;
            result.setText("余额为:" + now_account.get().getmoey());
        });

        savemoney.addActionListener(e -> {
            if (now_account.isEmpty())
                return;
            double m = 0;
            try {
                m = Double.parseDouble(input.getText());
            } catch (NumberFormatException e1) {
                result.setText(MONEY_MESSAGE);
                return;
            }
            try {
                bank.add_money(now_account.get(), m);
                result.setText("存款成功，当前余额: " + now_account.get().getmoey());
            } catch (Exception e1) {
                result.setText(e1.getMessage());
            }
        });

        withdrawmoney.addActionListener(e -> {
            if (now_account.isEmpty())
                return;
            double m = 0;
            try {
                m = Double.parseDouble(input.getText());
            } catch (NumberFormatException e1) {
                result.setText(MONEY_MESSAGE);
                return;
            }
            try {
                bank.withdraw_money(now_account.get(), m);
                result.setText("取款成功，当前余额: " + now_account.get().getmoey());
            } catch (Exception e1) {
                result.setText(e1.getMessage());
            }
        });

        transfermoney.addActionListener(e -> {
            if (now_account.isEmpty())
                return;
            double m = 0;
            String give_to = "";
            try {
                var temp = input.getText().trim().split("\\s+", 2);
                give_to = temp[0];
                m = Double.parseDouble(temp[1]);
                if (m < 0)
                    throw new NumberFormatException();
            } catch (NumberFormatException e1) {
                result.setText(MONEY_MESSAGE);
                return;
            } catch (Exception e1) {
                result.setText("请输入正确的格式：“名称 金额”");
                return;
            }
            try {
                bank.transfer_money(now_account.get(), give_to, m);
                result.setText("转账成功，当前余额: " + now_account.get().getmoey());
            } catch (Exception e1) {
                result.setText(e1.getMessage());
            }
        });

        try {
            bank.add_account("a", "123456");
            bank.add_account("b", "123456");
        } catch (AccessDeniedException e) {
            JOptionPane.showMessageDialog(this, "添加账户失败");
        }
    }

    public static void main(String[] args) {
        var temp = new bank_gui();
        temp.setVisible(true);
    }
}
