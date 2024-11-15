/*
Punto 1: unTempano.esAzul()
Punto 2: unTempano.enfriamiento()
Punto 3: masaDeAgua.esAtractiva()

*/

class Tempano{
    var tipo = compacto
    const property peso


    method esAzul() {
        return tipo.esAzul(self)
    }

    method parteVisible() = peso * 0.15

    method enfriamiento() = tipo.enfriamiento(self) // como es según su tipo: aireado/compacto pasamos por self
    
    method esGrande() = peso > 500

    method esActractivo() = self.esGrande() || self.esAzul()
}


object compacto{
    method esAzul(tempano) = tempano.parteVisible() > 100

    method enfriamiento(tempano) = tempano.peso() * 0.01 // centecima parte

}

object aireados{

    method esAzul(tempano) = false
    method enfriamiento(tempano) =  0.5

}

// Punto 2: masas de agua: rio o lago
class MasaDeAgua{
    const tempanos = [] // el enunciado dice que tiene tempanos las masa de agua por lo que da a entender que sería una lista

    method esAtractiva(){ 
        tempanos.size() >= 5 && tempanos.all{tempano => tempano.esAtractivo()}
    }

}






































