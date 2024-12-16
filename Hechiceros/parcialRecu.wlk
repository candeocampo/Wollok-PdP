/*
Parte A
1. mago.poderTotal()
2. mago.desafiarA(otroMago)

Parte B
1. torneoDeMagos.crearGremio(magos)
2. gremio.desafiarA(ente) puede ser un mago o un ente

*/

class Gremio{
    const magosAsociados = #{}

    method poderTotalGremio() = magosAsociados.sum{mago => mago.poderTotal()}
    method puntosCecidos() = magosAsociados.sum{mago => mago.energiaMagica()} // es la reserva de energia que pierden
    method liderGremio() = magosAsociados.max{mago => mago.poderTotal()}

    method desafiarA(ente){ // puede ser un mago o otro gremio
        if(ente.puedeSerVencido(self)){
            const energiaGanada = ente.puntosCecidos()
            ente.disminuirEnergia()
            self.liderGremio().transferirPuntosDe(ente)
        }
    } 
    method puedeSerVencido(ente) = ente.poderTotal() > self.puntosCecidos() + ente.liderGremio().poderTotal()

    method disminuirEnergia() = magosAsociados.forEach({mago => mago.disminuirEnergia()})
}

object torneoDeMagos{

    method crearGremio(magos){
        if(magos.size() < 2){
            throw new errorException (message = "No hay suficiente cantidad de miembros para crear un gremio.")
        }
        else{
            // new Gremio (magosAsociados = magos)
        }
    }

}

class errorException inherits DomainException{}



class Mago{
    const objetosMagicos = #{}
    var property poderInnato
    const nombreMago
    var property resistenciaMagica
    var property energiaMagica
    var property tipoMago

    // Punto 1
    method poderTotal() = objetosMagicos.sum{objeto => objeto.poder(self)} + poderInnato
    
    method cantidadLetrasNombre() = nombreMago.size()
    method tieneCantidadParDeLetras() = self.cantidadLetrasNombre().even()

    method resistenciaMagica() = resistenciaMagica

    // Punto 2
    method energiaMagica() = energiaMagica

    method desafiarA(otroMago){
        if(otroMago.puedeSerVencido(self)){
            self.transferirPuntosDe(otroMago)
        }
    }

    method transferirPuntosDe(otroMago){
            const puntosQueTransfiere = otroMago.puntosCedidos()
            otroMago.disminuirEnergia()
            self.aumentarEnergia(puntosQueTransfiere)
    }

    method aumentarEnergia(cantidad){
        energiaMagica +=cantidad
    }
    method disminuirEnergia(){
        energiaMagica -= tipoMago.puntosQueCede(self)
    }
    method puntosCecidos() = tipoMago.puntosQueCede(self)
    method puedeSerVencido(otroMago) = tipoMago.esVencido(self, otroMago)

}

// Tipos de magos
object aprendiz{
    method esVencido(magoAtacante,otroMago) =  magoAtacante.resistenciaMagica() < otroMago.poderTotal()
    method puntosQueCede(mago) = mago.energiaMagica() / 2 
}

object veterano{
    method esVencido(magoAtacante,otroMago) = otroMago.poderTotal() > otroMago.resistenciaMagica() * 1.5
    method puntosQueCede(mago) = mago.energiaMagica() / 4
}

object inmortal{
    method esVencido(magoAtacante,otroMago) = false
    method puntosQueCede(mago) = 0
}

// Objetos magicos
class ObjetoMagico{
    const property poderBase
    method poder(mago) 
}

class Varita inherits ObjetoMagico{
    override method poder(mago){
        if(mago.tieneCantidadParDeLetras()) 
            poderBase * 0.50
        else poderBase
    }
}

class Tunica inherits ObjetoMagico{

}

class TunicaComun inherits Tunica{
    override method poder(mago) = poderBase + 2 * mago.resistenciaMagica()
}

class TunicaEpica inherits TunicaComun{
    const property puntosFijos = 10
    override method poder(mago) = super(mago) + puntosFijos
}

object amuleto{
    method poder(mago) = 200
}

object ojota{
    method poder(mago) = 10 * mago.cantidadLetrasNombre()
}















































