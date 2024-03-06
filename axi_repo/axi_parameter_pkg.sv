package axi_parameter_pkg;
  parameter NO_M	             = 4;
  parameter NO_S 		     = 6;
 
  parameter int M_DATA_W [NO_M]        = '{16, 128, 32, 8}; 
  parameter SUM_M_DATA_W                   = 184;
 
  parameter [1023:0] S_DATA_W [NO_S]   = '{16, 8, 128, 64, 32, 32};
  parameter SUM_S_DATA_W                   = 280;
  
  parameter int M_ADDR_W 		   = 32;    //32
  
  parameter int S_ADDR_W [NO_S]   = '{12,13,14,20,13,13};
  parameter SUM_S_ADDR_W                   = 85;
  
  parameter int  M_STRB_WIDTH [NO_M]        = '{2,16,4,1};
  parameter      SUM_M_STRB_W		    =  23;

  parameter int  S_STRB_WIDTH [NO_S]        = '{2,1,16,8,4,4};
  parameter      SUM_S_STRB_W		    =  35;
  
  parameter int M_ID_WIDTH   [NO_M]        = '{9,9,9,9};
  parameter SUM_M_ID_WIDTH                 =  36;

  parameter  S_ID_WIDTH           =  11;
  
  parameter MAX_M_ID_WIDTH                 = 9;
  parameter MAX_S_ADDR_WIDTH               = 20;
  

   parameter S0_START = 32'h00000000, S0_END   = 32'h00000fff;
   parameter S1_START = 32'h00002000, S1_END   = 32'h00003fff;
   parameter S2_START = 32'h00004000, S2_END   = 32'h00007fff;
   parameter S3_START = 32'h00100000, S3_END   = 32'h001fffff; 
   parameter S4_START = 32'h00200000, S4_END   = 32'h00201fff; 
   parameter S5_START = 32'h00202000, S5_END   = 32'h00203fff;
		 
   parameter MID_M0   = 0; 
   parameter MID_M1   = 1; 
   parameter MID_M2   = 2; 
   parameter MID_M3   = 3; 
  
   parameter S_ID_MAX = 7;
   parameter S_NUM_S0 = 0;
   parameter S_NUM_S1 = 1;
   parameter S_NUM_S2 = 2;
   parameter S_NUM_S3 = 3;
   parameter S_NUM_S4 = 4;
   parameter S_NUM_S5 = 5;
   
   parameter CP       = 10;
endpackage
