//
// HT1080Z for MiSTer Keyboard module
//
// Copyright (c) 2009-2011 Mike Stirling
// Copyright (c) 2015-2017 Sorgelig
//
// All rights reserved
//
// Redistribution and use in source and synthezised forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// * Redistributions of source code must retain the above copyright notice,
//   this list of conditions and the following disclaimer.
//
// * Redistributions in synthesized form must reproduce the above copyright
//   notice, this list of conditions and the following disclaimer in the
//   documentation and/or other materials provided with the distribution.
//
// * Neither the name of the author nor the names of other contributors may
//   be used to endorse or promote products derived from this software without
//   specific prior written agreement from the author.
//
// * License is granted for non-commercial use only.  A fee may not be charged
//   for redistributions as source code or in synthesized/hardware form without
//   specific prior written agreement from the author.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
// THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
// PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.
//
//
// PS/2 scancode to TRS-80 matrix conversion
//




module keyboard
(
	input             reset,		// reset when driven high
	input             clk_sys,		// should be same clock as clk_sys from HPS_IO

	input      [10:0] ps2_key,		// [7:0] - scancode,
											// [8] - extended (i.e. preceded by scan 0xE0),
											// [9] - pressed
											// [10] - toggles with every press/release

	input       [7:0] addr,			// bottom 7 address lines from CPU for memory-mapped access
	output      reg [7:0] kb_rows,	// data lines returned from scanning

	input      [15:0] joy1,
	input      [15:0] joy2,
	
	output reg [11:1] Fn = 0,
	output reg  [2:0] modif = 0
);

reg  [7:0] keys[7:0];
reg        press_btn = 0;
reg  [7:0] code;
reg		  shiftstate = 0;

