/*
Punto 1) consumo.costo()
Punto 2) linea.promedioConsumos(fechaInicial,fechaFinal)
Punto 3) pack.puedeSatisfacer(consumo)
*/



class Linea{
    const numeroDeTelefono
    const packActivos = []
    const consumos = []

    // Punto 2.a
    method promedioConsumos() = consumos.sum({consumo => consumo.costo()}) / consumos.size()

    method consumoRealizadoEntre(inicio,final) = consumos.filter({consumo => consumo.consumidoEntre(inicio,final)})

    // Punto 2.b
    method gastosEnMes() = self.consumoRealizadoEntre(new Date().minusMonths(1), new Date()).sum({consumo => consumo.costo()})

    // Punto 4
    method agregarPack(nuevoPack) = packActivos.add(nuevoPack)

}


object pdefoni{
    var property costoMB = 0.10
    var property costoSeg = 0.05
    var property precioFijoLlamada = 1
}

class Consumo{
    const property fechaConsumo = new Date()

    method costo() // método abstracto

    // Punto 2.a
    method consumidoEntre(inicio,fin) = fechaConsumo.between(inicio,fin)

    // Punto 3
    method consumoDeInternet(pack) = false
    method consumoDeLlamada(pack) = false    
}

class ConsumoDeInternet inherits Consumo{
    const property cantidadMB

    // Punto 1
    override method costo() = self.cantidadMB() * pdefoni.costoMB()

    method cantidad() = cantidadMB

    // Punto 3
    override method consumoDeInternet(pack) = pack.puedeGastar(cantidadMB)

}

class ConsumoDeLlamadas inherits Consumo{
    const property cantidadMin

    // Punto 1
    override method costo() = pdefoni.precioFijoLlamada() + cantidadMin * pdefoni.costoSeg()

}

// Punto 3
class Pack{
    const vigencia = ilimitado

    method puedeSatisfacer(consumo) = !vigencia.vencido() && self.cubre(consumo)

    method cubre(consumo)

    method estaAcabado()

}

class PackConsumible inherits Pack{
    const consumos = []
    const property cantidad

    method consumir(consumo) = consumos.add(consumo)

    method cantidadConsumida() = consumos.sum({consumo => consumo.cantidad()})

    method remanente() = cantidad - (self.cantidadConsumida()).max(0)

    override method estaAcabado() = self.remanente() <= 0

}

// Tipos de Packs
class Credito inherits PackConsumible{
    override method cubre(consumo) = consumo.costo() <= super(consumo) 
}

class MBlibres inherits PackConsumible{
    override method cubre(consumo) = consumo.consumoDeInternet()
    method puedeGastar(cantidadMB) = cantidadMB < self.remanente()
}

class LlamadasGratis inherits PackConsumible{
    override method cubre(consumo) = consumo.consumoDeLlamada(self)
}

class PackIlimitado inherits Pack{ // internet ilimitado
    method puedeGastar(cantidadMB) = true // porque es ilimitado
    override method estaAcabado() = false
    method consumir(consumo){
        // no hace nada
    }
}































