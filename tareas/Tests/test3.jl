# Tests de la Tarea2 (`intervalos.jl`), incluyendo el redondeo.

using Test

# include("../intervalos.jl")

# using .Intervalos

u = Intervalo(1.0)
z = Intervalo(0.0)
a = Intervalo(1.5, 2.5)
b = Intervalo(1, 3)
c = Intervalo(BigFloat("0.1"), big(0.1))
d = Intervalo(-1, 1)
f = Intervalo(prevfloat(Inf))
emptyFl = intervalo_vacio(Float64)
emptyB = intervalo_vacio(BigFloat)

@testset "Creación de intervalos" begin
    @test typeof(a) == Intervalo{Float64}
    @test getfield(a, :infimo) == 1.5
    @test getfield(a, :supremo) == 2.5

    @test typeof(b) == Intervalo{Float64}
    @test getfield(b, :infimo) == 1.0
    @test getfield(b, :supremo) == 3.0

    @test typeof(c) == Intervalo{BigFloat}
    @test getfield(c, :infimo) == BigFloat("0.1")
    @test getfield(c, :supremo) == big(0.1)

    @test typeof(emptyFl) == Intervalo{Float64}
    @test typeof(emptyB) == Intervalo{BigFloat}

    @test u == Intervalo(1.0) == one(u)
    @test z == Intervalo(0.0) == zero(z)
    @test z == Intervalo(big(0.0))

    @test isa(u, Real)
    @test typeof(z) <: Real
end

@testset "Operaciones de conjuntos" begin
    @test a == a
    @test a !== b
    @test c == c
    @test emptyFl == emptyB
    @test a ⊆ a
    @test a ⊆ b
    @test emptyFl ⊆ b
    @test b ⊇ a
    @test c ⊆ c
    @test !(a ⊆ emptyFl)
    @test !(emptyB ⊇ c)
    @test !(c ⊆ b) && !(b ⊆ c)
    @test a ⪽ b
    @test emptyFl ⪽ b
    @test !(c ⪽ c)
    @test a ∪ b == b
    @test a ⊔ b == b
    @test a ∪ emptyFl == a
    @test c ⊔ emptyB == c
    @test a ∩ b == a
    @test a ∩ emptyFl == emptyFl
    @test a ∩ c == emptyB
    @test 0 ∈ z
    @test 2 ∈ a
    @test 3 ∉ a
    @test 0.1 ∈ c
end

@testset "Operaciones aritméticas" begin
    @test emptyFl + z == emptyFl
    @test z + z == Intervalo(prevfloat(0.0), nextfloat(0.0))
    @test u + z == u + 0.0
    @test z - u == 0.0-u
    @test -u == Intervalo(-u.supremo, -u.infimo)
    @test f + f !== intervalo_vacio(f)
    @test f + f == Intervalo(f.infimo, Inf)
    @test Inf ∈ f + f
    @test -u ⪽ z - u
    @test b + 1 == 1.0 + b == Intervalo(prevfloat(2.0), nextfloat(4.0))
    @test d ⪽ 2*(a - 2)
    @test c - 0.1 !== z
    @test emptyFl * z == emptyFl
    @test Intervalo(0.1, 0.1) ⪽ 0.1 * u
    @test Intervalo(-0.1, 0.1) ⪽ d * 0.1
    @test d * (a + b) ⊆ d*a + d*b
    @test d^1 == d
    @test d^2 == Intervalo(0, nextfloat(1.0))
    @test emptyB^2 == emptyB
    @test emptyFl^3 == emptyFl
    @test Intervalo(0,Inf) * u == Intervalo(prevfloat(0.0), Inf)
    @test Intervalo(-Inf,Inf) * z == z
    @test emptyFl * z == emptyFl
    @test d ⪽ d*d
    @test d ⪽ d^3
    @test d^4 == d^2
    @test a / emptyFl == emptyFl
    @test emptyB / c == emptyB
    @test emptyFl / emptyFl == emptyFl
    @test u/d == Intervalo(-Inf, Inf)
    @test inv(Intervalo(0.0)) == emptyFl
    @test 0.5 ∈ u/a
    @test 1 ∈ a/a
    @test c^-1 == 1/c
    @test inv(a) == 1/a
    @test (a-1)*(a-2) ⪽ (a*a -3*a + 3)
    @test a/d == Intervalo(-Inf, Inf)
    @test z/z == intervalo_vacio(z)
    @test u ⪽ 1/u
    @test all(division_extendida(u,z) .== (emptyFl,))
    @test all(division_extendida(z,z) .== (Intervalo(-Inf,Inf),))
    @test all(division_extendida(u,u) .== (u/u,))
    @test all(division_extendida(u, Intervalo(0,1)) .== (u/Intervalo(0,1),))
    @test all(division_extendida(u,d) .== (u/Intervalo(-1,0), u/Intervalo(0,1)))
