function [resp_corr] = corrResp(prob_out,data,store)
%Calculates if the response were normatively correct
%   Checks probability value and data = response value, using these two
%   calculates responses which were normatively correct
   for kk=1:size(prob_out,1)
       % if probability is greater than 0.5 and response =1 or probability
       % is less than 0.5 and response is equal to 2, stores resp_corr as 1
               if prob_out(kk)>0.5 && data(kk,1)==1  || prob_out(kk)<0.5 && data(kk,1)==2
                   store(kk,1) = 1;
                   elseif prob_out(kk)==0.5
                       store(kk,1)=" ";
               else
                   store(kk,1)=0;
               end
   end
    resp_corr=store;
end

