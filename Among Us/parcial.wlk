/*
Puntos de entrada:
1. jugador.esSospechoso()
2. jugador.buscar(item)
3. jugador.completoTodasSusTareas()
4. jugador.realizarTarea()
5. jugador.realizarSabotaje()


*/

class Jugador{
    const color 
    const mochila = []
    var nivelSospecha = 40
    const tareasARealizar = []
    var rol // para saber si es tripulante o impostor

    // Punto 1
    method esSospechoso() = nivelSospecha > 50
    // Punto 2
    method buscar(item) = mochila.add(item)

    // Parte 3
    method completoTareas() // abstracto

    // Punto 4
    method aumentarSospecha(puntos){
        nivelSospecha +=puntos
    }

    // Mochila metodos
    method contieneElemento(item) = mochila.contains(item)
    method usar(item) = mochila.remove(item)

    // Punto 5
    method votar()

}

// Tipos de rol
class Impostor inherits Jugador{

    override method completoTareas() = true
    method realizarTarea(){
        // no hace nada
    }

    // Punto 5
    method realizarSabotaje(sabotaje){
        self.aumentarSospecha(5)
        sabotaje.puedeSabotear(self)
    }
}

object reducirOxigeno{
    method puedeSabotear(impostor){
        if(!nave.alguienTiene("tubo de oxigeno")){
            nave.disminuirOxigeno(10)
        }
    }
}

object impugnarAJugador{
    method puedeSabotear(impostor) = impostor.votar()
}



class Tripulante inherits Jugador{
    override method completoTareas() = tareasARealizar.isEmpty()

    method tareasPendientes() = tareasARealizar.find{tarea => tarea.puedeCompletarTarea(self)}

    method realizarTarea(){
        const tareaPendiente = self.tareasPendientes()
        tareaPendiente.realizadaPor(self)
        tareasARealizar.remove(tareaPendiente)
        nave.finalizarTarea()
    }

}
// Tipos de tareas de los tripulantes
class Tarea{
    const elementoNecesario

    method puedeCompletarTarea(jugador) = elementoNecesario.all{elemento => jugador.contieneElemento(elemento)}

    method realizadaPor(jugador){
        self.afectarA(jugador)
        self.utilizarItemsNecesarios(jugador)  
    }

    method utilizarItemsNecesarios(jugador) = elementoNecesario.forEach{elemento => jugador.usar(elemento)}

    method afectarA(jugador)

}
object arregarTableroElectrico inherits Tarea(elementoNecesario = "llave inglesa"){
    override method afectarA(jugador) = jugador.aumentarSospecha(10)
}

object sacarLaBasura inherits Tarea(elementoNecesario = ["escoba", "bolsa de consorcio"]){
    override method afectarA(jugador) = jugador.disminuirSospecha(4)
}

object ventilarLaNave inherits Tarea(elementoNecesario = []){
    override method afectarA(jugador){
        nave.aumentarOxigeno(5)
    }
}

object nave{
    var property nivelOxigeno = 100
    const jugadores = #{}

    method aumentarOxigeno(cantidad){
        nivelOxigeno += cantidad
    }

    // Punto 4
    method completaronTodosTareas() = jugadores.all{jugador => jugador.completoTareas()}

    method finalizarTarea(){
        if(self.completaronTodosTareas()){
            throw new GanaronTripuExeption (message = "Ganaron los tripulantes")
        }
    }
    // Punto 5
    method alguienTiene(item) = jugadores.any{jugador => jugador.contieneElemento(item)}

    method disminuirOxigeno(cantidad){
        nivelOxigeno -=cantidad
        self.validarSiGanaronImpostores()
    }

    method validarSiGanaronImpostores(){
        if(nivelOxigeno==0){
            throw new GananImpostoresException(message ="Ganaron los impostores")
        }
    }

}

class GananImpostoresException inherits DomainException{}
class GanaronTripuExeption inherits DomainException{}
























































