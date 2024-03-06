package axi_interconnect_pkg;
  
  function automatic int sum_up_to_index(int array[], int index);
    int sum = 0;
    if(index == 0) return 0;
    index = index-1;
    for (int i = 0; i <= index; i++) begin
      if (i >= array.size()) // Check if index exceeds array size
        break;
      sum += array[i];
    end
    return sum;
  endfunction

endpackage