// Output addressed row to ULA
always @(*) begin
	kb_rows<=8'hff;
	
	
	//if (joystick_1_button) kb_rows[1]<=0;
	//if (joystick_2_button) kb_rows[0]<=0;
	//kb_rows[7]<=joystick_hilo;
	

	if (keys[0][0]==1'b0) if (addr[0] == 1'b0) kb_rows[0] <= 1'b0;
	if (keys[0][1]==1'b0) if (addr[1] == 1'b0) kb_rows[0] <= 1'b0;
	if (keys[0][2]==1'b0) if (addr[2] == 1'b0) kb_rows[0] <= 1'b0;
	if (keys[0][3]==1'b0) if (addr[3] == 1'b0) kb_rows[0] <= 1'b0;
	if (keys[0][4]==1'b0) if (addr[4] == 1'b0) kb_rows[0] <= 1'b0;
	if (keys[0][5]==1'b0) if (addr[5] == 1'b0) kb_rows[0] <= 1'b0;
	if (keys[0][6]==1'b0) if (addr[6] == 1'b0) kb_rows[0] <= 1'b0;
	if (keys[0][7]==1'b0) if (addr[7] == 1'b0) kb_rows[0] <= 1'b0;

	if (keys[1][0]==1'b0) if (addr[0] == 1'b0) kb_rows[1] <= 1'b0;
	if (keys[1][1]==1'b0) if (addr[1] == 1'b0) kb_rows[1] <= 1'b0;
	if (keys[1][2]==1'b0) if (addr[2] == 1'b0) kb_rows[1] <= 1'b0;
	if (keys[1][3]==1'b0) if (addr[3] == 1'b0) kb_rows[1] <= 1'b0;
	if (keys[1][4]==1'b0) if (addr[4] == 1'b0) kb_rows[1] <= 1'b0;
	if (keys[1][5]==1'b0) if (addr[5] == 1'b0) kb_rows[1] <= 1'b0;
	if (keys[1][6]==1'b0) if (addr[6] == 1'b0) kb_rows[1] <= 1'b0;
	if (keys[1][7]==1'b0) if (addr[7] == 1'b0) kb_rows[1] <= 1'b0;

	if (keys[2][0]==1'b0) if (addr[0] == 1'b0) kb_rows[2] <= 1'b0;
	if (keys[2][1]==1'b0) if (addr[1] == 1'b0) kb_rows[2] <= 1'b0;
	if (keys[2][2]==1'b0) if (addr[2] == 1'b0) kb_rows[2] <= 1'b0;
	if (keys[2][3]==1'b0) if (addr[3] == 1'b0) kb_rows[2] <= 1'b0;
	if (keys[2][4]==1'b0) if (addr[4] == 1'b0) kb_rows[2] <= 1'b0;
	if (keys[2][5]==1'b0) if (addr[5] == 1'b0) kb_rows[2] <= 1'b0;
	if (keys[2][6]==1'b0) if (addr[6] == 1'b0) kb_rows[2] <= 1'b0;
	if (keys[2][7]==1'b0) if (addr[7] == 1'b0) kb_rows[2] <= 1'b0;

	if (keys[3][0]==1'b0) if (addr[0] == 1'b0) kb_rows[3] <= 1'b0;
	if (keys[3][1]==1'b0) if (addr[1] == 1'b0) kb_rows[3] <= 1'b0;
	if (keys[3][2]==1'b0) if (addr[2] == 1'b0) kb_rows[3] <= 1'b0;
	if (keys[3][3]==1'b0) if (addr[3] == 1'b0) kb_rows[3] <= 1'b0;
	if (keys[3][4]==1'b0) if (addr[4] == 1'b0) kb_rows[3] <= 1'b0;
	if (keys[3][5]==1'b0) if (addr[5] == 1'b0) kb_rows[3] <= 1'b0;
	if (keys[3][6]==1'b0) if (addr[6] == 1'b0) kb_rows[3] <= 1'b0;
	if (keys[3][7]==1'b0) if (addr[7] == 1'b0) kb_rows[3] <= 1'b0;

	if (keys[4][0]==1'b0) if (addr[0] == 1'b0) kb_rows[4] <= 1'b0;
	if (keys[4][1]==1'b0) if (addr[1] == 1'b0) kb_rows[4] <= 1'b0;
	if (keys[4][2]==1'b0) if (addr[2] == 1'b0) kb_rows[4] <= 1'b0;
	if (keys[4][3]==1'b0) if (addr[3] == 1'b0) kb_rows[4] <= 1'b0;
	if (keys[4][4]==1'b0) if (addr[4] == 1'b0) kb_rows[4] <= 1'b0;
	if (keys[4][5]==1'b0) if (addr[5] == 1'b0) kb_rows[4] <= 1'b0;
	if (keys[4][6]==1'b0) if (addr[6] == 1'b0) kb_rows[4] <= 1'b0;
	if (keys[4][7]==1'b0) if (addr[7] == 1'b0) kb_rows[4] <= 1'b0;

	if (keys[5][0]==1'b0) if (addr[0] == 1'b0) kb_rows[5] <= 1'b0;
	if (keys[5][1]==1'b0) if (addr[1] == 1'b0) kb_rows[5] <= 1'b0;
	if (keys[5][2]==1'b0) if (addr[2] == 1'b0) kb_rows[5] <= 1'b0;
	if (keys[5][3]==1'b0) if (addr[3] == 1'b0) kb_rows[5] <= 1'b0;
	if (keys[5][4]==1'b0) if (addr[4] == 1'b0) kb_rows[5] <= 1'b0;
	if (keys[5][5]==1'b0) if (addr[5] == 1'b0) kb_rows[5] <= 1'b0;
	if (keys[5][6]==1'b0) if (addr[6] == 1'b0) kb_rows[5] <= 1'b0;
	if (keys[5][7]==1'b0) if (addr[7] == 1'b0) kb_rows[5] <= 1'b0;

	if (keys[6][0]==1'b0) if (addr[0] == 1'b0) kb_rows[6] <= 1'b0;
	if (keys[6][1]==1'b0) if (addr[1] == 1'b0) kb_rows[6] <= 1'b0;
	if (keys[6][2]==1'b0) if (addr[2] == 1'b0) kb_rows[6] <= 1'b0;
	if (keys[6][3]==1'b0) if (addr[3] == 1'b0) kb_rows[6] <= 1'b0;
	if (keys[6][4]==1'b0) if (addr[4] == 1'b0) kb_rows[6] <= 1'b0;
	if (keys[6][5]==1'b0) if (addr[5] == 1'b0) kb_rows[6] <= 1'b0;
	if (keys[6][6]==1'b0) if (addr[6] == 1'b0) kb_rows[6] <= 1'b0;
	if (keys[6][7]==1'b0) if (addr[7] == 1'b0) kb_rows[6] <= 1'b0;
	
