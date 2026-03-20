# Evaluación de Rendimiento con MPI y OpenMP

Proyecto académico desarrollado en el curso **Introducción a Sistemas Distribuidos**
Pontificia Universidad Javeriana — 2026

---

## 📌 Descripción

Este proyecto tiene como objetivo evaluar el rendimiento de algoritmos de multiplicación de matrices en entornos paralelos utilizando:

* **MPI (Message Passing Interface)** → paralelismo distribuido
* **OpenMP** → paralelismo en memoria compartida

Se comparan dos enfoques de multiplicación:

* 🔹 Filas × Columnas (FxC)
* 🔹 Filas × Transpuesta (FxT)

El experimento mide el desempeño bajo diferentes configuraciones de procesos y hilos, permitiendo analizar métricas como tiempo de ejecución, speedup, eficiencia y overhead.

---

## Tecnologías utilizadas

* Lenguaje: **C**
* Paralelismo:

  * MPI (OpenMPI)
  * OpenMP
* Automatización: **Perl**
* Sistema operativo: **Linux (Ubuntu)**
* Clúster: Red LAN con múltiples nodos

---

## Compilación

Desde el nodo maestro:

```bash
make
```

Esto generará los ejecutables:

* `mxmOmpMPIfxc`
* `mxmOmpMPIfxt`

---

## ▶️ Ejecución

```bash
mpirun -hostfile filehost -np <np> ./<ejecutable> <N> <nH>
```

### Parámetros:

* `<np>` → número total de procesos MPI
* `<N>` → tamaño de la matriz (NxN)
* `<nH>` → número de hilos OpenMP

### Ejemplo:

```bash
mpirun -hostfile filehost -np 4 ./mxmOmpMPIfxc 800 2
```

---

## Diseño Experimental

El experimento se divide en tres escenarios:

### 🔹 Caso 1: Variación de procesos MPI

* Se modifica `np`
* OpenMP fijo (`nH = 1`)

### 🔹 Caso 2: Variación de hilos OpenMP

* `np` fijo
* Se varía `nH`

### 🔹 Caso 3: Ejecución base

* Solo un trabajador
* Referencia para cálculo de métricas

---

##  Métricas evaluadas

* Tiempo de ejecución
* Speedup
* Eficiencia
* Overhead de comunicación

Cada configuración se ejecuta **30 veces** para garantizar resultados confiables.

---

## Resultados

Los resultados se almacenan en archivos `.dat` dentro del directorio:

```
datosDAT/
```

Cada archivo contiene:

* 30 mediciones de tiempo
* Configuración específica del experimento

---

##  Requisitos

Instalar dependencias:

```bash
sudo apt update
sudo apt install -y openmpi-bin libopenmpi-dev nfs-common perl
```

---

## Configuración del clúster

El proyecto requiere:

* Configuración de `/etc/hosts`
* Conexión SSH sin contraseña
* Sistema de archivos compartido (NFS)
* Archivo `hostfile` para MPI


---





Uso académico.
