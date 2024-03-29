### A Pluto.jl notebook ###
# v0.19.22

using Markdown
using InteractiveUtils

# ╔═╡ 17d45ab7-1af6-41a7-a0e4-e09c498c03b4
using DataFramesMeta, CSV, HTTP

# ╔═╡ e1ed72a0-3583-46bf-885a-4aefb845df7a
using StatsBase

# ╔═╡ ccdaf5ad-d3d2-468a-97ca-69a1cee35a1e
md"""
# DataFramesMeta.jl tutorial
This notebook is based on the tutorial in DataFramesMeta.jl [documentation](https://juliadata.github.io/DataFramesMeta.jl/stable/dplyr/)
"""

# ╔═╡ 4a4930c9-1428-4566-913f-6f22b07f7842
md"""
## Loading libraries
"""

# ╔═╡ fb0e1358-f3c6-4b53-8bfc-717f307c05fe
url = "https://raw.githubusercontent.com/genomicsclass/dagdata/master/inst/extdata/msleep_ggplot2.csv"

# ╔═╡ 54845cad-d928-491f-9538-a1775f1fdb51
mammals_sleep = CSV.read(HTTP.get(url).body, DataFrame; missingstring="NA")

# ╔═╡ f9761799-9dba-41d9-8b4c-356d72b87438
length(names(mammals_sleep)), names(mammals_sleep)

# ╔═╡ f6fff236-72db-4b7b-ac7c-4bcb2e25adb7
md"""
## DataFramesMeta.jl Verbs
"""

# ╔═╡ 5d013cf4-c164-4903-ba33-cb5e2c6787ca
md"""
### Selecting Columns similar to SQL
"""

# ╔═╡ f8413452-8057-4cf3-ade4-2eede2825601
begin
	# using symbol 
	mammals_sleep[:, [:name, :sleep_total]] # DataFrames.jl way
	@select mammals_sleep :name :sleep_total # DataFramesMeta.jl way
end

# ╔═╡ 0b23ca61-a51f-40a7-be67-a269105cd289
# Assign symbol to a variable
var = :name; vars = [:name, :sleep_total];

# ╔═╡ 9e0a3449-fe31-4b85-b9e2-3d423f7a4e8d
# The $ sign has a special meaning in DataFramesMeta.jl, its behaviour similar
# to reference $ in julia base
@select mammals_sleep $var :genus

# ╔═╡ 08872000-a441-4c4b-97e2-0b92e0a60c0d
@select mammals_sleep $vars

# ╔═╡ 13b6adcf-93cf-4acd-8661-c26bdf10a304
# Select the second column
@select mammals_sleep $2

# ╔═╡ 411f00ce-2b3c-4f67-b8c2-b0109bf504ed
# Not() inverses the selection, pass the vector of symbol in there is ok
# Not() = InvertedIndex()
@select mammals_sleep $(InvertedIndex([:name, :genus]))

# ╔═╡ 107a3813-c17f-48f9-84ad-7570154b042b
# select a range from :name -> :conservation using Between()
@select mammals_sleep $(Between(:name, :conservation))

# ╔═╡ e9c7019f-f11c-42f6-bdad-529578aaf593
# regex can be pass to the reference $()
@select mammals_sleep $(r"^sl")

# ╔═╡ 4a4f231b-f7f7-4c5a-b816-1b60764c5b9d
md"""
### Selecting Rows Using @subset and @rsubset
"""

# ╔═╡ f7420d65-5fb7-4a2a-9b7d-222117d9397a
begin
	# Because of element-wise comparison so broadcast is used
	@subset mammals_sleep broadcast(x -> x >= 10, :sleep_total)
	# similar to 
	@subset mammals_sleep :sleep_total .>= 10 # recommend because it's more intuitive.
end

# ╔═╡ a6b32b1d-5bf5-48cb-b669-dda09996e543
# Simplyfy the above code
@rsubset mammals_sleep :sleep_total >= 10 # recommend