/*
	if (keys[7][0]==1'b0) if (addr[0] == 1'b0) kb_rows[7] <= 1'b0;
	if (keys[7][1]==1'b0) if (addr[1] == 1'b0) kb_rows[7] <= 1'b0;
	if (keys[7][2]==1'b0) if (addr[2] == 1'b0) kb_rows[7] <= 1'b0;
	if (keys[7][3]==1'b0) if (addr[3] == 1'b0) kb_rows[7] <= 1'b0;
	if (keys[7][4]==1'b0) if (addr[4] == 1'b0) kb_rows[7] <= 1'b0;
	if (keys[7][5]==1'b0) if (addr[5] == 1'b0) kb_rows[7] <= 1'b0;
	if (keys[7][6]==1'b0) if (addr[6] == 1'b0) kb_rows[7] <= 1'b0;
	if (keys[7][7]==1'b0) if (addr[7] == 1'b0) kb_rows[7] <= 1'b0;
*/

end
/*
  reg [7:0] key_data;
assign key_data =  (addr[0] ? keys[0] : 8'b11111111)
                 & (addr[1] ? keys[1] : 8'b11111111)
                 & (addr[2] ? keys[2] : 8'b11111111)
                 & (addr[3] ? keys[3] : 8'b11111111)
                 & (addr[4] ? keys[4] : 8'b11111111)
                 & (addr[5] ? keys[5] : 8'b11111111)
                 & (addr[6] ? keys[6] : 8'b11111111)
                 & (addr[7] ? keys[7] : 8'b11111111);
*/
reg  input_strobe = 0;

