/*
Puntos de entrada
1. panelista.darRemateGracioso(tematica)
2. panelista.opinarSobre(tematica)
3. tematica.esInteresante()
4. emision.puedeTrasmitirse()
5. emision.emitir()
6. emision.panelistaEstrella()

*/

class Panelista{
    var puntosEstrella

    method aumentarPuntosEstrella(cantidad){
        puntosEstrella +=cantidad
    }

    // Punto 1
    method darRemateGracioso(tematica)
    
    // Punto 2
    method opinarSobreDeporte(tematica)
    method opinarSobreFarandula(tematica)

    method opinaSinSaber(){ // cuando es una tematica que no es depo o de farandula
        self.aumentarPuntosEstrella(1)
    }

    // Punto 5
    method hablarSobre(tematica){
        tematica.recibirOpinionDe(self)
        self.darRemateGracioso(tematica)
    }

    // Punto 6
    method cantidadEstrellas() = puntosEstrella

}


class Celebridad inherits Panelista{
    override method darRemateGracioso(tematica){
        self.aumentarPuntosEstrella(3) // no va con =, no esperamos que devuelva nada
    }
    // Punto 2
    override method opinarSobreFarandula(tematica){
        if(tematica.estaInvolucrado(self)){
            self.aumentarPuntosEstrella(tematica.cantidadInvolucrados())
        }
        else{
            self.opinaSinSaber()
        }
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

    method opinarSobreDeporte(){
        self.aumentarPuntosEstrella(5)
    }
}

// Punto 2
class Tematica{
    const tituloTematica

    // Punto 1
    method cantidadPalabrasDelTitulo() = self.cantidadDePalabras(tituloTematica)
    method cantidadDePalabras(unTexto) = unTexto.words().size() 

    // Punto 2
    method recibirOpinionDe(panelista)

    // Punto 3
    method esInteresante()
    method titulo() = tituloTematica

}

class Deportiva inherits Tematica{

    override method recibirOpinionDe(panelista){
        panelista.opinarSobreDeporte(self)
    }

    // Punto 3
    override method esInteresante() = self.titulo().contains("Messi")

}

class Farandula inherits Tematica{
    var involucrados = []

    method estaInvolucrado(celebridad) = involucrados.contains(celebridad)
    method cantidadInvolucrados() = involucrados.size()

    override method recibirOpinionDe(panelista){
        panelista.opinarSobreFarandula(self)
    }

    // Punto 3
    override method esInteresante() = self.cantidadInvolucrados() >= 3

}

// Punto 3
class Filosofica inherits Tematica{
    override method esInteresante() = self.cantidadPalabrasDelTitulo() > 20

}

// Dice que el título  está formado por la concetenación de los títulos de todas sus temáticas.
class Mixta inherits Tematica(tituloTematica = ""){
    const tematicasIncluidas = []

    override method titulo() = tematicasIncluidas.map({tematica => tematica.titulo()}).join("")
    override method esInteresante() = tematicasIncluidas.any{tematica => tematica.esInteresante()}
    override method recibirOpinionDe(panelista){
        tematicasIncluidas.forEach({tematica => tematica.recibirOpinionDe(panelista)})
    }
}

class Emision{
    const tematicasATratar = []
    const panelistasParticipantes = []
    var estadoEmision = false

    // Punto 4
    method puedeEmitirse() = self.cantidadPanelistas() >= 2 && self.alMenosLaMitadEsInteresante()

    method cantidadPanelistas() = panelistasParticipantes.size()
    method cantidadTematicas() = tematicasATratar.size()
    method cantidadDeTematicasInteresantes() = tematicasATratar.filter{tematica => tematica.esInteresante()}.size()
    method alMenosLaMitadEsInteresante() = self.cantidadDeTematicasInteresantes() >= self.cantidadTematicas() / 2

    // Punto 5
    method escucharSobre(tematica) = panelistasParticipantes.forEach{panelista => panelista.hablarSobre(tematica)}


    method emitir(){
        tematicasATratar.forEach({tematica => self.escucharSobre(tematica)})
        estadoEmision = true
    }

    method emisionTrasmitida(){
        if(!estadoEmision){
            throw new ErrorTrasmisionException(message = "No se emitio, no se puede elegir un panelista estrella")
        }
    }

    method panelistaEstrella(){
        self.emisionTrasmitida()
        return self.elegirPanelistaEstrella() // devuelve porque es una CONSULTA
    }

    method elegirPanelistaEstrella() = panelistasParticipantes.max{panelista => panelista.cantidadEstrellas()}
}

class ErrorTrasmisionException inherits DomainException{}

