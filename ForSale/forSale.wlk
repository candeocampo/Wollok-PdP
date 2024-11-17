/*
Punto 1: operacion.comision()
Punto 2: inmobiliaria.mejorEmpleadoSegun(criterio)
Punto 3: empleado.vaATenerProblemas(otro)



*/

// INMUEBLES //
class Inmueble{
    const metros
    const cantAmbientes
    const zona

    method valor() = self.valorParticular() + zona.valor()

    method valorParticular() // método abstracto

    method zona() = zona

    method validarParaQueSeaVendido()
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
    var estado = disponible // si la operacion esta disponible

    // Punto 1
    method comision()

    // Punto 4
    method concretarPara(cliente){
        estado.concretarPara(self,cliente)
    }

    method estado(nuevoEstado){ // el estado cambia
        estado = nuevoEstado
    }
}

// Estados de operaciones: cerradas o abiertas
class EstadoDeOperacion{
    method reservarPara(operacion,cliente)

    method concretarPara(operacion,cliente)

    method validarCierrePara(cliente)
}

object disponible {
    method reservarPara(operacion,cliente){
        // const nuevaReserva = operacion.estado(new Reservada(cliente))
    }
}

object cerrada{
    method reservarPara(operacion,cliente){
        self.error("No se pudo reservar")
    }
    method validarCierrePara(cliente){
        self.error("No se puede cerrar la operación más de una vez")
    }
}

class Reservada inherits EstadoDeOperacion{
    const property clienteQueReservo

    //method clienteQueReservo(cliente){
    //    clienteQueReservo = cliente
    //}
    
    override method reservarPara(operacion,cliente){
        self.error("Ya había una reserva previa")
    }

    override method concretarPara(operacion,cliente){
        if(cliente != self.clienteQueReservo()){
            self.error("La operacion está reservada para otro cliente")
        }
    }
}

// TIPOS DE OPERACIONES: venta, alquiler //

class Alquiler inherits Operacion{
    var cantidadMeses

    override method comision() = cantidadMeses * inmueble.valor() / 50000 
}

class Venta inherits Operacion{
    var property porcentaje

    override method comision() = inmueble.valor() * (1 + self.porcentaje() / 100)
    method porcentaje() = porcentaje
}

// Punto 2
class Inmobiliaria{
    const empleados = #{}
    method mejorEmpleadoSegun(criterio) = empleados.max({empleado => criterio.ponderacion(empleado)})

}

// Criterios de "Mejor Empleado según"
object porTotalComisiones{
    method ponderacion(empleado) = empleado.comisionesTotales()

}

object porCantOperacionesCerradas{
    method ponderacion(empleado) = empleado.operacionesCerradas().size()

}

object porCantidadReservas {
    method ponderacion(empleado) = empleado.reservas().size() 
}

class Empleado{
    const operacionesCerradas = #{}
    const reservas = #{}

    method operacionesCerradas() = operacionesCerradas.size() // contamos las operaciones cerradas

    method comisionesTotales() = operacionesCerradas.sum{empleado => empleado.comision()}

    method zonasEnLasQueOpero() = operacionesCerradas.map({operacion => operacion.zona()}).asSet()

    method operoEnZona(zona) = self.zonasEnLasQueOpero().contains(zona) // vemos si la zona pasada por parametro está en la zona

    // Punto 3
    method vaATenerProblema(otroEmpleado) = 
        self.operoEnMismaZona(otroEmpleado) && ((self.concretoOperacionReservadaPor(otroEmpleado) || otroEmpleado.concretoOperacionReservadaPor(self)))

    method operoEnMismaZona(otroEmpleado) = self.zonasEnLasQueOpero().any({zona => otroEmpleado.operoEnZona(zona)}) 

    method concretoOperacionReservadaPor(otroEmpleado) = operacionesCerradas.any({operacion => otroEmpleado.reservo(operacion)})

    method reservas() = reservas // hacemos un método para acceder a las reservas

    method reservo(operacion) = reservas.contains(operacion) // si se reservo entonces la operación debe contenerse

    // Punto 4
    method concretarOperacion(operacion,cliente){
        operacion.concretarPara(cliente) //concretamos la operación
        operacionesCerradas.add(operacion) // agregamos la operación concretada
    }

    method reservarPara(operacion,cliente){
        operacion.reservarPara(operacion,cliente) // hacemos la reserva
        reservas.add(operacion)
    }

}

class Cliente{
    var property nombreCliente

    method nombre(nombre){
        nombreCliente = nombre
    }
}


// Punto 5
/*
class Inmueble{
    const metros
    const cantAmbientes
    const zona

    method valor() = self.valorParticular() + zona.valor()

    method valorParticular() // método abstracto

    method zona() = zona

    method validarParaQueSeaVendido()
}

class Casa inherits Inmueble{
    var valorParticular

    override method valorParticular() = valorParticular
}

*/
class Local inherits Casa{
    var tipoLocal

    override method valor() = tipoLocal.valor(super())

    override method validarParaQueSeaVendido(){
        self.error("No se puede vender un local")
    }

}

object galpon{
    method valorFinal(precioBase) = precioBase / 2
}

object aLaCalle{
    var montoFijo

    method montoFijo(monto){
        montoFijo = monto
    }

    method valorFinal(precioBase) = precioBase + montoFijo
}









































