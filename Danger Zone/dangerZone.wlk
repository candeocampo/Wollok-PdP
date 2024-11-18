/*
RESUELTO CON: HERENCIA! :)
Punto 1) empleado.estaIncapacitado()
Punto 2) empleado.puedeUsar(habilidad)
Punto 3) empleado.cumplir(mision) es un msj de efecto
o podría ser: mision.serCumplidaPor(empleado) ¿Quién tiene la responsabilidad?


Ej de instanciación: const juan = new Espia()
empleado.puesto(espia) eso me permitiria que CAMBIE de puesto, al usar COMPOSICIÓN
ATENTO! => Al hacerlo con herencia el puesto de Juan siempre va a ser espia no podría cambiarlo, por eso quizás conviene más con composición


*/


class Empleado{
    const habilidades = #{} 
    var property salud
    var puesto
    //var esJefe = false // con esto nos diria si es JEFE o NO pero NO nos conviene ponerlo, pues si es o no jefe depende de subordinados

    method estaIncapacitado() = salud < self.saludCritica()

    method saludCritica() = puesto.saludCritrica() // método abstracto

    // Punto 2
    
    method poseeHabilidad(habilidad) = habilidades.contains(habilidad) // delegamos lo que es en empleado y lo que va en JEFE.

    method puedeUsar(habilidad) = !self.estaIncapacitado() && self.poseeHabilidad(habilidad)

    /* Estos métodos no irán aqui pues corresponden que sean de JEFE.
    method algunSobordinadoTiene(habilidad) = subordinados.any{subordinado => subordinado.puedeUsar(habilidad)}
    
    method esJefe() = subordinados.notEmpty() // nos dice si no está vacía
    */ 

    // Punto 3
    method recibirDanio(cantidad){
        salud -= cantidad
    }

    method estaVivo() = salud > 0

    method finalizarMision(mision){
        if(self.estaVivo()){
            self.completarMision(mision)
        }
    }

    method completarMision(mision){
        puesto.completarMision(mision,self) // dependerá del puesto según si es oficinista o espia
    }

    method aprenderHabilidad(habilidad) = habilidades.add(habilidad)

}

class Jefe inherits Empleado{
    const subordinados = []
    
    override method poseeHabilidad(habilidad) = super(habilidad) || self.algunSobordinadoTiene(habilidad)
    
    method algunSobordinadoTiene(habilidad) = subordinados.any{subordinado => subordinado.puedeUsar(habilidad)}
}

object puestoEspia { // esto significa que hay UN único puesto de espia
    method saludCritica() = 15

    // requiere que la misión conozca al empleado porque las habilidades las tiene el EMPLEADO
    method completarMision(mision,empleado){
        mision.enseniarHabilidades(empleado) 
    }
}

class puestoOficinista{ // esto no puede ser un object porque tiene estado interno.
    var estrellas = 0
    
    method saludCritica() = 40 - 5 * estrellas

    method ganarEstrella(cantidad){
        estrellas +=cantidad
    }

    method completarMision(mision,empleado){
        self.ganarEstrella(1)
        if(estrellas == 3){
            empleado.puesto(puestoEspia) //cambiaría el puesto.
        }
    }
}
/* Punto 2: vemos que repetimos código por lo que la HERENCIA ES DE UN SOLO TIRO!
Debemos usar composición ya que usamos herencia para hacer que un empleado sea oficinista o espia 
y queremos ahora saber si alguno es Jefe

class EspiaJefe inherits Espia{
    const subordinados = []
    override method poseeHabilidad(habilidad) = super(habilidad) || self.algunSobordinadoTiene(habilidad)
    method algunSobordinadoTiene(habilidad) = subordinados.any{subordinado => subordinado.puedeUsar(habilidad)}
}
class OficinistaJefe inherits Oficinista{
    const subordinados = []
    override method poseeHabilidad(habilidad) = super(habilidad) || self.algunSobordinadoTiene(habilidad)
    method algunSobordinadoTiene(habilidad) = subordinados.any{subordinado => subordinado.puedeUsar(habilidad)}
} 

Punto 3
El interfaz "asignado" tendría que entender estos dos msj:
- recibirDanio(peligrosidad),
- puedeUsar(hab)
- finalizarMision(mision)
*/

class Mision{
    const habilidadesRequeridas = []
    var peligrosidad

    method habilidades() = habilidadesRequeridas

    method serCumplidaPor(asignado){ // asignado por si es un equipo o un empleado
        self.validarHabilidades(asignado)
        asignado.recibirDanio(peligrosidad)
        asignado.finalizarMision(self)
    }   

    method reuneHabilidadesRequeridas(asignado) = habilidadesRequeridas.all({hab => asignado.puedeUsar(hab)})

    method validarHabilidades(asignado){
        if(!self.reuneHabilidadesRequeridas(asignado)){
            self.error("La misión no se puede cumplir")
        }
    }

    method enseniarHabilidades(empleado){
        self.habilidadesQueNoPosee(empleado).forEach({hab => empleado.aprenderHabilidad(hab)})
    }

    method habilidadesQueNoPosee(empleado) = habilidadesRequeridas.filter({hab => !empleado.poseeHabilidad(hab)})

}

class Equipo{
    const empleados = []

    method recibirDanio(cantidad) = empleados.forEach({empleado => empleado.recibirDanio(cantidad/3)})
 
    method puedeUsar(habilidad) = empleados.any({empleado => empleado.puedeUsar(habilidad)})

    method finalizarMision(mision){
        empleados.forEach({empleado => empleado.finalizarMision(mision)})
    }
}










