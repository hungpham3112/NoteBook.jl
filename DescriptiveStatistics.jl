### A Pluto.jl notebook ###
# v0.19.11

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ 8610c200-0b39-11ed-38d9-531c8edc5b15
begin 
	using Distributions    # Create random variables
	using StatsBase        # Basic statistical support
	using CSV              # Reading and writing CSV files
	using DataFrames       # Create a data structure
	using HypothesisTests  # Perform statistical tests
	using StatsPlots       # Statistical plotting
	using GLM              # General linear models
	using PlutoUI
end

# ╔═╡ 3fe296d6-6d88-4e26-aeb9-7e72df6a1c84
md"""
# Creating random variables
"""

# ╔═╡ f46d35a4-58ce-4d4e-a9ab-b367c3a74dcb
md"""
### StatsBase function
"""

# ╔═╡ 7ad1c3e7-6b74-4b50-b3db-1d5b1e58fb7b
md"""
# DataFrames
"""

# ╔═╡ b50dc090-167b-4357-b760-087103c27eb9
md"""
# Descriptive Statistics using dataframe object
"""

# ╔═╡ 5471cac1-c3a2-4194-aa63-178371403b7f
md"""
# Visualizing the data
"""

# ╔═╡ 473830b0-0f1d-422a-934e-9ef603b848ff
@bind choose Slider(100:1000, default=1500)  # Uniform distribution

# ╔═╡ 9ebe47d5-fd41-4250-bbfe-472317192cdc
begin
	age = rand(0:choose, 100);  # Uniform distribution
	wcc = round.(rand(Distributions.Normal(12, 2), 100), digits = 1)  # Normal distribution & round to one decimal place
	crp = round.(Int, rand(Distributions.Chisq(4), 100)) .* 10  # Chi-squared distribution with broadcasting & alternate round()
	treatment = rand(["A", "B"], 100); # Uniformly weighted
	result = rand(["Improved", "Static", "Worse"], 100);  # Uniformly weighted
end

# ╔═╡ 55b5b0ef-dd5f-4539-afb2-dd6886ee2e90
mean(age)

# ╔═╡ b11bd0c8-70ad-4575-8521-14f4560b5133
# Median of the age variable
median(age)

# ╔═╡ 923af935-fb1c-4745-a236-349ea882ef34
# Standard deviation of age
std(age)

# ╔═╡ 8b41b013-4284-432d-bbd9-ecd18688d87d
# Variance of age
var(age)

# ╔═╡ e47e9375-868d-47d9-a243-51030534769a
StatsBase.mean(wcc)

# ╔═╡ 88107ef1-c2fe-49ad-9e07-fd157741df35
std(crp)

# ╔═╡ 79055b0d-d24c-4bf3-8cfa-c2df6c18bd1f
StatsBase.describe(age)

# ╔═╡ 4d469649-ca42-421e-b9b1-aa737de1a6aa
# The summarystats() function omits the length and type
summary_for_wcc = StatsBase.summarystats(wcc)

# ╔═╡ cad92947-59d6-4b7c-ab88-538548177e90
typeof(summary_for_wcc)

# ╔═╡ 7d0970d3-f740-4173-9969-7e172f97b287
# Creating a dataframe object based on DataFrames package.
df = DataFrame(Age = age, WCC = wcc, CRP = crp, Treatment = treatment, Result = result)

# ╔═╡ aae1a667-b5a9-428b-9b43-932bc72ca499
# Numbers of rows and columns
size(df)

# ╔═╡ e0f577d3-cffa-4e0d-a653-5a6e44bc9da9
first(df, 5)

# ╔═╡ 6daaa663-a389-43f0-a212-8086cbcde104
last(df, 20)

# ╔═╡ c7e05d16-5b8f-4ce7-8422-870e0032aee3
dataA = df[df[:, :Treatment] .== "A", :]

# ╔═╡ eb605e9c-2440-484c-9a65-bbdb0bdd6750
dataB = df[df[:, :Treatment] .== "B", :]

# ╔═╡ 49ed2079-296b-4ab5-923f-db940d19f6e6
describe(df)

# ╔═╡ 6f71eeb1-e5dd-40a2-ac06-8770f7c2b1e2
grouped_df = groupby(df, :Treatment)

# ╔═╡ 4d0a730e-5e28-43ea-8246-748104db38db
combine(grouped_df, nrow => :Nrow)

# ╔═╡ f06d9df6-78be-4a48-9776-32640528afe0
combine(size, grouped_df)

# ╔═╡ 300651d4-973d-4f50-bf4d-f45109f9dcff
combine(grouped_df, :Age => mean)

# ╔═╡ bbe7e423-3915-49be-a557-3daee5d0bbd8
combine(grouped_df, :WCC => std)

# ╔═╡ dd4c57dd-2c18-4d3f-8b3f-1da99df28048
combine(grouped_df, :Age => describe)

