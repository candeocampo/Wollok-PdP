/*
Punto 1: operacion.comision()


*/

// INMUEBLES //
class Inmueble{
    const metros
    const cantAmbientes
    const zona

    method valor() = self.valorParticular() + zona.valor()

    method valorParticular() // método abstracto



}

class Casa inherits Inmueble{
    var valorParticular

    override method valorParticular() = valorParticular
}

class Hp inherits Inmueble{
    override method valorParticular() = (14000 * metros).max(500000)
}


class Departamento inherits Inmueble{
    override method valorParticular() = 350000 * cantAmbientes
}



// ZONAS //
class Zona{
    var valor

    method valor() = valor

    //Deben ser actualizables el valor de la Zona
    method valor(nuevoValor){
        valor = nuevoValor
    }
    // También es actualizable el valor por la zona
    //method valor(valorZona){
    //    valor = valorZona
    //}

}

// OPERACIONES //
class Operacion{
    const inmueble // define el inmueble

    // Punto 1
    method comision()



}

class Alquiler inherits Operacion{
    var cantidadMeses

    method comision() = cantidadMeses * inmueble.valor() / 50000 


}

class Venta inherits Operacion{
    var property porcentaje

    method comision() = inmueble.valor() * (1 + self.porcentaje() / 100)

    method porcentaje() = porcentaje

}

class Agente{

    method comision()

}

class Inmobiliaria{
    const agentes = []
}












































