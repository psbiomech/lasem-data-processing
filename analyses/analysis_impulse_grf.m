function datastruct = analysis_impulse_grf(datastruct,bbmeta)


%analysis_impulse_grf: Impulse of ground force
%   Prasanna Sritharan, April 2018
% 
% -------------------------------------------------------------------- 
%     Copyright (C) 2018 Prasanna Sritharan
%     Copyright (C) 2018 La Trobe University
% 
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.
% --------------------------------------------------------------------  


    % input data group name
    GRPIN = bbmeta.BBGROUPS{4};
    GRPOUT = upper(bbmeta.BBANALYSES{3});   

    % midstring
    INMIDSTR = GRPIN(1:end-1);
    OUTMIDSTR = bbmeta.BBANALYSES{3};    
    
    % integral over entire time window
    qnames = fieldnames(datastruct.(GRPIN));        
    for q=1:length(qnames)     
        qpresuf = regexpi(qnames{q},['(\w*)' INMIDSTR '(\w*)'],'tokens');
        qoutname = [qpresuf{1}{1} OUTMIDSTR qpresuf{1}{2}];
        datastruct.(GRPOUT).(qoutname).net = zeros(1,3);
        for x=1:3
            
            % time vector
            time = datastruct.TIMES.relative';
            
            % net integral
            data = datastruct.(GRPIN).(qnames{q})(:,x);
            datastruct.(GRPOUT).(qoutname).net(x) = trapz(time,data);
                        
            % positive integral
            dpos = data;
            dpos(dpos<0) = 0;
            datastruct.(GRPOUT).(qoutname).positive(x) = trapz(time,dpos);
                        
            % negative integral
            dneg = data;
            dneg(dneg>0) = 0;            
            datastruct.(GRPOUT).(qoutname).negative(x) = trapz(time,dneg);

            % first and second half of time window
            tranges = {1:round(length(time)/2),round(length(time)/2):length(time)};
            datastruct.(GRPOUT).(qoutname).half(:,x) = [trapz(time(tranges{1}),data(tranges{1})) trapz(time(tranges{2}),data(tranges{2}))];            
            
            % define segments
            posbnds = [find(diff([0 (data>0)'])==1);find(diff([(data>0)' 0])==-1)];            
            negbnds = [find(diff([0 (data<0)'])==1);find(diff([(data<0)' 0])==-1)];
            possign = ones(1,size(posbnds,2));
            negsign = -ones(1,size(negbnds,2));
            bounds = zeros(2,size(posbnds,2)+size(negbnds,2));
            ssign = zeros(1,size(posbnds,2)+size(negbnds,2));
            p = 1;
            n = 1;
            for b=1:2:size(bounds,2)
                if (p>size(posbnds,2))
                    bounds(:,b:end) = negbnds(:,n:end);
                    ssign(:,b:end) = negsign(n:end);
                    break;
                elseif (n>size(negbnds,2))
                    bounds(:,b:end) = posbnds(:,p:end);
                    ssign(:,b:end) = possign(p:end);
                    break;
                else
                    bounds(:,b:b+1) = [posbnds(:,p), negbnds(:,n)];
                    ssign(b:b+1) = [possign(p), negsign(n)];
                end
                p = p + 1;
                n = n + 1;
            end       
                     
            % segment integral
            segint = zeros(1,size(bounds,2));
            for s=1:size(segint,2)
                trange = [bounds(1,s):bounds(2,s)];
                if (length(trange)==1)
                    segint(s) = 0;
                else
                    segint(s) = trapz(time(trange),data(trange));
                end
            end
            datastruct.(GRPOUT).(qoutname).segments.(bbmeta.dirs{x}) = segint;
            
        end
    end

end

