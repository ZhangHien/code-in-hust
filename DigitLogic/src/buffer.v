`timescale 1ns / 1ps
/*
    ���������źſ��ܲ�ͬ����ϵͳ���첽�źŽ��д������׳���
    ����ʹ�����뻺��ģ����������ͬ�������������ı������ֵ
*/
module buffer(    
     reset, press,clk,ab,
    cancel, coin,
    coin_o,
     cancel_flag,
    reset_o, press_o,about
    );
   input reset;                         //��λ�ź�
   input cancel;                        //ȡ���ź�
   input clk;                           //ʱ��
   input press;                         //ȷ�Ϲ����
   input [2:0] coin;                    //Ͷ���ź�
   input [1:0]ab;                       //ѡ����Ʒ���ź�
   output reg [1:0]about;               //ѡ����Ʒ����ź�
   output reg [2:0] coin_o;             //��ֵ����ź�
   output reg reset_o;                  //��λ�ź����
   output reg cancel_flag;              //ȡ���ź����
   output reg press_o;                  //ȷ�Ϲ����ź����
always @(posedge clk) begin
    //���б���������������ʱ�������ؽ������
    //��ģ����𵽶��������ͬ��������
        about <= ab;
        reset_o <= reset;
        cancel_flag <= cancel ;
        press_o <= press;
        coin_o <= coin;
end 
endmodule