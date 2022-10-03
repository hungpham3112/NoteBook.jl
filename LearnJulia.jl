### A Pluto.jl notebook ###
# v0.19.12

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

# ╔═╡ 32fcd9f7-ba88-42b1-88f8-14661cf8f55f
using XKCD

# ╔═╡ 9592fae0-a333-11ec-1735-870a6451a227
md"""
# LearnJulia.jl
"""

# ╔═╡ 853fddbc-b716-4749-bd69-937247692a38
md"""
### varinfo() is used to show all the variable infomation
"""

# ╔═╡ 299a3de9-18b1-4a19-90fa-14db0713971c
varinfo()

# ╔═╡ fec3fbc3-2cad-447a-b8e6-99896b4442c2
md"""
### typeof() is used to show datatype of value
"""

# ╔═╡ 828a9f5e-30b6-44a6-b210-9fdd3509a400
typeof("hello")

# ╔═╡ 07cbc7c8-bfd8-4b27-8c69-a648db9723fb
typeof("H")

# ╔═╡ 8107df77-4447-4748-84b7-b029b820f190
typeof('H')

# ╔═╡ 99b347dd-0758-4d90-9468-cb53bbbc724f
varinfo()

# ╔═╡ 4b70e81b-a9be-4b08-9e3b-8bb9022d57cc
x = 1:10; y = rand(10)

# ╔═╡ 1ebf8997-ebb8-4b41-8c3b-978b0d6d00b4
range = 1:1000

# ╔═╡ 77e430eb-2ab7-4424-9487-d3653c79b4e3
random = rand(1000)

# ╔═╡ eaa00200-9c1f-4fda-b5fd-651633ef67c9
begin 
	function sayhello()
		print("Hello World")
	end
end

# ╔═╡ 0efa1446-51b5-44a4-a0b4-6a4e4e2cd1bc
sayhello()

# ╔═╡ 391a88b5-bc5d-4c5c-bc9c-f7d46167104b
@time [i for i in 1:1_000_000]

# ╔═╡ a179a904-b67a-4e75-9f48-eb113bcb4d77
@time (i for i in 1:1_000_000)

# ╔═╡ 3110266c-be9f-47cb-89f1-a183b556069f
generator = (i for i in 1:1_000_000)

# ╔═╡ de6a2dc3-9e2b-482d-b124-c969a2619fa9
@time collect(generator)

# ╔═╡ c979fb04-3326-4de3-9341-8b0f35bc0ec7
@time collect(Float32, 1:2:2_000_000)

# ╔═╡ 5ce83726-b383-4924-bae1-9a57ff053e57
@time (i + j for i in 1:10, j in 1:20)

# ╔═╡ 7bc0de52-6d05-4254-bef0-8e1de5756236
md"""
# Use md with triple quote to write text in notebook
### Short-cut <C-m>
"""

# ╔═╡ 9e13ef58-75be-4a8c-875f-b0ae60e094ed
BigInt(2)^100

# ╔═╡ 4cd03d61-b3fa-4771-865c-ab227e423a8c
G = ([x, sqrt(x), x^2] for x in 1:100 if iseven(x))

# ╔═╡ 9a3c17e1-41ba-46a4-89fc-55571892c759
map_obj = (x -> x.^2, G)

# ╔═╡ e8288dd1-2b41-42ff-9823-3decdfa3a7af
begin
@time for i in map_obj
		print(i)
	end
end

# ╔═╡ 44b4f5fc-232d-4959-8cd5-f5377acf9cf1
	function isprime(number)
		if number == 2 || number % 2 == 0
			return true
		end

		if number == 3 || number % 3 == 0
			return true
		end

		i = 5
		w = 2

		while i * i <= number
			if number % i == 0
				return false
			end

			i += w
			w = 6 - w
		end
		return true
	end

# ╔═╡ ef051e1f-64f3-4645-abc1-9c55b9ac8624
methods(muladd)

# ╔═╡ f7a2d96c-604e-4b1a-9078-91cabcf97120
@bind z html"<p>hello world</p>"

# ╔═╡ 5eb5e9aa-fd52-430e-a799-922f0f38377d
Comic(123)

# ╔═╡ 0082b482-1620-485c-837a-5e717a03f0ea
typeof(Comic)

# ╔═╡ 64fcfbfc-0dd1-4d32-b33e-fa606452724d


# ╔═╡ a803f5bc-674c-4c7e-8a79-f8a3f2428f12


# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
XKCD = "4bc7fa8b-4ef2-4643-8c8b-cef036f85839"

[compat]
XKCD = "~1.0.1"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.1"
manifest_format = "2.0"
project_hash = "31262fb204bf87ba73ed400f617add1d76bf8633"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.BitFlags]]
git-tree-sha1 = "84259bb6172806304b9101094a7cc4bc6f56dbc6"
uuid = "d1d4a3ce-64b1-5f1a-9ba4-7e7e69966f35"
version = "0.1.5"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "ded953804d019afa9a3f98981d99b33e3db7b6da"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.HTTP]]
deps = ["Base64", "CodecZlib", "Dates", "IniFile", "Logging", "LoggingExtras", "MbedTLS", "NetworkOptions", "OpenSSL", "Random", "SimpleBufferStream", "Sockets", "URIs", "UUIDs"]
git-tree-sha1 = "4abede886fcba15cd5fd041fef776b230d004cee"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.4.0"

