/*
Punto 1) pokemon.grositud()
Punto 2.a) movimiento.usarEntre(usuario,contricante)
Punto 2.b) pokemon.lucharContra(contrincante)

*/
class Pokemon{
    const movimientos = []
    const vidaMaxima // es constante
    var puntosDeVida = 0
    var property condicion = normal // condicion

    method grositud() = vidaMaxima * self.poderTotalDeMovimientos()

    method poderTotalDeMovimientos() = movimientos.sum{movimiento => movimiento.poder()}

    // Punto 2.a
    method curarVida(cantidad) {
        puntosDeVida = (cantidad + puntosDeVida).min(vidaMaxima)
    }

    method recibirDanio(danio){
        puntosDeVida -=danio
    }

    // Punto 2.b 
    method lucharContra(contrincante){
        if(!self.estaVivo()){
            self.error("El pokemon no está vivo")
        }
        const movimientoAUsar = self.movimientoDisponible() // elegir un movimiento disponible
        condicion.intentaMoverse(self) // usar ese movimiento sólo si la condición del mov se lo permite
        movimientoAUsar.usarEntre(self,contrincante)
    }

    method movimientoDisponible() = movimientos.find({movimiento => movimiento.estaDisponible()})

    method normalizar(){
        condicion = normal
    }

    method estaVivo() =  puntosDeVida > 0


}


class Movimiento{
    var cantidadUsos = 0

    // Punto 2.a
    method usarEntre(usuario,contrincante){
        if(!self.estaDisponible()){
            self.error("Movimiento agotado!")
        }
        self.modificarUsosMovimiento(1)
        self.afectarPokemones(usuario,contrincante)
        
    }

    method modificarUsosMovimiento(cantidad){
        cantidadUsos -= cantidad
    }

    method estaDisponible() = cantidadUsos > 0

    method afectarPokemones(usuario,contrincante) // No podría hacer efectoMovimiento() porque el enunciado hablá de que el efecto afecta a uno y al contrincante ¡¡¡A tener en cuenta!!!


}

class Curativo inherits Movimiento{
    const puntosDeSalud

    method poder() = puntosDeSalud 

    override method afectarPokemones(usuario,contrincante){
        usuario.curarVida(puntosDeSalud) //"El pokemon que lo usa se cura la vida"
    }
}

class Danino inherits Movimiento{
    const danioQueProduce

    method poder() = danioQueProduce * 2

    override method afectarPokemones(usuario,contrincante){
        contrincante.recibirDanio(danioQueProduce) //"El pokemon enfrentado recibe un danio que depende del mov..."
    }
}

class Especial inherits Movimiento{
    const tipoCondicion

    method poder() = tipoCondicion.poder()

    override method afectarPokemones(usuario,contrincante){
        contrincante.condicion(tipoCondicion) // "Pasa a tener la condición especial que el mov genera..."
    }

}

// Hacemos una clase
class CondicionEspecial{
    method intentaMoverse(pokemon){ // acá avisa si intento moverse
        if(!self.lograMoverse()){
            self.error("No pudo moverse")
        }
    }

    method lograMoverse() = 0.randomUpTo(2).roundUp().even()

    method poder()
}


object suenio inherits CondicionEspecial{

    override method poder() = 50

    override method intentaMoverse(pokemon){
        super(pokemon)
        pokemon.normalizar()
    }
}

object paralisis inherits CondicionEspecial{
    override method poder() = 30
}

object normal{
    // es una condición que tiene un pokemon que tiene cuando NO tiene ninguna condicion especial
    method intentaMoverse(pokemon){
        // ok entiende el msj listo
    }
}

class Confusion inherits CondicionEspecial{
    const duracionTurnos
    
    override method poder() = 40 * duracionTurnos

    override method intentaMoverse(pokemon){
        if(super(pokemon)){
            pokemon.recibirDanio(20)
            self.pasoUnTurno(pokemon)
            self.error("El pokemon no pudo moverse")
        }
        self.pasoUnTurno(pokemon)
    }

    method pasoUnTurno(pokemon){
        if(duracionTurnos > 1){
            pokemon.condicion(new Confusion(duracionTurnos = duracionTurnos - 1))
        }else{
            pokemon.normalizar()
        }
    }
}

