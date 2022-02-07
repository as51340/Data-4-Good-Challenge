using CSV
using DataFrames
using Query
using Statistics
using PyPlot


function clean_data_by_country(dataset :: DataFrame, country :: String) :: DataFrame
    res = @from i in dataset begin
        @where i.climate_crisis != "NA" && i.country == country
        @select {i.country, i.climate_crisis, i.exag_env}
        @collect DataFrame
    end
    return res
end

function create_bins(dataset :: DataFrame)
    below = 0
    between = 0
    above = 0
    for i=1:size(dataset, 1)
        val = dataset[i, 3]
        if val < 5
            below+=1
        elseif val >= 5 && val < 12
            between+=1
        else
            above += 1
        end
    end
    return below, between, above
end




issp_survey = read_file("./data/issp_survey.csv")
denmark_people = clean_data_by_country(issp_survey, "Denmark")
russia_people = clean_data_by_country(issp_survey, "Russia")
below_den, between_den, above_den = create_bins(denmark_people)
below_rus, between_rus, above_rus = create_bins(russia_people)
