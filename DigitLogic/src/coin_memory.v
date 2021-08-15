`timescale 1ns / 1ps
/*
    对每一个输入的投币和选货信号，对消费额和余额
    进行加减，并把最新的消费额和余额进行输出
*/
module coin_memory(
    reset, clk,
    ab, coin,state,
    cost, left, overflow
    );
    input reset;            //清零信号
    input [1:0] state;      //状态
    input [2:0] coin;       //输入币值信号
    input clk;              //时钟信号
    input [1:0]ab;          //选商品信号
    output reg [7:0] left;  //余额输出
    output reg [7:0] cost;  //消费额
    output reg overflow;    //投币或者购买溢出信号
    reg [1:0]abold;         //选商品信号的旧值
    reg [2:0] coin_old;     //币值信号的旧值
    reg [7:0] temp;         //一次消费的金额
    reg [4:0] coint;        //一次投入的金额
initial begin
        left <= 8'b00000000;
        cost <= 8'b00000000;
        abold <= 2'b00;
        coin_old <= 3'b000;
        temp <= 8'b00000000;
        overflow <= 1'b0;
        coint <= 5'b00000;
end
always @(posedge clk) begin
    //不工作状态和初态时金额为0
   if( reset==0 || state==2'b01 ) begin
        cost = 8'b00000000;
        left = 8'b00000000;
   end
   else begin
        //选择5元商品
        //当选货信号的新值和旧值不同时触发
        if( ab[1]!= abold[1] ) begin
            temp = ab[1] ? 8'b00001010 : 0;
            //商品价格大于余额，不可购买，溢出
            if( temp > left )    overflow <= 1'b1;
            else begin
            //消费额将要超出99.5元，不可显示，溢出
                if( cost + temp > 8'b11000111 )  overflow <= 1'b1;
            //计算消费额和余额
                else begin
                    cost = cost + temp ;
                    overflow <= 1'b0;
                    left = left - temp;
                end
            end
        end
        else  cost = cost;
        //选择2.5元商品，情况可类比5元商品
        if( ab[0]!= abold[0] ) begin
            temp = ab[0] ? 8'b00000101 : 0;
            if( temp > left )    overflow <= 1'b1;
            else begin
                if( cost + temp > 8'b11000111 )  overflow <= 1'b1;
                else begin
                    cost = cost + temp ;
                    overflow <= 1'b0;
                    left = left - temp;
                end
            end
        end
        else  cost = cost;
        //输入币值发生变化时触发
        if( coin != coin_old ) begin
            //coin的3位分别对应1元、5元和10元
            case(coin)
                3'b001: coint = 5'b00010;
                3'b010: coint = 5'b01010;
                3'b100: coint = 5'b10100;
                default:coint = 5'b00000;
            endcase
            //余额将要大于99.5元时，溢出
            if( left + coint > 8'b11000111 ) overflow <= 1'b1;
            else begin
                overflow <= 1'b0;
                left = left + coint;
            end
     end
     else left = left;
     //用变量保存币值和选货信号的旧值
     abold <= ab;
     coin_old <= coin;
  end
end
endmodule