# ╔═╡ 35885ff6-ab93-4fbb-ade4-40624fb9616a
md"""
###### Note that ```@df``` macro (from StatsPlots) is used to pass the column to the function
"""

# ╔═╡ 3b45917e-ae38-4697-a6e8-c995c4f5eb2b
@df df density(:Age, group = :Treatment, 
	title = "Distribution of ages by treatment group", 
	xlab = "Age", 
	ylab = "Distribution",
	legend = :topright
)

# ╔═╡ 0a8512ca-749b-400b-9181-72b381df4c38
@df df density(:Age, group = :Result,
	title = "Distribution of ages by result group",
	xlab = "Age",
	ylab = "Distribution",
	legend = :topright
)

# ╔═╡ 283f77c8-ade1-45de-b1f3-6a33b23f14e1
@df df density(:Age, group = (:Treatment, :Result),
	title = "Distribution of ages by treatment and result group",
	xlab = "Age",
	ylab = "Distribution",
	legend = :topright
)

# ╔═╡ ce3c3a94-5b5c-4ef9-8290-15abce2f1486
@df df boxplot(:Treatment, :WCC, 
	lab = "Wcc",
	title = "White cell count by treatment group",
	xlab = "Groups",
	ylab = "Wcc"
)

# ╔═╡ 0b08a213-6363-4b92-9964-d768d4840548
@df df cornerplot([:Age :WCC :CRP],
	grid = false,
	compact = true,
)

# ╔═╡ 124cd518-3ba7-4361-a935-11bbcd0685a2
test_df = DataFrame(Group=rand(["A", "B"], 20), Variable1=randn(20), Variable2=rand(20))

# ╔═╡ c5f8157f-6390-46e1-93ec-d433cf15a682
view(df, 3, :)

# ╔═╡ Cell order:
# ╠═8610c200-0b39-11ed-38d9-531c8edc5b15
# ╟─3fe296d6-6d88-4e26-aeb9-7e72df6a1c84
# ╠═9ebe47d5-fd41-4250-bbfe-472317192cdc
# ╟─f46d35a4-58ce-4d4e-a9ab-b367c3a74dcb
# ╠═55b5b0ef-dd5f-4539-afb2-dd6886ee2e90
# ╠═b11bd0c8-70ad-4575-8521-14f4560b5133
# ╠═923af935-fb1c-4745-a236-349ea882ef34
# ╠═8b41b013-4284-432d-bbd9-ecd18688d87d
# ╠═e47e9375-868d-47d9-a243-51030534769a
# ╠═88107ef1-c2fe-49ad-9e07-fd157741df35
# ╠═79055b0d-d24c-4bf3-8cfa-c2df6c18bd1f
# ╠═4d469649-ca42-421e-b9b1-aa737de1a6aa
# ╠═cad92947-59d6-4b7c-ab88-538548177e90
# ╠═7ad1c3e7-6b74-4b50-b3db-1d5b1e58fb7b
# ╠═7d0970d3-f740-4173-9969-7e172f97b287
# ╠═aae1a667-b5a9-428b-9b43-932bc72ca499
# ╠═e0f577d3-cffa-4e0d-a653-5a6e44bc9da9
# ╠═6daaa663-a389-43f0-a212-8086cbcde104
# ╠═c7e05d16-5b8f-4ce7-8422-870e0032aee3
# ╠═eb605e9c-2440-484c-9a65-bbdb0bdd6750
# ╟─b50dc090-167b-4357-b760-087103c27eb9
# ╠═49ed2079-296b-4ab5-923f-db940d19f6e6
# ╠═6f71eeb1-e5dd-40a2-ac06-8770f7c2b1e2
# ╠═4d0a730e-5e28-43ea-8246-748104db38db
# ╠═f06d9df6-78be-4a48-9776-32640528afe0
# ╠═300651d4-973d-4f50-bf4d-f45109f9dcff
# ╠═bbe7e423-3915-49be-a557-3daee5d0bbd8
# ╠═dd4c57dd-2c18-4d3f-8b3f-1da99df28048
# ╟─5471cac1-c3a2-4194-aa63-178371403b7f
# ╠═473830b0-0f1d-422a-934e-9ef603b848ff
# ╟─35885ff6-ab93-4fbb-ade4-40624fb9616a
# ╟─3b45917e-ae38-4697-a6e8-c995c4f5eb2b
# ╠═0a8512ca-749b-400b-9181-72b381df4c38
# ╠═283f77c8-ade1-45de-b1f3-6a33b23f14e1
# ╠═ce3c3a94-5b5c-4ef9-8290-15abce2f1486
# ╠═0b08a213-6363-4b92-9964-d768d4840548
# ╠═124cd518-3ba7-4361-a935-11bbcd0685a2
# ╠═c5f8157f-6390-46e1-93ec-d433cf15a682
