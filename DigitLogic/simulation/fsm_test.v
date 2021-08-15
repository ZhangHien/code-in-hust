`timescale 1ns / 1ps
module fsm_test( );
    reg reset;            //��λ�ź�
    reg clk;              //ʱ��
    reg press;            //ȷ�Ϲ���
    reg timeout;          //��ʱ�ź�
    reg cancel_flag;      //ȡ������
    reg [2:0] coin;       //��ֵ�ź�
    wire  run_ind;       //����ָʾ��
    wire  hold_ind;      //ռ��ָʾ
    wire  drinktk_ind;  //ȡ��Ʒָʾ
    wire  charge_ind;   //����ָʾ
    wire  [1:0] state;   //״̬
    fsm fsmtest(
     .reset(reset), .clk(clk),
     .coin(coin),
     .cancel_flag(cancel_flag), .press(press), .timeout(timeout),
     .hold_ind(hold_ind), .drinktk_ind(drinktk_ind),
     .charge_ind(charge_ind), .run_ind(run_ind), .state(state)  );
initial begin
    reset = 0;
    clk = 0;
    press = 0;
    timeout = 0;
    cancel_flag = 0;
    coin = 3'b000;
    #30 reset = 1;
    #30 coin = 3'b001;
    #15 coin = 3'b000;
    #50 press = 1;
    #30 press = 0;
    #50 timeout = 1;
    #30 timeout = 0;
    #50 coin = 3'b010;
    #15 coin = 3'b000;
    #30 cancel_flag = 1;
    #50 cancel_flag = 0;
    #100 reset = 0;
end
always #5 clk = ~clk;
endmodule
