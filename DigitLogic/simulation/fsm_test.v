`timescale 1ns / 1ps
module fsm_test( );
    reg reset;            //置位信号
    reg clk;              //时钟
    reg press;            //确认购买
    reg timeout;          //超时信号
    reg cancel_flag;      //取消购买
    reg [2:0] coin;       //币值信号
    wire  run_ind;       //运行指示灯
    wire  hold_ind;      //占用指示
    wire  drinktk_ind;  //取物品指示
    wire  charge_ind;   //找零指示
    wire  [1:0] state;   //状态
    fsm fsmtest(
     .reset(reset), .clk(clk),
     .coin(coin),
     .cancel_flag(cancel_flag), .press(press), .timeout(timeout),
     .hold_ind(hold_ind), .drinktk_ind(drinktk_ind),
     .charge_ind(charge_ind), .run_ind(run_ind), .state(state)  );
initial begin
    reset = 0;
    clk = 0;
    press = 0;
    timeout = 0;
    cancel_flag = 0;
    coin = 3'b000;
    #30 reset = 1;
    #30 coin = 3'b001;
    #15 coin = 3'b000;
    #50 press = 1;
    #30 press = 0;
    #50 timeout = 1;
    #30 timeout = 0;
    #50 coin = 3'b010;
    #15 coin = 3'b000;
    #30 cancel_flag = 1;
    #50 cancel_flag = 0;
    #100 reset = 0;
end
always #5 clk = ~clk;
endmodule
