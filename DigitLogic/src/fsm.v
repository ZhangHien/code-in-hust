`timescale 1ns / 1ps
/*
    ����״̬��ģ�飬����reset����ֵ����ʱ���ź�
    ����״̬ת�����������ָʾ��ռ��ָʾ������ָʾ�����ָʾ
*/
module fsm(
         reset, clk, coin,
         cancel_flag,press, timeout, 
         hold_ind, drinktk_ind,
         charge_ind, run_ind,state
     );
    input reset;            //��λ�ź�
    input clk;              //ʱ��
    input press;            //ȷ�Ϲ���
    input timeout;          //��ʱ�ź�
    input cancel_flag;      //ȡ������
    input [2:0] coin;       //��ֵ�ź�
    output reg run_ind;     //����ָʾ��
    output reg hold_ind;    //ռ��ָʾ
    output reg drinktk_ind; //ȡ��Ʒָʾ
    output reg charge_ind;  //����ָʾ
    output reg [1:0] state; //״̬
    reg [1:0] statenext;    //״̬�м����
    parameter s1=1,s2=2,s3=3,soff= 0;
initial  state <= soff;
  // CombLogic
always @(posedge clk  )begin
     case(state)
            //��̬��Ͷ��ʱ���빺��״̬
            s1:begin
                if(coin>4'b0000)    statenext = s2;
                else    statenext = s1;
                    run_ind = 1;
                    hold_ind = 0;
                    drinktk_ind = 0;
                    charge_ind = 0;
           end
            //����״̬��ȷ�ϻ�ȡ��ʱ��������״̬
           s2:begin
                 if(press | cancel_flag )     statenext = s3;   
                 else    statenext = s2;
                 run_ind = 1;
                 hold_ind = 1;
                 drinktk_ind = 0;
                 charge_ind = 0;
           end
           //����״̬��5s�Ժ�ص���̬
           s3:begin
               if(timeout)    statenext = s1;
               else    statenext = s3;
               run_ind = 1;
               hold_ind = 1;
               drinktk_ind = 1;//cancel_flag ? 0 :1;
               charge_ind = 1;
           end
           //������״̬��resetʱ�����̬
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
   //ʱ�������ؽ���״̬ת��
always @(posedge clk) begin
     if(reset==0)     state = soff;
     else      state = statenext;
end
endmodule