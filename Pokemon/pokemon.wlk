// PUNTO 1)
/* pokemon.grositud()*/

// PUNTO 2a)
// movimiento.usarEntre(usuario, contrincante)

// 2.b)
// pokemon.lucharContra(contrincante)

class Pokemon{

    const vidaMaxima
    const movimientos = []
    var vida = 0
    var property condicion = normal

    method grositud () = vidaMaxima * movimientos.sum{movimiento => movimiento.poder()}

    method curar(puntosDeSalud){
        vida = (vida + puntosDeSalud).min(vidaMaxima) // que al agg vida no supere la vida maxima
    }

    method recibirDanio(danio){
        vida = 0.max(vida - danio)
    }

    method lucharContra(contrincante){
        self.validarQueEstaVivo()
        const movimientoAUsar = self.movimientoDisponible()//elegir un mov disponible
        // usar el mov sólo si la cond lo permite
        condicion.intentaMoverse(self)
        movimientoAUsar.usarEntre(self, contrincante) //el self sería del pokemon
    }

    method movimientoDisponible() = movimientos.find{movimiento => movimiento.estaDisponible()}

    method normalizar(){
        condicion = normal
    }
    
    method validarQueEstaVivo(){
        if(vida==0){
            self.error("El pokemon no está vivo")
        }
    }
}


//Movimientos
class Movimiento{
    var usosPendientes = 0 // realmente cuando lo instanciamos deberiamos poner los usos

    method estaDisponible() = usosPendientes > 0

    method afectarPokemones(usuario,contrincante) // es un método abstracto

    method usarEntre(usuario,contrincante){
        if(!self.estaDisponible()){
            self.error("El movimiento no está disponible.")
            usosPendientes -= 1 //decremento el uso
            self.afectarPokemones(usuario,contrincante)
        }
    }

}

class MovimientoCurativo inherits Movimiento{
    const puntosDeSalud

    method poder() = puntosDeSalud

    override method afectarPokemones(usuario,contrincante){
        usuario.curar(puntosDeSalud)
    }

}

class MovimientoDanino inherits Movimiento{
    const danio

    method poder() = danio * 2

    override method afectarPokemones(usuario,contrincante){
        contrincante.recibirDanio(danio)
    }

}

// const confusion = new Confusion(turnosQueDura = 2)
// const movimiento = new MovimientoEspecial(condicionQueGenera = confusion)
// afectarPokemones --> pokemon.condicion(confusion)
class MovimientoEspecial inherits Movimiento{
    const condicionQueGenera

    method poder() = condicionQueGenera.poder()

    
    override method afectarPokemones(usuario,contrincante){
        contrincante.condicion(condicionQueGenera) // otra forma: contrincante.condicion(condicionQueGenera)
    }
    
}

// COndicion
class CondicionEspecial{
    
    method intentaMoverse(pokemon){
        if(!self.lograMoverse())
            self.error("No puede moverse el pokemon")
    }

    method lograMoverse() = 0.randomUpTo(2).roundUp().even()

    method poder() // sería abstracto

}

object normal {
    method intentaMoverse(pokemon){
		// siga, siga
	}
}

// Condiciones Especiales
object paralisis inherits CondicionEspecial{
    
    override method poder() = 30

}

object suenio inherits CondicionEspecial{
    
    override method poder() = 50

    override method intentaMoverse(pokemon){
        super(pokemon)
        pokemon.normalizar()
    }
}

class Confusion inherits CondicionEspecial{ //acá no va como object nos interesa la cant de turnos acá
    const turnosQueDura = 0

    override method poder() = 40 * turnosQueDura

    override method intentaMoverse(pokemon){
		self.pasoUnTurno(pokemon)
		try{
			super(pokemon)
		}
		catch e{
			pokemon.recibirDanio(20)
            self.error("El pokemon no pudo moverse y se hizo daño a si mismo.")
		}
    }

    method pasoUnTurno(pokemon){
        if(turnosQueDura == 0){
            pokemon.normalizar()
        }else{
            pokemon.condicion(new Confusion(turnosQueDura = turnosQueDura - 1)) // con esto evitamos que mute
        }
    }

}































