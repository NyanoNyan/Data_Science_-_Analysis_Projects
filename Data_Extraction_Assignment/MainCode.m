clc, clear all;
tic;
D=[]; %Storage of Data
% Adding path to the dat files, data files of the participants
addpath('Topic 1\additional files');
% Total number of participants that did the experiment
totalSub =40;trainSet=56;testSet=14;
% Look to load the data for each participats, from 1 to 40 in total
for i = 1:totalSub
    %% Loading the data of the participants
    % Gets the name of the file
      name= ['S',num2str(i),'.dat'];
    % Opens the corresponding file
      fid  = fopen(name,'r');
    % Need to only take the first 8 coloumns for the conditions 
      d = textscan(fid, '%s%s%s%s%s%s%s%s','CollectOutput',2);
    % Data is stored in a cell 
      data = d{1,1};fid  = fclose(fid);
      data = erase(data,"%"); % Some RT has % sign, delete the % character from the RT data 
   %% Data Gathering and structuring 
   %%  Subject Code
      Subno = string(data(1,1));
      
   %%  Finds the order of FnoA, either the condition was done first or second
      IndexFnoA = find(contains(data,'FnoA')); 
      IndexAnoF = find(contains(data,'AnoF'));
      if IndexFnoA<IndexAnoF
          FnoAorder = 1;
      else
          FnoAorder = 2;
      end
      
   %% Finding FnoAformat
     % Finds index of FnoA with that data gets the condition data
     IndexFormat = IndexFnoA-1; condFormat = char(data(IndexFormat));
                 if condFormat(1)=='w'
                    FnoAformat='FBK=W';
                 else
                     FnoAformat='FBK=D';
                 end
                 FnoAformat=string(FnoAformat);
   %% Counterbalancing Conditon Extraction
     cbcond = str2double(data(2,1)); 
     
   %% Phase Extraction
        % Position of Training Data name
         IndexTrainPhase = IndexFnoA+1; condPhaseTrain = string(data(IndexTrainPhase));condPhaseTrain=erase(condPhaseTrain,"ing");
        % Position of Test Data  name
         IndexTestPhase = find(contains(data,'Test')); IndexTestPhase = IndexTestPhase(FnoAorder); 
         condPhaseTest = string(data(IndexTestPhase));
         
   %% Training and Test data
     %% Include or not | When FnoA is done 2nd training trials 53-56 are not 
     % included
        IncTrain = ones(trainSet,1);
        IncTest = ones(testSet,1);
            if FnoAorder==2
                IncTrain(53:56,:)=0;
            end
   %% Extract Training phase data
   trainData = str2double(data(IndexTrainPhase+1:IndexTestPhase-1,:));
   % Train data with include
   trainData(:,size(trainData,2)+1)=IncTrain;
   % Extract number 70 for the end index for Test Phase
   Index70End = find(contains(data(:,1),'70')); 
   %% Extract Test phase data
   testData =  str2double(data(IndexTestPhase+1:Index70End,:)); 
   % Test data with include
   testData(:,size(testData,2)) = IncTest;
   %% Probability Outcome
   % Initializing beginning probability score to 0.5
   prob_outStor=0.5*ones(size(trainData,1),1);
   prob_outStorTes=0.5*ones(size(testData,1),1);
   % Function 'prob' that calculates the probability value 
   prob_out1Train = prob(prob_outStor,trainData);
   prob_out1Test = prob(prob_outStorTes,testData);
   %% Sorting out the outcome issue/ Need to check, usualy it should be 0=1,1=2
   % Set as the same in Excel file, 0=2 & 1=1 for outcome
   trainData(trainData(:,6)==0,6)=2; 
   %% Gathering resp  
   % Data storage response train data
   resp_Train=zeros(size(trainData,1),1);resp_Test=zeros(size(testData,1),1);
   % Function calculating response data for training data
   resp_Train=gathResp(trainData,resp_Train);
   
           %% Resp_corr for training phase 
           resp_corrTrain=zeros(size(trainData,1),1); % Storage of rep_corr training phase
           resp_corrTrain=corrResp(prob_out1Train,resp_Train,resp_corrTrain); % runs the function corrResp to get the rep_corr train data
            %% Resp_corr for Test phase 
           resp_corrTest=zeros(size(testData,1),1); % Storage for rep_corr test phase
           resp_corrTest =corrResp(prob_out1Test,testData(:,6),resp_corrTest);% runs the function corrResp to get the rep_corr test data
           % Blank Repeat variables for Test data for storing the data at the end
            blankRepTest=repmat(' ',[1 size(testData,1)])';
            
           %% Nitems and FnoAcorr value
           % Looks at RTs which are less than the baseline for fast RT, set
           % as 0.2. If value is less than 0.2 and if the resp_corr data is
           % either 0 or 1 gets the sum values.
           baseline=sum(testData(:,7)<0.2 & (resp_corrTest==0|resp_corrTest==1 ));
           % Checks value which that should not be inluded which have
           % resp_corr as 1
           checker=sum(testData(:,7)<0.2 & resp_corrTest==1 );
           % Gathers number of correct responses
           numCorr=nansum(resp_corrTest)-checker;
           % Calculates number of valid test phase response for the FnoA condition
           Nitems_FnoA=10-baseline;
           % Calculated the proportion correct in test phase of the FnoA
           % condition and stores the value of each participant
           FnoAcorr = numCorr/Nitems_FnoA; FnoAcorrStore(i)=FnoAcorr;
           % Blank repeats of the size of train data
           tFn=repmat(" ",[1 size(trainData,1)])';tNit=repmat(" ",[1 size(trainData,1)])';
           % Storage of FnoAcorr and Nitems_FnoA so the size of the final
           % data is the same
           tFn(1,1)=FnoAcorr;tNit(1,1)=Nitems_FnoA;
           
   %% Collecting all the data
   % Stores in the order below 
   % [subno, FnoAorder, FnoAformat, cbcond, trailnum, phase, include, cue1,
   % cue2, cue3, cue4, outcome, response, prob_out1, resp_rew, resp_corr,
   % RT, FnoAcorr]
   
   % Training Data
   niceDataTrain=[repelem(Subno,size(trainData,1))', repelem(FnoAorder,size(trainData,1))',...
       repelem(FnoAformat,size(trainData,1))', repelem(cbcond,size(trainData,1))', trainData(:,1), repelem(condPhaseTrain,size(trainData,1))' ...
       trainData(:,9), trainData(:,2:6),resp_Train, prob_out1Train,trainData(:,7),resp_corrTrain,trainData(:,8),tFn,tNit];
   % Test Data
   niceDataTest=[repelem(Subno,size(testData,1))', repelem(FnoAorder,size(testData,1))',...
       repelem(FnoAformat,size(testData,1))', repelem(cbcond,size(testData,1))', testData(:,1), repelem(condPhaseTest,size(testData,1))' ...
       testData(:,8), testData(:,2:5), blankRepTest,testData(:,6),prob_out1Test,blankRepTest,...
       resp_corrTest,testData(:,7),blankRepTest,blankRepTest];
   
   % Title for the variables
   Title= ["Subno" ,"FnoAorder" ,"FnoAformat" ,"cbcond" ,"trialnum" ,"phase" ,"include"...
       "cue1" ,"cue2", "cue3", "cue4", "outcome", "response", "prob_out1","resp_rew"...
        "resp_corr","RT","FnoAcorr","Nitems_FnoA"];
               if i ==1
                   % Just stores the title in the first run when i=1
               Store=[Title;niceDataTrain;niceDataTest];
               else
               Store=[niceDataTrain;niceDataTest];   
               end 
   D = [D; Store]; % Storage of all the Data     
end
toc;
gg=FnoAcorrStore'; %FnoAcorr for each participant
xlswrite('DataFile.xls', D);  % Save it as an Excel file
% xlswrite('DataFile.csv', D); % Save as csv File


