`timescale 1ns / 1ps
module top_test( );
    reg reset ;           //清零
    reg clk;              //系统时钟
    reg cancel;          //取消信号
    reg press;           //确认购买
    reg [2:0]coin;       //投币
    reg [1:0]ab;         //分别代表2.5和5元的商品
    wire run_ind ;        //运行指示灯
    wire hold_ind;        //占用指示灯
    wire drinktk_ind;     //取商品指示灯
    wire charge_ind;      //找零指示灯
    wire [7:0] seg;       //七段显示输出
    wire [7:0] an;        //片选信号
    wire overflow;        //投币或购买溢出信号
    controller test_cont(  press,  reset,  clk,ab,cancel, coin,
     run_ind, hold_ind, drinktk_ind, charge_ind,overflow, seg, an
    );
always #5 clk = ~ clk;
initial begin
    reset = 0;
    clk = 0;
    cancel = 0;
    press = 0;
    coin = 2'b00;
    ab = 2'b00;
    #15 reset = 1;
    //投币
    #120 coin = 3'b001;
    #15 coin = 3'b010;
    #15 coin = 3'b100;
    #15 coin = 3'b000;
    //选货
    ab = 2'b01;
    #15 ab = 2'b00;
    #15 ab = 2'b01;
    #15 ab = 2'b10;
    #15 ab = 2'b00;
    //购买
    #20 press = 1;
    #15 press = 0;
end
endmodule
