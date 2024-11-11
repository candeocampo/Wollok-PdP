// PUNTO 1)
/* pokemon.grositud()*/

class Pokemon{

    const vidaMaxima
    const movimientos = []

    method grositud () = vidaMaxima * movimientos.sum{movimiento => movimiento.poder()}

}


class MovimientoCurativo{
    const puntosDeSalud

    method poder() = puntosDeSalud

}

class MovimientoDanino{
    const danio

    method poder() = danio * 2

}

class MovimientoEspecial{
    const condicionQueGenera

    method poder() = condicionQueGenera.poder()
    
}

// Condiciones
object paralisis {
    method poder() = 30
}

object suenio{
    method poder() = 50
}

// PUNTO 2
// movimiento.usarEntre(usuario, contrincante)






























