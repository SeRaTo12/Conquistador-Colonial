---@diagnostic disable: undefined-global
local composer = require("composer")
local relayaout = require("librerias.relayout")

local w, h, cx, cy = relayaout._W, relayaout._H, relayaout._CX, relayaout._CY
math.randomseed(os.time()) --Semilla para los random
--Escena 
local scene = composer.newScene()

--Grupos
local grpPartida
local grpJugadores = {}

--Objetos
local turno = true
local usuario1_text
local usuario2_text
local usuario3_text
local usuario4_text

local dado1
local dado2
local dice1
local dice2
local boton
local ronda = 1

local imgHex = {
    "Imagenes/hexagonos/12.png",
    "Imagenes/hexagonos/13.png",
    "Imagenes/hexagonos/14.png",
    "Imagenes/hexagonos/15.png",
    "Imagenes/hexagonos/16.png",
    "Imagenes/hexagonos/17.png"
}

local imgNum = {
    "Imagenes/hexagonos/19.png",
    "Imagenes/hexagonos/20.png",
    "Imagenes/hexagonos/21.png",
    "Imagenes/hexagonos/22.png",
    "Imagenes/hexagonos/23.png",
    "Imagenes/hexagonos/29.png",
    "Imagenes/hexagonos/24.png",
    "Imagenes/hexagonos/25.png",
    "Imagenes/hexagonos/26.png",
    "Imagenes/hexagonos/27.png",
    "Imagenes/hexagonos/28.png"
    
}

local imgCartas = {

}

--Son arreglos para guardar las cartas que aparecen en la pantalla
local cartasjugador = {{}, {}, {}, {}}


    local grafo = {
        {2,9,nil},
        {1,3,nil},
        {2,4,11},
        {3,5,nil},
        {4,6,13},
        {5,7,nil},
        {6,15,nil},
        {9,18,nil},
        {1,8,10},
        {9,11,20},
        {3,10,12},
        {11,13,22},
        {5,12,14},
        {13,15,24},
        {7,14,16},
        {15,26,nil},
        {18,28,nil},
        {8,17,19},
        {18,20,30},
        {10,19,21},
        {20,22,32},
        {12,21,23},
        {22,24,34},
        {14,23,25},
        {24,26,36},
        {16,25,27},
        {26,28,nil},
        {17,29,nil},
        {28,30,39},
        {19,29,31},
        {30,32,41},
        {21,31,33},
        {32,34,43},
        {23,33,35},
        {34,36,45},
        {25,35,37},
        {36,38,47},
        {27,37,nil},
        {29,40,nil},
        {39,41,48},
        {31,40,42},
        {41,43,50},
        {33,42,44},
        {43,45,52},
        {35,44,46},
        {45,47,54},
        {37,46,nil},
        {40,49,nil},
        {48,50,nil},
        {42,49,51},
        {50,52,nil},
        {44,51,53},
        {52,54,nil},
        {46,53,nil}
    }


--Variable para almacenar el tipo y el numero que le corresponde a cada hexagono en 1 el tipo y en 2 la probabilidad
local numeroHexagonos = {
    {0,0,{1,2,3,9,10,11}}, 
    {0,0,{3,4,5,11,12,13}}, 
    {0,0,{5,6,7,13,14,15}}, 
    {0,0,{8,9,10,18,19,20}}, 
    {0,0,{10,11,12,20,21,22}}, 
    {0,0,{12,13,14,22,23,24}}, 
    {0,0,{14,15,16,24,25,26}}, 
    {0,0,{17,18,19,28,29,30}}, 
    {0,0,{19,20,21,30,31,32}}, 
    {0,0,{21,22,23,32,33,34}}, 
    {0,0,{23,24,25,34,35,36}}, 
    {0,0,{25,26,27,36,37,38}}, 
    {0,0,{29,30,31,39,40,41}}, 
    {0,0,{31,32,33,41,42,43}}, 
    {0,0,{33,34,35,43,44,45}}, 
    {0,0,{35,36,37,45,46,47}}, 
    {0,0,{40,41,42,48,49,50}}, 
    {0,0,{42,43,44,50,51,52}}, 
    {0,0,{44,45,46,52,53,54}}
  }
