
object julieta{

    var tickets = 15 // esto son atributos, var: que cambia
    var cansancio = 0

    method punteria() = 20 //es de CONSULTA

    method fuerza() = 80 - cansancio // un valor que muta, conviene hacer method
 
    method tickets() = tickets // esto nos retorna los tickets para que podamos verlos

    method tickets(nuevoValor){ //esto da una orden; el de arriba es de consulta.
        tickets = nuevoValor
    }

    method jugar(juego){
        tickets = tickets + juego.ticketsGanados()
        cansancio = cansancio + juego.cansancioQueProduce()
    }

}


// JUEGOS
// delegamos los juegos en objetos
object tiroAlBlanco {
    method ticketsGanados() {
      
    }
    method cansancioQueProduce() {
      
    }


}

object pruebaDeFuerza {
    method ticketsGanados() {
      
    }
    method cansancioQueProduce() {
      
    }
  
}

object ruedaDeLaFortuna {
    method ticketsGanados() {
      
    }
    method cansancioQueProduce() {
      
    }

  
}

























