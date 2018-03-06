# logtime

Versión 0.1

Programa que determina el tiempo que un usuario ha estado en el sistema.

**Ejemplo:** Obtener el tiempo de un usuario en específico del archivo bitacora.txt

```shell
$ ./logtime -u ic15dbh -f bitacora.txt                                                                                                          
Reporte de sesiones.
Archivo: bitacora.txt

   USUARIO 	|  TIEMPO
   ic15dbh 	|  0: 1:17

* Este resultado puede variar pues se ignoran los datos cuando aún sigue activo.

```

**Ejemplo:** Obtener resumen de todos los usuarios

```shell
$ ./logtime -f bitacora.txt                                                                                                          
Reporte de sesiones.
Archivo: bitacora.txt

   USUARIO 	|  TIEMPO
  acardena 	|  0: 5:11
  atortole 	|  2:27:30
     dsosa 	|  0: 0:21
    eortiz 	|  5:32:31
    .
    .
    .
   mp18due 	|  0: 7:12
   mp18jsa 	|  0: 7:42
   mp18kam 	|  0: 6:46
   mp18mol 	|  0: 5:57
   mp18sgm 	|  0: 6: 0
    nathan 	|  0: 0: 2
    reboot 	|  5:23:39
      root 	|  0: 0:26

* Este resultado puede variar pues se ignoran los datos cuando aún sigue activo.

```

La manera en que se ejecuta es importante pues tiene dos modos de ejecución: 

1. Por usuario

   ```shell
   ./logtime -u <usuario> -f <archivo>  
   ```

2. General

   ```shell
   ./logtime -f <archivo>  
   ```

Para mayor información, usar: 

```shell
./logtime -h
```

## What is in the box?

El archivo de bitácora es fácil de conseguir de auth.log