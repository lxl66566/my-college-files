/* 
 * @author lxl66566 （github.com/lxl66566）
 * 银行管理系统，实现 GUI，登录登出，查询金额，存取款，改密，添加/删除账户，查询银行信息功能，权限控制
 * 账户信息保存在本地执行目录下的 account.data 中，未加密
 * 初始账户为（{用户名,密码}）：{admin, admin}, {a, 1}, {b, 2}，其中 admin 账户为管理员账户
 */

import javax.naming.*;
import javax.swing.*;
import java.awt.*;
import java.io.*;
import java.nio.file.AccessDeniedException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

class account implements Serializable {

    private static final long serialVersionUID = 1L;
    private static int num = 0;
    private int id;
    private String name = "";
    private double money = 0;
    private String pwd = "";

    public account(String name) {
        this.id = ++num;
        this.name = name;
    }

    public account(String name, String pwd) {
        this(name);
        this.pwd = pwd;
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

    @Override
    public String toString() {
        return String.format("{id: %d, name: %s, money: %f, pwd: %s}", id, name, money, pwd);
    }
}

class Bank {
    private ArrayList<account> accounts;

    public Bank() {
        try (var fis = new FileInputStream("account.data");
                var ois = new ObjectInputStream(fis);) {
            accounts = (ArrayList<account>) ois.readObject();
        } catch (IOException ioe) {
            accounts = new ArrayList<>(
                    List.of(new account("admin", "admin"), new account("a", "1"), new account("b", "2")));
        } catch (Exception c) {
            System.out.println("unknown exception");
            c.printStackTrace();
        }
    }

    void add_account(String name, String pwd) throws AccessDeniedException {
        var temp = new account(name);
        accounts.add(temp);
        temp.changepwd("", pwd);
    }

    void delete_account(String name) throws NameNotFoundException, AccessDeniedException {
        var temp = get_account(name);
        if (temp.isEmpty())
            throw new NameNotFoundException("没有此用户");
        if (is_admin(temp.get()))
            throw new AccessDeniedException("不能删除管理员账户");
        accounts.remove(temp.get());
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

    void transfer_money(account me, String to, double money)
            throws NameNotFoundException, AccessDeniedException, LimitExceededException {
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

    public boolean is_admin(account me) {
        return me == accounts.get(0);
    }

    public void save_to_file() {
        try (FileOutputStream fos = new FileOutputStream("account.data");
                ObjectOutputStream oos = new ObjectOutputStream(fos);) {
            oos.writeObject(accounts);
        } catch (Exception e) {
            System.out.println("write to file failed");
        }
    }

    String info() {
        var temp = new StringBuilder();
        accounts.forEach(a -> {
            temp.append(a).append("\n");
        });
        return temp.toString();
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
    JButton checkmoney = new JButton("    查询    ");
    JButton savemoney = new JButton("    存款    ");
    JButton withdrawmoney = new JButton("    取款    ");
    JButton transfermoney = new JButton("    转账    ");
    JButton reset_password = new JButton("修改密码");
    JButton add_account = new JButton("添加账户");
    JButton delete_account = new JButton("删除账户");
    JButton manage_bank = new JButton("银行管理");

    JPanel resultPanel = new JPanel();
    JLabel result = new JLabel("请登录", SwingConstants.CENTER);
    JTextArea input = new JTextArea(10, 20);

    public bank_gui() {
        super("银行管理系统");
        setLayout(new BorderLayout());
        setSize(450, 300);
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
        operationPanel.add(reset_password);
        operationPanel.add(add_account);
        operationPanel.add(delete_account);
        operationPanel.add(manage_bank);
        add(operationPanel, BorderLayout.WEST);

        resultPanel.setLayout(new BorderLayout());
        resultPanel.add(result, BorderLayout.NORTH);
        resultPanel.add(input, BorderLayout.CENTER);
        result.setFont(new Font(Font.SERIF, Font.BOLD, 18));
        add(resultPanel, BorderLayout.CENTER);

        login.addActionListener(e -> {
            try {
                now_account = bank.login(account_name.getText(), pwd.getText());
            } catch (AccessDeniedException e1) {
                result.setText(e1.getMessage());
            }
            if (now_account.isEmpty()) {
                result.setText("用户名或密码错误");
                return;
            }
            if (bank.is_admin(now_account.get())) {
                add_account.setEnabled(true);
                delete_account.setEnabled(true);
                manage_bank.setEnabled(true);
            } else {
                add_account.setEnabled(false);
                delete_account.setEnabled(false);
                manage_bank.setEnabled(false);
            }
            logoutinfo.setText("welcome, " + now_account.get().getname());
            result.setText("登录成功，请选择操作");
            account_name.setText("");
            pwd.setText("");
            input.setText("");
            northPanel.remove(loginPanel);
            northPanel.add(logoutpanel);
            northPanel.revalidate();
            northPanel.repaint();
        });

        logout.addActionListener(e -> {
            result.setText("");
            input.setText("");
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
            input.setText("");
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
            input.setText("");
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
                result.setText("请输入正确的格式：“对象名 金额”");
                return;
            }
            try {
                bank.transfer_money(now_account.get(), give_to, m);
                result.setText("转账成功，当前余额: " + now_account.get().getmoey());
            } catch (Exception e1) {
                result.setText(e1.getMessage());
            }
            input.setText("");
        });

        reset_password.addActionListener(e -> {
            if (now_account.isEmpty())
                return;
            try {
                var temp = input.getText().trim().split("\\s+", 2);
                now_account.get().changepwd(temp[0], temp[1]);
                bank.save_to_file();
                result.setText("密码重置成功");
            } catch (ArrayIndexOutOfBoundsException e1) {
                result.setText("请输入正确的格式：“旧密码 新密码”");
            } catch (Exception e1) {
                result.setText(e1.getMessage());
            }
            input.setText("");
        });

        add_account.addActionListener(e -> {
            if (now_account.isEmpty())
                return;
            if (!bank.is_admin(now_account.get()))
                result.setText("无权限");
            try {
                var temp = input.getText().trim().split("\\s+", 2);
                if (!bank.get_account(temp[0]).isEmpty())
                    throw new AccessDeniedException("账户已存在");
                bank.add_account(temp[0], temp[1]);
                bank.save_to_file();
                result.setText("添加账户成功");
            } catch (ArrayIndexOutOfBoundsException e1) {
                result.setText("请输入正确的格式：“新账户名 密码”");
            } catch (Exception e1) {
                result.setText(e1.getMessage());
            }
            input.setText("");
        });

        delete_account.addActionListener(e -> {
            if (now_account.isEmpty())
                return;
            if (!bank.is_admin(now_account.get()))
                result.setText("无权限");
            try {
                bank.delete_account(input.getText());
                bank.save_to_file();
                result.setText("删除账户成功");
            } catch (ArrayIndexOutOfBoundsException e1) {
                result.setText("请输入正确的格式：“账户名”");
            } catch (Exception e1) {
                result.setText(e1.getMessage());
            }
            input.setText("");
        });

        manage_bank.addActionListener(e -> {
            if (now_account.isEmpty())
                return;
            if (!bank.is_admin(now_account.get()))
                result.setText("无权限");
            result.setText("银行信息");
            input.setText(bank.info());
        });
    }

    public static void main(String[] args) {
        var temp = new bank_gui();
        temp.setVisible(true);
    }
}
