using CSV
using DataFrames
using Query
using Statistics
using PyPlot


function get_ind_percentage_for_country_during_years(dataset :: DataFrame, country:: String)
    res = @from i in dataset begin
        @where i.country == country && i.real_gdp != "NA"
        @select {i.country, i.year, i.real_gdp}
        @collect DataFrame
    end
    return res
end

function get_gdp(dataset :: DataFrame)
    values = Vector{Float64}()
    for i=1:size(dataset, 1)
        push!(values, parse(Float64, convert(String, dataset[i, :real_gdp])))
    end
    return values
end

function plot_economic_growths(dataset :: DataFrame, filename :: String, my_title :: String)
    years = dataset[!, :year]
    values = get_gdp(dataset)
    values = log.(values)    

    fig, ax = PyPlot.subplots()
    fig.set_size_inches(18.5, 10.5)
    lp = PyPlot.plot(years, values)
    ax.set_ylabel("Absolute GDP(ln)", fontsize=30)
    ax.set_xlabel("Years", fontsize=30)
    title(my_title, fontsize=30)
    fig.savefig(filename)
    clf()
    cla()
end

economic_indicators = read_file("./data/economic_indicators.csv")

russia_gdp = get_ind_percentage_for_country_during_years(economic_indicators, "Russia")
china_gdp = get_ind_percentage_for_country_during_years(economic_indicators, "China")
denmark_gdp = get_ind_percentage_for_country_during_years(economic_indicators, "Denmark")

# Plot economic plot_economic_growths
plot_economic_growths(russia_gdp, "./plots/russia_gdp.png", "Russia GDP")
plot_economic_growths(china_gdp, "./plots/china_gdp.png", "China GDP")
plot_economic_growths(denmark_gdp, "./plots/denmark_gdp.png", "Denmark GDP")

