/*
1. tempano.seVeAzul()
2. tempano.enfriaElAgua()
3. masaDeAgua.esAtractiva()
4. glaciar.pesoInicialDeUnTempano()
5. glaciar.desprendimiento()
6. embarcacion.navegar(masaDeAgua) la masa de agua puede ser rio o lago
*/

// Tempanos
class Tempano{
    var property pesoTotal
    var tipo = compacto

    method seVeAzul(){
        return tipo.seVeAzul(self)
    }
    method parteVisible() = pesoTotal * 0.15

    // Punto 2
    method enfriaElAgua() = tipo.enfriaElAgua()
    // Punto 3
    method esGrande() = pesoTotal > 500 || self.seVeAzul()
    // Punto 6
    method modificarPeso(cantidad){
        pesoTotal = (pesoTotal - cantidad).max(0)
        tipo.perderPeso(self)
    }
}

object compacto{
    method seVeAzul(tempano) = tempano.parteVisible() > 100
    method enfriaElAgua(tempano) = tempano.pesoTotal() * 0.01 

    // Punto 6
    method perderPeso(tempano){
        if(!tempano.esGrande()){
            tempano.tipo(aireado)
        }
    }
}

object aireado{
    method seVeAzul(tempano) = false
    method enfriaElAgua(tempano) = 0.5
    method perderPeso(tempano){
        // no hace nada
    }
}

// Punto 3
class MasaDeAgua{
    const tempanos = #{}
    var property temperaturaAmbiente

    method tempanosGrandes() = tempanos.all{tempano => tempano.esGrande()}
    method esAtractiva() = tempanos.size() >= 5 && self.tempanosGrandes()

    // Punto 4
    method temperatura() = temperaturaAmbiente - self.gradosTotalesQueEnfrianTempanos()
    method gradosTotalesQueEnfrianTempanos() = tempanos.sum{tempano => tempano.enfriaElAgua()}

    // Punto 6
    method cantidadTempanosGrandes() = tempanos.filter{tempano => tempano.esGrande()}.size()
    method esPosibleNavegar(embarcacion)

    method teNavego(embaracion) = tempanos.forEach{tempano => tempano.modificarPeso(1)}
}

class Rio inherits MasaDeAgua{
    var property velocidadBase

    override method temperatura() = super() + self.velocidadAgua()
    method velocidadAgua() = velocidadBase - self.tempanosGrandes().size()

    // Punto 6
    override method esPosibleNavegar(embarcacion){
        if(self.velocidadAgua() > embarcacion.fuerza()){
            throw new UserException(message = "Fuerza insuficiente para navegar en el rio")
        }
    }
}

// Punto 6
class Lago inherits MasaDeAgua{

    override method esPosibleNavegar(embarcacion){
        if(self.cantidadTempanosGrandes() > 20 && embarcacion.tripulantes() > 10){
            throw new UserException(message = "Embarcacion muy grande")
        }
        if(self.temperatura() < 0){
            throw new UserException(message = "Agua congelada")
        }
    }  
}

class UserException inherits DomainException{}

// Punto 4
class Glaciar{
    var property masaGlaciar
    const property temperaturaDesembocadura
    const property desembocadura

    method pesoInicialDeUnTempano() = (masaGlaciar / 1000000) * temperaturaDesembocadura
    method temperatura() = 1

    // Punto 5
    method desprendimiento(){
        const tempanoCompacto = self.pesoInicialDeUnTempano() // generar tempano compacto
        self.modificarMasa(-tempanoCompacto) // glaciar pierde  masa como pese el tempano
        desembocadura.modificarMasa(new Tempano(pesoTotal = tempanoCompacto))// cae sobre desembocadura que depende: rio o glaciar
    } 

    method modificarMasa(tempano){
        masaGlaciar += tempano.pesoTotal()
    }
}

// Punto 6
class Embarcacion{
    const property tripulantes
    const property fuerza

    method navegar(masaDeAgua){
        self.verificarNavegacion(masaDeAgua) // no va en igual porque no produce un efecto
        masaDeAgua.teNavego(self) // efectos
    }
    method verificarNavegacion(masaDeAgua){
        masaDeAgua.esPosibleNavegar(self)
    }
}











































