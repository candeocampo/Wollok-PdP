/*
1) equipo.alturaPromedio()
2) jugador.saquePeligroso()
3) jugador.puedeRematar()
4) equipo.rotar()


*/

class Equipo{
    const integrantes = []

    // Punto 1
    method alturaPromedio() = integrantes.sum{jugador => jugador.altura()} / self.cantidadJugadores()
    method cantidadJugadores() = integrantes.size()

    // Punto 4
    method rotar()

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

object zagueroDerecho inherits Zaguero(numPosicion = 1, posicionSiguiente = zagueroCentro){}

object delanteroDerecho inherits Delantero(numPosicion = 2, posicionSiguiente = zagueroDerecho){}
object delanteroCentro inherits Delantero(numPosicion = 3, posicionSiguiente = delanteroDerecho){}
object delanteroIzquierdo inherits Delantero(numPosicion = 4, posicionSiguiente = delanteroCentro){}
object zagueroIzquierdo inherits Zaguero(numPosicion = 5, posicionSiguiente = delanteroIzquierdo ){}
object zagueroCentro inherits Zaguero(numPosicion = 6, posicionSiguiente = zagueroIzquierdo){}



























