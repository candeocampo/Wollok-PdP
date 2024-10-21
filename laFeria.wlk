
object julieta{

    var property tickets = 15 // esto son atributos, var: que cambia
    var cansancio = 0

    method punteria() = 20 //es de CONSULTA

    method fuerza() = 80 - cansancio // un valor que muta, conviene hacer method
 
    //method tickets() = tickets // esto nos retorna los tickets para que podamos verlos

    //method tickets(nuevoValor){ //esto da una orden; el de arriba es de consulta.
    //    tickets = nuevoValor
    //}

    method jugar(juego){
        tickets = tickets + juego.ticketsGanados(self) // el self hace que se pase a si misma
        cansancio = cansancio + juego.cansancioQueProduce()
    }

    method puedeCanjear(premio) = tickets >= premio.costo()

}

object gerundio {

    method jugar(juego){}
  
    method puedeCanjear(premio) = true

}
// ya son polimorfimos respecto a que puede canjear a un premio pero no para 
// jugar;
// dos obj son poliformiscos para un 3° que quiere utilizarlo

// JUEGOS
// delegamos los juegos en objetos
object tiroAlBlanco {

    method ticketsGanados(jugador) = (jugador.punteria()/10).roundUp()

    method cansancioQueProduce() = 3

}

object pruebaDeFuerza {
    method ticketsGanados(jugador) =
        if(jugador.fuerza() > 75){
            return 20
        }else{
            return 0
        }
    
    method cansancioQueProduce() = 8
  
}

object ruedaDeLaFortuna {

    var property aceitada = true // con el property evito escribir los dos methods de aceitada

    // method aceitada() = aceitada // si ya lo está

    //method aceitada(nuevoValor){ // permite poner un nuevo valor desde afuera
    //    aceitada = nuevoValor
    //}

    method ticketsGanados(jugador) = 0.randomUpTo(20).roundUp() // roundUp redondea.

    method cansancioQueProduce() =
        if(aceitada){
            return 0
        }else{
            return 1
        }

}

// PUNTO 2
// PREMIOS
object ositoDePeluche {

    method costo() = 45

}

object taladro {
  
  var property costo = 200 // puede variar; por eso el propierty

}


























