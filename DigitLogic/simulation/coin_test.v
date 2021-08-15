`timescale 1ns / 1ps
module coin_test( );
    reg reset;            //�����ź�
    reg [1:0] state;      //״̬
    reg [2:0] coin;       //�����ֵ�ź�
    reg clk;              //ʱ���ź�
    reg [1:0]ab;          //ѡ��Ʒ�ź�
    wire  [7:0] left;  //������
    wire  [7:0] cost;  //���Ѷ�
    wire  overflow;    //Ͷ�һ��߹�������ź�
coin_memory cointest(
    reset, clk,
    ab, coin,state,
    cost, left, overflow
    );
initial begin
    clk = 0;
    state = 2'b00;
    reset = 0;
    coin = 3'b000;
    ab = 2'b00;
    #45 reset = 1;
    #50 coin = 3'b001;
    #30 coin = 3'b100;
    #20 coin = 3'b000;
    #50 ab= 2'b10;
    #35 ab = 2'b01;
    #50 ab = 2'b00;
    #20 ab = 2'b10;
    #20 ab = 2'b00;
    #20 ab = 2'b10;
    #20 ab = 2'b00;
    #30 reset = 0;
end
always #5 clk = ~clk;
endmodule
