%  this script does fastcap to matlab matrix from either file or clipboard
% 
str = clipboard('paste'); disp('Reading from clipboard');
% 
% % or from file
str = fileread('example.txt'); disp('Reading from file');
% % open filed
str = regexp(str, 'attofarads.*','match');
str = str{1}; % weird.
re = regexp(str,'\n', 'split');

count = 0;
data = [];
name = [];
nc = 1; %counter for names
for i=1:length(re)-1
    if (count > 0)
%         re{i} = regexprep(re{i},' *',' ')
        s = regexp(re{i},' *', 'split');
        s = regexprep(s,'\r|^ *| *$',''); % trims. 
        if (length(s) == count+2)
            name{nc} = regexprep(s{1},'\..*','');
            nc = nc + 1;
            data = [data; s(3:count+2)];
        end
    end
    if (count == 0 && sum(regexp(re{i},'1 *2'))) % assume at least 2 gates
        s = regexprep(re{i},'\r|^ *| *$',''); % trims.
        s = regexprep(s,'\r|^ *| *$',''); % trims. 
        % readfile incurs a penalty of a \r
        s = regexp(s,' *', 'split');
        count = length(s) ;
  
    end
end

disp(horzcat([{''}, name]', ...
        vertcat(name,...
                data)))

disp 'please check that this matches your output from fastcap'
disp(sprintf('we found %d gates, does this match?',count))

caps = data;
save('fc.mat','caps')