# ╔═╡ 60da5440-85fd-4cdd-a42c-04acc5774f21
@time begin
	@rsubset mammals_sleep :sleep_total >= 16 && :bodywt >= 1 # SQL style
	
	@rsubset(mammals_sleep, :sleep_total >= 16, :bodywt >= 1) # R style
	
	@rsubset mammals_sleep begin # Lisp style
		:sleep_total >= 10
		:bodywt >= 1
	end
	
	filter(mammals_sleep) do row # Filter style
	    row.sleep_total >= 16 && row.bodywt >= 1
	end
end

# ╔═╡ 74af404c-7ac3-4f7e-a7db-a7cf8c67fc5b
# Wrap code inside let...end block can help reduce memory allocation and improve 
# performance in certain situations.
@time let # try to change let -> begin to see the difference
	conservation_state = Set(["lc", "domesticated"]) # Set is faster than vector
	@rsubset mammals_sleep :conservation ∉ conservation_state # ∉ is \notin<Tab> 
end

# ╔═╡ 9482c56b-57a8-4684-98af-815c431143c4
md"""
## Chain.jl
"""

# ╔═╡ 34f75ab6-434e-4d65-a238-ef4b2cc1ebec
@chain mammals_sleep begin # it has to order like this
	@select :name :sleep_total 
	@rsubset :sleep_total >= 16 
end

# ╔═╡ 8727750c-468d-4f14-b5dc-56094342c004
md"""
### Arrange Or Re-order Rows Using @orderby
"""

# ╔═╡ 06f003ea-b480-4e98-916f-97f12fddbd14
@chain mammals_sleep begin
	@select :name :order :sleep_total 
	@orderby begin 
		:order 
		-:sleep_total # `-` stands for descending order.
	end
	@rsubset :sleep_total >= 10
	first(5)
end

# ╔═╡ e1a08c00-be7a-455f-ad62-4b9757597a0e
md"""
### Create New Columns Using @transform and @rtransform
"""

# ╔═╡ ab2ef226-8155-4bfa-a195-6f6c5f996b60
@rtransform mammals_sleep begin 
	:brain_proportion = :brainwt / :bodywt
	:rem_proportion = :sleep_rem / :sleep_total
end

# ╔═╡ 0f5e5f1b-22c6-4ba2-92ef-4cf9a2bd70fc
@chain mammals_sleep begin
	@select :sleep_total
	@transform :diff_sleep = abs.(:sleep_total .- mean(:sleep_total))
end

# ╔═╡ 6dd34e7c-e5c1-4aa8-9b02-7530bdac9aa0
md"""
### Create Summaries of the Data Frame using @combine
"""

# ╔═╡ c42ee511-b419-479d-8f30-b6a254f2d64c
@chain mammals_sleep begin # Using @chain for dataframe name mammals_sleep
	@rsubset :sleep_total > 12 # Apply for sleep_total > 12
	@combine :avg_sleep = mean(:sleep_total) # calculate the mean value using @combine to group all value together
end

# ╔═╡ 2921539e-aed2-447d-8e41-b65e0807bea7
@combine mammals_sleep begin # Similar to describe()
	:length = length(:sleep_total)
	:missing_count = count(x -> ismissing(x), :sleep_total)
	:mean = mean(:sleep_total)
	:median = median(:sleep_total)
	:min = minimum(:sleep_total)
	:"1st quantile" = quantile(:sleep_total)[2]
	:"3rd quantile" = quantile(:sleep_total)[4]
	:max = maximum(:sleep_total)
	:type = eltype(:sleep_total)
end

# ╔═╡ 2da98ac2-1b8b-4ff5-a47b-5d4c29723924
describe(mammals_sleep[:, :sleep_total])

# ╔═╡ edb224ee-ba8a-4fcc-bbb5-dbbb998516c7


# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CSV = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
DataFramesMeta = "1313f7d8-7da2-5740-9ea0-a2ca25f37964"
HTTP = "cd3eb016-35fb-5094-929b-558a96fad6f3"
StatsBase = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"

