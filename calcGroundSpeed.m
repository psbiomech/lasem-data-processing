function speed = calcGroundSpeed(itf,speedmarker,vfrange)


%CALCGROUNDSPEED Calculate the average ground speed
%   Prasanna Sritharan, August 2020

    % get the index of the marker used to calculate speed
    idx = itf.GetParameterIndex('POINT','LABELS');
    nvars = itf.GetParameterLength(idx);
    for n=0:nvars-1
        pname = itf.GetParameterValue(idx,n);
        if strcmpi(pname,speedmarker)
            spidx = n;
            break;
        end
    end
    
    % time and frame windows
    vfrate = itf.GetVideoFrameRate;
    vfirst = itf.GetVideoFrame(0);
    vlast = itf.GetVideoFrame(1);
    vfall0 = (vfirst:vlast)-vfirst;
    tfall0 = vfall0/vfrate;
    vfstance0 = (vfrange(1):vfrange(2))-vfrange(1);
    tfstance0 = vfstance0/vfrate;
    
    % get the point datastreams for the marker
    marker = struct;
    for x=1:3
        marker.all(:,x) = double(cell2mat(itf.GetPointDataEx(spidx,x-1,vfirst,vlast,'1')));
        marker.stance(:,x) = double(cell2mat(itf.GetPointDataEx(spidx,x-1,vfrange(1),vfrange(2),'1')));
    end

    % calculate average ground speed for stance
    % (assume: Y, foreaft; X, mediolateral; and units: mm)
    dispXYstance = (marker.stance(end,1:2)-marker.stance(1,1:2))/1000;
    delTstance = tfstance0(end)-tfstance0(1);
    speed.stance = norm(dispXYstance)/delTstance;
    
    % calculate average ground speed for whole trial
    % (assume: Y, foreaft; X, mediolateral; and units: mm)
    activeidx = find(marker.all(:,3));
    dispXY = (marker.all(activeidx(end),1:2)-marker.all(activeidx(1),1:2))/1000;
    delT = tfall0(activeidx(end))-tfall0(activeidx(1));
    speed.trial = norm(dispXY)/delT;
    
    
    
    
    
end

