/*
1) equipo.alturaPromedio()
2) jugador.saquePeligroso()
3) jugador.puedeRematar()
4) equipo.rotar()
5) partido.equipoConVentaja()
6) partido.anotarPunto(equipo) o equipo.anotarPunto(partido)
*/

// Punto 4
class Partido{
    var property estadoActual = new PorElSaque()
    const marcadorEquipoA
    const marcadorEquipoB

    // abstracciones para facilitar el uso interno de los marcadores
    method marcadores() = [marcadorEquipoA,marcadorEquipoB]
    method marcadorEquipo(equipo) = self.marcadores().find{marcador => marcador.equipo() == equipo}

    method equipoConVentaja() = estadoActual.equipoConVentaja()

    // abstracciones para el punto 4, para obtener informacion del partido, encapsulando detalles del marcador.
    method equipos() = self.marcadores().map{marcador=>marcador.equipo()}
    method puntajeEquipo(equipo) = self.marcadorEquipo(equipo).puntos() 
    method empate() = marcadorEquipoA.puntos() == marcadorEquipoB.puntos()

    // punto 4
    method equipoConMayorPuntaje() = self.equipos().max({equipo => self.puntajeEquipo(equipo)})

    // Punto 6
    method algunEquipoCon25Puntos() = self.equipos().any({equipo => self.puntajeEquipo(equipo) >=25})
    method hayDiferenciaMayorA2() = (marcadorEquipoA.puntos() - marcadorEquipoB.puntos()).abs() >=2

    method hayPuntajeFinal() = self.algunEquipoCon25Puntos() && self.hayDiferenciaMayorA2()
}

class Marcador{
    var puntos = 0
    const property equipo

    method puntos() = puntos

    method sumarPuntos(puntoGanado){
        puntos +=puntoGanado
    }
}

class EstadoPartido{
    method equipoConVentaja(partido){
        if(partido.estanEmpatados()) self.equipoConVentajaEnEmpate(partido) // No utilizamos return porque no esperamos que nos devuelva algo
        else partido.equipoConMayorPuntaje()
    }
    method equipoConVentajaEnEmpate(partido) = partido.equipos().max{equipo => equipo.alturaPromedio()}
    method anotaPunto(partido,equipo)
}

// estados de partido
class PorElSaque inherits EstadoPartido{
    override method anotaPunto(partido,equipo){
        partido.estadoActual(new EnJuego(equipoEnSaque = equipo))
    }
}

class EnJuego inherits EstadoPartido{
    var property equipoEnSaque // el equipo que saca en el PARTIDO

    override method equipoConVentajaEnEmpate(partido){
        if(self.equipoEnSaque().tieneSacadorPeligroso()){ // acá si utilizamos return pues el método necesita devolver un valor
            return self.equipoEnSaque()
        }
        return super(partido)
    }

    // Punto 6
    override method anotaPunto(partido,equipo){
        partido.marcadorEquipo(equipo).sumarPuntos(1) // sumar punto
        if(equipo!=equipoEnSaque){ 
            equipo.rotar()
            self.cambiarSaqueA(equipo)
        }
        self.verificarFinDe(partido)
    }

    method cambiarSaqueA(equipo){
        equipoEnSaque = equipo
    }

    method verificarFinDe(partido){
        if(partido.hayPuntajeFinal()){
            partido.estadoActual(new Terminado())
        }
    }
}

class Terminado inherits EstadoPartido{
    override method anotaPunto(partido,equipo){
        throw new PartidoTerminadoException(message = "Fin del partido, no se pueden anotar más puntos")
    }
}

class PartidoTerminadoException inherits DomainException{}


class Equipo{
    const integrantes = []
    var property puntos
    // Punto 1
    method alturaPromedio() = integrantes.sum{jugador => jugador.altura()} / self.cantidadJugadores()
    method cantidadJugadores() = integrantes.size()

    // Punto 4
    method rotar() = integrantes.forEach{jugador => jugador.cambiarPosicionAlRotar()}

    // Punto 5
    method tieneSacadorPeligroso() = integrantes.find({jugador => jugador.posicionDeSaque()}).saquePeligroso()

}

class Jugador{
    const property altura
    const property precision
    const property potencia
    const saquesQueConoce = []
    // Punto 3
    var property posicionActual

    method saquePeligroso() = saquesQueConoce.any{saque => saque.esPeligroso(self)}

    method dominaSaque(saque) = saque.efectividad(self) > 80 

    // Punto 3
    method puedeRematar() = (altura >= 1.60) && posicionActual.permiteRematar()

    // Punto 4
    method cambiarPosicionAlRotar(){
        posicionActual = posicionActual.posicionSiguiente() // ??
    }

    // Punto 5
    method posicionDeSaque() = posicionActual.posicionDeSaque()
}

// SAQUES 

class Saque{

    method efectividad(jugador)  // método abstracto
    method esPeligroso(jugador) = self.tecnicaPeligrosa(jugador) && jugador.dominaSaque(self)
    method tecnicaPeligrosa(jugador) // método abstracto

}

class SaqueDeAbajo inherits Saque{
    override method efectividad(jugador) = jugador.precision() * 5
    override method tecnicaPeligrosa(jugador) = false
}

class SaqueDeArriba inherits Saque{} // no aporta nada, es abstracto

object saqueTenis inherits SaqueDeArriba{
    override method efectividad(jugador) = (jugador.precision() / 2 + jugador.potencia()) * 3
    override method tecnicaPeligrosa(jugador) = jugador.potencia() > 10
}

class SaqueEnSalto inherits SaqueDeArriba{
    const efectividadaSaqueEnSalto

    override method efectividad(jugador) = efectividadaSaqueEnSalto
    override method tecnicaPeligrosa(jugador) = true
}

// POSICIONES
class Posicion{
    const property numPosicion
    const property posicionSiguiente

    method permiteRematar() // abstracto

}

class Delantero inherits Posicion{
    override method permiteRematar() = true
}

class Zaguero inherits Posicion{
    override method permiteRematar() = false
}

// Posiciones conocidas 
object zagueroDerecho inherits Zaguero(numPosicion = 1, posicionSiguiente = zagueroCentro){}
object delanteroDerecho inherits Delantero(numPosicion = 2, posicionSiguiente = zagueroDerecho){}
object delanteroCentro inherits Delantero(numPosicion = 3, posicionSiguiente = delanteroDerecho){}
object delanteroIzquierdo inherits Delantero(numPosicion = 4, posicionSiguiente = delanteroCentro){}
object zagueroIzquierdo inherits Zaguero(numPosicion = 5, posicionSiguiente = delanteroIzquierdo){}
object zagueroCentro inherits Zaguero(numPosicion = 6, posicionSiguiente = zagueroIzquierdo){}