local posicion = 1  
local probHex = {}
local hexagonosM = {}
local verticesC = {}
local verticeClase = {}

--Variable para controlar las repeticiones de los hexagonos
local rep = {0,0,0,0,0,0}

--Variable para las probabilidades
local probabilidad = {1,2,2,2,2,0,2,2,2,2,1}

--Jugadores
local jugadores={}
local jugadorActual = 1;
local jugando = display.newText("", display.contentCenterX - 400 , display.contentHeight-200, native.systemFont, 70)
--Cronometro
local textoTiempo = display.newText("", display.contentWidth-330, display.contentHeight-500, native.systemFont, 70)
local tiempoTotal = 20
local tiempoRestante = tiempoTotal
local temporizador


--Creacion de clases

Jugador = {
    numero = 0,
    nombre = "",
    puntos = 0,
    cartas = 0,
    casasD = 4,
    ciudadesD = 5, 
    caminosD = 15, 
    casasC = 0,
    cartas1 = 0, --arboles
    cartas2 = 0, --trigo
    cartas3 = 0, --ladrillo
    cartas4 = 0, --vacas 
    cartas5 = 0, --roca
    cartas6 = 0,  --especiales
    --cartasR = {}
    casaL = 2,
    caminoL = 2

}

Vertice = {
    ocupado = false, 
    tipoC = 0,
    jugador = 0,
    activo = true

}

Camino = {
    ocupado = false,
    verticeI = nil,
    verticeF = nil,
}

Jugador.__index = Jugador

Vertice.__index = Vertice 

Camino.__index = Camino


function Jugador:nuevo(nombre)
    local nuevo_jugador = {}
    setmetatable(nuevo_jugador,self)
    self.__index = self
    nuevo_jugador.nombre = nombre
    return nuevo_jugador
end

function Vertice:nuevo()
    local nuevo_vertice = {}
    setmetatable(nuevo_vertice,self)
    self.__index = self
    return nuevo_vertice
end

function Camino:nuevo()
    local nuevo_camino = {}
    setmetatable(nuevo_camino,self)
    self.__index = self
    return nuevo_camino
end

-- Funciones
local function colocarHexagonos() --Funcion para randomizar el tipo de hexagono
    local valor
    local bandera = false
    while bandera == false do
        valor = math.random(6)
        if valor < 6 then
            if rep[valor] < 4 then
                rep[valor] = rep[valor] + 1
                numeroHexagonos[posicion][1] = valor
                posicion = posicion + 1
                return valor 
            end
        elseif rep[valor] < 1 then
            rep[valor] = rep[valor] + 1
            numeroHexagonos[posicion][1] = valor
            numeroHexagonos[posicion][2] = 7
            posicion = posicion + 1
            return valor
        end   
    end
end

local function asignarProbabilidad(posicion) --Funcion para randomizar la probabilidad de hexagono
    local valor
    local bandera = false
    while bandera == false do
        valor = math.random(11)
        if probabilidad[valor] > 0 then
        probabilidad[valor] = probabilidad[valor] - 1
        numeroHexagonos[posicion][2] = valor 
        return valor
        end   
    end
end

local function aumentar(carta, i)
        if carta == 1 then
            jugadores[i].cartas1 = jugadores[i].cartas1 + 1
        elseif carta == 2  then
            jugadores[i].cartas2 = jugadores[i].cartas2 + 1
        elseif carta == 3  then
            jugadores[i].cartas3 = jugadores[i].cartas3 + 1
        elseif carta == 4  then
            jugadores[i].cartas4 = jugadores[i].cartas4 + 1
        elseif carta == 5  then
            jugadores[i].cartas5 = jugadores[i].cartas5 + 1
        end
end

local function verOcupacion(j, i)
    if verticeClase[j].ocupado == true then
        aumentar(numeroHexagonos[i][1], verticeClase[j].jugador)
    end
end
local function obtenerRecursos()
    local probabilidad = dice1 + dice2
    --print("probabilidad: ",probabilidad)
    if probabilidad ~= 7 then
        for i =1, 19 do
            if numeroHexagonos[i][2] == probabilidad -1 then
                --print("Hexagono: ", i)
                for j = 1, 6 do
                    verOcupacion(numeroHexagonos[i][3][j], i)
                end
                
            end
        end
    end
    
