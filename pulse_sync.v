`timescale 1ns/1ps
module pulse_sync(
	input wire src_clk, //Source clock
	input wire src_rst, //Source reset
	input wire src_pulse, //Source pulse input
	
	input wire dst_clk, //Destination clock
	input wire dst_rst, //Destination reset
	output reg dst_pulse //Destination pulse output
);

   //中介信號
	reg src_pulse_reg;
	reg sync_ff1, sync_ff2;
	wire pulse_detect;
	
	//在source domain捕捉pulse
	always @(posedge src_clk or posedge src_rst) begin
		if(src_rst)
			src_pulse_reg <= 0;
		else if (src_pulse)
			src_pulse_reg <=1;
		else
			src_pulse_reg <= 0; //只要送一次脈衝
    end
	 
	 //在destination domain做雙級同步
	 always @(posedge dst_clk or posedge dst_rst) begin
		if (dst_rst) begin
			sync_ff1 <= 0;
			sync_ff2 <=0;
		end
		else begin
			sync_ff1 <= src_pulse_reg;
			sync_ff2 <= sync_ff1;
		end
	end
	
	//檢測邊緣,恢復成單脈衝
	assign pulse_detect = sync_ff1 & ~sync_ff2;
	
	always @(posedge dst_clk or posedge dst_rst) begin
		if(dst_rst)
			dst_pulse <= 0;
		else
			dst_pulse <= pulse_detect;
	end
endmodule
			