module calculatePhaseIncrement(
    input wire [15:0] setFreq,
    output reg [31:0] phase_inc

);
//calculate phase increment when set frequency is changed
always @(setFreq) begin
    phase_inc <= (setFreq * 4294967296) / 10000000; //setfreq*2^32/clockfreq
end
endmodule


module phaseAccumulator (
input wire clk;
input reg [31:0] phaseInc,
output reg [31:0] phase_out,
output reg endPeriod
);
//at each clock cycle, add phase increment. 
always @(posedge clk) begin
    phase_out <= phase_out + phase_inc;
    endPeriod <= phase_out < (phase_inc); //if phase overflows, 1 period has elapsed
end
endmodule


module sinLUT (
input wire [9:0] addr; //use 10 MSB from phase_out
output reg [15:0] waveVal;
);

always @(addr) begin
    case
        //sin lookup table w/ w^10 vals
    endcase

end
endmodule

module square (
input wire phaseMSB,
output reg signed [15:0] waveVal
);

always @(*) begin
    //phase is 180 degrees when MSB changes from 0 to 1
 case (phaseMSB)
    1'b0: waveVal=16'sh7FFF; //max and min signed vals for 16 bits:
    1'b1: waveVal=-16'sh7FFF;
 endcase

end
endmodule


module triangle (
output reg signed [15:0] waveVal,
input wire [31:0] phase
);
always @(*) begin
     case(phase[31]) 
         1'b0: waveVal = 16'sh7FFF - phase[29:14]; //count down starting from max val
         1'b1: waveVal = phase[29:14] - 16'sh7FFF; //count up starting from min val
    endcase

end
endmodule

module sawtooth (
output reg signed [15:0] waveVal,
input wire [31:0] phase,
input reg endPeriod
);
//increase until phase wraps around then go to 0
//increment until endperiod is 1
always @(*) begin
        waveVal = -16'sh7FFF + phase[31:16]; //when phase overflows, this array will be near zero and wavaVal resets. 
end
endmodule

