/*
RESUELTO CON: HERENCIA! :)
Punto 1) empleado.estaIncapacitado()
Puesto 2) empleado.puedeUsar(habilidad)


Ej de instanciación: const juan = new Espia()
empleado.puesto(espia) eso me permitiria que CAMBIE de puesto, al usar COMPOSICIÓN
ATENTO! => Al hacerlo con herencia el puesto de Juan siempre va a ser espia no podría cambiarlo, por eso quizás conviene más con composición


*/


class Empleado{
    const habilidades = [] // no va #{} porque las habilidades son DIFERENTES!
    var property salud
    var puesto
    //var esJefe = false // con esto nos diria si es JEFE o NO pero NO nos conviene ponerlo, pues si es o no jefe depende de subordinados

    method estaIncapacitado() = salud < self.saludCritica()

    method saludCritica() = puesto.saludCritrica() // método abstracto

    // Punto 2
    
    method poseeHabilidad(habilidad) = habilidades.contains(habilidad) // delegamos lo que es en empleado y lo que va en JEFE.

    method puedeUsar(habilidad) = !self.estaIncapacitado() && self.poseeHabilidad(habilidad)

    /* Estos métodos no irán aqui pues corresponden que sean de JEFE.
    method algunSobordinadoTiene(habilidad) = subordinados.any{subordinado => subordinado.puedeUsar(habilidad)}
    
    method esJefe() = subordinados.notEmpty() // nos dice si no está vacía
    */ 
}

class Jefe inherits Empleado{
    const subordinados = []
    
    override method poseeHabilidad(habilidad) = super(habilidad) || self.algunSobordinadoTiene(habilidad)
    
    method algunSobordinadoTiene(habilidad) = subordinados.any{subordinado => subordinado.puedeUsar(habilidad)}


}

object puestoEspia { // esto significa que hay UN único puesto de espia
    method saludCritica() = 15
}

class PuestoOficinista{ // esto no puede ser un object porque tiene estado interno.
    var estrellas = 0
    method saludCritica() = 40 - 5 * estrellas
    method ganarEstrella(cantidad){
        estrellas +=cantidad
    }
}

/*
Punto 2: vemos que repetimos código por lo que la HERENCIA ES DE UN SOLO TIRO!
Debemos usar composición ya que usamos herencia para hacer que un empleado sea oficinista o espia 
y queremos ahora saber si alguno es Jefe

class EspiaJefe inherits Espia{
    const subordinados = []
    
    override method poseeHabilidad(habilidad) = super(habilidad) || self.algunSobordinadoTiene(habilidad)
    
    method algunSobordinadoTiene(habilidad) = subordinados.any{subordinado => subordinado.puedeUsar(habilidad)}
}

class OficinistaJefe inherits Oficinista{
    const subordinados = []
    
    override method poseeHabilidad(habilidad) = super(habilidad) || self.algunSobordinadoTiene(habilidad)
    
    method algunSobordinadoTiene(habilidad) = subordinados.any{subordinado => subordinado.puedeUsar(habilidad)}
}
*/











