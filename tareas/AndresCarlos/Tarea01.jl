### A Pluto.jl notebook ###
# v0.16.1

using Markdown
using InteractiveUtils

# ╔═╡ 7dfae42a-4211-11ec-3983-29e1cea73a3b
begin 
	
	"""
	             Intervalo
	La siguiente estructura definira un intervalo, que es un conjunto cerrado continuo donde el ´inf´ denota al valor minimo del intervalo y el ´sup´ el valor maximo del mismo.
	"""
	struct Intervalo{T<:Real} #Definimos la estructura, tendra un subtipo menor a Real
		infimo :: T #TDefinimos el tipo de las variables que tendra, en este caso el inf
		supremo :: T #Definimos el tipo de la variabla sup, que sera de tipo T
		#mismo :: T #Definimos el tipo de la variable punto que sera tipo T
		
		function Intervalo(infimo::T, supremo::T) where {T<:Real} #Definimos la función
			@assert infimo ≤ supremo #Hacemos la afirmación de inf menor a sup
			return new{T}(infimo, supremo) #Nos regresa un intervalo y de tipo T
		end
		
		
		
		
		
		
	end
	
	function Intervalo(infimo::T, supremo::R) where {T<:Real, R<:Real} #Definimos la 
			                                                    #función
	    i, s = promote(infimo, supremo, 1.0) #No necesariamente tiene que tener los mismos 
			                     #tipos
		return Intervalo(i,s) #con Promote hacemos que sean del mismo tipo de 
	end                       #mayor jererquia y nos regresa la función 
		                          #intervalo anterior
		
	function Intervalo(mismo::T) where{T<:Real} #Definimos la función para un 
			                                    #punto
		return Intervalo(mismo, mismo) #nos regresa el intervalo del punto
	end
	
	
	function Intervalo()     #Intervalo vacio
		return ()      #Regresamos un arreglo pues vacio :v
	end
	
end

# ╔═╡ b6be6e7a-3ae9-48ba-abf6-bd04e889164b
Intervalo()

# ╔═╡ a2d08992-2591-4f1d-a8e0-43076aa9d5e2
function ∪(a::Intervalo, b::Intervalo) #Definimos la operación union#
	CotI=min(a.infimo, b.infimo) #Definimos la cota minima de los dos intervalos
	CotS=max(a.supremo, b.supremo) #Definimos la cota maxima de los dos intervalos
	return Intervalo(CotI, CotS) #Regresamos la función intervalo con esas cotas
end

# ╔═╡ 477da29e-8326-48aa-b823-01cc86c4d4b3
begin
	I1=Intervalo(3,4)
    I2=Intervalo(5,9)
	I3=Intervalo(1,10)
	I4=Intervalo(9,16)
	zero=Intervalo(0,0)
end

# ╔═╡ d1affbbd-b74e-4983-a6a2-92a688ab6c19
∪(I1,I2)

# ╔═╡ 5b13850e-1e68-461b-a41c-2cd695502716
function ∩(a::Intervalo, b::Intervalo) #definimos la función de intersección
	if a.supremo < b.infimo    #Vemos que el intervalo a y b son ajenos con a.sup < b.inf
		return Intervalo() #de ser el caso nos arroja el vacio
	elseif b.supremo < a.infimo  #Vemos que sean ajenos para el otro caso que a este a la 
		                  #derecha de b
		return Intervalo() #De ser el caso nos arroja el intervalo vacio
	elseif b.supremo < a.supremo && b.supremo > a.infimo  #vemos un primer caso de la intersección
		CotMin= max(a.infimo, b.infimo)  #como b esta atrapado en a, b.sup < a.sup, la cota
		return Intervalo(CotMin, b.supremo) #minima estara denotada por la maxima de los 
		                                #inf
	elseif a.supremo < b.supremo && a.supremo > b.infimo #El otro caso donde a.sup < b.sup
		CotMin= max(a.infimo, b.infimo)   #Vemos la cota inf adecuada para la intersección
		return Intervalo(CotMin, a.supremo) #Nos regresa la intersección
		
	end
