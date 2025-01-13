module machine_tb;
  reg clk;
  reg half;
  reg one;
  wire drink;
  wire change;

  machine vm(
    .clk(clk),
    .half(half),
    .one(one),
    .drink(drink),
    .change(change)
  );

  initial begin
    // 初始化
    clk = 0;
    half = 0;
    one = 0;

    // 生成时钟信号
    forever #5 clk = ~clk;
  end

  initial begin
    // 仿真输入序列
    #10 half = 1; #10 half = 0; // 投入 0.5 元
    #10 one = 1; #10 one = 0;   // 投入 1 元
    #10 one = 1; #10 one = 0;   // 再投入 1 元（共2.5元，发放饮料）
    
    #20; // 等待一段时间
    
    #10 one = 1; #10 one = 0; // 投入 1 元
    #10 one = 1; #10 one = 0; // 投入 1 元
    #10 one = 1; #10 one = 0; // 投入 1 元（共 3 元，发放饮料，找零）

    #50 $finish; // 结束仿真
  end

  initial begin
    // 监视输出
    $monitor("At time %t: drink = %b, change = %b", $time, drink, change);
    // 启动 VCD 转储
    $dumpfile("test.vcd"); // 指定 VCD 文件名
    $dumpvars(0, machine_tb); // 转储所有变量
  end

endmodule
