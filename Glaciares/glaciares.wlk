/*
Punto 1: unTempano.esAzul()
Punto 2: unTempano.enfriamiento()
Punto 3: masaDeAgua.esAtractiva()
Punto 4: glaciar.pesoInicialDeUnTempano()
Punto 5: glaciar.desprendimiento()

*/

class Tempano{
    var tipo = compacto
    var property peso


    method esAzul() {
        return tipo.esAzul(self)
    }

    method parteVisible() = peso * 0.15

    method enfriamiento() = tipo.enfriamiento(self) // como es según su tipo: aireado/compacto pasamos por self
    
    method esGrande() = peso > 500

    method esActractivo() = self.esGrande() || self.esAzul()
    
    method cuantoEnfria() = tipo.cuantoEnfria(self) // "grados totales de cuanto enfria un tempano"

    method modificarPeso(cantidad){
        peso = (peso - cantidad).max(0)
        tipo.modificarPeso(self)
    }
}




object compacto{
    method esAzul(tempano) = tempano.parteVisible() > 100

    method enfriamiento(tempano) = tempano.peso() * 0.01 // centecima parte.

    method modificarPeso(tempano){
        if(!tempano.esGrande()){
            tempano.tipo(aireados) //se vuelve aireado, cambia el tipo.
        }
    }
}

object aireados{

    method esAzul(tempano) = false
    method enfriamiento(tempano) =  0.5

}

// Punto 2: masas de agua: rio o lago
class MasaDeAgua{
    const tempanos = #{} // el enunciado dice que tiene tempanos las masa de agua por lo que da a entender que sería una lista
    var property temperaturaAmbiente 

    method esAtractiva(){ 
        tempanos.size() >= 5 && tempanos.all{tempano => tempano.esAtractivo()}
    }

    method temperatura() = self.temperaturaAmbiente() - tempanos.sum{tempano => tempano.cuantoEnfria()}

    method tempanosGrandes() = tempanos.filter({tempano => tempano.esGrande()}).size() // ¡¡NO TE OLVIDES DEL FILTER!!

    // Punto 6
    method validarQueEsNavegable(embarcacion)

    method teNavego(embarcacion) = tempanos.forEach({tempano => tempano.modificarPeso(1)})


}


// Punto 4
class Glaciar{
    var property masaGlaciar
    const property desembocadura

    method pesoInicialDeUnTempano() = (masaGlaciar / 1000000) * self.desembocadura().temperatura()

    method temperatura() = 1

    // Punto 5
    method modificarMasa(tempano){
        masaGlaciar += tempano.peso()
    }

    method desprendimiento(){
        const pesoTempano = self.pesoInicialDeUnTempano()
        masaGlaciar -=pesoTempano
        self.desembocadura().modificarMasa(new Tempano(peso = pesoTempano))
    }

}

class Rio inherits MasaDeAgua{
    var property velocidadBase

    method velocidadAgua() = velocidadBase - self.tempanosGrandes()

    override method temperatura() = super() + self.velocidadAgua()

    override method validarQueEsNavegable(embarcacion) = self.velocidadBase() < embarcacion.fuerza()

}

class Lago inherits MasaDeAgua{
    // var property temperatura => ESTO NO! Por herencia ya adquiere el atributo de temperatura

    override method validarQueEsNavegable(embarcacion){
        if(self.tempanosGrandes() > 20 && embarcacion.tamanio() > 10){
            self.error("Embarcacion muy grande")
        }
        else if(self.temperaturaAmbiente() < 0){
            self.error("Agua congelada!")
        }
    }


}


// Punto 6
class Embarcacion{
    const property tamanio
    const property fuerza

    method navegar(masaDeAgua){ //= self.validarNavegacion(embarcacion)
        self.validarNavegacion(masaDeAgua)
        masaDeAgua.teNavego(self)
    } 


    method validarNavegacion(masaDeAgua){
        masaDeAgua.validarQueEsNavegable(self)
    }


}


