end

local function actualizaDado() --Función para cambiar la imagen de los dados
    dice1 = math.random(6)
    dice2 = math.random(6)
    if turno == true then
        turno = false
        dado1.fill = { type="image", filename="Imagenes/dado"..dice1..".png" }
        dado2.fill = { type="image", filename="Imagenes/dado"..dice2..".png" }
        obtenerRecursos()
    end
end



local function actualizarTextoTiempo()
    local minutos = math.floor(tiempoRestante / 60)
    local segundos = tiempoRestante % 60
    local tiempoFormateado = string.format("%02d:%02d", minutos, segundos)
    textoTiempo.text = tiempoFormateado
end


local function actualizarRecursos() --La funcion mas larga, es para actualizar las cartas de los jugadores, si usted que lee esto tiene una idea para hacerla corta, adelante
    for i =1, 4 do
        if jugadores[i].cartas1 == 0 then 
            cartasjugador[i][1].fill = { type="image", filename="Imagenes/CartasM/vacia.png" }
        elseif jugadores[i].cartas1 >=3 then
            cartasjugador[i][1].fill = { type="image", filename="Imagenes/CartasM/cartas13.png" }
        elseif jugadores[i].cartas1 ==2 then
            cartasjugador[i][1].fill = { type="image", filename="Imagenes/CartasM/cartas12.png" }
        else
            cartasjugador[i][1].fill = { type="image", filename="Imagenes/CartasM/cartas11.png" }
        end
        if jugadores[i].cartas2 == 0 then 
            cartasjugador[i][2].fill = { type="image", filename="Imagenes/CartasM/vacia.png" }
        elseif jugadores[i].cartas2 >=3 then
            cartasjugador[i][2].fill = { type="image", filename="Imagenes/CartasM/cartas23.png" }
        elseif jugadores[i].cartas2 ==2 then
            cartasjugador[i][2].fill = { type="image", filename="Imagenes/CartasM/cartas22.png" }
        else
            cartasjugador[i][2].fill = { type="image", filename="Imagenes/CartasM/cartas21.png" }
        end
        if jugadores[i].cartas3 == 0 then 
            cartasjugador[i][3].fill = { type="image", filename="Imagenes/CartasM/vacia.png" }
        elseif jugadores[i].cartas3 >=3 then
            cartasjugador[i][3].fill = { type="image", filename="Imagenes/CartasM/cartas33.png" }
        elseif jugadores[i].cartas3 ==2 then
            cartasjugador[i][3].fill = { type="image", filename="Imagenes/CartasM/cartas32.png" }
        else
            cartasjugador[i][3].fill = { type="image", filename="Imagenes/CartasM/cartas31.png" }
        end
        if jugadores[i].cartas4 == 0 then 
            cartasjugador[i][4].fill = { type="image", filename="Imagenes/CartasM/vacia.png" }
        elseif jugadores[i].cartas4 >=3 then
            cartasjugador[i][4].fill = { type="image", filename="Imagenes/CartasM/cartas43.png" }
        elseif jugadores[i].cartas4 ==2 then
            cartasjugador[i][4].fill = { type="image", filename="Imagenes/CartasM/cartas42.png" }
        else
            cartasjugador[i][4].fill = { type="image", filename="Imagenes/CartasM/cartas41.png" }
        end
        if jugadores[i].cartas5 == 0 then 
            cartasjugador[i][5].fill = { type="image", filename="Imagenes/CartasM/vacia.png" }
        elseif jugadores[i].cartas5 >=3 then
            cartasjugador[i][5].fill = { type="image", filename="Imagenes/CartasM/cartas53.png" }
        elseif jugadores[i].cartas5 ==2 then
            cartasjugador[i][5].fill = { type="image", filename="Imagenes/CartasM/cartas52.png" }
        else
            cartasjugador[i][5].fill = { type="image", filename="Imagenes/CartasM/cartas51.png" }
        end
        if jugadores[i].cartas6 == 0 then 
            cartasjugador[i][6].fill = { type="image", filename="Imagenes/CartasM/vacia.png" }
        else
            cartasjugador[i][6].fill = { type="image", filename="Imagenes/CartasM/tcartas.png" }
        end
    end
