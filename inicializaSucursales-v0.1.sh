#!/bin/bash

##############################################################################
# ARCHIVO             : automataActualizaSucursales.sh
# AUTOR/ES            : Norman ruiz
# VERSION             : 0.01 beta.
# FECHA DE CREACION   : 20/08/2019.
# ULTIMA ACTUALIZACION: 26/08/2019.
# LICENCIA            : GPL (General Public License) - Version 3.
#
#  **************************************************************************
#  * El software libre no es una cuestion economica sino una cuestion etica *
#  **************************************************************************
#
# Este programa es software libre;  puede redistribuirlo  o  modificarlo bajo
# los terminos de la Licencia Publica General de GNU  tal como se publica por
# la  Free Software Foundation;  ya sea la version 3 de la Licencia,  o (a su
# eleccion) cualquier version posterior.
#
# Este programa se distribuye con la esperanza  de que le sea util,  pero SIN
# NINGUNA  GARANTIA;  sin  incluso  la garantia implicita de MERCANTILIDAD  o
# IDONEIDAD PARA UN PROPOSITO PARTICULAR.
#
# Vea la Licencia Publica General GNU para mas detalles.
#
# Deberia haber recibido una copia de la Licencia Publica General de GNU junto
# con este proyecto, si no es asi, escriba a la Free Software Foundation, Inc,
# 59 Temple Place - Suite 330, Boston, MA 02111-1307, EE.UU.

#=============================================================================
# SISTEMA OPERATIVO   : Debian 4.9.144-3.1 (2019-02-19) x86_64 GNU/Linux
# IDE                 : Visual Studio Code Version: 1.37.1
# COMPILADOR          : gcc version 6.3.0 20170516 (Debian 6.3.0-18+deb9u1)  
# LICENCIA            : GPL (General Public License) - Version 3.
#=============================================================================
# DESCRIPCION:
#              Este script automatiza la instalacion de el servidor de 
#              sucursal.
#
##############################################################################

#*****************************************************************************
#                             INCLUSIONES ESTANDAR
#=============================================================================

#*****************************************************************************
#                             INCLUSIONES PERSONALES
#=============================================================================

#*****************************************************************************
# DEFINICION DE LAS FUNCIONES
#=============================================================================

#=============================================================================
# FUNCION : IniciaLogs().
# ACCION : Esta funcion crea el archivo donde se generaran los logs del script.
# PARAMETROS: void, no devuelve nada.
# DEVUELVE : void, no devuelve nada.
#-----------------------------------------------------------------------------
function IniciaLogs(){
	ARCHIVOLOGS='logs-'$(date +"%d%m%Y")'.log'
	echo ""
	echo "   Creando archivo $ARCHIVOLOGS..."
	echo ""
	echo "Carga de logs iniciada..." > $ARCHIVOLOGS
	if [ $? -eq 0 ]; then
    	echo ""
    	echo "   Terminado Ok."
    	echo ""
  	else
    	echo ""
    	echo "Terminado con observaciones: $?"
    	echo ""
  	fi
}

