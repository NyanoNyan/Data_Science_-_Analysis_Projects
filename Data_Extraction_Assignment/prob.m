function [prob_out] = prob(initialProb,Data)
 % Probability Outcome --- If values are 1 in cue1 & 2 then cuescore gets 
 % 0.25. Score gets -0.25 if cue3 & cue4 have got 1 coded. Final
 % propability calculation is done in prob_out with the all the cue scores. 
   cue1Score=zeros(size(Data,1),1); cue2Score=zeros(size(Data,1),1);
   cue3Score=zeros(size(Data,1),1); cue4Score=zeros(size(Data,1),1);
   
      cue1Score(Data(:,2)== 1) = 0.25; cue2Score(Data(:,3)== 1) = 0.25;
      cue3Score(Data(:,4)== 1) = -0.25; cue4Score(Data(:,5)== 1) = -0.25;
  
   prob_out = initialProb +cue1Score+cue2Score+cue3Score+cue4Score;
end