end


local function actualizarTemporizador()
    tiempoRestante = tiempoRestante - 1
    if tiempoRestante <= 0 then
        timer.cancel(temporizador)
        tiempoRestante = 20
        temporizador = timer.performWithDelay(1000, actualizarTemporizador, tiempoTotal)
        actualizarTextoTiempo()
        turno = true
        if jugadorActual ==1 then 
            jugando.text = jugadores[2].nombre
            jugadorActual = 2 
        elseif jugadorActual ==2 then
            jugando.text = jugadores[3].nombre
            jugadorActual = 3 
        elseif jugadorActual ==3 then
            jugando.text = jugadores[4].nombre
            jugadorActual = 4 
        else
            jugando.text = jugadores[1].nombre
            jugadorActual = 1
            ronda = ronda + 1 
        end
    else
        actualizarTextoTiempo()
    end
end

local function pasarTurno() --Función para pasar el Turno al siguiente jugador. 
    turno = true
    if jugadorActual ==1 then 
        jugando.text = jugadores[2].nombre
        jugadorActual = 2
        actualizarRecursos()
        grpJugadores[1].isVisible = false
        grpJugadores[2].isVisible = true


    elseif jugadorActual ==2 then
        actualizarRecursos()
        jugando.text = jugadores[3].nombre
        jugadorActual = 3
        grpJugadores[2].isVisible = false
        grpJugadores[3].isVisible = true

    elseif jugadorActual ==3 then
        actualizarRecursos()
        jugando.text = jugadores[4].nombre
        jugadorActual = 4
        grpJugadores[3].isVisible = false
        grpJugadores[4].isVisible = true
    else
        actualizarRecursos()
        jugando.text = jugadores[1].nombre
        jugadorActual = 1
        ronda = ronda + 1
        grpJugadores[4].isVisible = false
        grpJugadores[1].isVisible = true

    end
    timer.cancel(temporizador)
    tiempoRestante = 20
    temporizador = timer.performWithDelay(1000, actualizarTemporizador, tiempoTotal)
    actualizarTextoTiempo()
end








local function dibujarNumeros()
    --NUMEROS
    local x = -255
    local y = -260

    for i = 1, 19 do
        if i == 4 then
            x = -320
            y = -150
        elseif i == 8 then
            x = -385
            y = -35
        elseif i == 13 then
            x = -320
            y = 75
        elseif i == 17 then
            x = -255
            y = 190
        end
        if numeroHexagonos[i][1] < 6 then
            local numero1 = display.newImageRect(grpPartida,imgNum[asignarProbabilidad(i)], 70, 100)
            numero1.x = display.contentCenterX + x
            numero1.y = display.contentCenterY + y
        else
            local numero1 = display.newImageRect(grpPartida,imgNum[6], 60, 40)
            numero1.x = display.contentCenterX + x
            numero1.y = display.contentCenterY + y
        end
        
        table.insert(probHex,numero1)
        x = x + 130
    end
end

local function colocarCartas()
    local x = 180
    local y = 200
    for i =1, 4 do
        x = 180
        y = 200
        for j =1, 6 do
            local carta = display.newImageRect(grpJugadores[i],"Imagenes/CartasM/vacia.png", 100, 140)
            carta.x =  x
            carta.y =  y
            y = y + 150
            table.insert(cartasjugador[i],carta)
        end
    end
end

local function dibujarHexagonos()
    --HEXAGONOS
    local x = -255
    local y = -295

    for i = 1, 19 do
        if i == 4 then
            x = -320
            y = -182
        elseif i == 8 then
            x = -385
            y = -70
        elseif i == 13 then
            x = -320
            y = 45
        elseif i == 17 then
            x = -255
            y = 160
        end

        
        
        local hexagono1 = display.newImageRect(grpPartida,imgHex[colocarHexagonos()], 135, 185)
        hexagono1.x = display.contentCenterX + x
        hexagono1.y = display.contentCenterY + y
        
        table.insert(hexagonosM,hexagono1)
        x = x + 130
    end
