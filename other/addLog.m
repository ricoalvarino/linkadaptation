function  addLog( txt  )
[ST,I] = dbstack;
fid = fopen('log.txt','at');
fprintf(fid,'%s [%s] %s\n',datestr(now),ST(2).file,txt);
fclose(fid);


end

