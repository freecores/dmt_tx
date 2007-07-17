/* *****************************************************************
 *
 *  This file is part of Tone Order and Constellation Encoder Core.
 *  Copyright (C) 2007 Guenter Dannoritzer
 *
 *   This source is free software; you can redistribute it
 *   and/or modify it under the terms of the 
 *             GNU General Public License
 *   as published by the Free Software Foundation; 
 *   either version 3 of the License,
 *   or (at your option) any later version.
 *
 *   This source is distributed in the hope 
 *   that it will be useful, but WITHOUT ANY WARRANTY;
 *   without even the implied warranty of MERCHANTABILITY
 *   or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the
 *   GNU General Public License along with this program.
 *   If not, see <http://www.gnu.org/licenses/>.
 *
 * *****************************************************************/

module const_encoder( 
                clk,
                reset,
                input_ready_o,
                we_data_i,
                data_i,
                addr_i,
                we_conf_i,
                conf_data_i,
                xy_ready_o,
                bin_num_o,
                x_o,
                y_o);

input   clk;
input   reset;
output  input_ready_o;
input   we_data_i;
input   data_i;
input   addr_i;
input   we_conf_i;
input   conf_data_i;
output  xy_ready_o;
output  bin_num_o;
output  x_o;
output  y_o;



endmodule
