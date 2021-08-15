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
    input reset ;           //����
    input clk;              //ϵͳʱ��
    input cancel;          //ȡ���ź�
    input press;           //ȷ�Ϲ���
    input [2:0]coin;       //Ͷ��
    input [1:0]ab;         //�ֱ����2.5��5Ԫ����Ʒ
    output run_ind ;        //����ָʾ��
    output hold_ind;        //ռ��ָʾ��
    output drinktk_ind;     //ȡ��Ʒָʾ��
    output charge_ind;      //����ָʾ��
    output [7:0] seg;       //�߶���ʾ���
    output [7:0] an;        //Ƭѡ�ź�
    output overflow;        //Ͷ�һ�������ź�
    wire [7:0]left;         //ʣ���ֵ
    wire [7:0]cost;         //���Ѷ�
    wire [2:0] coin_o;      //��ֵ
    wire [1:0] state;       //״̬
    wire clk_N;             //��ʾģ���õ�ʱ��
    wire cancel_flag;       //ȡ���ź�
    wire reset_o;           //��λ�ź����
    wire press_o;           //ȷ�Ϲ����ź����
    wire [1:0] about;       //ѡ����Ʒ�ź����
    wire timeout;           //��ʱ�ź�
    //��ʱģ��ʵ����
    delay mydelay( .clk(clk), .state(state) , .timeout(timeout) );
    //��Ƶģ��ʵ����
    divider  mydivider(.clk(clk), .clk_N(clk_N) );
    //���뻺��ʵ����
    buffer mybuf (
    .reset(reset), .press(press), .clk(clk), .ab( ab),
    .cancel(cancel), .coin(coin),
    .coin_o(coin_o), .cancel_flag(cancel_flag),
    .reset_o(reset_o), .press_o(press_o), .about(about)
     );
     //�ܱ�ֵ����ģ��ʵ����
     coin_memory mycm( .reset(reset_o), .clk(clk) , .ab(about),  .coin(coin_o),
     .state(state), .cost(cost),.left(left), .overflow(overflow) );
     //��ʾģ��ʵ����
     display mydis( .state(state),.cancel_flag(cancel_flag),
     .press(press), .cost(cost), .left(left), .clk_N(clk_N) ,  .seg(seg),  .an(an) );
     //����״̬��ʵ����
     fsm myfinite(
     .reset(reset_o), .clk(clk),
     .coin(coin_o),
     .cancel_flag(cancel_flag), .press(press_o), .timeout(timeout),
     .hold_ind(hold_ind), .drinktk_ind(drinktk_ind),
     .charge_ind(charge_ind), .run_ind(run_ind), .state(state)  );
endmodule