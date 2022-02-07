using CSV
using DataFrames
using Query
using Statistics
using PyPlot

function read_file(filename :: String) :: DataFrame
    return DataFrame(CSV.File(filename))
end

function get_data_for_year(dataset :: DataFrame, year :: Int64) :: DataFrame
    emissions_country = @from i in dataset begin
        @where i.year == year
        @select {i.country, i.share_global_co2}
        @collect DataFrame
    end
    return emissions_country
end

function get_columns_from_data(dataset :: DataFrame)
    countries, co2_per_capita = Vector{String}(), Vector{Float64}()
    for i=1:size(dataset, 1)
        if dataset[i, 2] != "NA"
            push!(countries, dataset[i, 1])
            push!(co2_per_capita, parse(Float64, dataset[i, 2]))
        end
    end
    return countries, co2_per_capita
end

function get_top_co2_consumers(dataset :: DataFrame, n :: Int64)
    sort!(dataset, [:share_global_co2], rev = true)
    return dataset[1:n, [:country, :share_global_co2]]
end

function clean_share_global_co2(dataset :: DataFrame)
    res = @from i in dataset begin
        @where i.share_global_co2 != "NA"
        @select {i.country, i.year, i.share_global_co2}
        @collect DataFrame
    end
    return res
end

function plot_histogram_top_consumers(dataset :: DataFrame, filename :: String, my_title :: String)
    countries, co2_per_capita = get_columns_from_data(dataset)
    x = [1:1:length(countries);]
    display(co2_per_capita)
    display(x)
    fig, ax = PyPlot.subplots()
    fig.set_size_inches(18.5, 10.5)
    b = PyPlot.bar(x, co2_per_capita,color="#00008b",align="center", tick_label=countries)
    ax.set_ylabel("Share of co2", fontsize=30)
    title(my_title, fontsize=30)
    fig.savefig(filename)
    clf()
    cla()
end


# Read your datasets
# climate_change_data = read_file("./data/climate_change.csv")
# see_level_change = read_file("./data/see_level_change.csv")
# economic_indicators = read_file("./data/economic_indicators.csv")
# issp_survey = read_file("./data/issp_survey.csv")

emissions_energy_consumptions = read_file("./data/emissions_energy_consumptions.csv")
emissions_energy_consumptions = clean_share_global_co2(emissions_energy_consumptions)
# Country vs co2
emission_country_1970 = get_data_for_year(emissions_energy_consumptions, 1970)
emission_country_1990 = get_data_for_year(emissions_energy_consumptions, 1990)
emission_country_2010 = get_data_for_year(emissions_energy_consumptions, 2010)
emission_country_2019 = get_data_for_year(emissions_energy_consumptions, 2019)

# Get top consumers
top_consumers_1970 = get_top_co2_consumers(emission_country_1970, 10)
top_consumers_1990 = get_top_co2_consumers(emission_country_1990, 10)
top_consumers_2010 = get_top_co2_consumers(emission_country_2010, 10)
top_consumers_2019 = get_top_co2_consumers(emission_country_2019, 10)

# Plot top consumers
plot_histogram_top_consumers(top_consumers_1970, "./plots/top_consumers_1970", "Top co2 consumers 1970")
plot_histogram_top_consumers(top_consumers_1990, "./plots/top_consumers_1990", "Top co2 consumers 1990")
plot_histogram_top_consumers(top_consumers_2010, "./plots/top_consumers_2010", "Top co2 consumers 2010")
plot_histogram_top_consumers(top_consumers_2019, "./plots/top_consumers_2019", "Top co2 consumers 2019")

# Take countries which are not going to attend
# Russia, China, United States had problems with Donald Trump