[compat]
CSV = "~0.10.9"
DataFramesMeta = "~0.13.0"
HTTP = "~1.7.4"
StatsBase = "~0.33.21"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.5"
manifest_format = "2.0"
project_hash = "5dc3fc5656d450df27edb78426e941317fc1e33f"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.BitFlags]]
git-tree-sha1 = "43b1a4a8f797c1cddadf60499a8a077d4af2cd2d"
uuid = "d1d4a3ce-64b1-5f1a-9ba4-7e7e69966f35"
version = "0.1.7"

[[deps.CSV]]
deps = ["CodecZlib", "Dates", "FilePathsBase", "InlineStrings", "Mmap", "Parsers", "PooledArrays", "SentinelArrays", "SnoopPrecompile", "Tables", "Unicode", "WeakRefStrings", "WorkerUtilities"]
git-tree-sha1 = "c700cce799b51c9045473de751e9319bdd1c6e94"
uuid = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
version = "0.10.9"

[[deps.Chain]]
git-tree-sha1 = "8c4920235f6c561e401dfe569beb8b924adad003"
uuid = "8be319e6-bccf-4806-a6f7-6fae938471bc"
version = "0.5.0"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "c6d890a52d2c4d55d326439580c3b8d0875a77d9"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.15.7"

[[deps.ChangesOfVariables]]
deps = ["ChainRulesCore", "LinearAlgebra", "Test"]
git-tree-sha1 = "485193efd2176b88e6622a39a246f8c5b600e74e"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.6"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "9c209fb7536406834aa938fb149964b985de6c83"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.1"

[[deps.Compat]]
deps = ["Dates", "LinearAlgebra", "UUIDs"]
git-tree-sha1 = "7a60c856b9fa189eb34f5f8a6f6b5529b7942957"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.6.1"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.1+0"

[[deps.Crayons]]
git-tree-sha1 = "249fe38abf76d48563e2f4556bebd215aa317e15"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.1.1"

[[deps.DataAPI]]
git-tree-sha1 = "e8119c1a33d267e16108be441a287a6981ba1630"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.14.0"

[[deps.DataFrames]]
deps = ["Compat", "DataAPI", "Future", "InlineStrings", "InvertedIndices", "IteratorInterfaceExtensions", "LinearAlgebra", "Markdown", "Missings", "PooledArrays", "PrettyTables", "Printf", "REPL", "Random", "Reexport", "SentinelArrays", "SnoopPrecompile", "SortingAlgorithms", "Statistics", "TableTraits", "Tables", "Unicode"]
git-tree-sha1 = "aa51303df86f8626a962fccb878430cdb0a97eee"
uuid = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
version = "1.5.0"

[[deps.DataFramesMeta]]
deps = ["Chain", "DataFrames", "MacroTools", "OrderedCollections", "Reexport"]
git-tree-sha1 = "f9db5b04be51162fbeacf711005cb36d8434c55b"
uuid = "1313f7d8-7da2-5740-9ea0-a2ca25f37964"
version = "0.13.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "d1fff3a548102f48987a52a2e0d114fa97d730f0"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.13"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "2fb1e02f2b635d0845df5d7c167fec4dd739b00d"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.3"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FilePathsBase]]
deps = ["Compat", "Dates", "Mmap", "Printf", "Test", "UUIDs"]
git-tree-sha1 = "e27c4ebe80e8699540f2d6c805cc12203b614f12"
uuid = "48062228-2e41-5def-b9a4-89aafe57970f"
version = "0.9.20"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[deps.Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[deps.HTTP]]
deps = ["Base64", "CodecZlib", "Dates", "IniFile", "Logging", "LoggingExtras", "MbedTLS", "NetworkOptions", "OpenSSL", "Random", "SimpleBufferStream", "Sockets", "URIs", "UUIDs"]
git-tree-sha1 = "37e4657cd56b11abe3d10cd4a1ec5fbdb4180263"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.7.4"

[[deps.IniFile]]
git-tree-sha1 = "f550e6e32074c939295eb5ea6de31849ac2c9625"
uuid = "83e8ac13-25f8-5344-8a64-a9f2b223428f"
version = "0.5.1"