end 

# ╔═╡ 6a5926ee-e419-4ea4-9ed2-fe1dd110de89
begin 
	
	import Base: == #No se lo entiendo del todo pero me pedia importar :V
	
	function ==(a::Intervalo, b::Intervalo) #Definimos la función de igualdad
		
		return a.infimo == b.infimo && a.supremo == b.supremo
		
	end
	
end
		

# ╔═╡ 94aa2723-4d33-4a1d-b9f0-eae10c02f157
I1 == I2

# ╔═╡ 85117a02-e8fb-40e9-b9dc-43e1b599179a
begin 
	
	import Base. ∈
	
	function ∈(x::Real, j::Intervalo) #Definimos el operador logico ∈ ¨creo¨
		
		return j.infimo ≤ x ≤ j.supremo 
		
	end
	
end

# ╔═╡ cb54faf9-cd66-4459-b3f9-9917b6d5df7b
7 ∈ I2

# ╔═╡ 38542482-adfd-45d9-8190-c823e63740cf
function ⪽(a::Intervalo, b::Intervalo) #Definimos el operador logico ⪽ ¨creo, no se 
	                                   #decirlo mejor¨
	return a.infimo > b.infimo && a.supremo < b.supremo
	
end

# ╔═╡ 1eac0dc7-89db-42fe-bff5-d5db0b317383
I1 ⪽ I3

# ╔═╡ 9b51c7e4-7c48-4f46-8e52-4f8d4fbd6cbe
function ⊃(a::Intervalo, b::Intervalo) #Definimos el operador logico ⊃ ¨creo, no se 
	                                   #decirlo mejor¨ 
	return b.infimo > a.infimo && b.supremo < a.supremo 
	
end

# ╔═╡ b55288a2-3e37-4f0e-9e29-54646aaf672a
function ⊆(a::Intervalo, b::Intervalo) #Definimos el operador logico ⊆ ¨creo, no se 
	                                   #decirlo mejor¨
	return a.infimo ≥ b.infimo && a.supremo ≤ b.supremo 
	
end

# ╔═╡ f18f5215-6846-4ee2-aa5a-a1bb0926c720
begin 
	import Base: + 
	
	function +(a::Intervalo, b::Intervalo)  #Definimos la suma
	    suminf = a.infimo + b.infimo        #sumamos infimos
	    sumsup = a.supremo + b.supremo        #Sumamos supremos
	    return Intervalo(suminf, sumsup)  #Regresamos el intervalo supremo
    end
	
	function +(a::Intervalo, c::T) where{T<:Real} #Definimos la suma
		suminf = a.infimo + c
		sumsup = a.supremo + c
		return Intervalo(suminf, sumsup)
	end
	
	function +(c::T, b::Intervalo) where{T<:Real}  #Definimos la suma
		suminf = b.infimo + c
		sumsup = b.supremo + c
		return Intervalo(suminf, sumsup)
	end
	
end
	

# ╔═╡ 22abd523-629b-4463-b7e5-872081bac579
+(I1,1)


# ╔═╡ ba47a76f-75b7-4ee0-8f5a-aaa3332d9cc3
begin 
	import Base: -   #importamos de Base el -
	
	function -(a::Intervalo, b::Intervalo) #Definimos la resta
	    restinf = a.infimo - b.supremo   #Hacemos el infimo de la resta
	    restsup = a.supremo - b.infimo   #Hacemos el supremo de la resta
	    return Intervalo(restinf, restsup)  #Devolvemos el intervalo resta
    end
	
	function -(a::Intervalo, c::T) where{T<:Real} #Definimos la suma
		suminf = a.infimo - c
		sumsup = a.supremo - c
		return Intervalo(suminf, sumsup)
	end
	
	function -(c::T, b::Intervalo) where{T<:Real}  #Definimos la suma
		suminf = c-b.supremo
		sumsup = c-b.infimo
		return Intervalo(suminf, sumsup)
	end
	
	
end

# ╔═╡ 0ddfbb55-cad4-4212-a0af-ff51b864e54c
-(I1,I2)

