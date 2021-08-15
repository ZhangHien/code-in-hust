`timescale 1ns / 1ps
module top_test( );
    reg reset ;           //����
    reg clk;              //ϵͳʱ��
    reg cancel;          //ȡ���ź�
    reg press;           //ȷ�Ϲ���
    reg [2:0]coin;       //Ͷ��
    reg [1:0]ab;         //�ֱ����2.5��5Ԫ����Ʒ
    wire run_ind ;        //����ָʾ��
    wire hold_ind;        //ռ��ָʾ��
    wire drinktk_ind;     //ȡ��Ʒָʾ��
    wire charge_ind;      //����ָʾ��
    wire [7:0] seg;       //�߶���ʾ���
    wire [7:0] an;        //Ƭѡ�ź�
    wire overflow;        //Ͷ�һ�������ź�
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
    //Ͷ��
    #120 coin = 3'b001;
    #15 coin = 3'b010;
    #15 coin = 3'b100;
    #15 coin = 3'b000;
    //ѡ��
    ab = 2'b01;
    #15 ab = 2'b00;
    #15 ab = 2'b01;
    #15 ab = 2'b10;
    #15 ab = 2'b00;
    //����
    #20 press = 1;
    #15 press = 0;
end
endmodule
