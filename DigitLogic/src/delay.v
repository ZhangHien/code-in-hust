`timescale 1ns / 1ps
/*
    系统进入找零状态后，调用延时模块，
    计时8s后，输出超时信号，使系统返回初始状态。
*/
module delay(
    clk,state,timeout
    );
    input clk;          //系统时钟
    input [1:0]state;   //系统状态
    output reg timeout; //是否超时
    wire clk_N;         //分频后的时钟
    reg [2:0] count;    //计数变量
    //把时钟频率降到1Hz
    divider #(  100000000 ) dilay( clk, clk_N );
initial begin           //输出初始化
    timeout <= 1'b0;
    count <= 3'b000;
end
always @( posedge clk_N ) begin
    case( state)
    //找零状态时，开始计时，8s后输出超时信号
        2'b11:begin
            if( count == 3'b111 ) begin
                count = 3'b000;
                timeout = 1'b1;
            end
            else begin
                count = count + 1'b1;
                timeout = 1'b0;
            end
        end
        //其他状态不计时
        default: begin
            timeout = 1'b0;
            count = 3'b000;
        end
    endcase
end
endmodule