end

#=
Nota: los siguientes tests sobre monotonicidad, si bien imponen corrección en la implementación,
por el tipo de redondeo que estamos usando, que es exagerado, dan resultados demasiado anchos y
entonces no producen el resultado correcto. Esto ocurre en particular cuando el rango de la
derivada tiene al cero en uno de los extremos.
=#
@testset "Monotonicidad de funciones" begin
    @test esmonotona(x->x^2, Intervalo(0.5, 1))
    @test !esmonotona(x->x^2, Intervalo(0.0, 1))
    @test !esmonotona(x->x^3+1, Intervalo(-1, 1))
    @test esmonotona(x->x^3+x, Intervalo(-2, -1))
    @test esmonotona(x->x^3+x, Intervalo(0.6, 1))
    @test esmonotona(x->x^3+x, Intervalo(-0.5, 0.5))
    @test !esmonotona(x->x^3-x^2, Intervalo(0.7, 1))
    @test !esmonotona(x-> 1 - x^4 + x^5, Intervalo(0, 1))
end

@testset "Raíces y ceros con el método de Newton" begin
    @test fieldnames(Raiz) == (:raiz, :unicidad)
    @test fieldtypes(Raiz) == (Intervalo, Bool)

    h(x) = 4*x + 3
    r = ceros_newton(h, Intervalo(-1,0), 0.25)
    @test -0.75 ∈ getfield(r[1], :raiz)
    # Este ejemplo no tiene raices
    r = ceros_newton(h, Intervalo(1,2), 0.5)
    @test length(r) == 0

    h1(x) = x^2 - 2
    rr1 = ceros_newton(h1, Intervalo(-10,10))
    @test rr1[1] isa Raiz
    @test any( sqrt(2) .∈ getfield.(rr1, :raiz))
    @test any(-sqrt(2) .∈ getfield.(rr1, :raiz))
    @test all( getfield.(rr1, :unicidad) )
    @test all(0 .∈ h1.(getfield.(rr1, :raiz)))

    h2(x) = 1 - x^4 + x^5
    rr1 = ceros_newton(h2, Intervalo(-10,10), 1/1024)
    @test rr1[1] isa Raiz
    @test all(0 .∈ h2.(getfield.(rr1, :raiz)))
    @test all(getfield.(rr1, :unicidad))

    # Este ejemplo muestra que a veces vale la pena usar un intervalo
    # no simétrico con el método de Newton
    h3(x) = x^3*(4-5*x)
    rr3 = ceros_newton(h3, Intervalo(-big(3),4), big(1)/2^10)
    @test all(0 .∈ h3.(getfield.(rr3, :raiz)))
    @test all(typeof.(getfield.(rr3, :raiz)) .== Intervalo{BigFloat})
    @test any( 4//5 .∈ getfield.(rr3, :raiz))
    @test any( 0 .∈ getfield.(rr3, :raiz))
    @test any(getfield.(rr3, :unicidad))
    @test !all(getfield.(rr3, :unicidad))
end

@testset "Optimizacion" begin
    h(x) = 1 - x^4 + x^5
    xm, ym = minimiza(h, Intervalo(0,1))
    @test typeof(xm) <: Vector{T} where {T<: Intervalo}
    @test any(4/5 .∈ xm)
    @test all(ym .∈ h.(xm))

    xM, yM = maximiza(h, Intervalo(0,1))
    @test any( 0 .∈ xM)
    @test any( 1 .∈ xM)
    @test all(yM .∈ h.(xM))

    g(x) = 4*x + 3
    xm, ym = minimiza(g, Intervalo(big(1),2), big(1)/125)
    @test any(1 .∈ xm)
    @test all(ym .∈ g.(xm))
    xM, yM = maximiza(g, Intervalo(big(1),2), big(1)/125)
    @test any(2 .∈ xM)
    @test all(yM .∈ g.(xM))
end