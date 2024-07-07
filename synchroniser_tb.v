module synchroniser_tb();
reg clk,rstn,detect_add,write_enb_reg,full_0,full_1,full_2,read_enb_0,read_enb_1,read_enb_2,empty_0,empty_1,empty_2;
reg [1:0] data_in;
wire vld_out_0,vld_out_1,vld_out_2,fifo_full,soft_reset_0,soft_reset_1,soft_reset_2;
wire [2:0] write_enb;
synchroniser dut(clk,rstn,detect_add,write_enb_reg,full_0,full_1,full_2,read_enb_0,read_enb_1,read_enb_2,empty_0,empty_1,empty_2,data_in, vld_out_0,vld_out_1,vld_out_2,fifo_full,soft_reset_0,soft_reset_1,soft_reset_2,write_enb);
initial
begin
clk=0;
forever #10 clk=~clk;
end
task rst_dut();
	begin
	@(negedge clk)
		rstn=1'b0;
	@(negedge clk)
		rstn=1'b1;
	end
endtask
task initialise;
begin
detect_add=1'b0;
data_in=2'b00;
write_enb_reg=1'b0;
{empty_0,empty_1,empty_2}=3'b111;
{full_0,full_1,full_2}=3'b000;
{read_enb_0,read_enb_1,read_enb_2}=3'b000;
end
endtask
task addr(input [1:0]m);
begin
@(negedge clk)
detect_add=1'b1;
data_in=m;
@(negedge clk)
detect_add=1'b0;
end
endtask
task write;
begin
@(negedge clk)
write_enb_reg=1'b1;
@(negedge clk)
write_enb_reg=1'b0;
end
endtask
task stimulus;
begin
@(negedge clk)
{full_0,full_1,full_2}=3'b001;
@(negedge clk)
{read_enb_0,read_enb_1,read_enb_2}=3'b001;
@(negedge clk)
{empty_0,empty_1,empty_2}=3'b110;
end
endtask
initial
begin
initialise;
rst_dut;
addr(2'b10);
stimulus;
#500 $finish;
end
endmodule

