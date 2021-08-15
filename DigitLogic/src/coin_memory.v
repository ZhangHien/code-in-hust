`timescale 1ns / 1ps
/*
    ��ÿһ�������Ͷ�Һ�ѡ���źţ������Ѷ�����
    ���мӼ����������µ����Ѷ�����������
*/
module coin_memory(
    reset, clk,
    ab, coin,state,
    cost, left, overflow
    );
    input reset;            //�����ź�
    input [1:0] state;      //״̬
    input [2:0] coin;       //�����ֵ�ź�
    input clk;              //ʱ���ź�
    input [1:0]ab;          //ѡ��Ʒ�ź�
    output reg [7:0] left;  //������
    output reg [7:0] cost;  //���Ѷ�
    output reg overflow;    //Ͷ�һ��߹�������ź�
    reg [1:0]abold;         //ѡ��Ʒ�źŵľ�ֵ
    reg [2:0] coin_old;     //��ֵ�źŵľ�ֵ
    reg [7:0] temp;         //һ�����ѵĽ��
    reg [4:0] coint;        //һ��Ͷ��Ľ��
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
    //������״̬�ͳ�̬ʱ���Ϊ0
   if( reset==0 || state==2'b01 ) begin
        cost = 8'b00000000;
        left = 8'b00000000;
   end
   else begin
        //ѡ��5Ԫ��Ʒ
        //��ѡ���źŵ���ֵ�;�ֵ��ͬʱ����
        if( ab[1]!= abold[1] ) begin
            temp = ab[1] ? 8'b00001010 : 0;
            //��Ʒ�۸���������ɹ������
            if( temp > left )    overflow <= 1'b1;
            else begin
            //���ѶҪ����99.5Ԫ��������ʾ�����
                if( cost + temp > 8'b11000111 )  overflow <= 1'b1;
            //�������Ѷ�����
                else begin
                    cost = cost + temp ;
                    overflow <= 1'b0;
                    left = left - temp;
                end
            end
        end
        else  cost = cost;
        //ѡ��2.5Ԫ��Ʒ����������5Ԫ��Ʒ
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
        //�����ֵ�����仯ʱ����
        if( coin != coin_old ) begin
            //coin��3λ�ֱ��Ӧ1Ԫ��5Ԫ��10Ԫ
            case(coin)
                3'b001: coint = 5'b00010;
                3'b010: coint = 5'b01010;
                3'b100: coint = 5'b10100;
                default:coint = 5'b00000;
            endcase
            //��Ҫ����99.5Ԫʱ�����
            if( left + coint > 8'b11000111 ) overflow <= 1'b1;
            else begin
                overflow <= 1'b0;
                left = left + coint;
            end
     end
     else left = left;
     //�ñ��������ֵ��ѡ���źŵľ�ֵ
     abold <= ab;
     coin_old <= coin;
  end
end
endmodule
