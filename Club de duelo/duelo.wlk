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
        self.validarQuePuedeLanzarHechizos()
        hechizo.serUsadoPor(self,contrincante)
    }

    method validarQuePuedeLanzarHechizos(){
        efectosVigentes.forEach({efectoVigente => efectoVigente.validarQuePermiteLanzarHechizos()})
    }

    // punto c
    method hechizoMasConveniente(hechizos,contrincante) = 
        hechizos.max({hechizo => hechizo.conveniencia(self,contrincante)})

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
        //
    }

    method aplicarEfecto(impacto,hechizero,contrincante) // donde va a aplicarse el efecto según el tipo de hechizo

    // punto c
    method conveniente(hechizero,contrincante)



}

class HechizoCurativo inherits Hechizo{

    override method aplicarEfecto(impacto,hechizero,contricante){
        hechizero.variarResistencia(impacto)
    }

}

class HechizoAtaque inherits Hechizo{

    override method aplicarEfecto(impacto,hechizero,contrincante){
        contrincante.variarResistencia(impacto)
    }
}

























