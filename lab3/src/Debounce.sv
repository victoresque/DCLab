module Debounce(
	input i_in,
	input i_clk,
	output o_debounced,
	output o_neg,
	output o_pos
);
	parameter CNT_N = 7;
	localparam CNT_BIT = $clog2(CNT_N+1);

	logic o_debounced_r, o_debounced_w;
	logic [CNT_BIT-1:0] counter_r, counter_w;
	logic neg_r, neg_w, pos_r, pos_w;

	assign o_debounced = o_debounced_r;
	assign o_pos = pos_r;
	assign o_neg = neg_r;

	always_comb begin
		pos_w = ~o_debounced_r &  o_debounced_w;
		neg_w =  o_debounced_r & ~o_debounced_w;
		if (i_in != o_debounced_r) begin
			counter_w = counter_r - 1;
		end else begin
			counter_w = CNT_N;
		end
		if (counter_r == 0) begin
			o_debounced_w = ~o_debounced_r;
		end else begin
			o_debounced_w = o_debounced_r;
		end
	end

	always_ff @(posedge i_clk) begin
		o_debounced_r <= o_debounced_w;
		counter_r <= counter_w;
		neg_r <= neg_w;
		pos_r <= pos_w;
	end
endmodule
