
/*
Punto 1:
a. venta.costo(alma)
b. departamentoDeLaMuerte.mejorAgente()
c. agente.dineroTotalGanado()
d. agente.deudaActual()

Punto 4:
a. agente.atender(alma)

*/

// Punto 1
class Venta{
    const alma
    const paquete
    method costo() = paquete.precioPara(alma)
}


class Agente{
    var property deuda
    const ventas = []
    var estrategia // punto 4

    method vender(paquete,alma){
        if(!alma.puedeCostear(paquete)){
            throw new UserException(message = "El alma no puede costear el paquete")
        }
        else{
            ventas.add(paquete)
        }
    }

    // 1.b
    method cantidadVentas() = ventas.size()
    // 1.c
    method dineroTotalGanado() = ventas.sum{venta => venta.costo()}
    // 1.d
    method deudaActual() = deuda - self.dineroTotalGanado()

    // Punto 2
    method modificarDeuda(cantidad){
        deuda += cantidad
    }

    method deudaInicial() = deuda

    method saldoDeuda() = self.deudaInicial() <= 0

    // 4.a
    method atender(alma){
        self.vender(estrategia.paquetePara(alma),alma)
    }

    //4.c
    method cambiarEstrategia(nuevaEstrategia){
        estrategia = nuevaEstrategia
    }

}
class UserException inherits DomainException{}

// Punto 4
object clasico{
    method paquetesCosteablesPara(alma) = departamentoDeLaMuerte.paquetesPredefinidos.filter({paquete => alma.puedeCostear(paquete)})
    method paquetePara(alma) = self.paquetesCosteablesPara(alma).max({paq => paq.precioPara(alma)})
}

object navegante{
    method paquePara(alma){
        if(alma.cantidadAccionesBuenas() > 50){
            new Crucero(costoBasico = alma.cantidadAccionesBuenas())
        }else{ 
            new Bote(costoBasico = alma.cantidadAccionesBuenas())
        }
    }
}

object indiferente{
    method paquetePara(alma) = new PaloConBrujula (costoBasico = 1.randomUpTo(300))
}



class Alma{
    const dinero
    const accionesBuenas

    method capital() = dinero + self.cantidadAccionesBuenas()

    method cantidadAccionesBuenas() = accionesBuenas

    method puedeCostear(paquete) = self.capital() > paquete.precioPara(self)

}

class Paquete{
    const costoBasico

    // Punto 3
    method precioPara(alma) = (costoBasico * self.aniosQueReduceA(alma)).min(350)
    method aniosQueReduceA(alma)
}

// 3.a
class Tren inherits Paquete{
    override method aniosQueReduceA(alma) = 4
}
// 3.b
class Bote inherits Paquete{
    override method aniosQueReduceA(alma) = (alma.cantidadAccionesBuenas() / 50).min(2)
}
// 3.c
class Crucero inherits Bote{
    override method aniosQueReduceA(alma) = 2 * super(alma)
}
// 3.d
class PaloConBrujula inherits Paquete{
    override method aniosQueReduceA(alma) = 0.05
    override method precioPara(alma) = costoBasico
}

object departamentoDeLaMuerte{
    const agentes = []
    const property paquetesPredefinidos = [] // punto 4
    // 1.b
    method mejorAgente() = agentes.max{agente => agente.cantidadVentas()}

    // Punto 2
    method pasarElDiaDeLosMuertos(){
        const mejorAgente = self.mejorAgente()
        mejorAgente.modificarDeuda(-50)
        agentes.removeAll{self.agentesQuePagaronDeuda()} // agentes que pagaron su deuda son liberados
        agentes.forEach{agente => agente.modificarDeuda(100)}
    }

    method agentesQuePagaronDeuda() = agentes.filter{ agente=> agente.saldoDeuda()}
}




