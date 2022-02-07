using CSV
using DataFrames
using Query
using Statistics
using PyPlot


function get_co2_per_years_for_country(dataset :: DataFrame, country :: String)
    res = @from i in dataset begin
        @where i.country == country && i.co2 != "NA"
        @select {i.country, i.year, i.co2}
        @collect DataFrame
    end
    return res
end

function get_co2_from_dataset(dataset :: DataFrame)
    values = Vector{Float64}()
    for i=1:size(dataset, 1)
        push!(values, parse(Float64, convert(String, dataset[i, :co2])))
    end
    return values
end

function plot_co2_movement(co2 :: DataFrame, filename :: String, my_title :: String)
    years = co2[!, :year]
    values = get_co2_from_dataset(co2)

    fig, ax = PyPlot.subplots()
    fig.set_size_inches(18.5, 10.5)
    lp = PyPlot.plot(years, values)
    ax.set_ylabel("CO2", fontsize=30)
    ax.set_xlabel("Years", fontsize=30)
    title(my_title, fontsize=30)
    fig.savefig(filename)
    clf()
    cla()
end

emissions_energy_consumptions = read_file("./data/emissions_energy_consumptions.csv")
russia_co2 = get_co2_per_years_for_country(emissions_energy_consumptions, "Russia")
china_co2 = get_co2_per_years_for_country(emissions_energy_consumptions, "China")
usa_co2 = get_co2_per_years_for_country(emissions_energy_consumptions, "United States")
denmark_co2 = get_co2_per_years_for_country(emissions_energy_consumptions, "Denmark")

# Plot russia 
plot_co2_movement(russia_co2, "./plots/russia_co2.png", "Russia co2 per years")
plot_co2_movement(china_co2, "./plots/china_co2.png", "China co2 per years")
plot_co2_movement(usa_co2, "./plots/usa_co2.png", "USA co2 per years")
plot_co2_movement(denmark_co2, "./plots/denmark_co2.png", "Denmark Co2 per years")