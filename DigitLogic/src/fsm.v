`timescale 1ns / 1ps
/*
    有限状态机模块，根据reset、币值、超时等信号
    进行状态转换，输出运行指示、占用指示、找零指示和溢出指示
*/
module fsm(
         reset, clk, coin,
         cancel_flag,press, timeout, 
         hold_ind, drinktk_ind,
         charge_ind, run_ind,state
     );
    input reset;            //置位信号
    input clk;              //时钟
    input press;            //确认购买
    input timeout;          //超时信号
    input cancel_flag;      //取消购买
    input [2:0] coin;       //币值信号
    output reg run_ind;     //运行指示灯
    output reg hold_ind;    //占用指示
    output reg drinktk_ind; //取物品指示
    output reg charge_ind;  //找零指示
    output reg [1:0] state; //状态
    reg [1:0] statenext;    //状态中间变量
    parameter s1=1,s2=2,s3=3,soff= 0;
initial  state <= soff;
  // CombLogic
always @(posedge clk  )begin
     case(state)
            //初态，投币时进入购买状态
            s1:begin
                if(coin>4'b0000)    statenext = s2;
                else    statenext = s1;
                    run_ind = 1;
                    hold_ind = 0;
                    drinktk_ind = 0;
                    charge_ind = 0;
           end
            //购买状态，确认或取消时进入找零状态
           s2:begin
                 if(press | cancel_flag )     statenext = s3;   
                 else    statenext = s2;
                 run_ind = 1;
                 hold_ind = 1;
                 drinktk_ind = 0;
                 charge_ind = 0;
           end
           //找零状态，5s以后回到初态
           s3:begin
               if(timeout)    statenext = s1;
               else    statenext = s3;
               run_ind = 1;
               hold_ind = 1;
               drinktk_ind = 1;//cancel_flag ? 0 :1;
               charge_ind = 1;
           end
           //不工作状态，reset时进入初态
           soff:begin
               if( reset)    statenext = s1;
               else        statenext = soff;
               run_ind = 0;
               hold_ind = 0;
               drinktk_ind = 0;
               charge_ind = 0;
           end
   endcase   
end
   // StateReg 
   //时钟上升沿进行状态转换
always @(posedge clk) begin
     if(reset==0)     state = soff;
     else      state = statenext;
end
endmodule