end

local function generarVertices()
    for i = 1, 54 do
        verticeClase[i] = Vertice:nuevo()
    end
end


local function dibujarVertices()
    local x = -255
    local y = -295
    local ubx = - 60
    local uby = - 40
    for i = 1, 19 do
        if i == 4 then
            x = -320
            y = -182
        elseif i == 8 then
            x = -385
            y = -70
        elseif i == 13 then
            x = -320
            y = 45
        elseif i == 17 then
            x = -255
            y = 160
        end
        uby = - 40
        ubx = - 60 
        
        for j =1, 2 do
            local vertice = display.newImageRect(grpPartida,"Imagenes/Construccion/circulo.png", 15, 15)
            vertice.x = display.contentCenterX + x + ubx
            vertice.y = display.contentCenterY + y + uby
            table.insert(verticesC, vertice)
            uby = uby * 2
            ubx = ubx + 60 
        end
        x = x + 130
        if i == 3 or i == 7 or i == 12 or i == 16 or i == 19 then 
            local vertice = display.newImageRect(grpPartida,"Imagenes/Construccion/circulo.png", 15, 15)
            uby = uby/4
            vertice.x = display.contentCenterX + x - 65
            vertice.y = display.contentCenterY + y + uby
            table.insert(verticesC, vertice)

        elseif i == 13 then
            local vertice = display.newImageRect(grpPartida,"Imagenes/Construccion/circulo.png", 15, 15)
            vertice.x = display.contentCenterX + x - 255
            vertice.y = display.contentCenterY + y - 75
            table.insert(verticesC, vertice)
            
            local vertice = display.newImageRect(grpPartida,"Imagenes/Construccion/circulo.png", 15, 15)
            vertice.x = display.contentCenterX + x - 195
            vertice.y = display.contentCenterY + y + 30
            table.insert(verticesC, vertice)
        end
        
        if i == 17 or i == 18 or i == 19 then
            local vertice = display.newImageRect(grpPartida,"Imagenes/Construccion/circulo.png", 15, 15)
            uby = uby/4
            vertice.x = display.contentCenterX + x - 130
            vertice.y = display.contentCenterY + y + 60
            table.insert(verticesC, vertice)

            local vertice = display.newImageRect(grpPartida,"Imagenes/Construccion/circulo.png", 15, 15)
            vertice.x = display.contentCenterX + x - 190
            vertice.y = display.contentCenterY + y + 30
            table.insert(verticesC, vertice)
        end

        if i == 19 then
            local vertice = display.newImageRect(grpPartida,"Imagenes/Construccion/circulo.png", 15, 15)
            vertice.x = display.contentCenterX + x + 65
            vertice.y = display.contentCenterY + y - 195
            table.insert(verticesC, vertice)
            
            local vertice = display.newImageRect(grpPartida,"Imagenes/Construccion/circulo.png", 15, 15)
            vertice.x = display.contentCenterX + x
            vertice.y = display.contentCenterY + y - 80
            table.insert(verticesC, vertice)
            
            local vertice = display.newImageRect(grpPartida,"Imagenes/Construccion/circulo.png", 15, 15)
            vertice.x = display.contentCenterX + x - 65
            vertice.y = display.contentCenterY + y + 30
            table.insert(verticesC, vertice)
        end
        generarVertices()
    end
end



local function intercambio(a,b) --Arregla las posiciones de los vertices
    local aux = verticesC[b]  
    verticesC[b] = verticesC[a]
    verticesC[a] = aux
end

local function verificarRecursos(i)
    if jugadores[jugadorActual].cartas1>=1 and jugadores[jugadorActual].cartas2>=1 and jugadores[jugadorActual].cartas3>=1 and jugadores[jugadorActual].cartas4>=1 then
        return true
    end
    return false
end

