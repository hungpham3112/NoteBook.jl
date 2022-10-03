using Plots
using CSV
data = CSV.File("data.csv")

gr(size = (600, 600))

theta_0 = 0.0    # y-intercept (default = 0)

theta_1 = 1.0    # slope (default = 1)

# track parameter value history

t0_history = []

t1_history = []

push!(t0_history, theta_0)

push!(t1_history, theta_1)

# define hypothesis function

z(x) = theta_0 .+ theta_1 * x

h(x) = 1 ./ (1 .+ exp.(-z(x)))

# plot initial hypothesis

plot!(0:0.1:1.2, h, color = :green)

# use cost function from Andrew Ng

m = length(X)

y_hat = h(X)

function cost()
    (-1 / m) * sum(
        Y .* log.(y_hat) +
        (1 .- Y) .* log.(1 .- y_hat)
    )
end

J = cost()

# track cost value history

J_history = []

push!(J_history, J)

# define batch gradient descent algorithm

# use partial derivative formulae from Andrew Ng

function pd_theta_0()
    sum(y_hat - Y)
end

function pd_theta_1()
    sum((y_hat - Y) .* X)
end

# set learning rate (alpha)

alpha = 0.01

# initialize epochs

epochs = 0

################################################################################
# begin iterations (repeat until convergence)
################################################################################

for i in 1:1000

    # calculate partial derivatives

    theta_0_temp = pd_theta_0()

    theta_1_temp = pd_theta_1()

    # adjust parameters by the learning rate

    global theta_0 -= alpha * theta_0_temp

    global theta_1 -= alpha * theta_1_temp

    push!(t0_history, theta_0)

    push!(t1_history, theta_1)

    # recalculate cost

    global y_hat = h(X)

    global J = cost()

    push!(J_history, J)

    # replot prediction

    global epochs += 1


end

plot!(0:0.1:1.2, h, color = :blue, alpha = 0.025,
    title = 
        "Wolf Spider Presence Classifier (epochs = $epochs)"
)