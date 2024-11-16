
/*
Punto 1) posta.esMejor(competidor,competidor2)
Punto 2) torneo.jugarse()

*/



class Vikingo{
    var property peso
	var property barbarosidad
	var property velocidad
	var property nivelDeHambre
    var property item

    method cantidadDePescadoQuePuedeCargar(){
        return peso * 0.50 + 2 * barbarosidad
    }

    method incrementarHambre(cantidad){
        peso = (peso + cantidad).max(0)
    }

    method danioQueProduce() = barbarosidad + item.danio()

    method puedeParticipar(posta){
        return self.nivelDeHambre() + posta.hambreQueProduce() < 100
    }

    method sufrirEfectos(posta){
        nivelDeHambre += self.hambreQueProduce(posta)
    }

    method hambreQueProduce(posta){ // Abstracción para poder redefinir sólo esto en patapez
        return posta.hambreQueProduce()
    }




}


// ITEMS Y ARMA
class Item{

    method danio() = 0 // esto sería para cuaquier otra que no sea arma
}

class Arma inherits Item{
    var property danio
}

class Comestible{
    var property porcentajeDisminuye
}

// POSTAS
class Posta{

    var property competidores

    method esMejor(competidor1,competidor2)

    method hambreQueProduce() // clase abstracta

    method inscribirse(participante) = competidores
        .filter({participante => participante.puedeParticipar()}).add(participante)

    method resultadosOrdenados() = competidores.sortBy{mejor,peor=>self.esMejor(mejor,peor)}

}

class Pesca inherits Posta{

    override method esMejor(competidor1,competidor2){
        return competidor1.cantidadDePescadoQuePuedeCargar() > competidor2.cantidadDePescadoQuePuedeCargar()
    }

    override method hambreQueProduce() = 5

}

class Combate inherits Posta{

    override method esMejor(competidor1,competidor2){
        return competidor1.danioQueProduce() > competidor2.danioQueProduce()
    }

    override method hambreQueProduce() = 10

}

class Carrera inherits Posta{

    override method esMejor(competidor1,competidor2){
        return competidor1.velocidad() > competidor2.velocidad()
    }

    override method hambreQueProduce() = 1
}


// Algunos Personajes
class Patapez inherits Vikingo{
  
    override method puedeParticipar(posta){
        return self.nivelDeHambre() < 50
    }

    override method hambreQueProduce(posta){
        return super(posta) * 2
    }

    method comer(){
        nivelDeHambre = 0.max(nivelDeHambre - item.porcentajeDisminuye())
    }

    override method sufrirEfectos(posta){
        super(posta) // esto va por herencia: sufre el efecto de la posta + el propio
        self.comer()
    }

}




