#=============================================================================
# FUNCION : LimpiaEstructura().
# ACCION : Esta funcion deja limpia y organizada la estructura de directorios.
# PARAMETROS: void, no devuelve nada.
# DEVUELVE : void, no devuelve nada.
#-----------------------------------------------------------------------------
function LimpiaEstructura(){
	echo ""
	echo "   Creando directorio backup..."
	echo ""
	if [ -d backup ];
	then
		echo ""
		echo "   El directorio ya existe."
		echo ""
		FECHA=$(date +"%d%m%Y")
		echo ""
		echo "   Creando directorio backup-$FECHA"
		echo ""
		if [ -d ./backup/backup-$FECHA ];
		then
			echo ""
			echo "   El directorio ya existe."
			echo ""
		else
			mkdir -v ./backup/backup-$FECHA
			if [ $? -eq 0 ]; then
				echo ""
				echo "   Terminado Ok."
				echo ""
			else
				echo ""
				echo "   Terminado con observaciones: $?"
				echo ""
			fi
			echo ""
			echo "   Copiando carpeta config y docker-compose.yml..."
			echo ""
			cp -iav config docker-compose.yml ./backup/backup-$FECHA
			if [ $? -eq 0 ]; then
				echo ""
				echo "   Terminado Ok."
				echo ""
			else
				echo ""
				echo "   Terminado con observaciones: $?"
				echo ""
			fi
		fi
	else
		mkdir -v backup
		if [ $? -eq 0 ]; then
			echo ""
			echo "   Terminado Ok."
			echo ""
		else
			echo ""
			echo "   Terminado con observaciones: $?"
			echo ""
		fi
		FECHA=$(date +"%d%m%Y")
		echo ""
		echo "   Creando directorio backup-$FECHA"
		echo ""
		mkdir -v backup-$FECHA
		if [ $? -eq 0 ]; then
			echo ""
			echo "   Terminado Ok."
			echo ""
		else
			echo ""
			echo "   Terminado con observaciones: $?"
			echo ""
		fi
		echo ""
		echo "   Copiando carpeta config y docker-compose.yml..."
		echo ""
		cp -iav config docker-compose.yml backup-$FECHA
		if [ $? -eq 0 ]; then
			echo ""
			echo "   Terminado Ok."
			echo ""
		else
			echo ""
			echo "   Terminado con observaciones: $?"
			echo ""
		fi
		echo ""
		echo "   Moviendo archivos obsoletos..."
		echo ""
		mv -v posGateway.bkp pos-gateway.tar backup-$FECHA
		if [ $? -eq 0 ]; then
			echo ""
			echo "   Terminado Ok."
			echo ""
		else
			echo ""
			echo "   Terminado con observaciones: $?"
			echo ""
		fi
		echo ""
		echo "   Centralizando backups..."
		echo ""
		mv -v backup-$FECHA backup_old backup
		if [ $? -eq 0 ]; 
		then
			echo ""
			echo "   Terminado Ok."
			echo ""
		else
			echo ""
			echo "   Terminado con observaciones: $?"
			echo ""
		fi
		echo ""
		echo "   Limpiando base de batos obsoleta..."
		echo ""
		sudo rm -rv /srv/mysql
		if [ $? -eq 0 ]; 
		then
			echo ""
			echo "   Terminado Ok."
			echo ""
		else
			echo ""
			echo "   Terminado con observaciones: $?"
			echo ""
		fi
 	fi
}

#=============================================================================
# FUNCION : DownSucursal().
# ACCION : Esta funcion baja el compose de sucursal.
# PARAMETROS: void, no devuelve nada.
# DEVUELVE : void, no devuelve nada.
#-----------------------------------------------------------------------------
function DownSucursal(){
	echo ""
	echo "   Bajando sucursal..."
	echo ""
	docker-compose down
  	if [ $? -eq 0 ]; then
    	echo ""
    	echo "   Terminado Ok."
    	echo ""
  	else
    	echo ""
    	echo "   Terminado con observaciones: $?"
    	echo ""
  	fi
}

#=============================================================================
# FUNCION : IdMySQL().
# ACCION : Esta funcion obtiene el id de la imagen mysql de docker.
# PARAMETROS: void, no devuelve nada.
# DEVUELVE : void, no devuelve nada.
#-----------------------------------------------------------------------------
function IdMySQL(){
	echo ""
	echo "   Validando MySQL..."
	echo ""
	MYSQL=$(docker images -q -f "reference=mysql:5.7")
  	if [ $? -eq 0 ]; then
    	echo ""
    	echo "   Terminado Ok."
    	echo ""
  	else
    	echo ""
    	echo "   Terminado con observaciones: $?"
    	echo ""
  	fi
}

#=============================================================================
# FUNCION : IdAdminer().
# ACCION : Esta funcion obtiene el id de la imagen adminer de docker.
# PARAMETROS: void, no devuelve nada.
# DEVUELVE : void, no devuelve nada.
#-----------------------------------------------------------------------------
function IdAdminer(){
	echo ""
	echo "   Validando Adminer..."
	echo ""
	ADMINER=$(docker images -q -f "reference=adminer")
  	if [ $? -eq 0 ]; then
    	echo ""
    	echo "   Terminado Ok."
    	echo ""
  	else
    	echo ""
    	echo "   Terminado con observaciones: $?"
    	echo ""
  	fi
}

#=============================================================================
# FUNCION : LimpiaImagenes().
# ACCION : Esta funcion limpia el etorno de imagnes docker, 
#          solo persiste mysql y adminer.
# PARAMETROS: void, no devuelve nada.
# DEVUELVE : void, no devuelve nada.
#-----------------------------------------------------------------------------
function LimpiaImagenes(){
	echo ""
	echo "   Validando Adminer..."
	echo ""
	#echo "MySQL: $MYSQL"
	#echo "Adminer: $ADMINER"
	for id in $(docker images -a -q)
	do
		if [ $id = $MYSQL ]; then
			echo "Persistiendo MySQL: $MYSQL"
		elif [ $id = $ADMINER ]; then
			echo "Persistiendo Adminer: $ADMINER"
		else
			echo "Eliminando: $id"
			docker rmi -f $id
			if [ $? -eq 0 ]; then
    			echo ""
    			echo "   Terminado Ok."
    			echo ""
  			else
    			echo ""
    			echo "   Terminado con observaciones: $?"
    			echo ""
  			fi
		fi
	done
}

