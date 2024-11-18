

// USANDO COMPOSICION
// const empleado = new Empleado(puesto = espia)

class Empleado{
    var property puesto //el puesto del empleado
    var salud
    var habilidades = []

    method estaIncapacitado() = salud < puesto.saludCritica() 

    // Punto 2
    method puedeUsar(habilidad) = !self.estaIncapacitado() && self.poseeHabilidad(habilidad)

    method poseeHabilidad(habilidad) = habilidades.contains(habilidad)

}

class Jefe inherits Empleado{
    const subordinados = []

    override method poseeHabilidad(habilidad) = 
        super(habilidad) || self.algunoDeSusSobordinadosLaPuedeUsar(habilidad)
    
    method algunoDeSusSobordinadosLaPuedeUsar(habilidad) = subordinados.any{subordinado => subordinado.poseeHabilidad(habilidad)}

}


// el objeto puesto sirve para decirnos la salud critica del empleado

object espia{
    method saludCritica() = 15
}

class Oficinista{ // como acá tenemos más interacciones(osea compartimos) es una clase
    var cantidadEstrellas = 0 

    method saludCritica() = 40 - 5 * cantidadEstrellas

    
    method ganarEstrella(cantidad){
        cantidadEstrellas +=cantidad
    }
}




















