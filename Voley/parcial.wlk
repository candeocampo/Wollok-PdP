/*
Puntos de entrada
1. equipo.promedioAlturaJugadores()
2. jugador.tieneSaquePeligroso()
3. jugador.puedeRematar()
4. equipo.rotar()
5. partido.equipoTieneVentaja()
6. equipo.anotarPunto() || partido.anotarPuntoDe(equipo)
*/

class Partido{
    const marcadorEquipo
    const marcadorOtroEquipo
    var estadoActual

    // abstracciones para manipular el marcador de un equipo
    method marcadores() = [marcadorEquipo,marcadorOtroEquipo]
    method marcadorDe(equipo) = self.marcadores().find{marcador => marcador.equipo() == equipo}

    // Punto 5
    method equipoTieneVentaja() = estadoActual.equipoTieneVentaja()

    method equiposJuegan() = self.marcadores().map{marcador => marcador.equipo()}
    method equipoConMayorAlturaPromedio() = self.equiposJuegan().max{equipo => equipo.promedioAlturaJugadores()}

    method equiposEmpatados() = marcadorEquipo.puntoEquipo() == marcadorOtroEquipo.otroEquipo()
    method equipoConMayorPuntaje() = marcadorEquipo.puntoEquipo() > marcadorOtroEquipo.puntosEquipo()

    method puntajeDe(equipo) = self.marcadorDe(equipo).puntos()

    // Punto 6
    method anotarPunto(equipo){
        estadoActual.anotarPunto(self,equipo)
    }

    method algunEquipoCon25() = self.marcadores().any{equipo => self.puntajeDe(equipo) >= 25}
    method hayDiferenciaDe2Puntos() = marcadorEquipo.puntosEquipo() - marcadorOtroEquipo.puntoEquipo() == 2

    method hayPuntajeFinal() = self.algunEquipoCon25() && self.hayDiferenciaDe2Puntos()



}

class Marcador{
    const property equipo // tiene un equipo
    var property puntoEquipo = 0
    method ganarPunto(cantidad){
        puntoEquipo +=cantidad
    }
}

class EstadoPartido{

    // Punto 5
    method equipoTieneVentaja(partido){
        if(partido.equiposEmpatados(partido)) self.equipoConVentajaDeEmpate(partido)
        else partido.equipoConMayorPuntaje()
    }
    method equipoConVentajaDeEmpate(partido) = partido.equipoConMayorAlturaPromedio() 

    // Punto  6 
    method anotarPunto(partido,equipo)
}

class EnJuego inherits EstadoPartido{
    var property equipoEnSaque

    // Punto 5
    override method equipoConVentajaDeEmpate(partido){
        if(self.equipoEnSaque().tieneSacadorPeligroso()){
            return self.equipoEnSaque()
        }
        return super(partido)
    }

    // Punto 6
    override method anotarPunto(partido,equipo){
        partido.marcadorDe(equipo).ganarPunto(1)
        if(equipo != self.equipoEnSaque()){
            equipo.rotar()
            self.cambiarSaqueA(equipo)
        }
        self.verificarFinalizacion(partido)
    }

    method cambiarSaqueA(equipo){
        equipoEnSaque = equipo
    }

    method verificarFinalizacion(partido){
        if(partido.hayPuntajeFinal()){
            partido.estadoActual(new Terminado())
        }
    }

}

class EnSaque inherits EstadoPartido{

    override method anotarPunto(partido,equipo){
        partido.estadoActual(new EnJuego(equipoEnSaque = equipo))
    }

}

class Terminado inherits EstadoPartido {
    override method anotarPunto(partido, equipo){
        throw new PartidoTerminadoException(message = "El partido esta finalizado, no es posible anotar mas puntos")
    }
}

class PartidoTerminadoException inherits DomainException{}



class Equipo{
    const jugadores = []

    // Punto 1
    method promedioAlturaJugadores() = jugadores.sum{jugador => jugador.altura()} / self.cantidadJugadores()
    method cantidadJugadores() = jugadores.size()

    // Punto 4
    method rotar() = jugadores.forEach{jugador => jugador.cambarPosicion()}

    // Punto 5
    method tieneSacadorPeligroso() = jugadores.find{jugador => jugador.posicionSaque()}.tieneSaquePeligroso()
}

class Jugador{
    const property altura
    const property precision
    const property potencia
    const saquesQueConoce = #{}
    // Punto 3
    var property posicionActual

    // Punto 2
    method tieneSaquePeligroso() = saquesQueConoce.any{saque => saque.tecnicaPeligrosa()}
    method dominaUn(saque) = saque.efectividadDeUn(self) > 80

    // Punto 3
    method puedeRematar() = (altura >= 1.60) && posicionActual.puedeRematar(self)
    // Punto 4
    method cambarPosicion(){
        posicionActual = posicionActual.posicionSiguiente() // VA A HABER UN EFECTO EN LA POSICIÓN
    }   

    // Punto 5
    method posicionSaque() = posicionActual.posicionSaque()
}

// Posiciones 
class Posicion{
    const numPosicion
    const numPosicionSig

    method puedeRematar(jugador)
    // Punto 4
    method posicionActual() = numPosicion
    method posicionSiguiente() = numPosicionSig

    // Punto 5
    method posicionSaque() = false
}

class Delantero inherits Posicion{
    override method puedeRematar(jugador) = true
}

class Zaguero inherits Posicion{
    override method puedeRematar(jugador) = false
}

object zagueroDerecho inherits Zaguero(numPosicion = 1, numPosicionSig = 6){
    override method posicionSaque() = true
}
object delanteroDerecho inherits Delantero(numPosicion = 2, numPosicionSig = 1){}
object delanteroCentro inherits Delantero(numPosicion = 3, numPosicionSig = 2){}
object delanteroIzquierdo inherits Delantero(numPosicion = 4, numPosicionSig = 3){}
object zagueroIzquierdo inherits Zaguero(numPosicion = 5, numPosicionSig = 4){}
object zagueroCentro inherits Zaguero(numPosicion = 6, numPosicionSig = 5){}



// Saques

class Saque{
    method tecnicaPeligrosa(jugador) = self.tecnicaPeligrosa(jugador) && jugador.dominaUn(self)
    method efectividadDeUn(jugador)
}

object saqueDeAbajo inherits Saque{
    override method efectividadDeUn(jugador) = jugador.precision() * 5
    override method tecnicaPeligrosa(jugador) = false
}

class SaqueDeArriba inherits Saque{
    // no hace la gran cosa, solamente nos guia de donde provienen los saques de arriba
}

object deTenis inherits SaqueDeArriba{
    override method efectividadDeUn(jugador) = (jugador.precision() / 2 + jugador.potencia()) * 3
    override method tecnicaPeligrosa(jugador) = jugador.potencia() > 10
}

class EnSalto inherits SaqueDeArriba{
    const efectividadEnSalto
    override method efectividadDeUn(jugador) = efectividadEnSalto
    override method tecnicaPeligrosa(jugador) = true // siempre es peligrosa.
}


































