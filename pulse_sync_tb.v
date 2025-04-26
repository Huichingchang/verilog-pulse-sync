`timescale 1ns/1ps
module pulse_sync_tb;
	
	//宣告訊號
	reg src_clk, src_rst, src_pulse;
	reg dst_clk, dst_rst;
	wire dst_pulse;
	
	//實例化pulse_sync模組
	pulse_sync uut(
		.src_clk(src_clk),
		.src_rst(src_rst),
		.src_pulse(src_pulse),
		.dst_clk(dst_clk),
		.dst_rst(dst_rst),
		.dst_pulse(dst_pulse)
	);
	
	//來源時脈:週期10ns
	always #5 src_clk = ~src_clk;
	//目的時脈:週期7ns
	always #3.5 dst_clk = ~dst_clk;
	
	integer f;
	
	initial begin
	   //儲存波形
		$dumpfile("pulse_sync.vcd");
		$dumpvars(0,pulse_sync_tb);
		
		//開啟monitor_log.txt
		f=$fopen("monitor_log.txt","w");
		if (!f) begin
			$display("Failed to open monitor_log.txt");
			$finish;
		end
		
		//初始化
		src_clk = 0;
		dst_clk = 0;
		src_rst = 1;
		dst_rst = 1;
		src_pulse = 0;
		
		#10;
		src_rst = 0;
		dst_rst = 0;
		
		//發第一個pulse
		#15;
	   src_pulse = 1;
	   #10;
		src_pulse = 0;
		
		$fwrite(f,"Sent 1st pulse at %0t ns\n", $time);
		
		//發第二個pulse
		#50;
	   src_pulse = 1;
	   #10;
		src_pulse = 0;
		
		$fwrite(f,"Sent 2nd pulse at %0t ns\n", $time);		
		
		
		//發第三個pulse
		#40;
		src_pulse = 1;
		#10;
		src_pulse = 0;
		
		$fwrite(f, "Sent 3rd pulse at %0t ns\n", $time );
		
		//結束模擬
		$fclose(f);
		$display("Simulation Done");
		#100;
		$finish;
	end
endmodule