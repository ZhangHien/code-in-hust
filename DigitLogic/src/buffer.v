`timescale 1ns / 1ps
/*
    由于输入信号可能不同步，系统对异步信号进行处理容易出错，
    所以使用输入缓冲模块对输入进行同步化处理，但不改变输入的值
*/
module buffer(    
     reset, press,clk,ab,
    cancel, coin,
    coin_o,
     cancel_flag,
    reset_o, press_o,about
    );
   input reset;                         //置位信号
   input cancel;                        //取消信号
   input clk;                           //时钟
   input press;                         //确认购买键
   input [2:0] coin;                    //投币信号
   input [1:0]ab;                       //选择商品的信号
   output reg [1:0]about;               //选择商品输出信号
   output reg [2:0] coin_o;             //币值输出信号
   output reg reset_o;                  //置位信号输出
   output reg cancel_flag;              //取消信号输出
   output reg press_o;                  //确认购买信号输出
always @(posedge clk) begin
    //所有变量都不作处理，在时钟上升沿进行输出
    //此模块仅起到对输入进行同步的作用
        about <= ab;
        reset_o <= reset;
        cancel_flag <= cancel ;
        press_o <= press;
        coin_o <= coin;
end 
endmodule