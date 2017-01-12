for i = 1:1:length(AAANklas_all)
   wy(i,1) = sum(AAANklas_all(i, :)) ;
end

Z = wy/683;
