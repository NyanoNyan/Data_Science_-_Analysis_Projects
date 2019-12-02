function [resp] = gathResp(data,store)
% Calculates the response from the traning phase data, using response
% reward and outcome data

     for ii=1:size(data(:,7),1)
         %  Checks if response reward = 1, if it is then response=outcome
               if data(ii,7)==1
                   store(ii,1)=data(ii,6) ; 
                    
             % Checks if response_rew=0 & outcome = 2, if it is then response =1
               elseif data(ii,7)==0 && data(ii,6)==2
                    store(ii,1)=1;
                    
               % Checks if response_rew=0 & outcome = 1, if it is then response =2 
               elseif data(ii,7)==0 && data(ii,6)==1
                    store(ii,1)=2;
               end
      end
  resp=store;      
end

