using PyPlot
using CSV
using DataFrames
using Query
using Statistics

function get_ind_percentage_for_country_during_years(dataset :: DataFrame, country:: String)
    res = @from i in dataset begin
        @where i.country == country && i.ind_percent_gdp != "NA"
        @select {i.country, i.year, i.ind_percent_gdp}
        @collect DataFrame
    end
    return res
end

function get_ind_percent_values(ind_percent :: DataFrame)
    values = Vector{Float64}()
    for i=1:size(ind_percent, 1)
        push!(values, parse(Float64, convert(String, ind_percent[i, :ind_percent_gdp])))
    end
    return values
end

function plot_ind_percentage(ind_percent :: DataFrame, filename :: String, my_title :: String)
    years = ind_percent[!, :year]
    values = get_ind_percent_values(ind_percent)

    fig, ax = PyPlot.subplots()
    fig.set_size_inches(18.5, 10.5)
    lp = PyPlot.plot(years, values),
    ax.set_ylabel("Industry percentage of gdp", fontsize=30)
    ax.set_xlabel("Years", fontsize=30)
    title(my_title, fontsize=30)
    fig.savefig(filename)
    clf()
    cla()
end

economic_indicators = read_file("./data/economic_indicators.csv")

russia_ind_percent = get_ind_percentage_for_country_during_years(economic_indicators, "Russia")
china_ind_percent = get_ind_percentage_for_country_during_years(economic_indicators, "China")
denmark_ind_percent = get_ind_percentage_for_country_during_years(economic_indicators, "Denmark")

plot_ind_percentage(russia_ind_percent, "./plots/russia_ind_percent.png", "Russia industry percentage of GDP per years")
plot_ind_percentage(china_ind_percent, "./plots/china_ind_percent.png", "China industry percentage per years")
plot_ind_percentage(denmark_ind_percent, "./plots/denmark_ind_percent.png", "Denmark industry percentage per years")