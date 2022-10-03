### A Pluto.jl notebook ###
# v0.19.10

using Markdown
using InteractiveUtils

# ╔═╡ 3bea47e0-152b-11ed-234d-317142def298
begin
	import Pkg; Pkg.add(["PyCall","Plots"])
	using PyCall
end

# ╔═╡ 31cc0715-16e0-43cd-8cc7-8549f2fde5cb
using Plots

# ╔═╡ c834215c-0132-400a-848d-85ba8f586d71
md"""
# Question 4
"""

# ╔═╡ a89a57bc-b1ba-4f92-bd1c-b52ab213a6a4
md"""
#### Load matplotlib library
"""

# ╔═╡ 7428bad6-7552-4a9a-bf1a-3edceafe4a9b
plt = pyimport("matplotlib.pyplot")

# ╔═╡ f9e86c84-9c1c-44ba-a46c-b7e7c862c488
md"""
The above code is equivalent to:
```py
import matplotlib.pyplot as plt
```
"""

# ╔═╡ f0f2c77b-5c27-4218-974a-59089d27f74e
md"""
#### Create data for the plot
"""

# ╔═╡ 9c0f874f-1bf0-4bff-9522-de47438c9f38
height = (147, 150, 153, 155, 158, 160, 163, 165, 168, 170, 173, 175, 178, 180, 183)

# ╔═╡ 3bfc68d4-e5f1-4a39-b50b-6daaf1dce710
weight = (49, 50, 51, 52, 54, 56, 58, 59, 60, 72, 63, 64, 66, 67, 68)

# ╔═╡ 38f1a9d2-f850-4885-8018-d6800d1db015
md"""
#### Draw the figure
"""

# ╔═╡ 3273d445-7736-41c9-92a0-e7ec2b2a1a03
begin
	plt.plot(height, weight,
		color = "cyan",
		linestyle = "dotted",
		marker = "x",
		markeredgecolor = "red"
	)
	plt.xlabel("Height(cm)")
	plt.ylabel("Weight(kg)")
	plt.show()
end

# ╔═╡ b4044226-d853-4d7b-acb5-84fc8d5ad25f
f(x) = √x

# ╔═╡ 5485f5bb-c337-4719-8f9a-e7b6c421bced
plot(f)

# ╔═╡ 394a42e2-c857-42dd-bf55-f4f81db95d45
g(x) = -√x - 1

# ╔═╡ ab69bf17-1708-4b23-b903-a413543b804a
plot(g)

# ╔═╡ cb2ca7c7-d851-4500-b517-2fa04eb1f241
begin
	d(x) = x <= 0 ? 4x + 3 : -x + 1
	plot(d,-20:20)
end

# ╔═╡ 09e76f41-6933-4771-87d9-d95a42fce996
begin
	e(x) = x < 0 ? x^2 - 3 : 4x - 3
	plot(e, -20:20)
end

# ╔═╡ 23d5a3a9-01dd-4465-a2e4-09049f0a537e
begin
	h(x) = x <=5 ? x + 1 : 4
	plot(h, -6:20)
end

# ╔═╡ 03b5f1d2-38e7-4d65-a004-fa166edf5a8b
begin
	func(x) = 1 / (√x - 2)
	plot(func)
end

# ╔═╡ d140577d-fd46-42c5-9785-ab8f0446642b


# ╔═╡ Cell order:
# ╟─c834215c-0132-400a-848d-85ba8f586d71
# ╠═3bea47e0-152b-11ed-234d-317142def298
# ╟─a89a57bc-b1ba-4f92-bd1c-b52ab213a6a4
# ╠═7428bad6-7552-4a9a-bf1a-3edceafe4a9b
# ╟─f9e86c84-9c1c-44ba-a46c-b7e7c862c488
# ╟─f0f2c77b-5c27-4218-974a-59089d27f74e
# ╠═9c0f874f-1bf0-4bff-9522-de47438c9f38
# ╠═3bfc68d4-e5f1-4a39-b50b-6daaf1dce710
# ╟─38f1a9d2-f850-4885-8018-d6800d1db015
# ╠═3273d445-7736-41c9-92a0-e7ec2b2a1a03
# ╠═31cc0715-16e0-43cd-8cc7-8549f2fde5cb
# ╠═b4044226-d853-4d7b-acb5-84fc8d5ad25f
# ╠═5485f5bb-c337-4719-8f9a-e7b6c421bced
# ╠═394a42e2-c857-42dd-bf55-f4f81db95d45
# ╠═ab69bf17-1708-4b23-b903-a413543b804a
# ╠═cb2ca7c7-d851-4500-b517-2fa04eb1f241
# ╠═09e76f41-6933-4771-87d9-d95a42fce996
# ╠═23d5a3a9-01dd-4465-a2e4-09049f0a537e
# ╠═03b5f1d2-38e7-4d65-a004-fa166edf5a8b
# ╠═d140577d-fd46-42c5-9785-ab8f0446642b
