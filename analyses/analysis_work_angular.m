function bbstruct = analysis_work_angular(bbstruct,bbmeta,subj,trial)


%analysis_work_angular Joint rotational work
%   Prasanna Sritharan, August 2017
%
%   Requires joint power in BB structure

    % input data group name
    GRPIN = bbmeta.BBGROUPS{3};
    GRPOUT = bbmeta.BBANALYSES{1};

    % integral over entire time window
    qnames = fieldnames(bbstruct.(subj).(trial).(GRPIN));        
    for q=1:length(qnames)       
        bbstruct.(subj).(trial).(GRPOUT).(qnames{q}).net = zeros(1,3);
        for x=1:3
            
            % get channel data
            time = bbstruct.(subj).(trial).TIME;
            data = bbstruct.(subj).(trial).(GRPIN).(qnames{q})(:,x);
            
            % separate positive and negative signals
            dpos = data;
            dneg = data;
            dpos(dpos<0) = 0;
            dneg(dneg>0) = 0;
                        
            % integrate
            bbstruct.(subj).(trial).(GRPOUT).(qnames{q}).net(x) = trapz(time,data);
            bbstruct.(subj).(trial).(GRPOUT).(qnames{q}).positive(x) = trapz(time,dpos);
            bbstruct.(subj).(trial).(GRPOUT).(qnames{q}).negative(x) = trapz(time,dneg);
        
        end
    end

end

