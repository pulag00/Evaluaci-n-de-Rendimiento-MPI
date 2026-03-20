#!/usr/bin/perl

$Path = `pwd`;
chomp($Path);
$DirDatos = "$Path/datosDAT";
system("mkdir -p $DirDatos");

$Repeticiones = 30;

@Programas = ("mxmOmpMPIfxc", "mxmOmpMPIfxt");
@Matrices = ("400", "800", "1600", "3200");

# Ajusta este nombre si tu archivo se llama distinto.
$HostProcesos = "procesosHostfile";
$HostHilos = "hilosHostFile";

%ProgTag = ("mxmOmpMPIfxc" => "clasica", "mxmOmpMPIfxt" => "transpuesta");


# =========================
# Caso 1: envio de procesos MPI entre nodos
# mpirun -hostfile procesosHostfile -np <NP> --map-by node ./<PROGRAM> <MATRIX_SIZE> 1
# NP: 5, 17, 33
# =========================
@NPsCaso1 = ("5", "17", "33");

foreach $np (@NPsCaso1) {
	foreach $programa (@Programas) {
		foreach $size (@Matrices) {
			$archivo = "$DirDatos/Procesos-Pr-".$ProgTag{$programa}."-N-".$size."-NP-".$np.".dat";

			printf("rm $archivo\n");
			system("rm -f $archivo");

			for ($i = 0; $i < $Repeticiones; $i++) {
				$comando = "mpirun -hostfile $HostProcesos -np $np --map-by node ./$programa $size 1";
				printf("$comando\n");
				system("$comando >> $archivo");
			}

			close($archivo);
		}
	}
}

# =========================
# Caso 2: un proceso por nodo y paralelismo OpenMP
# mpirun -hostfile hilosHostFile -np 5 --map-by node ./<PROGRAM> <MATRIX_SIZE> <THREADS>
# THREADS: 1, 4, 8
# =========================
@HilosCaso2 = ("1", "4", "8");

foreach $programa (@Programas) {
	foreach $size (@Matrices) {
		foreach $hilos (@HilosCaso2) {
			$archivo = "$DirDatos/Hilos-Pr-".$ProgTag{$programa}."-N-".$size."-NP-5-H-".$hilos.".dat";

			printf("rm $archivo\n");
			system("rm -f $archivo");

			for ($i = 0; $i < $Repeticiones; $i++) {
				$comando = "mpirun -hostfile $HostHilos -np 5 --map-by node ./$programa $size $hilos";
				printf("$comando\n");
				system("$comando >> $archivo");
			}

			close($archivo);
		}
	}
}

# =========================
# Caso 3: todo en nodo master con 1 CPU (hilos=1)
# Nota: el codigo requiere al menos 1 worker, por eso se usa -np 2 (master + 1 worker)
# y se fuerza ejecucion solo en master.
# =========================
foreach $programa (@Programas) {
	foreach $size (@Matrices) {
		$archivo = "$DirDatos/ProcesosMaster-Pr-".$ProgTag{$programa}."-N-".$size."-NP-2.dat";

		printf("rm $archivo\n");
		system("rm -f $archivo");

		for ($i = 0; $i < $Repeticiones; $i++) {
			$comando = "mpirun --host master:2 -np 2 ./$programa $size 1";
			printf("$comando\n");
			system("$comando >> $archivo");
		}

		close($archivo);
	}
}
