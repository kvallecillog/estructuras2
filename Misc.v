module FLIP_FLOP_D # ( parameter SIZE=8 )
(
	input wire Clock,
	input wire Reset,
	input wire Enable,
	input wire [SIZE-1:0] D,
	output reg [SIZE-1:0] Q
);
	always @ ( * )
	begin
		if (Reset)
			Q <= 0;
	end

	always @ (posedge Clock)
	begin
		if (Enable)
			Q <= D;
	end
endmodule