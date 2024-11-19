/*
Punto 1) hechizo.impactoEnResistencia(hechizero, contrincante)
Punto 2) hechizero.lanzarHechizo(hechizo,contrincante)
Punto 3) hechizo.hechizoMasConveniente(hechizo,contrincante)
*/



class Hechizero{
    // Caracteristicas de los hechiceros
    const property coraje
    const property empatia
    const property conocimiento

    var property resistencia
    const property resistenciaMaxima

    // punto b
    const efectosVigentes = []


    method resistencia(nuevaResistencia){
        resistencia = (nuevaResistencia.min(resistenciaMaxima)).max(0)
    }

    // Punto b
    method variarResistencia(cantidad){
        self.resistencia(self.resistencia() + cantidad)
    }

    method lanzarHechizo(hechizo,contrincante){
        self.validarQuePuedeLanzarHechizos() // parte 2.b
        hechizo.serUsadoPor(self,contrincante)
    }

    method validarQuePuedeLanzarHechizos(){
        efectosVigentes.forEach({efectoVigente => efectoVigente.validarQuePermiteLanzarHechizos()})
    }

    // punto c
    method hechizoMasConveniente(hechizos,contrincante) = 
        hechizos.max({hechizo => hechizo.conveniencia(self,contrincante)})

    // 2.b
    method agregarEfectoDurarero(efecto){
        //efectosVigentes.add(new EfectoVigente(efecto = efecto))
    }

    method finalizarTurno(){
        efectosVigentes.forEach({efecto => efecto.pasoUnTurno(self)})
        efectosVigentes.removeAllSuchThat({efecto => efecto.turnosRestantes() == 0})
    }

}

class Hechizo{
    const potencia
    const caracteristica // de los hechizeros, el hechizo se hace sobre una caracteristica
    // punto b
    const efectos = []


    method impactoEnResistencia(hechizero,contrincante) = potencia + 2  * self.diferenciaEnCaracteristica(hechizero, contrincante)

    method diferenciaEnCaracteristica(hechizero,contrincante) =
     (caracteristica.valor(hechizero) - caracteristica.valor(contrincante)).max(0)

    
    // punto b
    method serUsadoPor(hechizero,contrincante){
        const impacto = self.impactoEnResistencia(hechizero, contrincante)
        self.aplicarEfecto(impacto,hechizero,contrincante)
        self.agregarEfectosDurareros(hechizero,contrincante) // parte 2.b
    }

    method aplicarEfecto(impacto,hechizero,contrincante) // donde va a aplicarse el efecto según el tipo de hechizo

    method impactoSobreReceptor(calculo,hechizero,contrincante)
    // punto c
    method conveniente(hechizero,contrincante) = 
        self.convenienciaBase(hechizero,contrincante) + efectos.sum({efecto => efecto.impactoAConveniente()})

    method convenienciaBase(hechizero,contrincante) = self.impactoEnResistencia(hechizero, contrincante)

    // parte 2.b
    method agregarEfectosDurareros(hechizero,contrincante){
        efectos.forEach({efecto => self.receptor(hechizero,contrincante).agregarEfectoDurarero(efecto)})
    }

    method receptor(hechizero,contrincante)

}

class HechizoCurativo inherits Hechizo{

    override method aplicarEfecto(impacto,hechizero,contricante){
        hechizero.variarResistencia(impacto)
    }

    override method impactoSobreReceptor(calculo,hechizero,contrincante) = 
        calculo.min(contrincante.resistenciaMaxima() - hechizero.resistencia())


}

class HechizoAtaque inherits Hechizo{

    override method aplicarEfecto(impacto,hechizero,contrincante){
        contrincante.variarResistencia(impacto)
    }

    // punto b
    override method impactoSobreReceptor(calculo,hechizero,contrincante) = 
        calculo.min(hechizero.resistencia())

    // punto c
    override method convenienciaBase(hechizero, contrincante){
        const terminariaElDuelo = self.impactoEnResistencia(hechizero, contrincante) >= contrincante.resistencia()
        return super(hechizero, contrincante) * if(terminariaElDuelo)  2 else 1
    }
}

// pundo D
object caracteristicaEmpatia {
    method valor(hechicero) = hechicero.empatia()
}
object carateristicaCoraje {
    method valor(hechicero) = hechicero.coraje()
}
object carateristicaConocimiento {
    method valor(hechicero) = hechicero.conocimiento()
}

object caracteristicaBalance{
    method valor(hechizero) = (hechizero.coraje() + hechizero.empatia() + hechizero.conocimiento()) /3 

    /* otra forma de escribirlo:
        method valor(hechicero) {
        const caracteristicas = [caracteristicaEmpatia, carateristicaCoraje, carateristicaConocimiento]
        return caracteristicas.sum {caracteristica => caracteristica.valor(hechicero)} / caracteristicas.length()
    }
    */
}

// PARTE 2

class Efecto{
    const property turnosQueDura

    method multiplicadorDeConveniencia() 

    method impactoAConveniencia() = self.multiplicadorDeConveniencia() * turnosQueDura

    method afectar(hechizero){
        // parte 2.c no hace nada
    }

    method permiteLanzarHechizos() = true // para el punto de aturdimiento
}

class EfectoSobreResistencia inherits Efecto{
    const resistenciaPorTurno
    method factor()
    override method multiplicadorDeConveniencia() = self.factor() * resistenciaPorTurno  // es 2 o 3 depende de cuál efecto es
    
    override method afectar(hechizero){
        hechizero.variarResistencia(self.deltaEnResistencia())
    }
    method deltaEnResistencia() = resistenciaPorTurno
}

class EfectoCurativo inherits EfectoSobreResistencia{
    override method factor() = 2
}

class EfectoDanio inherits EfectoSobreResistencia{
    override method factor() = 3
    override method deltaEnResistencia() = super() * (-1)
}

class EfectoAturdimiento inherits Efecto {
    override method multiplicadorDeConveniencia() = 5
    override method permiteLanzarHechizos() = false
}

class EfectoVigente{
    const property efecto
    var property turnosRestantes = efecto.turnosQueDura()

    method validarQuePermiteLanzarHechizos(){
        if(turnosRestantes > 0 && !efecto.permiteLanzarHechizos()){
            self.error("No se pueden lanzar hechizos")
        }
    }

    method pasoUnTurno(hechizeroAfectado){
        turnosRestantes -=1
        efecto.afectar(hechizeroAfectado)
    }
}




















