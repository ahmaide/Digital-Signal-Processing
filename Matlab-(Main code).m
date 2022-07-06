load handel.mat

clc;
close all; 
clear all; 

male =0;
female =0; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% open file and select  
[file,path] = uigetfile('*.wav'); 
if isequal(file,0)
   disp('You did not select any file - operation terminated');
   [file,path] = uigetfile('*.wav');
else
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % audio file reading
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    f = fullfile(path,file);
    disp(['You selected: ',f]);
    % read wav file 
    [y,Fs] = audioread(f)
    N = length(y); % sample lenth
    slength = N/Fs; % total time span of audio signal
    disp(slength)
    t = linspace(0, N/Fs, N);
    plot(t, y); % pplots the audio
    disp(Fs)
    data = y(4000:5000); % taking 1000 sample 
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % pitch frequency estimation - FOR VERIFICATION -- commented for now.
    % un-comment to compare
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
   %% f0 = pitch(y,Fs)        
   %% disp("PITCH")  
   %% disp(length(f0))
   %% for i = 1: length(f0)
   %%     if f0(i) > 90 & f0(i) < 200
   %%        
   %%         male = male + 1;
   %%     else if f0(i) > 200 & f0(i) <300
   %%             disp("f")
   %%            female = female +1;
   %%         end 
   %%     end 
   %% end 
   %% if male > female
   %%     disp("MALE")
   %% else disp("FEMALE");
   %% end 
   %% disp(mean(f0));                   
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    % do framing
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    f_d = 0.2;
    f_size = round(f_d * Fs);
    n = length(y);
    n_f = floor(n/f_size);  %no. of frames
    temp = 0;
    disp(n_f)
    % iterate through all frames 
    for i = 1 : n_f 
     frames(i,:) = y(temp + 1 : temp + f_size);
     temp = temp + f_size;
     [lags{i},acf] = xcorr(frames(i,:),frames(i,:))
     if i==10
        [acf,lags{i}] = xcorr(frames(i,:),frames(i,:))
        stem(lags{i},acf);
     end 
%      if i==10
%          figure;
%          autocorr(frames(i,:));
%      end
    
    lags{i} = lags{i}(2:end); % removing first element 1 in each lag 
    end % for i= 1 : n_f
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
   if length(lags) == n_f
       disp("TRUE completion")
   else fprintf('Lost %d frames',n_f - length(lags))
   end 
       
   max_vals=[]
   for i=1 : length(lags)
       max_vals = [max_vals,max(lags{i})];
   end 
   
   max_pitches =[]
   for i=1 : length(max_vals)
	 max_pitches = [max_pitches,1/max_vals(i)];
   end 
   for i=1 :length(max_pitches)
       if max_pitches(i) > 95 & max_pitches(i)<190
            male = male+1
       else if max_pitches(i) >190 & max_pitches<270
            female=female+1
       end
       end 
   end
   
   if male>female
       disp("Voice of a MALE")
   else disp("Voice of a FEMALE");
   end 
end 