#=============================================================================
# FUNCION : LimpiaContenedores().
# ACCION : Esta funcion elimina todos los contenedores huerfanos que pudiesen
#          quedar en el sistema.
# PARAMETROS: void, no devuelve nada.
# DEVUELVE : void, no devuelve nada.
#-----------------------------------------------------------------------------
function LimpiaContenedores(){
	echo ""
	echo "   Eliminando contenedores obsoletos..."
	echo ""
	docker rm -f $(docker ps -a -q)
  	if [ $? -eq 0 ]; then
    	echo ""
    	echo "   Terminado Ok."
    	echo ""
  	else
    	echo ""
    	echo "   Terminado con observaciones: $?"
    	echo ""
  	fi
}

#=============================================================================
# FUNCION : LimpiaVolumenes().
# ACCION : Esta funcion elimina todos los volumenes en desuso que pudiesen 
#          quedar en el sistema.
# PARAMETROS: void, no devuelve nada.
# DEVUELVE : void, no devuelve nada.
#-----------------------------------------------------------------------------
function LimpiaVolumenes(){
	echo ""
	echo "   Eliminando volumenes obsoletos..."
	echo ""
	docker volume prune
  	if [ $? -eq 0 ]; then
    	echo ""
    	echo "   Terminado Ok."
    	echo ""
  	else
    	echo ""
    	echo "   Terminado con observaciones: $?"
    	echo ""
  	fi
}

#=============================================================================
# FUNCION : CargaNuevaImagen().
# ACCION : Esta funcion Carga las imagenes especidicadas .
# PARAMETROS: void, no devuelve nada.
# DEVUELVE : void, no devuelve nada.
#-----------------------------------------------------------------------------
function CargaNuevaImagen(){
	echo ""
	echo "   Cargando la nueva imagen de posgateway..."
	echo ""
	docker load -i Sucursal-0.1.0.tar
  	if [ $? -eq 0 ]; then
    	echo ""
    	echo "   Terminado Ok."
    	echo ""
  	else
    	echo ""
    	echo "   Terminado con observaciones: $?"
    	echo ""
  	fi
}

#=============================================================================
# FUNCION : LevantaSucursal().
# ACCION : Esta funcion inicia el servidor de sucursal.
# PARAMETROS: void, no devuelve nada.
# DEVUELVE : void, no devuelve nada.
#-----------------------------------------------------------------------------
function LevantaSucursal(){
	echo ""
	echo "   Iniciando sucursal..."
	echo ""
	docker-compose up -d
  	if [ $? -eq 0 ]; then
    	echo ""
    	echo "   Terminado Ok."
    	echo ""
  	else
    	echo ""
    	echo "   Terminado con observaciones: $?"
    	echo ""
  	fi
}

#=============================================================================
# FUNCION : Main().
# ACCION : Esta es la funcion principal que realiza todas las tareas que 
#          requiere la actualizacion.
# PARAMETROS: void, no devuelve nada.
# DEVUELVE : void, no devuelve nada.
#-----------------------------------------------------------------------------
function Main(){
	clear
	echo ""
	echo "# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #"
	echo "   Actualizacion de sucursal en progreso..."
	echo "# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #"

	# Creo archivo de logs con fecha de ejecucion
	#IniciaLogs

	# Llamo a la funcion
	LimpiaEstructura

	# Llamo a la funcion DownSucursal
	DownSucursal

	# Llamo a la funcion IdMySQL
	IdMySQL

	# Llamo a la funcion IdAdminer
	IdAdminer

	# Llamo a la funcion
	LimpiaImagenes

	# Llamo a la funcion
	LimpiaContenedores

	# Llamo a la funcion
	LimpiaVolumenes

	# Llamo a la funcion
	#CargaNuevaImagen

	# Llamo a la funcion
	#LevantaSucursal

	echo "# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #"
	echo "   Tareas finalizadas."
	echo "# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #"
	echo ""
}

# Llamo a la funcion Main que depliega el script
Main

#=============================================================================
#                            FIN DE ARCHIVO
##############################################################################