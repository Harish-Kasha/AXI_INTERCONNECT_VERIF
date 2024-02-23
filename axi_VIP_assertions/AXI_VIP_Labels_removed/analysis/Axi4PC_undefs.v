//-----------------------------------------------------------------------------
//  Purpose             : AXI4 SV Protocol Assertions undefines
//=============================================================================

//-----------------------------------------------------------------------------
// AXI Constants
//-----------------------------------------------------------------------------

`ifdef AXI4PC_TYPES
    `undef AXI4PC_TYPES
    // ALEN Encoding
    `undef AXI4PC_ALEN_1  
    `undef AXI4PC_ALEN_2  
    `undef AXI4PC_ALEN_3  
    `undef AXI4PC_ALEN_4  
    `undef AXI4PC_ALEN_5  
    `undef AXI4PC_ALEN_6  
    `undef AXI4PC_ALEN_7  
    `undef AXI4PC_ALEN_8  
    `undef AXI4PC_ALEN_9  
    `undef AXI4PC_ALEN_10 
    `undef AXI4PC_ALEN_11 
    `undef AXI4PC_ALEN_12 
    `undef AXI4PC_ALEN_13 
    `undef AXI4PC_ALEN_14 
    `undef AXI4PC_ALEN_15 
    `undef AXI4PC_ALEN_16 

    // ASIZE Encoding
    `undef AXI4PC_ASIZE_8      
    `undef AXI4PC_ASIZE_16     
    `undef AXI4PC_ASIZE_32     
    `undef AXI4PC_ASIZE_64     
    `undef AXI4PC_ASIZE_128    
    `undef AXI4PC_ASIZE_256    
    `undef AXI4PC_ASIZE_512    
    `undef AXI4PC_ASIZE_1024   

    // ABURST Encoding
    `undef AXI4PC_ABURST_FIXED 
    `undef AXI4PC_ABURST_INCR   
    `undef AXI4PC_ABURST_WRAP   

    // ALOCK Encoding
    `undef AXI4PC_ALOCK_EXCL

    // RRESP / BRESP Encoding
    `undef AXI4PC_RESP_OKAY         
    `undef AXI4PC_RESP_EXOKAY       
    `undef AXI4PC_RESP_SLVERR       
    `undef AXI4PC_RESP_DECERR       
    
    //define the protocol
    `undef AXI4PC_AMBA_AXI4        
    `undef AXI4PC_AMBA_ACE         
    `undef AXI4PC_AMBA_ACE_LITE    
`endif

// --========================= End ===========================================--