always @(posedge clk_sys) begin
	reg old_reset;
	old_reset <= reset;

	if(~old_reset & reset) begin
		keys[0] <= 8'b11111111;
		keys[1] <= 8'b11111111;
		keys[2] <= 8'b11111111;
		keys[3] <= 8'b11111111;
		keys[4] <= 8'b11111111;
		keys[5] <= 8'b11111111;
		keys[6] <= 8'b11111111;
		keys[7] <= 8'b11111111;
	end

	if(input_strobe) begin
		case(code)
			8'h59: modif[0]<= press_btn; // right shift
			8'h11: modif[1]<= press_btn; // alt
			8'h14: modif[2]<= press_btn; // ctrl
			8'h05: Fn[1] <= press_btn; // F1
			8'h06: Fn[2] <= press_btn; // F2
			8'h04: Fn[3] <= press_btn; // F3
			8'h0C: Fn[4] <= press_btn; // F4
			8'h03: Fn[5] <= press_btn; // F5
			8'h0B: Fn[6] <= press_btn; // F6
			8'h83: Fn[7] <= press_btn; // F7
			8'h0A: Fn[8] <= press_btn; // F8
			8'h01: Fn[9] <= press_btn; // F9
			8'h09: Fn[10]<= press_btn; // F10
			8'h78: Fn[11]<= press_btn; // F11
		endcase

		case(code)

			//////////////////////////////
			// For the first group of keys, the keyboard mode (TRS or PC) doesn't matter
			// The results are the same either way
			//////////////////////////////

			8'h1c : keys[0][1] <= ~press_btn; // A
			8'h32 : keys[0][2] <= ~press_btn; // B
			8'h21 : keys[0][3] <= ~press_btn; // C
			8'h23 : keys[0][4] <= ~press_btn; // D
			8'h24 : keys[0][5] <= ~press_btn; // E
			8'h2b : keys[0][6] <= ~press_btn; // F
			8'h34 : keys[0][7] <= ~press_btn; // G

			8'h33 : keys[1][0] <= ~press_btn; // H
			8'h43 : keys[1][1] <= ~press_btn; // I
			8'h3b : keys[1][2] <= ~press_btn; // J
			8'h42 : keys[1][3] <= ~press_btn; // K
			8'h4b : keys[1][4] <= ~press_btn; // L
			8'h3a : keys[1][5] <= ~press_btn; // M
			8'h31 : keys[1][6] <= ~press_btn; // N
			8'h44 : keys[1][7] <= ~press_btn; // O

			8'h4d : keys[2][0] <= ~press_btn; // P
			8'h15 : keys[2][1] <= ~press_btn; // Q
			8'h2d : keys[2][2] <= ~press_btn; // R
			8'h1b : keys[2][3] <= ~press_btn; // S
			8'h2c : keys[2][4] <= ~press_btn; // T
			8'h3c : keys[2][5] <= ~press_btn; // U
			8'h2a : keys[2][6] <= ~press_btn; // V
			8'h1d : keys[2][7] <= ~press_btn; // W

			8'h22 : keys[3][0] <= ~press_btn; // X
			8'h35 : keys[3][1] <= ~press_btn; // Y
			8'h1a : keys[3][2] <= ~press_btn; // Z

			8'h16 : keys[4][1] <= ~press_btn;	// 1
			8'h26 : keys[4][3] <= ~press_btn; // 3
			8'h25 : keys[4][4] <= ~press_btn; // 4
			8'h2e : keys[4][5] <= ~press_btn; // 5


			8'h41 : keys[5][4] <= ~press_btn; // ,<
			8'h49 : keys[5][6] <= ~press_btn; // .>
			8'h4a : keys[5][7] <= ~press_btn; // /?

			8'h5a : keys[6][0] <= ~press_btn; // ENTER

			8'h0d : keys[6][1] <= ~press_btn; // TAB (PC)    -> CLEAR (TRS)
			8'h76 : keys[6][2] <= ~press_btn; // ESCAPE (PC) -> BREAK (TRS)

			8'h75 : keys[3][3] <= ~press_btn; // UP ARROW
			8'h72 : keys[3][4] <= ~press_btn; // DN ARROW
			8'h6B : keys[3][5] <= ~press_btn; // LF ARROW (PC)  -> LF ARROW (TRS)
			8'h66 : keys[3][5] <= ~press_btn; // BACKSPACE (PC) -> LF ARROW (TRS)
			8'h74 : keys[3][6] <= ~press_btn; // RT ARROW
			8'h29 : keys[3][7] <= ~press_btn; // SPACE


			8'h12 : begin
						keys[6][7] <= ~press_btn; // Left shift
						shiftstate <= press_btn;
					end

			8'h59 : begin
						keys[6][7] <= ~press_btn; // Right shift
						shiftstate <= press_btn;
					end

			8'h58 : begin
						keys[4][0] <= ~press_btn; // Caps lock (= shift-0 on CoCo)
						keys[6][7] <= ~press_btn;
					end

//			8'h14 : keys[7][1] <= press_btn; // CTRL (Symbol Shift)


			// Numpad new keys:

			8'h7b : keys[5][5] <= ~press_btn; // keypad -
			8'h6c : keys[6][1] <= ~press_btn; // KYPD-7 (PC) -> CLEAR (TRS)

			8'h7c : begin
						keys[5][2] <= ~press_btn; // * (shifted)
						keys[6][7] <= ~press_btn;
					end

			8'h79 : begin
						keys[5][3] <= ~press_btn; // + (shifted)
						keys[6][7] <= ~press_btn;
					end


			//////////////////////////////
			// For the next group of keys, results depend on the keyboard mode (TRS or PC)
			//////////////////////////////
