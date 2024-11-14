
// COMPUTADORAS
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




}

class A105 inherits SuperComputadora{
    const property consumoBase = 300
    var property micros

    override method consumo() = 300

    override method computo() = 600


}

class B2 inherits SuperComputadora{
    const property consumoBase = 50
    var property micros
    const property chipInstalado

    override method consumo() = consumoBase * chipInstalado + 10

    override method computo() = 100


}



































