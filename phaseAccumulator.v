module phaseAccumulator (
input wire clk;
input wire [15:0] setFreq;
output reg [31:0] phase_out;
);

//calculate phase increment when set frequency is changed
always @(setFreq) begin
    phase_inc <= (setFreq * 4294967296) / 10000000; 
end

//at each clock cycle, add phase increment. 
always @(posedge clk) begin
    phase_out <= phase_out + phase_inc;
end

endmodule


module sinLUT (
input wire [9:0] addr; //use 10 MSB from phase_out
output reg [15:0] waveVal;
);

assign addr = phase_out[31:22];

always @(addr) begin
    case
        //sin lookup table
    endcase

end
endmodule

module square (
input wire phaseMSB;
output reg signed [15:0] waveVal
);

always @(*) begin
    //phase is 180 degrees when MSB changes from 0 to 1
 case (phaseMSB)
    1'b0: waveVal=16'sd32767; //max and min signed vals for 16 bits:
    1'b1: waveVal=-16'sd32767;
 endcase

end
endmodule


module triangle (
output reg signed [15:0] waveVal;
input wire [31:0] phase;
);
always @(*) begin
    case(phase[31:30]) 
        2'b00: waveVal = phase[29:14]; //count up starting from 0
        2'b01: waveVal = 16'hFFFF - phase[29:14]; //count down starting from max
        2'b10: waveVal = 16'h0000 - phase[29:14]; //count down starting from 0
        2'b11: waveVal = phase[29:14] - 16'hFFFF; //count up starting from min
    endcase

end

endmodule

