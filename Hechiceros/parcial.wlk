/*
Puntos de Entrada A
1. mago.poderTotal()
2. mago.desafiarA(otroMago)

Puntos de Entrada B
1. torneoDeMagos.crearGremio()
3. gremio.desafiarA(ente)
*/

object torneoDeMagos{

    method crearGremio(magosAsociados){
        if(magosAsociados.size() < 2){
            throw new ErrorException(message = "No hay cantidad suficientes de participantes para crear un gremio")
        }
        // new Gremio(magosAsociados = magosAsociados)
    }

    method transferirPuntoDe(mago,ente){
        mago.modificarEnergiaMagica(-ente.puntosEnergiaMagica())
        ente.modificarEnergiaMagica(ente.puntosEnergiaMagica())
    }
}

class ErrorException inherits DomainException{}



class Mago{
    const objetosMagicos = #{}
    const property poderInnato
    const property nombreMago
    // Punto 2
    const property resistenciaMagica
    var property puntosEnergiaMagica

    // Punto 1
    method poderTotal() = objetosMagicos.sum{objetoMagico => objetoMagico.poder()} * self.poderInnato()
    method cantidadLetrasPar() = self.cantidadLetrasNombre() % 2 == 0
    method cantidadLetrasNombre() = nombreMago.size()

    method puntosEnergiaMagica() = puntosEnergiaMagica

    // Punto 2
    method desafiarA(ente){ // cambia a ente por Parte B.2)
        if(ente.puedeSerVencido(self)){
                self.transferirPuntosDe(ente)
        }
    }

    method transferirPuntosDe(otroMago){
        self.modificarEnergiaMagica(-otroMago.puntosEnergiaMagica())
        otroMago.modificarEnergiaMagica(otroMago.puntosEnergiaMagica())
    }

    method modificarEnergiaMagica(cantidad){
        puntosEnergiaMagica -=cantidad
    }

    method puedeSerVencido(ente)
    method puntosCedidos()
}

class Aprendiz inherits Mago{
    override method puedeSerVencido(ente) = self.resistenciaMagica() < ente.poderTotal()
    override method puntosCedidos() = self.puntosEnergiaMagica() / 2
}

class Veterano inherits Mago{
    override method puedeSerVencido(ente) = ente.poderTotal() * 1.5 >= self.resistenciaMagica()
    override method puntosCedidos() = puntosEnergiaMagica / 4
}

class Inmortal inherits Mago{
    override method puedeSerVencido(ente) = false
    override method puntosCedidos(){
        // no cede nada, no hace nada
    }
}

class ObjetoMagico{
    const valorBase

    method poder(mago) = valorBase + self.poder(mago) // abstracto

}

class Varita inherits ObjetoMagico{
    /*
    override method poder(mago){
        if(mago.cantidadLetrasPar()){
            valorBase * 0.50
        }else{ 0 }
    }
    */
}

class Tunica inherits ObjetoMagico{

}

class Comun inherits Tunica{
    override method poder(mago) = 2 * mago.resistenciaMagica()
}

class Epica inherits Tunica{
    const property puntosFijos = 10
    override method poder(mago) = 2 * mago.resistenciaMagica() + puntosFijos
}

class Amuleto inherits ObjetoMagico{
    override method poder(mago) = 200
}

object ojota{
    method poder(mago) = 10 * mago.cantidadLetrasNombre()
}

// Parte B
class Gremio{
    const magosAsociados = #{} // pueden estar formados por magos o gremios

    method poderTotal() = magosAsociados.sum{mago => mago.poderTotal()}
    method reservaDeEnergiaMagica() = magosAsociados.sum{mago => mago.puntosEnergiaMagica()}
    method liderGremio() = magosAsociados.max{mago => mago.poderTotal()}
    method resistenciaMagica() = magosAsociados.sum{mago => mago.resistenciaMagica()}

    method desafiarA(ente){
        if(ente.puedeSerVencido(self)){
            torneoDeMagos.transferirPuntosDe(self,ente)
        }
    }

    method puedeSerVencido(ente) = ente.poderTotal() > self.resistenciaMagicaGremio()

    method resistenciaMagicaGremio() = self.resistenciaMagica() + self.poderTotalLider()

    method poderTotalLider() = self.liderGremio().poderTotal()
}


















































