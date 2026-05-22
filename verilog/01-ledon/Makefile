#-- Colores
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RESET='\033[0m'  #-- Color por defecto

#-- Descripcion de la FPGA usada
PART=xc7a35tcpg236
PART1=${PART}"-1"

#-- Directorio de la base de datos
CHIPDB_DIR = ../../chipdb

#-- Fichero con la base de datos
CHIPDB = ${CHIPDB_DIR}/${PART}.bin



#──────────────────────────────────────────────────
#───  Construccion de la base de datos
#──────────────────────────────────────────────────
chipdb: ${CHIPDB}
	
${CHIPDB}:
	@echo
	@echo -e ${BLUE}"➡️  Generando base de datos..."${RESET}
	pypy3 ${NEXTPNR_XILINX_PYTHON_DIR}/bbaexport.py --device ${PART1} --bba ${PART}.bba
	bbasm -l ${PART}.bba ${CHIPDB}
	rm -f ${PART}.bba
	@echo

#-- Borrado de la base de datos
clean-chipdb:
	@echo
	@echo -e ${BLUE}"➡️  Borrando base de datos..."${RESET}
	rm -f ${CHIPDB}
	@echo
