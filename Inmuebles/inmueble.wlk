/*
1. operacion.comision()
2. inmobiliaria.mejorEmpleadoSegun(criterio)
3. empleado.vaATenerProblema(otroEmpleado)

*/

class Operacion{
    const inmueble // sería el inmueble
    var estado 

    method comision()

    method zona() = inmueble.zona()

    // punto 5
    method reservarPara(cliente){
        estado.reservarPara(self,cliente)
    }

    method concretarPara(cliente){
        estado.concretarPara(self,cliente)
    }

    method nuevoEstado(nuevo){
        estado = nuevo
    }

}

// Punto 4
class EstadoOperacion inherits Operacion{
    method reservarPara(operacion,cliente)
    method validarReservaPara(cliente)

}

object disponible inherits EstadoOperacion{
    override method reservadaPara(operacion,cliente){
        operacion.estado(new Reservada(cliente))
    }
}

class Reservada inherits EstadoOperacion{
    const clienteQueReservo

    override method reservadaPara(operacion,cliente){
        throw new NosePudoReservarException(message = "Ya habia una reserva previa")
    }

    override method validarReservaPara(cliente){
        if(cliente!=clienteQueReservo){
            throw new ReservaHechaException(message = "La operacion ya fue reservada para otro cliente")
        }
    }
}

class NoSePudoReservarException inherits DomainException{}
class ReservaHechaException inherits DomainException{}





class Venta inherits Operacion{
    override method comision() = inmueble.valor() * (1 + self.porcentaje() / 100)

    method porcentaje() = inmobliaria.porcentajeDeComisionVenta()

}

class Alquiler inherits Operacion{
    const mesesAquiler

    override method comision() = (inmueble.valor() * mesesAquiler) / 50000 

}

object inmobliaria{
    var porcentajeDeVenta
    const empleados = []

    method porcentajeDeComisionVenta() = porcentajeDeVenta

    // Punto 2
    method mejorEmpleadoSegun(criterio) = empleados.max({empleado => criterio.ponderacion(empleado)})

}

// Punto 2
object porTotalComisionesPorOperacionesCerradas{
    method ponderacion(empleado) = empleado.totalComisiones()
}

object porCantidadOperacionesCerradas{
    method ponderacion(empleado) = empleado.operacionesCerradas().size()
}

object porCantidadReservas{
    method ponderacion(empleado) = empleado.reservas().size()
}

class Empleado{
    // Punto 2
    const reservas = #{}
    const operacionesCerradas = #{}

    method totalComisiones() = operacionesCerradas.sum{operacion => operacion.comision()}
    method operacionesCerradas() = operacionesCerradas
    method reservas() = reservas

    // Punto 3
    method vaATenerProblema(otroEmpleado) = 
        self.operoEnMismaZona(otroEmpleado) && (
            self.concretoOperacionReservadaPor(otroEmpleado) || otroEmpleado.concretoOperacionReservadaPor(self)
        )

    method zonasEnLasQueOpero() = operacionesCerradas.map({operacion => operacion.zona()}).asSet()

    method operoEnZona(zona) = self.zonasEnLasQueOpero().contains(zona)

    method operoEnMismaZona(otroEmpleado) = self.zonasEnLasQueOpero().any({zona => otroEmpleado.operoEnZona()})

    method concretoOperacionReservadaPor(otroEmpleado) = operacionesCerradas.any{operacion => otroEmpleado.reservo(operacion)} 

    method reservo(operacion) = reservas.contains(operacion)

    // Punto 4
    method reservar(operacion,cliente){
        operacion.reservarPara(cliente)
        reservas.add(operacion) // agg operacion a las reservas de nuestro empleado
    }
    
    method concretarOperacion(operacion,cliente){
        operacion.concretarPara(cliente)
        operacionesCerradas.add(operacion)
    }

}

class Cliente{

}

class Zona{
    method valorPlus()
}

class Inmueble{
    const tamanio
    const cantidadAmbientes
    const zona


    method valor() = self.valorParticular() + zona.valorPlus()

    method valorParticular()
    method zona() = zona

    // Punto 5
    method validarQuePuedeSerVendido()

}

class Casa inherits Inmueble{
    var valorCasa // seria el valor de la propiedad 
    override method valorParticular() = valorCasa
}

class Ph inherits Inmueble{
    override method valorParticular() = (14000 * tamanio).max(500000)
}

class Departamento inherits Inmueble{
    override method valorParticular() = 350000 * cantidadAmbientes
}

// Punto 5
class Local inherits Casa{
    var tipoLocal

    override method valorParticular() = tipoLocal.valor(super())

    override method validarQuePuedeSerVendido(){
        throw new VentaInvalidaException (message = "Este inmueble no puede ser vendido")
    }
}

class VentaInvalidaException inherits DomainException{}

object galpon{
    method valor(valorCasa) = valorCasa/2
}

object aLaCalle{
    var valorFijo

    method valorFijo(monto){
        valorFijo = monto
    }
    method valor(valorBase) = valorFijo + valorBase
}

