/*
			8'h54 : 															// [ (PC backslash)
					if (kblayout == 0) begin
						keys[0][0] <= ~press_btn;						// -> @ TRS			(TRS layout)
					end														// -> no mapping	(PC layout)

			8'h45 :															// 0
					if ((kblayout == 1) && (shiftstate == 1)) begin
						keys[5][1] <= ~press_btn;						// PC ')' -> 9 + shift (TRS)
						keys[6][7] <= ~press_btn;
					end
					else begin
						keys[4][0] <= ~press_btn;						// 0
					end

			8'h1e :															// 2
					if ((kblayout == 1) && (shiftstate == 1)) begin
						keys[0][0] <= ~press_btn;						// PC '@" -> @ (TRS)
						keys[6][7] <= press_btn;
					end
					else begin
						keys[4][2] <= ~press_btn;						// 2
					end


			8'h36 :															// 6
					if ((kblayout == 0) || (shiftstate == 0)) begin
						keys[4][6] <= ~press_btn;						// 6 (no mapping for '^' from PC)
					end

			8'h3d :															// 7
					if ((kblayout == 1) && (shiftstate == 1)) begin
						keys[4][6] <= ~press_btn;						// PC '&' -> '6' + shift (TRS)
						keys[6][7] <= ~press_btn;
					end
					else begin
						keys[4][7] <= ~press_btn;						// 7
					end

			8'h3e :															// 8
					if ((kblayout == 1) && (shiftstate == 1)) begin
						keys[5][2] <= ~press_btn;						// PC '*' -> ':' + shift (TRS)
						keys[6][7] <= ~press_btn;
					end
					else begin
						keys[5][0] <= ~press_btn;						// 8
					end

			8'h46 :															// 9
					if ((kblayout == 1) && (shiftstate == 1)) begin
						keys[5][0] <= ~press_btn;						// PC '(' -> '8' + shift (TRS)
						keys[6][7] <= ~press_btn;
					end
					else begin
						keys[5][1] <= ~press_btn;						// 9
					end


			8'h4e :															// - (minus)
					if (kblayout == 0) begin
						keys[5][2] <= ~press_btn;						// :* (TRS)
					end
					else if (shiftstate == 0) begin
						keys[5][5] <= ~press_btn;						// - (minus)
					end

			8'h4c :															// ;:
					if ((kblayout == 1) && (shiftstate == 1)) begin
						keys[5][2] <= ~press_btn;						// ':' (not shifted)  (TRS)
						keys[6][7] <= press_btn;
					end
					else begin
						keys[5][3] <= ~press_btn;						// - (minus)
					end

			8'h55 :															// = +
					if (kblayout == 1) begin
						if (shiftstate == 0) begin						// if '=' on PC keyboard
							keys[5][5] <= ~press_btn;					// '-' + shift (TRS)
							keys[6][7] <= ~press_btn;
						end
						else begin											// if '+' on PC keyboard
							keys[5][3] <= ~press_btn;					// ';' + shift (TRS)
							keys[6][7] <= ~press_btn;
						end
					end
					else begin
						keys[5][5] <= ~press_btn;						// =
					end

			8'h52 :															// ' "
					if (kblayout == 1) begin
						if (shiftstate == 1) begin						// if (double-quote) on PC keyboard
							keys[4][2] <= ~press_btn;					// '2' + shift (TRS)
							keys[6][7] <= ~press_btn;
						end
						else begin											// if (apostrophe) on PC keyboard
							keys[4][7] <= ~press_btn;					// '7' + shift (TRS)
							keys[6][7] <= ~press_btn;
						end
					end														// otherwise no mapping (TRS)
*/
			default: ;
		endcase
	end
end

always @(posedge clk_sys) begin
	reg old_state;

	input_strobe <= 0;
	old_state <= ps2_key[10];

	if(old_state != ps2_key[10]) begin
		press_btn <= ps2_key[9];
		code <= ps2_key[7:0];
		input_strobe <= 1;
	end
end

endmodule