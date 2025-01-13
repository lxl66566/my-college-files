module machine(
  input wire clk,
  input wire half,  // 0.5 元输入
  input wire one,   // 1 元输入
  output reg drink, // 是否发放饮料
  output reg change // 是否发放找零
);

  reg [1:0] current_state, next_state;
  reg [3:0] total; // 记录总金额（0-15, 表示0元到3.5元，步长0.5元）

  // 状态转移逻辑
  always @(posedge clk) begin
    if (drink) drink = 0; // 发放一次饮料
    if (change) change = 0; // 发放一次找零
    case (current_state)
      2'b00: begin
        if (half) total = total + 1; // 投入0.5元
        if (one) total = total + 2;  // 投入1元
        if (total >= 5) next_state = 2'b01; // 金额达到或超过2.5元
        else next_state = 2'b00;
      end
      2'b01: begin
        drink = 1;
        change = (total > 5); // 如果金额超过5（2.5元），需要找零
        total = 0; // 重置总金额
        next_state = 2'b00; // 返回初始状态
      end
      default: next_state = 2'b00;
    endcase

    current_state <= next_state;
  end

  // 初始化
  initial begin
    current_state = 2'b00;
    next_state = 2'b00;
    drink = 0;
    change = 0;
    total = 0;
  end

endmodule
