
// COMPUTADORA
class SuperComputadora{
    const equipos = [] // estos serían los equipos A105 y B2

    //Punto 1)
    method equiposActivos() = equipos.filter{equipo => equipo.estaActivo()}

    method computo() = self.equiposActivos().sum{equipo => equipo.computo()}
                // equipos.filter{equipo => equipo.estaActivo()} para evitar volver a repetir código usamos self
    
    method consumo() = self.equiposActivos().sum{equipo=> equipo.consumo()}

    //1.c) Vamos separando las cosas que nos piden..
    method equipoActivoQueMas(criterio) = self.equiposActivos().max(criterio) 

    method malConfigurada() = 
        self.equipoActivoQueMas{equipo => equipo.consumo()} != self.equipoActivoQueMas{equipo => equipo.computo()}


    // method malConfigurada() = self.equipoQueMasConsume() != self.equipoQueMasComputa()

    // method equipoQueMasConsume() = equipos.max{equipo => equipo.consumo()} 

    // method equipoQueMasComputa() = equipos.max{equipo => equipo.computo()}

    // podriamos haber hecho todo en malConfigurada así (pero queda muy feo)
    // self.equiposActivos().max{equipo=>equipo.consumo()} != self.equiposActivos().max{equipo=>equipo.computo()}

    method estaActivo() = true // con este metodo ya cumple el polimorfimo con EQUIPO!
}

// MODOS
object standard{

    method consumoDe(equipo) = equipo.consumoBase()
    method computoDe(equipo) = equipo.computoBase()
}

class Overclock{
    var property usos

    method consumoDe(equipo) = 2 * equipo.consumoBase()

    method computoDe(equipo) = equipo.computoBase() * equipo.extraComputoPorOverclock()
}

class AhorroDeEnergia{

    method consumoDe(equipo) = 200

    method computoDe(equipo) = (self.consumoDe(equipo) / equipo.consumoBase()) * equipo.conmputoBase()
                        // otra forma: equipo.consumo() /  equipo.consumoBase()) * equipo.consumoBase()
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

}

class A105 inherits Equipo{
    const property consumoBase = 300
    var property micros

    override method consumoBase() = 300

    override method computoBase() = 600

    override method extraComputoPorOverclock() = self.computoBase() * 0.3 // aumenta un 30%


}

class B2 inherits Equipo{
    const micros

    override method consumoBase() = 50 * micros + 10

    override method computoBase() = 800.min(100 * micros) //acá usamos el max y min con el "min"

    override method extraComputoPorOverclock() = micros * 20


}



































