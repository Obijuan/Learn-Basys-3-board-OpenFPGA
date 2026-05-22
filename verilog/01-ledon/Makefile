#-- Colores
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RESET='\033[0m'  #-- Color por defecto

#-- Top module
TOP = ledon

#-- Descripcion de la FPGA usada
PART=xc7a35tcpg236
PART1=${PART}"-1"

#-- Fichero de restricciones
XDC = ../../config/basys3.xdc

#-- Directorio de la base de datos
CHIPDB_DIR = ../../chipdb

#-- Fichero con la base de datos
CHIPDB = ${CHIPDB_DIR}/${PART}.bin


#──────────────────────────────────────────────────
#─── SINTESIS
#──────────────────────────────────────────────────
#-- Ficheros .v ---> .json
${TOP}.json: ${TOP}.v
	@echo
	@echo -e ${BLUE}"─────────────────────────────────────"${RESET}
	@echo -e ${BLUE}"➡️  Sintetizando..."${RESET}
	@echo -e ${BLUE}"─────────────────────────────────────"${RESET}
	yosys -p "synth_xilinx -arch xc7 -top ${TOP}; \
	          write_json ${TOP}.json" \
	          ${TOP}.v ${DEPS} -q
	@echo


#--------------------------------------
#-- RUTADO
#--------------------------------------
#-- .json --> .fasm
$(TOP).fasm: ${TOP}.json ${CHIPDB}
	@echo
	@echo -e ${BLUE}"─────────────────────────────────────"${RESET}
	@echo -e ${BLUE}"➡️  Rutando..."${RESET}
	@echo -e ${BLUE}"─────────────────────────────────────"${RESET}
	nextpnr-xilinx --chipdb ${CHIPDB} \
       --xdc ${XDC} --json ${TOP}.json --fasm ${TOP}.fasm -q
	@echo



#──────────────────────────────────────────────────
#───  Construccion de la base de datos
#──────────────────────────────────────────────────
chipdb: ${CHIPDB}
	
${CHIPDB}:
	@echo
	@echo -e ${BLUE}"─────────────────────────────────────"${RESET}
	@echo -e ${BLUE}"➡️  Generando base de datos..."${RESET}
	@echo -e ${BLUE}"─────────────────────────────────────"${RESET}
	pypy3 ${NEXTPNR_XILINX_PYTHON_DIR}/bbaexport.py \
		  --device ${PART1} --bba ${PART}.bba
	bbasm -l ${PART}.bba ${CHIPDB}
	rm -f ${PART}.bba
	@echo

#-- Borrado de la base de datos
clean-chipdb:
	@echo
	@echo -e ${BLUE}"─────────────────────────────────────"${RESET}
	@echo -e ${BLUE}"➡️  Borrando base de datos..."${RESET}
	@echo -e ${BLUE}"─────────────────────────────────────"${RESET}
	rm -f ${CHIPDB}
	@echo


#---------- LIMPIEZA
clean:
	@echo
	@echo -e ${RED}"➡️  Borrando ficheros..."${RESET}
	rm -rf *.fasm *.frames *.json
	@echo

