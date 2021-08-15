`timescale 1ns / 1ps
module controller(
    press,
    reset, 
    clk,ab,
    cancel,
    coin,
    run_ind, hold_ind,
    drinktk_ind, charge_ind,overflow,
    seg, an
    );
    input reset ;           //清零
    input clk;              //系统时钟
    input cancel;          //取消信号
    input press;           //确认购买
    input [2:0]coin;       //投币
    input [1:0]ab;         //分别代表2.5和5元的商品
    output run_ind ;        //运行指示灯
    output hold_ind;        //占用指示灯
    output drinktk_ind;     //取商品指示灯
    output charge_ind;      //找零指示灯
    output [7:0] seg;       //七段显示输出
    output [7:0] an;        //片选信号
    output overflow;        //投币或购买溢出信号
    wire [7:0]left;         //剩余币值
    wire [7:0]cost;         //消费额
    wire [2:0] coin_o;      //币值
    wire [1:0] state;       //状态
    wire clk_N;             //显示模块用的时钟
    wire cancel_flag;       //取消信号
    wire reset_o;           //置位信号输出
    wire press_o;           //确认购买信号输出
    wire [1:0] about;       //选择商品信号输出
    wire timeout;           //超时信号
    //延时模块实例化
    delay mydelay( .clk(clk), .state(state) , .timeout(timeout) );
    //分频模块实例化
    divider  mydivider(.clk(clk), .clk_N(clk_N) );
    //输入缓冲实例化
    buffer mybuf (
    .reset(reset), .press(press), .clk(clk), .ab( ab),
    .cancel(cancel), .coin(coin),
    .coin_o(coin_o), .cancel_flag(cancel_flag),
    .reset_o(reset_o), .press_o(press_o), .about(about)
     );
     //总币值计算模块实例化
     coin_memory mycm( .reset(reset_o), .clk(clk) , .ab(about),  .coin(coin_o),
     .state(state), .cost(cost),.left(left), .overflow(overflow) );
     //显示模块实例化
     display mydis( .state(state),.cancel_flag(cancel_flag),
     .press(press), .cost(cost), .left(left), .clk_N(clk_N) ,  .seg(seg),  .an(an) );
     //有限状态机实例化
     fsm myfinite(
     .reset(reset_o), .clk(clk),
     .coin(coin_o),
     .cancel_flag(cancel_flag), .press(press_o), .timeout(timeout),
     .hold_ind(hold_ind), .drinktk_ind(drinktk_ind),
     .charge_ind(charge_ind), .run_ind(run_ind), .state(state)  );
endmodule