[[deps.IniFile]]
git-tree-sha1 = "f550e6e32074c939295eb5ea6de31849ac2c9625"
uuid = "83e8ac13-25f8-5344-8a64-a9f2b223428f"
version = "0.5.1"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "abc9885a7ca2052a736a600f7fa66209f96506e1"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.4.1"

[[deps.JSON3]]
deps = ["Dates", "Mmap", "Parsers", "StructTypes", "UUIDs"]
git-tree-sha1 = "f1572de22c866dc92aea032bc89c2b137cbddd6a"
uuid = "0f8b85d8-7281-11e9-16c2-39a750bddbf1"
version = "1.10.0"

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

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.LoggingExtras]]
deps = ["Dates", "Logging"]
git-tree-sha1 = "5d4d2d9904227b8bd66386c1138cf4d5ffa826bf"
uuid = "e6f89c97-d47a-5376-807f-9c37f3926c36"
version = "0.4.9"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "MozillaCACerts_jll", "Random", "Sockets"]
git-tree-sha1 = "6872f9594ff273da6d13c7c1a1545d5a8c7d0c1c"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.1.6"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.0+0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.2.1"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenSSL]]
deps = ["BitFlags", "Dates", "MozillaCACerts_jll", "OpenSSL_jll", "Sockets"]
git-tree-sha1 = "02be9f845cb58c2d6029a6d5f67f4e0af3237814"
uuid = "4d8831e6-92b7-49fb-bdf8-b643e874388c"
version = "1.1.3"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e60321e3f2616584ff98f0a4f18d98ae6f89bbb3"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.17+0"

[[deps.Parsers]]
deps = ["Dates"]
git-tree-sha1 = "3d5bf43e3e8b412656404ed9466f1dcbf7c50269"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.4.0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.8.0"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "47e5f437cc0e7ef2ce8406ce1e7e24d44915f88d"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.3.0"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.SimpleBufferStream]]
git-tree-sha1 = "874e8867b33a00e784c8a7e4b60afe9e037b74e1"
uuid = "777ac1f9-54b0-4bf8-805c-2214025038e7"
version = "1.1.0"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.StructTypes]]
deps = ["Dates", "UUIDs"]
git-tree-sha1 = "ca4bccb03acf9faaf4137a9abc1881ed1841aa70"
uuid = "856f2bd8-1eba-4b0a-8007-ebc267875bd4"
version = "1.10.0"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.0"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.TranscodingStreams]]
deps = ["Random", "Test"]
git-tree-sha1 = "8a75929dcd3c38611db2f8d08546decb514fcadf"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.9.9"

[[deps.URIs]]
git-tree-sha1 = "e59ecc5a41b000fa94423a578d29290c7266fc10"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.4.0"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.XKCD]]
deps = ["HTTP", "JSON3"]
git-tree-sha1 = "51ecf03bd50fbc5b855975b3f94513dee6d29f65"
uuid = "4bc7fa8b-4ef2-4643-8c8b-cef036f85839"
version = "1.0.1"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.12+3"

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
# ╟─9592fae0-a333-11ec-1735-870a6451a227
# ╟─853fddbc-b716-4749-bd69-937247692a38
# ╠═299a3de9-18b1-4a19-90fa-14db0713971c
# ╟─fec3fbc3-2cad-447a-b8e6-99896b4442c2
# ╠═828a9f5e-30b6-44a6-b210-9fdd3509a400
# ╠═07cbc7c8-bfd8-4b27-8c69-a648db9723fb
# ╠═8107df77-4447-4748-84b7-b029b820f190
# ╠═99b347dd-0758-4d90-9468-cb53bbbc724f
# ╠═4b70e81b-a9be-4b08-9e3b-8bb9022d57cc
# ╠═1ebf8997-ebb8-4b41-8c3b-978b0d6d00b4
# ╠═77e430eb-2ab7-4424-9487-d3653c79b4e3
# ╠═eaa00200-9c1f-4fda-b5fd-651633ef67c9
# ╠═0efa1446-51b5-44a4-a0b4-6a4e4e2cd1bc
# ╠═391a88b5-bc5d-4c5c-bc9c-f7d46167104b
# ╠═a179a904-b67a-4e75-9f48-eb113bcb4d77
# ╠═3110266c-be9f-47cb-89f1-a183b556069f
# ╠═de6a2dc3-9e2b-482d-b124-c969a2619fa9
# ╠═c979fb04-3326-4de3-9341-8b0f35bc0ec7
# ╠═5ce83726-b383-4924-bae1-9a57ff053e57
# ╠═7bc0de52-6d05-4254-bef0-8e1de5756236
# ╠═9e13ef58-75be-4a8c-875f-b0ae60e094ed
# ╠═4cd03d61-b3fa-4771-865c-ab227e423a8c
# ╠═9a3c17e1-41ba-46a4-89fc-55571892c759
# ╠═e8288dd1-2b41-42ff-9823-3decdfa3a7af
# ╠═44b4f5fc-232d-4959-8cd5-f5377acf9cf1
# ╠═ef051e1f-64f3-4645-abc1-9c55b9ac8624
# ╠═f7a2d96c-604e-4b1a-9078-91cabcf97120
# ╠═32fcd9f7-ba88-42b1-88f8-14661cf8f55f
# ╠═5eb5e9aa-fd52-430e-a799-922f0f38377d
# ╠═0082b482-1620-485c-837a-5e717a03f0ea
# ╠═64fcfbfc-0dd1-4d32-b33e-fa606452724d
# ╠═a803f5bc-674c-4c7e-8a79-f8a3f2428f12
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
