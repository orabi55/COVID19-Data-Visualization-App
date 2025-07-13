classdef Region < handle
    properties
        World
        Country = Region.empty 
        States    % For Global: countries; For Country: states
        Cases
        Deaths
        Dates
    end

    methods
        function obj = Region(World,Country,States,data,Dates)
                    obj.World = World;
                    obj.Dates = Dates;
                    obj.Country = Country;
                    obj.States = States;
                    if ~isempty(data)
                        obj.Cases = cellfun(@(x) x(1), data);
                        obj.Deaths = cellfun(@(x) x(2), data);
                    else
                        obj.Cases = [];
                        obj.Deaths = [];
                    end
           
        end

        function daily = getDaily(obj, field , idx)
            % Compute daily new cases or deaths
            vals = obj.(field)(idx,1:end);
            daily = [vals(1), diff(vals)];
            daily(daily < 0) = 0;
        end

        function both = ComputeFieldAvg(obj, field, mode, avgWindow , idx)
            % mode = 'Daily' or 'Cumulative'
            % field = 'Cases' or 'Deaths'
            if strcmp(mode, 'Daily')
                both = obj.getDaily(field,idx);
            else
                both = obj.(field)(idx,1:end);
            end
            if avgWindow > 1
                both = movmean(both, [avgWindow-1, 0]);
            end
        end
    end
end
