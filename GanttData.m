function [gap,gap_act] = GanttData(Timetable,N_Series,Categories)

start_points = ones(1,N_Series);
gap = double.empty(0,N_Series);
gap_act = [];
point_values = double.empty(0,N_Series);
while any(start_points<length(Timetable))
    for r = 1:N_Series
        if start_points(1,r)<length(Timetable)
            point_values(r) = Timetable(start_points(1,r),r);
        else
            point_values(r) = NaN;
        end
    end
    for i = Categories(1):Categories(end)
        if any(point_values==i)
            gap_act = [gap_act,i];
            gap = [gap; zeros(1,N_Series)];
            ind = find(point_values == i);
            for j = 1:length(ind)
                gap_ind = find(diff([false,Timetable(start_points(ind(j)):end,ind(j))'==i,false])~=0);
                gap_len = gap_ind(2:2:end)-gap_ind(1:2:end-1);
                gap(end,ind(j)) = gap_len(1);
                start_points(ind(j)) = start_points(ind(j))-1+gap_ind(2);
            end
        end
    end
end


end

