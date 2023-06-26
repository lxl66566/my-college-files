// ���� Verilog ���������һ����ʱ��ģ�飬���԰����趨���ӳ�ʱ�䣨delay�����һ���źţ�out_sig�����ڲ�ʹ����һ�� 32 λ���������ڼ���ʱ�����ڣ����������ۻ��� 1 ��ʱ�����ȥ 1 ���ʱ�䣬ֱ��ȫ���ӳ�ʱ��ľ�������ʱ����������źŻᱻ���㡣

module timer (
    input wire clk,         // ʱ���ź�
    input wire rst,         // ��λ�ź�
    input wire start,       // ��ʼ�ź�
    input wire [4:0] delay, // 5λ�ӳ٣���λ���룩
    output reg out_sig      // ����ź�
);

reg [31:0] counter;        // 32λ�����������ڼ���ʱ��������
reg [4:0] elapsed_seconds; // ��ʱ��ʼ���ѹ�ȥ������
reg enable_count;          // ��������

// ����1���Ӧ��ʱ��������������ʱ��Ƶ��Ϊ100MHz��
localparam CLK_CYCLES_PER_SECOND = 10;
// localparam CLK_CYCLES_PER_SECOND = 100_000_000;

always @(posedge clk) begin
    if (rst) begin
        counter <= 32'b0;         // ��λʱ���������
        out_sig <= 1'b0;          // ��λʱ�������ź�
        elapsed_seconds <= 5'b0;  // ��λʱ�����ѹ�ȥ������
        enable_count <= 1'b0;     // ��λʱ��ֹ����
    end
    else if (enable_count) begin
        counter <= counter + 32'b1; // ���Ӽ�����ֵ

        if (counter == CLK_CYCLES_PER_SECOND - 1) begin
            counter <= 32'b0;         // �������ﵽ1�룬����Ϊ0
            if (elapsed_seconds > 5'b0) begin
                elapsed_seconds <= elapsed_seconds - 5'b1; // �ѹ�ȥ�������ݼ�1��
            end else begin
                out_sig <= 1'b0;      // ��ʱ��ɣ��������ź�
                enable_count <= 1'b0; // ��ֹ����
            end
        end
    end
	//  else if (start) begin
	// 	  elapsed_seconds <= delay; // ����ʼ�ź�Ϊ�ߵ�ƽ����⵽������ʱ�����ӳ�ֵ�����ѹ�ȥ������
    //     enable_count <= 1'b1;     // ��������
    //     counter <= 32'b0;         // ���������
    //     out_sig <= 1'b1;          // ��������ź�
	//  end
end
always@(posedge start) begin
    if (!rst && !enable_count) begin
        elapsed_seconds <= delay; // ����ʼ�ź�Ϊ�ߵ�ƽ����⵽������ʱ�����ӳ�ֵ�����ѹ�ȥ������
        enable_count <= 1'b1;     // ��������
        counter <= 32'b0;         // ���������
        out_sig <= 1'b1;          // ��������ź�
    end
end
endmodule
