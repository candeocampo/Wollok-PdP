/*
Punto 1) posta.esMejor(competidor,competidor2)

*/

// PERSONAJE // 
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



}


// ITEMS Y ARMA
class Item{

    method danio() = 0 // esto sería para cuaquier otra que no sea arma
}

class Arma inherits Item{
    var property danio
}


// POSTAS
class Posta{

    var property competidores

    method esMejor(competidor1,competidor2)

    method hambreQueProduce() // clase abstracta


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






























