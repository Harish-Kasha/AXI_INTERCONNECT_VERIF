 //***********************************************************************************************************************************************************
 //	File_name   : axi_interconnect_narrow_transfer_test.sv
 //     Description : This class is going to test the narrow_transfer for aligned and unaligned addresses
 //***********************************************************************************************************************************************************

`include "axi_defines.svh"
class axi_interconnect_narrow_transfer_test extends axi_interconnect_base_test;
  `uvm_component_utils(axi_interconnect_narrow_transfer_test)
  extern function new(string name, uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void end_of_elaboration_phase(uvm_phase phase);
  extern virtual task run_phase (uvm_phase phase);
endclass

  //constructor
  function axi_interconnect_narrow_transfer_test::new(string name, uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  //build_phase
  function void axi_interconnect_narrow_transfer_test::build_phase(uvm_phase phase);
    super.build_phase(phase);  
  endfunction: build_phase
  
  //end_of elaboration_phase
  function void axi_interconnect_narrow_transfer_test::end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);  
    uvm_top.print_topology ();
  endfunction: end_of_elaboration_phase
  
  //run_phase
  task axi_interconnect_narrow_transfer_test::run_phase (uvm_phase phase);
    logic [`AXI_MAX_DW-1:0] data   [];	
    int 		    addr   [6];
    int 		    addr_0 [5];
    int                     burst_length;

    //master read and write sequences handles
    axi_pipeline_write_seq pw_seq,pw_seq1,pw_seq2,pw_seq3,pw_seq_u,pw_seq1_u,pw_seq2_u;
    axi_pipeline_read_seq  pr_seq,pr_seq1,pr_seq2,pr_seq_u,pr_seq1_u,pr_seq2_u;
    axi_seq_item t;
   
    `uvm_info("TRACE"," Interconnect_extended_test is running. Using read and write sequences to narrow transfer", UVM_LOW);
    phase.raise_objection (this);
  
      pw_seq    = axi_pipeline_write_seq::type_id::create   ("pw_seq");
      pw_seq1   = axi_pipeline_write_seq::type_id::create   ("pw_seq1");
      pw_seq2   = axi_pipeline_write_seq::type_id::create   ("pw_seq2");
      pw_seq3   = axi_pipeline_write_seq::type_id::create   ("pw_seq3");
      pr_seq    = axi_pipeline_read_seq::type_id::create    ("pr_seq");
      pr_seq1   = axi_pipeline_read_seq::type_id::create    ("pr_seq1");
      pr_seq2   = axi_pipeline_read_seq::type_id::create    ("pr_seq2");

      pw_seq_u  = axi_pipeline_write_seq::type_id::create   ("pw_seq_u");
      pw_seq1_u = axi_pipeline_write_seq::type_id::create   ("pw_seq1_u");
      pw_seq2_u = axi_pipeline_write_seq::type_id::create   ("pw_seq2_u");
      pr_seq_u  = axi_pipeline_read_seq::type_id::create    ("pr_seq_u");
      pr_seq1_u = axi_pipeline_read_seq::type_id::create    ("pr_seq1_u");
      pr_seq2_u = axi_pipeline_read_seq::type_id::create    ("pr_seq2_u");
                                                         
      addr={'h00,'h2000, 'h4000, 'h100000, 'h200000, 'h202000};
      addr_0={'h00, 'h4000, 'h100000, 'h200000, 'h202000 };
     /* fork                                               
        begin                                            
          begin                                          
            for(int i = 0; i < 5; i++) begin             
              burst_length =$urandom_range(2,5);         
              data = new[burst_length];                  
              foreach(data[j])begin                      
                data[j]=j;                               
              end                                        
              pw_seq.write_burst(i*'h128, data,burst_length, 'b1, env.master_agt_0.sqr,1);
              #30ns;                                     
            end                                          
            #1000;                                       
            for(int i = 0; i < 5; i++) begin             
              burst_length =$urandom_range(2,5);         
              pr_seq.read_burst(i*'h128,burst_length,env.master_agt_0.sqr,1);
              #30ns;                                     
            end                                          
          end                                            
                                                         
          begin                                          
            for(int i = 0; i < 5; i++) begin             
              burst_length =$urandom_range(2,5);         
              data = new[burst_length];                  
              foreach(data[j])begin                      
                data[j]=j+2;                             
              end                                        
              pw_seq1.write_burst((i*16)+'h2000, data,burst_length, 16'hF, env.master_agt_1.sqr,4);
            end                                          
            #1000;                                       
            for(int i = 0; i < 5; i++) begin             
              burst_length =$urandom_range(2,5);         
              pr_seq1.read_burst((i*16)+'h2000,burst_length,env.master_agt_1.sqr,4);
              #30ns;                                     
            end                                          
          end                                            
                                                         
          begin                                          
            for(int i = 0; i < 5; i++) begin             
               burst_length =$urandom_range(2,5);        
               data = new[burst_length];                 
               foreach(data[j])begin                     
                 data[j]=j+2;                            
               end                                       
               pw_seq2.write_burst((i*4)+'h4000, data,burst_length, 4'b0011, env.master_agt_2.sqr,2);
               #30ns;                                    
            end                                          
                                                         
            #10000;                                      
            for(int i = 0; i < 5; i++) begin             
               burst_length =$urandom_range(2,5);        
               pr_seq2.read_burst((i*4)+'h4000,burst_length,env.master_agt_2.sqr,2);
               #30ns;                                    
            end                                          
          end   
          begin  
            #20000;
            burst_length =$urandom_range(2,5);        
            data = new[burst_length];                 
            foreach(data[j])begin                     
              data[j]=$random;                            
            end                                       
            pw_seq3.write_burst('h100000, data,burst_length, 16'h00FF, env.master_agt_1.sqr,8);
          end                                            
        end
                                              
        //unaligend narrow transfer                      
        begin  
         // t.byte_en_first_custom=1;  //for unaligned address it should be 1                                        
          begin                                          
            for(int i = 0; i < 5; i++) begin             
              burst_length =$urandom_range(2,5);         
              data = new[burst_length];                  
              foreach(data[j])begin                      
                data[j]=j;                               
              end                                        
              pw_seq_u.write_burst((i*'h10)+1, data,burst_length, 'b1, env.master_agt_0.sqr,1);
              #30ns;                                     
            end                                          
            #1000;                                       
            for(int i = 0; i < 5; i++) begin             
              burst_length =$urandom_range(2,5);         
              pr_seq_u.read_burst((i*'h10)+1, burst_length,env.master_agt_0.sqr,1);
              #30ns;                                     
            end                                          
          end                                            
                                                         
          begin                                          
            for(int i = 0; i < 5; i++) begin             
              burst_length =$urandom_range(2,5);         
              data = new[burst_length];                  
              foreach(data[j])begin                      
                data[j]=j+2;                             
              end                                        
              pw_seq1_u.write_burst((i*160)+'h2100+1, data,burst_length, 16'hE, env.master_agt_1.sqr,4);
              #30ns;                                    
            end                                         
            #1000;                                      
            for(int i = 0; i < 5; i++) begin            
              burst_length =$urandom_range(2,5);        
              pr_seq1_u.read_burst((i*160)+'h2100+1,burst_length,env.master_agt_1.sqr,4);
              #30ns;                                    
            end                                         
          end                                           
                                                        
          begin                                         
            for(int i = 0; i < 5; i++) begin            
               burst_length =$urandom_range(2,5);       
               data = new[burst_length];                
               foreach(data[j])begin                    
                 data[j]=j+2;                           
               end                                      
               pw_seq2_u.write_burst((i*40)+'h5500+1, data,burst_length, 4'b0011, env.master_agt_2.sqr,2);
               #30ns;                                   
            end                                         
                                                        
            #10000;                                     
            for(int i = 0; i < 5; i++) begin            
               burst_length =$urandom_range(2,5);       
               pr_seq2_u.read_burst((i*40)+'h5500+1,burst_length,env.master_agt_2.sqr,2);
               #30ns;                                   
            end                                         
          end                                           
        end                                                                                                                                                              
      join                                                                                                       
    #500000ns;                                         
    phase.drop_objection (this);                        
   endtask     */                                         
       //aligned addresses   
       fork                           
        begin                                         
          begin                                         
            foreach(addr[j])begin                       
              for(int i = 0; i < 5; i++) begin          
                 burst_length =$urandom_range(2,5);     
                 data = new[burst_length];              
                 foreach(data[k])begin                  
                   data[k]=$urandom_range(1,9);         
                 end                                    
                 pw_seq.write_burst(addr[j]+(i*'h10), data,burst_length, 'b1, env.master_agt_0.sqr,1);
                 #30ns;                                 
              end                                       
            end                                         
            #10000;                                     
            foreach(addr[j])begin                       
              for(int i = 0; i < 5; i++) begin          
                 burst_length =$urandom_range(2,5);     
                 pr_seq.read_burst(addr[j]+(i*'h10),burst_length,env.master_agt_0.sqr,1);
                 #30ns;                                 
              end                                       
            end                                         
          end                                           
          begin                                         
            foreach(addr[j])begin                       
              for(int i = 0; i < 5; i++) begin          
                 burst_length =$urandom_range(2,5);     
                 data = new[burst_length];              
                 foreach(data[k])begin                  
                   data[k]=$urandom_range(1000,4000);   
                 end                                    
                 pw_seq1.write_burst(addr[j]+(i*'h100), data,burst_length, 16'hF, env.master_agt_1.sqr,4);
                 #30ns;                                 
              end                                       
            end                                         
            #10000;                                     
            foreach(addr[j])begin                       
              for(int i = 0; i < 5; i++) begin          
                 burst_length =$urandom_range(2,5);     
                 pr_seq1.read_burst(addr[j]+(i*'h100),burst_length,env.master_agt_1.sqr,4);
                 #30ns;                                 
              end                                       
            end                                         
          end                                           
          begin                                         
            foreach(addr[j])begin                       
              for(int i = 0; i < 5; i++) begin          
                 burst_length =$urandom_range(2,5);     
                 data = new[burst_length];              
                 foreach(data[k])begin                  
                   data[k]=$urandom_range(100,500);                   
                 end                                    
                 pw_seq2.write_burst(addr[j]+(i*'h30), data,burst_length, 4'b0011, env.master_agt_2.sqr,2);
                 #30ns;                                 
              end                                       
            end                                         
            #10000;                                     
            foreach(addr[j])begin                       
              for(int i = 0; i < 5; i++) begin          
                 burst_length =$urandom_range(2,5);     
                 pr_seq2_u.read_burst(addr[j]+(i*'h30),burst_length,env.master_agt_2.sqr,2);
                 #30ns;                                 
              end                                       
            end                                         
          end                                           
        end                                           
        //unaligned addresses                           
      begin                                             
          begin                                         
            foreach(addr_0[j])begin                     
              for(int i = 0; i < 5; i++) begin          
                 burst_length =$urandom_range(2,5);     
                 data = new[burst_length];              
                 foreach(data[k])begin                  
                   data[k]=k;                           
                 end                                    
                 pw_seq_u.write_burst(addr_0[j]+(i*'h60)+1, data,burst_length, 'b1, env.master_agt_0.sqr,1);
                 #30ns;                                 
              end                                       
            end                                         
            #10000;                                     
            foreach(addr[j])begin                       
              for(int i = 0; i < 5; i++) begin          
                 burst_length =$urandom_range(2,5);     
                 pr_seq_u.read_burst(addr_0[j]+(i*'h60)+1,burst_length,env.master_agt_0.sqr,1);
                 #30ns;                                 
              end                                       
            end                                         
          end                                           
          begin                                         
            foreach(addr[j])begin                       
              for(int i = 0; i < 5; i++) begin          
                 burst_length =$urandom_range(2,5);     
                 data = new[burst_length];              
                 foreach(data[k])begin                  
                   data[k]=k+2;                         
                 end                                    
                 pw_seq1_u.write_burst(addr[j]+'h100+(i*'h100)+1, data,burst_length, 16'hE, env.master_agt_1.sqr,4);
                 #30ns;                                 
              end                                       
            end                                         
            #10000;                                     
            foreach(addr[j])begin                       
              for(int i = 0; i < 5; i++) begin          
                 burst_length =$urandom_range(2,5);     
                 pr_seq1_u.read_burst(addr[j]+'h100+(i*'h100)+1,burst_length,env.master_agt_1.sqr,4);
                 #30ns;                                 
              end                                       
            end                                         
          end                                           
          begin                                         
            foreach(addr[j])begin                       
              for(int i = 0; i < 5; i++) begin          
                 burst_length =$urandom_range(2,5);     
                 data = new[burst_length];              
                 foreach(data[k])begin                  
                   data[k]=k*4;                         
                 end                                    
                 pw_seq2_u.write_burst(addr[j]+'h200+(i*'h60)+1, data,burst_length, 4'b0010, env.master_agt_2.sqr,2);
                 #30ns;                                 
              end                                       
            end                                         
            #10000;                                     
            foreach(addr[j])begin                       
              for(int i = 0; i < 5; i++) begin          
                 burst_length =$urandom_range(2,5);     
                 pr_seq2_u.read_burst(addr[j]+'h200+(i*'h60)+1,burst_length,env.master_agt_2.sqr,2);
                 #30ns;                                 
              end                                       
            end                                         
          end                                          
       end                                                                
                    
      join                                                                                                       
    #500000ns;                                         
    phase.drop_objection (this);                        
   endtask                                                   
                                                        
                                                        
                                                        
                                                        
                                                        
                                                        
                                                        