local function casasDistancia()
    for i = 1, 54 do
        if verticeClase[i].ocupado == true then
            if i ~= 1 and i ~= 1 and i ~= 8 and 17 ~= 1 and i ~= 1 and i ~= 1 and i ~= 1 and i ~= 1 and i ~= 1 and i ~= 1 then
                if verticeClase[i-1].activo == true then
                    verticeClase[i-1].activo = false
                end
            end
            if i > 7 then
                if verticeClase[i-7].activo == true then
                    verticeClase[i-7].activo = false
                end
            end
        end
    end
end



local function noSonAdyacentes(vertice1, vertice2)
    -- Verificar si vertice2 no está en la lista de adyacencia de vertice1
    for i, vecino in ipairs(grafo[vertice1]) do
        if vecino == vertice2 then
            return false
        end
    end
    -- Verificar si vertice1 no está en la lista de adyacencia de vertice2
    for i, vecino in ipairs(grafo[vertice2]) do
        if vecino == vertice1 then
            return false
        end
    end
    -- Si no se encontró en ninguna lista, entonces no son adyacentes

    return true
end



local function cambiarImagen(event) --Coloca las casas 
    local imagenClicada = event.target
    local posicion
    for i, imagen in ipairs(verticesC) do
        if imagen == imagenClicada then
            posicion = i
            break
        end 
    end

    local banderaNoAdyacentes = true
    for i in ipairs(verticesC) do
        if verticeClase[i].ocupado == true then
            banderaNoAdyacentes = noSonAdyacentes(posicion,i)
            if banderaNoAdyacentes == false then
                break
            end
        end
    end


    if (verificarRecursos(1) or (ronda == 1 and jugadores[jugadorActual].casaL >= 1)) and banderaNoAdyacentes == true then
        
        verticeClase[posicion].ocupado = true
        verticeClase[posicion].jugador = jugadorActual
        verticeClase[posicion].tipoC = 1
        if ronda ==1 then
            jugadores[jugadorActual].casaL = jugadores[jugadorActual].casaL -1 
        else
            jugadores[jugadorActual].cartas1 = jugadores[jugadorActual].cartas1 -1
            jugadores[jugadorActual].cartas2 = jugadores[jugadorActual].cartas2 -1
            jugadores[jugadorActual].cartas3 = jugadores[jugadorActual].cartas3 -1
            jugadores[jugadorActual].cartas4 = jugadores[jugadorActual].cartas4 -1
        end
        imagenClicada.fill = { type="image", filename="Imagenes/Construccion/casa"..jugadorActual..".png" }
        --imagenClicada:scale(5,5)
        imagenClicada.width = 75
        imagenClicada.height = 90
        actualizarRecursos()
        
    end
    banderaNoAdyacentes = true
    --print(posicion)
    
end



local function COMOQUIERAS()  --Les agrega la funcion de que sis on tocadas se puedan convertir a casa o ciudad. 
    for i = 1, 54 do
        verticesC[i]:addEventListener("tap",cambiarImagen)
    end
end

local function hazLaLuz()

    dibujarVertices()
    intercambio(28,30)
    intercambio(29,30)
    intercambio(32,31)
    intercambio(33,32)
    intercambio(33,34)
    intercambio(34,35)
    intercambio(35,36)
    intercambio(36,37)
    intercambio(37,38)
    intercambio(38,52)
    intercambio(39,52)
    intercambio(40,52)
    intercambio(41,52)
    intercambio(42,43)
    intercambio(43,44)
    intercambio(47,44)
    intercambio(45,48)
    intercambio(46,49)
    intercambio(49,50)
    intercambio(47,53)
    intercambio(49,52)
    intercambio(51,48)
    intercambio(48,53)
    intercambio(53,52)
    COMOQUIERAS()
end











