`timescale 1ns / 1ps
module display_testbench(  );
    reg clk;            // 时钟
    reg press;            //确认信号
    reg cancel_flag;      //取消信号
    reg [1:0] state;      //状态机状态
    reg [7:0] cost;       //消费额
    reg [7:0] left;       //余额
    wire [7:0] seg;   // 分别对应CA、CB、CC、CD、CE、CF、CG和DP
    wire [7:0] an;   // 8位数码管片选信号
    display mydisplay(
     .state(state), .cancel_flag(cancel_flag),
         .press(press), .cost(cost), .left(left),
          .clk_N(clk) ,  .seg(seg),  .an(an) );
always begin
    #5 clk <= ~clk;
end

initial begin

    clk = 1'b0;
    press = 1'b0;
    state = 2'b00;
    cost = 8'b00000000;
    left = 8'b00000000;
    cancel_flag = 1'b0;
    
    #50 state <= 2'b01;
    #100 state <=2'b10;
    #30 cost <= 8'b00000011;
    #50 left <= 8'b10000100;
    #20 press <= 1'b1;
    #5 state <= 2'b11;
    #20 press <= 1'b0;
    #100 cancel_flag <= 1'b1;
    #20 cancel_flag <= 1'b0;
    #100 state <= 2'b01;
end


endmodule
