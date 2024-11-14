
// COMPUTADORA
class SuperComputadora{
    const equipos = [] // estos serían los equipos A105 y B2
    var totalComplejidadComputada = 0 
    var property estaQuemado = false


    //Punto 1)
    method equiposActivos() = equipos.filter{equipo => equipo.estaActivo()}

    method computo() = self.equiposActivos().sum{equipo => equipo.computo()}
                // equipos.filter{equipo => equipo.estaActivo()} para evitar volver a repetir código usamos self
    
    method consumo() = self.equiposActivos().sum{equipo=> equipo.consumo()}

    //1.c) Vamos separando las cosas que nos piden..
    method equipoActivoQueMas(criterio) = self.equiposActivos().max(criterio) 

    method malConfigurada() = 
        self.equipoActivoQueMas{equipo => equipo.consumo()} != self.equipoActivoQueMas{equipo => equipo.computo()}

    /*
    
    method malConfigurada() = self.equipoQueMasConsume() != self.equipoQueMasComputa()
    method equipoQueMasConsume() = equipos.max{equipo => equipo.consumo()} 
    method equipoQueMasComputa() = equipos.max{equipo => equipo.computo()}

    podriamos haber hecho todo en malConfigurada así (pero queda muy feo)
     self.equiposActivos().max{equipo=>equipo.consumo()} != self.equiposActivos().max{equipo=>equipo.computo()}
    
    */

    method estaActivo() = true // con este metodo ya cumple el polimorfimo con EQUIPO!

    // Punto 2
    method computar(problema){
        const subProblema = new Problema(complejidad = problema.complejidad() / self.equiposActivos().size())
        self.equiposActivos().forEach{equipo => equipo.computar(subProblema)}

        totalComplejidadComputada += problema.complejidad()
    }

}

// Punto 2
class Problema{
    const property complejidad

}

// MODOS
object standard{

    method consumoDe(equipo) = equipo.consumoBase()
    method computoDe(equipo) = equipo.computoBase()
    method realizoComputo(){

    }
}

class Overclock{
    var usosRestantes

    override method initialize(){ // esto nos garantiza que el atributo de usosRestantes sean positivos
        if(usosRestantes < 0){
            self.error("Los usos restantes deben ser >=0")
        }
    }

    method consumoDe(equipo) = 2 * equipo.consumoBase()

    method computoDe(equipo) = equipo.computoBase() * equipo.extraComputoPorOverclock()

    method realizoComputo(equipo){
        if(usosRestantes == 0){
            equipo.estaQuemado(true) //y en equipos tenemos un atributo que define si esta o no
            self.error("Equipo quemado!")
        }
        usosRestantes -= 1
    }
}

class AhorroDeEnergia{
    var intentosComputoRealizados = 0

    method consumoDe(equipo) = 200

    method computoDe(equipo) = (self.consumoDe(equipo) / equipo.consumoBase()) * equipo.conmputoBase()
                        // otra forma: equipo.consumo() /  equipo.consumoBase()) * equipo.consumoBase()

    method realizoComputo(){
        intentosComputoRealizados += 1 //incrementamos antes de la excepcion
        if(intentosComputoRealizados % self.peridiocidadDeError() == 0){ //hacemos si es divisible por 17
            self.error("Corriendo monitor")
        }
    }

    method peridiocidadDeError() = 17 // con esto delegamos mejor por que VALOR dividir

}


// Punto 3
class APruebaDeFallos inherits AhorroDeEnergia{

    override method computoDe(equipo) = super(equipo) / 2

    override method periodicidadDeError() = 100
}


// superComputadora utiliza estaActivo, consumo y computo los entiende para los equipos.

// EQUIPOS
class Equipo{
    var property modo // tipo de modo: Standard, Overclock y Ahorro de Energía
    var property estaQuemado = false

    method estaActivo() = !estaQuemado && self.computo() > 0

    // el consumo y computo del equipo depende del modo 
    method consumo() = modo.consumoDe(self)

    method computo() = modo.computoDe(self)

    // Son métodos abstractos
    method consumoBase() 

    method computoBase()
    
    method extraComputoPorOverclock()

    // Punto 2
    method computar(problema){
        if(problema.complejidad() > self.computo()){
            self.error("Capacidadd excedida")
        }
        modo.realizoComputo(self)
    }

}

class A105 inherits Equipo{
    const property consumoBase = 300
    var property micros

    override method consumoBase() = 300

    override method computoBase() = 600

    override method extraComputoPorOverclock() = self.computoBase() * 0.3 // aumenta un 30%

    override method computar(problema){
        if(problema.complejidad() < 5){
            self.error("Error de fabrica")
        }
        super(problema)
    }


}

class B2 inherits Equipo{
    const micros

    override method consumoBase() = 50 * micros + 10

    override method computoBase() = 800.min(100 * micros) //acá usamos el max y min con el "min"

    override method extraComputoPorOverclock() = micros * 20

    /* No lo ponemos porque YA LO HEREDAMOS! no hacemos un método al pedo donde solo vamos a usar super
    override method computar(problema){
        super(problema)
    }
    */ 

}

