[[deps.InlineStrings]]
deps = ["Parsers"]
git-tree-sha1 = "9cc2baf75c6d09f9da536ddf58eb2f29dedaf461"
uuid = "842dd82b-1e85-43dc-bf29-5d0ee9dffc48"
version = "1.4.0"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "49510dfcb407e572524ba94aeae2fced1f3feb0f"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.8"

[[deps.InvertedIndices]]
git-tree-sha1 = "82aec7a3dd64f4d9584659dc0b62ef7db2ef3e19"
uuid = "41ab1584-1d38-5bbf-9106-f11c6c58b48f"
version = "1.2.0"

[[deps.IrrationalConstants]]
git-tree-sha1 = "630b497eafcc20001bba38a4651b327dcfc491d2"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.2"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "abc9885a7ca2052a736a600f7fa66209f96506e1"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.4.1"

[[deps.LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.3"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "7.84.0+0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.10.2+0"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LogExpFunctions]]
deps = ["ChainRulesCore", "ChangesOfVariables", "DocStringExtensions", "InverseFunctions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "0a1b7c2863e44523180fdb3146534e265a91870b"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.23"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.LoggingExtras]]
deps = ["Dates", "Logging"]
git-tree-sha1 = "cedb76b37bc5a6c702ade66be44f831fa23c681e"
uuid = "e6f89c97-d47a-5376-807f-9c37f3926c36"
version = "1.0.0"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "42324d08725e200c23d4dfb549e0d5d89dede2d2"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.10"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "MozillaCACerts_jll", "Random", "Sockets"]
git-tree-sha1 = "03a9b9718f5682ecb107ac9f7308991db4ce395b"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.1.7"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.0+0"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "f66bdc5de519e8f8ae43bdc598782d35a25b1272"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.1.0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.2.1"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.20+0"

[[deps.OpenSSL]]
deps = ["BitFlags", "Dates", "MozillaCACerts_jll", "OpenSSL_jll", "Sockets"]
git-tree-sha1 = "6503b77492fd7fcb9379bf73cd31035670e3c509"
uuid = "4d8831e6-92b7-49fb-bdf8-b643e874388c"
version = "1.3.3"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9ff31d101d987eb9d66bd8b176ac7c277beccd09"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.20+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[deps.Parsers]]
deps = ["Dates", "SnoopPrecompile"]
git-tree-sha1 = "478ac6c952fddd4399e71d4779797c538d0ff2bf"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.5.8"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.8.0"

[[deps.PooledArrays]]
deps = ["DataAPI", "Future"]
git-tree-sha1 = "a6062fe4063cdafe78f4a0a81cfffb89721b30e7"
uuid = "2dfb63ee-cc39-5dd5-95bd-886bf059d720"
version = "1.4.2"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "47e5f437cc0e7ef2ce8406ce1e7e24d44915f88d"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.3.0"

[[deps.PrettyTables]]
deps = ["Crayons", "Formatting", "LaTeXStrings", "Markdown", "Reexport", "StringManipulation", "Tables"]
git-tree-sha1 = "96f6db03ab535bdb901300f88335257b0018689d"
uuid = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"
version = "2.2.2"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.SentinelArrays]]
deps = ["Dates", "Random"]
git-tree-sha1 = "77d3c4726515dca71f6d80fbb5e251088defe305"
uuid = "91c51154-3ec4-41a3-a24f-3f23e20d615c"
version = "1.3.18"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.SimpleBufferStream]]
git-tree-sha1 = "874e8867b33a00e784c8a7e4b60afe9e037b74e1"
uuid = "777ac1f9-54b0-4bf8-805c-2214025038e7"
version = "1.1.0"

[[deps.SnoopPrecompile]]
deps = ["Preferences"]
git-tree-sha1 = "e760a70afdcd461cf01a575947738d359234665c"
uuid = "66db9d55-30c0-4569-8b51-7e840670fc0c"
version = "1.0.3"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "a4ada03f999bd01b3a25dcaa30b2d929fe537e00"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.1.0"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f9af7f195fb13589dd2e2d57fdb401717d2eb1f6"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.5.0"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "d1bf48bfcc554a3761a133fe3a9bb01488e06916"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.21"