# ╔═╡ 715fe57f-04c9-4ec2-96d7-cfc3f83c5baf
begin 
	
	import Base: * #importamos de Base el *
	
	function *(a::Intervalo, b::Intervalo) #Definimos el producto
	    producinf = min(a.infimo*b.infimo, a.infimo*b.supremo, a.supremo*b.infimo, a.supremo*b.supremo)
	    producsup = max(a.infimo*b.infimo, a.infimo*b.supremo, a.supremo*b.infimo, a.supremo*b.supremo) 
	    return Intervalo(producinf, producsup) #Devolvemos el producto 
    end
	
	function *(a::Intervalo, c::T) where{T<:Real}#Definimos el producto
	    producinf = min(a.infimo*c, a.supremo*c)
	    producsup = max(a.infimo*c, a.supremo*c) 
	    return Intervalo(producinf, producsup) #Devolvemos el producto 
    end
	
	function *(c::T, a::Intervalo) where{T<:Real}#Definimos el producto
	    producinf = min(a.infimo*c, a.supremo*c)
	    producsup = max(a.infimo*c, a.supremo*c) 
	    return Intervalo(producinf, producsup) #Devolvemos el producto 
    end
	
end

# ╔═╡ bdc3c336-77c1-47f2-a7f7-0bd5b41e38d0
*(I4,I4)

# ╔═╡ baf8ef76-0642-4510-82cc-668e0cf216c3
#=begin 
	
	import Base: ^ #Importamos de Base la potencia
	
	function ^(a::intervalo, n::Integer) #definimos la potencia
		#@assert typeof(n) == Integer
		k=1 #Ponemos valores iniciales para hacer la potencia
		b=a #Definimos b = a para que haga el producto usando codigo anterior
		
	    for i in 1:n #Iteramos para la potencia buscada
			k=k+1    #Aumentamos un valor a K para que en algun momento se detenga
		    poteninf = min(a.inf*b.inf, a.inf*b.sup, a.sup*b.inf, a.sup*b.sup)
	        potensup = max(a.inf*b.inf, a.inf*b.sup, a.sup*b.inf, a.sup*b.sup)
	        b=intervalo(poteninf, potensup) #Obtenemos un nuevo valor de b
			if k == n #Si se ejecuta el codigo n-1 veces se detiene la iteración
				break #Se sale del ciclo con el break
			end
			
		end
		
		return b #Regresamos el nuevo valor de b, o la potencia nueva que se buscaba
		
    end
	
end =#

# ╔═╡ 1a338fb1-44d6-4793-948c-5a6f2e187791
begin
	import Base. ^
	
	function ^(a::Intervalo, m::Int64)
		
		if rem(m, 2) == 0 #Vemos si la potencia es par
			
		    if a.infimo < 0 && a.supremo > 0
				if m==0
				    potinf = a.infimo^m
				    potsup = a.supremo^m
					#break
				else
					potinf = 0
				    potsup = max(a.infimo^m,a.supremo^m)
					
				end
					
				
			else
				potinf = min(a.infimo^m,a.supremo^m)
				potsup = max(a.infimo^m,a.supremo^m)

			#elseif a.infimo > 0 && a.supremo > 0
				#potinf = a.infimo^m
				#potsup = a.supremo^m
				
			#=elseif abs(a.infimo) < abs(a.supremo) 
			    potinf = abs(a.infimo)^m
			    potsup = abs(a.supremo)^m
		    elseif abs(a.supremo) < abs(a.infimo)
			    potinf = abs(a.supremo)^m
			    potsup = abs(a.infimo)^m=#
				
		    end
			
		else  #Vemos si la potencia es impar
				potinf = a.infimo^m
			    potsup = a.supremo^m
		end
		
		return Intervalo(potinf, potsup)
	end
	
end

# ╔═╡ 7533db12-f172-4c27-89a4-2a69eadb5153
typeof(0)

# ╔═╡ 58f9b25f-14dc-4e31-b579-3e48bea5c450
I11=Intervalo(-1,1)

