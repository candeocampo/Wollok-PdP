/*
Puntos de entrada
1. panelista.darRemateGracioso(tematica)
2. panelista.opinarSobre(tematica)
3. tematica.esInteresante()

*/

class Panelista{
    var puntosEstrella

    method aumentarPuntosEstrella(cantidad){
        puntosEstrella +=cantidad
    }

    // Punto 1
    method darRemateGracioso(tematica)



}


class Celebridad inherits Panelista{
    override method darRemateGracioso(tematica){
        self.aumentarPuntosEstrella(3) // no va con =, no esperamos que devuelva nada
    }
}

class Colorado inherits Panelista{
    var nivelDeGracia
    
    override method darRemateGracioso(tematica){
        self.aumentarPuntosEstrella(nivelDeGracia * 1/5) // da el remate
        self.aumentarNivelDeGracia(1)
    }
    method aumentarNivelDeGracia(cantidad){
        nivelDeGracia +=cantidad
    }
}

class ColoradoConPeluca inherits Colorado{
    override method darRemateGracioso(tematica){
        super(tematica)
        self.aumentarPuntosEstrella(1)
    }
}

class Viejo inherits Panelista{
    override method darRemateGracioso(tematica){
        self.aumentarPuntosEstrella(tematica.cantidadPalabrasDelTitulo())
    }
}

class Deportivos inherits Panelista{
    override method darRemateGracioso(tematica){
        // no hace nada ya que no son graciosos.
    }
}

// Punto 2
class Tematica{

}




