[[deps.StringManipulation]]
git-tree-sha1 = "46da2434b41f41ac3594ee9816ce5541c6096123"
uuid = "892a3eda-7b42-436c-8928-eab12a02cf0e"
version = "0.3.0"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.0"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "OrderedCollections", "TableTraits", "Test"]
git-tree-sha1 = "c79322d36826aa2f4fd8ecfa96ddb47b174ac78d"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.10.0"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.1"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.TranscodingStreams]]
deps = ["Random", "Test"]
git-tree-sha1 = "94f38103c984f89cf77c402f2a68dbd870f8165f"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.9.11"

[[deps.URIs]]
git-tree-sha1 = "074f993b0ca030848b897beff716d93aca60f06a"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.4.2"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.WeakRefStrings]]
deps = ["DataAPI", "InlineStrings", "Parsers"]
git-tree-sha1 = "b1be2855ed9ed8eac54e5caff2afcdb442d52c23"
uuid = "ea10d353-3f73-51f8-a26c-33c1cb351aa5"
version = "1.4.2"

[[deps.WorkerUtilities]]
git-tree-sha1 = "cd1659ba0d57b71a464a29e64dbc67cfe83d54e7"
uuid = "76eceee3-57b5-4d4a-8e66-0e911cebbf60"
version = "1.6.1"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.12+3"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.1.1+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.48.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"
"""

# ╔═╡ Cell order:
# ╟─ccdaf5ad-d3d2-468a-97ca-69a1cee35a1e
# ╟─4a4930c9-1428-4566-913f-6f22b07f7842
# ╠═17d45ab7-1af6-41a7-a0e4-e09c498c03b4
# ╠═fb0e1358-f3c6-4b53-8bfc-717f307c05fe
# ╠═54845cad-d928-491f-9538-a1775f1fdb51
# ╠═f9761799-9dba-41d9-8b4c-356d72b87438
# ╟─f6fff236-72db-4b7b-ac7c-4bcb2e25adb7
# ╟─5d013cf4-c164-4903-ba33-cb5e2c6787ca
# ╠═f8413452-8057-4cf3-ade4-2eede2825601
# ╠═0b23ca61-a51f-40a7-be67-a269105cd289
# ╠═9e0a3449-fe31-4b85-b9e2-3d423f7a4e8d
# ╠═08872000-a441-4c4b-97e2-0b92e0a60c0d
# ╠═13b6adcf-93cf-4acd-8661-c26bdf10a304
# ╠═411f00ce-2b3c-4f67-b8c2-b0109bf504ed
# ╠═107a3813-c17f-48f9-84ad-7570154b042b
# ╠═e9c7019f-f11c-42f6-bdad-529578aaf593
# ╟─4a4f231b-f7f7-4c5a-b816-1b60764c5b9d
# ╠═f7420d65-5fb7-4a2a-9b7d-222117d9397a
# ╠═a6b32b1d-5bf5-48cb-b669-dda09996e543
# ╠═60da5440-85fd-4cdd-a42c-04acc5774f21
# ╠═74af404c-7ac3-4f7e-a7db-a7cf8c67fc5b
# ╟─9482c56b-57a8-4684-98af-815c431143c4
# ╠═34f75ab6-434e-4d65-a238-ef4b2cc1ebec
# ╟─8727750c-468d-4f14-b5dc-56094342c004
# ╠═06f003ea-b480-4e98-916f-97f12fddbd14
# ╟─e1a08c00-be7a-455f-ad62-4b9757597a0e
# ╠═ab2ef226-8155-4bfa-a195-6f6c5f996b60
# ╠═0f5e5f1b-22c6-4ba2-92ef-4cf9a2bd70fc
# ╟─6dd34e7c-e5c1-4aa8-9b02-7530bdac9aa0
# ╠═e1ed72a0-3583-46bf-885a-4aefb845df7a
# ╠═c42ee511-b419-479d-8f30-b6a254f2d64c
# ╠═2921539e-aed2-447d-8e41-b65e0807bea7
# ╠═2da98ac2-1b8b-4ff5-a47b-5d4c29723924
# ╠═edb224ee-ba8a-4fcc-bbb5-dbbb998516c7
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