# ╔═╡ 06253152-86e6-4449-811d-288ca381da70
^(I11, 3)

# ╔═╡ 09b7fdad-8d3d-4ad5-88ea-86c6d266f250
begin 
	
	import Base: / #Importamos de base el div pero segun yo no es necesario, creo 
	#No, no es necesario xD
	function /(a::Intervalo, b::Intervalo) #Definimos la función división
		#@assert b.infimo < 0 && b.infimo > 0 && b.supremo < 0 && b.supremo > 0 #Que no haya ceros
	    divinf=min(a.infimo*(1/b.supremo), a.infimo*(1/b.infimo), a.supremo*(1/b.supremo), a.supremo*(1/b.infimo))
	    divsup=max(a.infimo*(1/b.supremo), a.infimo*(1/b.infimo), a.supremo*(1/b.supremo), a.supremo*(1/b.infimo))
	    return Intervalo(divinf, divsup) #Regresamos el valor de la división calculado
    end
	
end

# ╔═╡ 92b5da99-b067-4b68-8bff-2b15090df7b9
/(I1, I2)

# ╔═╡ e10f41f4-739d-4f30-8b85-b8b87bc02635
iseven(0)


# ╔═╡ ac97b423-45cd-45d5-94be-528fc40f3f86
begin
	I9=Intervalo(0.0,1.0) 
	I8=Intervalo(-Inf, Inf) 
	#*(I8,I9)
end

# ╔═╡ 9b1fc3ed-c82d-4b2c-9e23-25145ff3864f
∪(I8,I9)

# ╔═╡ Cell order:
# ╠═7dfae42a-4211-11ec-3983-29e1cea73a3b
# ╠═b6be6e7a-3ae9-48ba-abf6-bd04e889164b
# ╠═a2d08992-2591-4f1d-a8e0-43076aa9d5e2
# ╠═477da29e-8326-48aa-b823-01cc86c4d4b3
# ╠═d1affbbd-b74e-4983-a6a2-92a688ab6c19
# ╠═5b13850e-1e68-461b-a41c-2cd695502716
# ╠═6a5926ee-e419-4ea4-9ed2-fe1dd110de89
# ╠═94aa2723-4d33-4a1d-b9f0-eae10c02f157
# ╠═85117a02-e8fb-40e9-b9dc-43e1b599179a
# ╠═cb54faf9-cd66-4459-b3f9-9917b6d5df7b
# ╠═38542482-adfd-45d9-8190-c823e63740cf
# ╠═1eac0dc7-89db-42fe-bff5-d5db0b317383
# ╠═9b51c7e4-7c48-4f46-8e52-4f8d4fbd6cbe
# ╠═b55288a2-3e37-4f0e-9e29-54646aaf672a
# ╠═f18f5215-6846-4ee2-aa5a-a1bb0926c720
# ╠═22abd523-629b-4463-b7e5-872081bac579
# ╠═ba47a76f-75b7-4ee0-8f5a-aaa3332d9cc3
# ╠═0ddfbb55-cad4-4212-a0af-ff51b864e54c
# ╠═715fe57f-04c9-4ec2-96d7-cfc3f83c5baf
# ╠═bdc3c336-77c1-47f2-a7f7-0bd5b41e38d0
# ╠═baf8ef76-0642-4510-82cc-668e0cf216c3
# ╠═1a338fb1-44d6-4793-948c-5a6f2e187791
# ╠═7533db12-f172-4c27-89a4-2a69eadb5153
# ╠═58f9b25f-14dc-4e31-b579-3e48bea5c450
# ╠═06253152-86e6-4449-811d-288ca381da70
# ╠═09b7fdad-8d3d-4ad5-88ea-86c6d266f250
# ╠═92b5da99-b067-4b68-8bff-2b15090df7b9
# ╠═e10f41f4-739d-4f30-8b85-b8b87bc02635
# ╠═ac97b423-45cd-45d5-94be-528fc40f3f86
# ╠═9b1fc3ed-c82d-4b2c-9e23-25145ff3864f