--Eventos de la escena
function scene:create(event)

    --Agregar grupo de imagenes
    grpPartida = display.newGroup()
    self.view:insert(grpPartida)
    for i = 1, 4 do
        local grpjugador = display.newGroup()
        table.insert(grpJugadores,grpjugador)
    end

    local background = display.newImageRect(grpPartida,"Imagenes/fondoH.png", 2800, 1200 )
    background.x = display.contentCenterX
    background.y = display.contentCenterY

    --Tablero
    local tablero = display.newImageRect(grpPartida, "Imagenes/tablero2.png", 1209, 726)
    tablero.x = display.contentCenterX -100
    tablero.y = display.contentCenterY-70
    
    local configuracion = display.newImageRect(grpPartida, "Imagenes/CartasM/11.png", 95, 130)
    configuracion.x = 70
    configuracion.y = 70
    --Hexagonos
    dibujarHexagonos()
        --Probabilidades
    dibujarNumeros()
    hazLaLuz()
    temporizador = timer.performWithDelay(1000, actualizarTemporizador, tiempoTotal)

    -- Inicializar el objeto de texto con el tiempo restante inicial
    actualizarTextoTiempo()


        --Barcos
    local barco = display.newImageRect(grpPartida,"Imagenes/barco1.png", 200, 120)
    barco.x = display.contentCenterX -70
    barco.y = 100
    
    local barco2 = display.newImageRect(grpPartida,"Imagenes/barco2.png", 200, 120)
    barco2.x = display.contentCenterX -350
    barco2.y = 100
    
    local barco3 = display.newImageRect(grpPartida,"Imagenes/barco3.png", 200, 120)
    barco3.x = display.contentCenterX - 490
    barco3.y = display.contentCenterY + 50
    
    local barco4 = display.newImageRect(grpPartida,"Imagenes/barco4.png", 200, 120)
    barco4.x = display.contentCenterX - 490
    barco4.y = display.contentCenterY - 200
    
    local barco5 = display.newImageRect(grpPartida,"Imagenes/barco5.png", 200, 120)
    barco5.x = display.contentCenterX + 220
    barco5.y = display.contentCenterY - 310
    
    local barco6 = display.newImageRect(grpPartida,"Imagenes/barco6.png", 200, 120)
    barco6.x = display.contentCenterX + 200
    barco6.y = display.contentCenterY + 150
    
    local barco7 = display.newImageRect(grpPartida,"Imagenes/barco6.png", 200, 120)
    barco7.x = display.contentCenterX - 50
    barco7.y = display.contentCenterY + 300
    
    --Jugadores
    local usuario = display.newImageRect(grpPartida,"Imagenes/CartasM/usuario1.png", 142.5, 195)
    usuario.x = display.contentWidth - 350 
    usuario.y = display.contentHeight - 750

    local usuario2 = display.newImageRect(grpPartida,"Imagenes/CartasM/usuario2.png", 142.5, 195)
    usuario2.x = display.contentWidth - 150
    usuario2.y = display.contentHeight - 750

    local usuario3 = display.newImageRect(grpPartida,"Imagenes/CartasM/usuario3.png", 142.5, 195)
    usuario3.x = display.contentWidth-350 
    usuario3.y = display.contentHeight-1000

    local usuario4 = display.newImageRect(grpPartida,"Imagenes/CartasM/usuario4.png", 142.5, 195)
    usuario4.x = display.contentWidth-150
    usuario4.y = display.contentHeight-1000

    
    jugadores[1] = Jugador:nuevo("Evan")
    jugadores[1].numero = 1
    usuario1_text = display.newText(grpPartida,jugadores[1].nombre, display.contentWidth -150, display.contentHeight-880, native.systemFont, 50 )
    usuario1_text:setFillColor(0,0,0);
    --table.insert(jugadores,jugador1)


    jugadores[2] = Jugador:nuevo("Omar")
    jugadores[2].numero = 2
    usuario2_text = display.newText(grpPartida,jugadores[2].nombre, display.contentWidth - 350 , display.contentHeight-880, native.systemFont, 50 )
    usuario2_text:setFillColor(0,0,0);
    --table.insert(jugadores,jugador2)
    

    jugadores[3] = Jugador:nuevo("Sebas")
    jugadores[3].numero = 3
    usuario3_text = display.newText(grpPartida,jugadores[3].nombre, display.contentWidth - 350, display.contentHeight-640, native.systemFont, 50 )
    usuario3_text:setFillColor(0,0,0);
   -- table.insert(jugadores,jugador3)
    

    jugadores[4] = Jugador:nuevo("Bolillo")
    jugadores[4].numero = 4
    usuario4_text = display.newText(grpPartida,jugadores[4].nombre, display.contentWidth -150, display.contentHeight-640, native.systemFont, 50 )
    usuario4_text:setFillColor(0,0,0);
    --table.insert(jugadores,jugador4)
    

    colocarCartas()
    grpPartida:insert(grpJugadores[jugadores[1].numero])
    grpPartida:insert(grpJugadores[jugadores[2].numero])
    grpJugadores[2].isVisible = false
    grpPartida:insert(grpJugadores[jugadores[3].numero])
    grpJugadores[3].isVisible = false
    grpPartida:insert(grpJugadores[jugadores[4].numero])
    grpJugadores[4].isVisible = false
    --jugadores[1].cartas1 = 2
    --jugadores[2].cartas1 = 3
    --jugadores[3].cartas3 = 1
    --jugadores[4].cartas5 = 2


    --Banco
    local cartasEspeciales = display.newImageRect(grpPartida,"Imagenes/CartasM/tcartas.png", 100, 140)
    cartasEspeciales.x = display.contentWidth - 650
    cartasEspeciales.y = display.contentHeight- 90

    local arbolBank = display.newImageRect(grpPartida,"Imagenes/CartasM/cartas11.png", 100, 140)
    arbolBank.x = display.contentWidth - 540
    arbolBank.y = display.contentHeight - 90

    local ladrilloBank = display.newImageRect(grpPartida,"Imagenes/CartasM/cartas21.png", 100, 140)
    ladrilloBank.x = display.contentWidth - 430
    ladrilloBank.y = display.contentHeight- 90

    local trigoBank = display.newImageRect(grpPartida,"Imagenes/CartasM/cartas31.png", 100, 140)
    trigoBank.x = display.contentWidth - 320
    trigoBank.y = display.contentHeight- 90

    local vacaBank = display.newImageRect(grpPartida,"Imagenes/CartasM/cartas41.png", 100, 140)
    vacaBank.x = display.contentWidth - 210 
    vacaBank.y = display.contentHeight- 90

    local rocaBank = display.newImageRect(grpPartida,"Imagenes/CartasM/cartas51.png", 100, 140)
    rocaBank.x = display.contentWidth -100
    rocaBank.y = display.contentHeight- 90

    --Dados
    dado1 = display.newImageRect(grpPartida,"Imagenes/dado1.png", 200, 200)
    dado1.x = display.contentWidth -350
    dado1.y = display.contentHeight- 300

    dado2 = display.newImageRect(grpPartida,"Imagenes/dado2.png", 200, 200)
    dado2.x = display.contentWidth- 150
    dado2.y = display.contentHeight- 300

    --Avanzar
    boton = display.newImageRect(grpPartida,"Imagenes/avanzar.png", 100, 100)
    boton.x =  display.contentWidth -100
    boton.y = display.contentHeight-500

    --Objetos
    local casas = display.newImageRect(grpPartida,"Imagenes/Construccion/casa.png", 105, 140)
    casas.x = display.contentCenterX-160
    casas.y = display.contentHeight-100

    local ciudades = display.newImageRect(grpPartida,"Imagenes/Construccion/ciudad.png", 105, 140)
    ciudades.x = display.contentCenterX - 30
    ciudades.y = display.contentHeight-100

    local camino = display.newImageRect(grpPartida,"Imagenes/Construccion/camino.png", 105, 140)
    camino.x = display.contentCenterX +110
    camino.y = display.contentHeight- 100
    

    local tradeo = display.newImageRect(grpPartida,"Imagenes/Construccion/tradeo.png", 400, 240)
    tradeo.x = display.contentCenterX-400
    tradeo.y = display.contentHeight-100



    

    boton:addEventListener("tap", pasarTurno) --Se le agrega el evento al objeto para pasar Turno
    dado1:addEventListener("tap", actualizaDado) --Se le agrega el evento a los dados para que puedan lanzarse
    dado2:addEventListener("tap", actualizaDado)

end

function scene:show(event)
    if(event.phase == "will") then
    elseif (event.phase == "did") then
    end
end


function scene:hide(event)
    if(event.phase == "will") then
    elseif (event.phase == "did") then
    end
end

function scene:destroy(event)
    if(event.phase == "will") then
    elseif (event.phase == "did") then
    end
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)



return scene