/*
1. mago.poderTotal()
2. mago.desafiarA(otroMago)
*/




class Mago{
    const objetosMagicos = []
    const poderInnato
    const nombreMago
    // Punto 2
    const resistenciaMagica
    var property puntosEnergiaMagica

    // Punto 1
    method poderTotal() = objetosMagicos.sum{objetoMagico => objetoMagico.poder()} 
    method cantidadLetrasPar() = nombreMago.size().even()
    method cantidadLetrasNombre() = nombreMago.size()

    // Punto 2
    method desafiarA(otroMago)

    method esVencido(otroMago)

    method modificarEnergiaMagica(cantidad){
        puntosEnergiaMagica -=cantidad
    }

}

class Apendice inherits Mago{
    override method esVencido(otroMago){
        if(resistenciaMagica > otroMago.poderTotal()){
            throw new UserException(message="La resistencia magica del mago es superior al poder total del atacante")
        }else{
            self.modificarEnergiaMagica(puntosEnergiaMagica / 2)
        }
    }
}

class UserException inherits DomainException{}
class ResistenciaFuerteException inherits DomainException{}

class Veterano inherits Mago{
    override method esVencido(otroMago){
        if(otroMago.poderTotal() <= (resistenciaMagica * 1/5)){
            throw new ResistenciaFuerteException(message = "La resistencia magica es más fuerte")
        }else{
            self.modificarEnergiaMagica(puntosEnergiaMagica * 1/4)
        }
    }
}

class Inmortal inherits Mago{
    override method esVencido(otroMago){
        // no hace nada porque nunca son vencidos.
    }
}




class ObjetoMagico{
    const valorBase

    method poder(mago) // abstracto

}

class Varita inherits ObjetoMagico{

    method aporteExtra() = valorBase * 0.50

    override method poder(mago){
        if(mago.cantidadLetrasPar()){
            return valorBase + self.aporteExtra()
        }
        else{
            return valorBase
        }
    }
    
}

class Tunica inherits ObjetoMagico{

}

class Comun inherits Tunica{
    override method poder(mago) = 2 * mago.resistenciaMagica()
}

class Epica inherits Tunica{
    override method poder(mago) = 2 * mago.resistenciaMagica() + 10
}

class Amuleto inherits ObjetoMagico{
    override method poder(mago) = 200
}

object ojota{
    method poder(mago) = 10 * mago.cantidadLetrasNombre()
}





















































