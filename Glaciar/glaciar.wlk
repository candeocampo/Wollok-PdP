/*
1. tempano.seVeAzul()
2. tempano.enfriaElAgua()
3. masaDeAgua.esAtractiva()
4. glaciar.pesoInicialDeUnTempano()

*/



// Tempanos
class Tempano{
    const pesoTotal
    var tipo = compacto

    method seVeAzul(){
        return tipo.seVeAzul(self)
    }
    method parteVisible() = pesoTotal * 0.15

    // Punto 2
    method enfriaElAgua() = tipo.enfriaElAgua()

    // Punto 3
    method esGrande() = pesoTotal > 500 || self.seVeAzul()

}

object compacto{
    method seVeAzul(tempano) = tempano.parteVisible() > 100
    method enfriaElAgua(tempano) = tempano.pesoTotal() * 0.01 
}

object aireados{
    method seVeAzul(tempano) = false
    method enfriaElAgua(tempano) = 0.5
}

// Punto 3
class masaDeAgua{
    const tempanos = #{}
    var property temperaturaAmbiente

    method tempanosGrandes() = tempanos.all{tempano => tempano.esGrande()}
    method esAtractiva() = tempanos.size() >= 5 && self.tempanosGrandes()

    // Punto 4
    method temperatura() = temperaturaAmbiente - self.gradosTotalesQueEnfrianTempanos()

    method gradosTotalesQueEnfrianTempanos() = tempanos.sum{tempano => tempano.enfriaElAgua()}

}

class rio inherits masaDeAgua{
    var property velocidadBase

    override method temperatura() = super() + self.velocidadAgua()

    method velocidadAgua() = velocidadBase - self.tempanosGrandes().size()

}

// Punto 4
class Glaciar{
    var property masaGlaciar
    const property temperaturaDesembocadura

    method pesoInicialDeUnTempano() = (masaGlaciar / 1000000) * temperaturaDesembocadura

    method temperatura() = 1

}













































