`timescale 1ns / 1ps
/*
    ϵͳ��������״̬�󣬵�����ʱģ�飬
    ��ʱ8s�������ʱ�źţ�ʹϵͳ���س�ʼ״̬��
*/
module delay(
    clk,state,timeout
    );
    input clk;          //ϵͳʱ��
    input [1:0]state;   //ϵͳ״̬
    output reg timeout; //�Ƿ�ʱ
    wire clk_N;         //��Ƶ���ʱ��
    reg [2:0] count;    //��������
    //��ʱ��Ƶ�ʽ���1Hz
    divider #(  100000000 ) dilay( clk, clk_N );
initial begin           //�����ʼ��
    timeout <= 1'b0;
    count <= 3'b000;
end
always @( posedge clk_N ) begin
    case( state)
    //����״̬ʱ����ʼ��ʱ��8s�������ʱ�ź�
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
        //����״̬����ʱ
        default: begin
            timeout = 1'b0;
            count = 3'b000;
        end
    endcase
end
endmodule
