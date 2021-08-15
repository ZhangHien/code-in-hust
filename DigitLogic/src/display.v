`timescale 1ns / 1ps
/*
    ��ʾģ�飬����״̬��������״̬���ֱ���ʾhello��
    ���Ѷ������ʾ
*/
module display(
    state, cancel_flag, press,
    cost,  left,
    clk_N,  seg, an
    );
    input clk_N;            // ʱ��
    input press;            //ȷ���ź�
    input cancel_flag;      //ȡ���ź�
    input [1:0] state;      //״̬��״̬
    input [7:0] cost;       //���Ѷ�
    input [7:0] left;       //���
    output reg[7:0] seg;   // �ֱ��ӦCA��CB��CC��CD��CE��CF��CG��DP
    output reg [7:0] an;   // 8λ�����Ƭѡ�ź�
    reg [3:0]code;         //����ʾ���ֶ�������
    reg [2:0]num;          //���������
    reg [2:0]num_t;         //����������ľ�ֵ
    reg [8:0] total;        //�ܽ��
initial begin
    total <= 9'b000000000;
     an <= 8'b10111111;
     num <= 3'b110;
     seg <= 8'b11111111;
     code <= 4'b1111;
     num_t <= 3'b000;
end
always @( posedge clk_N)begin
    num_t = num;
    if(num[2:0] == 3'b111)  num[2:0] = 3'b000;// ��ʱ��
    else      num[2:0] = num[2:0] + 1;
    case(state)    
            //��̬��ʾ��HELLO��
            2'b01:begin
                total = 9'b000000000;
                case(num)
		            3'b000: code[3:0] = 4'b0000;
                    3'b001: code[3:0] = 4'b1100;
                    3'b010: code[3:0] = 4'b1100;
                    3'b011: code[3:0] = 4'b1011;
                    3'b100: code[3:0] = 4'b1010;
                    default:code[3:0] = 4'b1111;
                endcase
            end
            //����״̬����ʾ���Ѷ�����
            2'b10:begin
                total = 9'b000000000;
                case(num)
                    3'b000:    code[3:0] = (left[0]) ? 4'b0101 : 4'b0000;
                    3'b001:    code[3:0] = left[7:1] % 4'b1010;
                    3'b010:    code[3:0] = (left[7:1] / 4'b1010)?(left[7:1] / 4'b1010):4'b1111;
                    3'b100:    code[3:0] = cost[0] ? 4'b0101 : 4'b0000;
                    3'b101:    code[3:0] = cost[7:1] % 4'b1010;
                    3'b110:    code[3:0] = (cost[7:1] / 4'b1010)?(cost[7:1] / 4'b1010):4'b1111;
                    default:   code[3:0] = 4'b1111;
                endcase
            end
            //����״̬����ʾ������
            2'b11:begin
                if( cancel_flag)  total[8:0] = cost[7:0] + left[7:0];
                else if(press) total[8:0] = {1'b0+left[7:0]};
                else total = total;
                case( num)
                    3'b000: code = total[0] ? 4'b0101 : 4'b0000;
                    3'b001: code = total[8:1] % 8'b00001010;
                    3'b010: code = ( (total[8:1] % 8'b01100100 ) / 8'b00001010 ) ? 
                        ( (total[8:1] % 8'b01100100 ) / 8'b00001010 ) : 4'b1111;
                    3'b011: code = (total[8:1] / 8'b01100100) ? (total[8:1] / 8'b01100100) : 4'b1111;
                    default:code = 4'b1111;
                endcase
            end
            //������״̬������ʾ
            2'b00:begin
                total = 9'b000000000;
                code[3:0] = 4'b1111;
            end
    endcase 
    //Ƭѡ�źŷ����ı�ʱ����
    if( num[2:0] != num_t[2:0] ) begin
        case(num)
            3'b000: an[7:0] = 8'b11111110;
            3'b001: an[7:0] = 8'b11111101;
            3'b010: an[7:0] = 8'b11111011;
            3'b011: an[7:0] = 8'b11110111;
            3'b100: an[7:0] = 8'b11101111;
            3'b101: an[7:0] = 8'b11011111;
            3'b110: an[7:0] = 8'b10111111;
            3'b111: an[7:0] = 8'b01111111;
        endcase
    end
    else   an = an;
    //������ʾ���ֵĶ����ƴ���ת��Ϊ�߶�����ܱ���
    case(code[3:0])
             4'b0000: seg[7:0] = 8'b11000000;
             4'b0001: seg[7:0] = 8'b11111001;
             4'b0010: seg[7:0] = 8'b10100100;
             4'b0011: seg[7:0] = 8'b10110000;
             4'b0100: seg[7:0] = 8'b10011001;
             4'b0101: seg[7:0] = 8'b10010010;
             4'b0110: seg[7:0] = 8'b10000010;
             4'b0111: seg[7:0] = 8'b11111000;
             4'b1000: seg[7:0] = 8'b10000000;
             4'b1001: seg[7:0] = 8'b10010000;
             4'b1010: seg[7:0] = 8'b10001001;  //H
             4'b1011: seg[7:0] = 8'b10000110;  //E
             4'b1100: seg[7:0] = 8'b11000111;  //L
             default: seg[7:0] = 8'b11111111;  //ȫ��
    endcase
    case(state)
            //����״̬ʱ����1λ�͵�5λ��ʾС����
             2'b10:begin
                 case(num)
                     3'b001: seg = seg - 8'b10000000;
                     3'b101: seg = seg - 8'b10000000;
                     default:seg = seg;
                 endcase
             end
             //����״̬ʱ����1λ��ʾС����
             2'b11:begin
                case(num)
                    3'b001: seg = seg - 8'b10000000;
                    default:seg = seg;
                endcase
             end
             default: seg[7] <= 1'b1;
    endcase
end
endmodule